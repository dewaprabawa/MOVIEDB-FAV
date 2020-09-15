//
//  ViewController.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class SignInPageVC: UIViewController {

    lazy var UsernameTextField:UITextField = {
        let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Username"
        textfield.autocapitalizationType = .none
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.text?.lowercased()
        textfield.autocorrectionType = UITextAutocorrectionType.no
        
        return textfield
    }()
    
    
    
    
    lazy var PasswordTextField:UITextField = {
        let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Password"
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.contentVerticalAlignment =
            UIControl.ContentVerticalAlignment.center
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = UITextAutocorrectionType.no
        
        return textfield
    }()
    
    lazy var SignInBtn: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.setTitle("Login", for: .normal)
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.0345714353, green: 0.1464241445, blue: 0.1970108449, alpha: 1)
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var SignWebBtn: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 0)
        btn.setTitle("Visit TMDB", for: .normal)
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.0345714353, green: 0.1464241445, blue: 0.1970108449, alpha: 1)
        return btn
    }()
    
    lazy var UIBarButton: UIBarButtonItem = {
        var btn = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(signOut))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupviews()
        
        let stackview = UIStackView(arrangedSubviews: [UsernameTextField, PasswordTextField, SignInBtn,SignWebBtn])
        stackview.alignment = .fill
        stackview.distribution = .fillEqually
        stackview.axis = .vertical
        stackview.spacing = 10

        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.heightAnchor.constraint(equalToConstant: 170).isActive = true
        stackview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupviews(){
        title = "Wellcome to MovieDB"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .white
    }
    
    @objc private func signOut(){
        
    }
    
    @objc private func login(){
        NetworkingClient.getRequestToket(completion: handleResponseRequestToken(success:err:))
    }
    
    
    func handleResponseRequestToken(success:Bool, err: Error?){
        if success {
            NetworkingClient.getLogin(username: UsernameTextField.text ?? "", password: PasswordTextField.text ?? "", completion: handleLoginResponse(success:err:))
        }else{
            
        }
    }
    
    func handleLoginResponse(success:Bool, err: Error?){
        if success {
            NetworkingClient.createSession(completion: handleSessionResponse(success:error:))
        }
    }
    
    
    func handleSessionResponse(success: Bool, error: Error?){
        if success {
            let vc = UINavigationController(rootViewController: HomeVC())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
}

