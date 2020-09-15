//
//  NetworkingClient.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation
import Alamofire
import JGProgressHUD


enum MovieType: String {
    case nowPlaying = "/movie/now_playing"
    case topRated = "/movie/top_rated"
    case popular = "/movie/popular"
}
  
class NetworkingClient{
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    static var shared = NetworkingClient()
    
    var apiKey = "2e1626a2f0871692a64fc534f599643e"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum ImageSize: String {
         case tiny = "w45"
         case small = "w92"
         case large = "w500"
         case original = "original"
     }

    
    enum Endpoints {
        
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageURL = "https://image.tmdb.org/t/p/"
        static let videoURL = "https://img.youtube.com/vi/"
        static let apiKeyParam = "?api_key=\(NetworkingClient.shared.apiKey)"
        
        case getRequestToken
        case login
        case createSessionId
        case logout
        case downloadImageMovie(String)
        case movieGenres
        case getMovieList(Int, String)
        
        var stringURL: String {
            switch self {
            case .getRequestToken:
                  return Endpoints.baseURL + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login:
                return Endpoints.baseURL + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.baseURL + "/authentication/session/new" + Endpoints.apiKeyParam
            case .logout:
                return Endpoints.baseURL + "/authentication/session" + Endpoints.apiKeyParam
            case .downloadImageMovie(let path):
                return Endpoints.imageURL + ImageSize.original.rawValue + "\(path)"
            case .movieGenres:
                return Endpoints.baseURL + "/genre/movie/list" + Endpoints.apiKeyParam
            case .getMovieList(let page, let movieType):
                return Endpoints.baseURL + movieType + Endpoints.apiKeyParam + "&page=\(page)"
            }
        }
        
        var validURL: URL {
            return URL(string: self.stringURL)!
        }
    }
    
    
    
    class func getData<ResponseType:Decodable>(at Path: URL, response: ResponseType.Type, completion:@escaping (ResponseType?, Error?)-> Void) -> URLSessionDataTask? {
        
        let request = URLRequest(url: Path)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let responseHTTPs = response as? HTTPURLResponse {
                print("status code: \(responseHTTPs.statusCode)")
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                completion(nil, error)
                }
                return
            }
            
            do{
                let decode = JSONDecoder()
                
                let responseObject = try decode.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
                
            }catch{
                
                do {
                    let errorResponse = try JSONDecoder().decode(TMDBresponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                        }
                    
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                        }
                }
            }
            
        }
        task.resume()
        
      return task
    }
    
    
    class func postData<ResponseType:Decodable, RequestType:Encodable>(at Path:URL, responseType:ResponseType.Type, body: RequestType, completion:@escaping (ResponseType? , Error?) -> Void){
        
        var request = URLRequest(url: Path)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let responseHTTPs = response as? HTTPURLResponse {
                print("status code: \(responseHTTPs.statusCode)")
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                completion(nil, error)
                }
                return
            }
            
            do{
                let responseobject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseobject, nil)
                }
                
            }catch{
                do {
                    let errorResponse = try JSONDecoder().decode(TMDBresponse.self, from: data) as Error
                              
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                              
                              
                    } catch {
                    DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
                      
            }
        task.resume()
    }
    
    
    class func getRequestToket(completion:@escaping (Bool , Error?) -> Void)-> URLSessionDataTask?{
       let task = getData(at: Endpoints.getRequestToken.validURL, response: RequestTokenAccess.self) { (response, error) in
            
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
        
        return task
    }
    
    class func getLogin(username name:String, password pass:String,completion:@escaping (Bool, Error?) -> Void){
        
        let body = LoginRequest(username: name, password: pass, requestToken: Auth.requestToken)
        
        postData(at: Endpoints.login.validURL, responseType:
        RequestTokenAccess.self, body:body ) { (data, error) in
            if let response = data {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
    }
    
    
    class func createSession(completion:@escaping (Bool, Error?) -> Void){
        
        let body = PostSession(requestToken: Auth.requestToken)
        
        postData(at: Endpoints.createSessionId.validURL, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.sessionId = response.sessionId
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
        
    }
    
    class func getMovieList(_ page:Int, type:MovieType, completion:@escaping (Movie) -> Void){
        let url = Endpoints.getMovieList(page, type.rawValue).validURL
        AF.request(url).validate().responseDecodable(of:Movie.self) { (response) in
            guard let movie = response.value else { return }
            completion(movie)
        }
        
    }
    
    class func getGenreList(completion:@escaping (MovieGenres)-> Void){
        let url = Endpoints.movieGenres.validURL
        AF.request(url).validate().responseDecodable(of:MovieGenres.self){(response) in
            guard let genreList = response.value else { return }
            completion(genreList)
        }
    }

}





extension UIImageView {
    
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
          containerView.clipsToBounds = false
           containerView.layer.shadowColor = UIColor.black.cgColor
           containerView.layer.shadowOpacity = 1.0
           containerView.layer.shadowOffset = CGSize(width: 1, height: 1.5)
           containerView.layer.shadowRadius = 3
           containerView.layer.cornerRadius = cornerRadious
           self.clipsToBounds = true
           self.layer.cornerRadius = cornerRadious
    }
    
    
    func loadImageFromUrl(path: String)  {
        let spinner = JGProgressHUD(style: .dark)

        image = nil
        layer.masksToBounds = true
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        let url = "https://image.tmdb.org/t/p/w500\(path)"
        
        if let imageFromCache = NetworkingClient.imageCache.object(forKey: url as AnyObject) as? UIImage{
            self.image = imageFromCache
            spinner.dismiss()
            return
        }
        
        
        AF.request(url, method: .get).response { (responseData) in

            spinner.show(in: self)
            
            if let data = responseData.data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data){
                        NetworkingClient.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                            self.image = imageToCache
                        }, completion: nil)
                         spinner.dismiss()
                    }
                }
            }
        }
        
    }
}
