//
//  MovieListVC.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 25/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation
import UIKit

class MovieListVC: UIViewController {
    
    var movie:Movie?
    var data = [MovieResult]()
    var type: MovieType?
    var page = 1
    var cellTitle: String?
    
    
    let tableView: UITableView = {
        var tb = UITableView(frame: .zero, style: .plain)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    let tableViewIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = cellTitle
        fetchMovieList()
    }
    
    override func loadView() {
        super.loadView()
        tableViewSetup()
        
        view.addSubview(tableViewIndicator)
        
        tableViewIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        tableViewIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableViewIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    private func tableViewSetup(){
        view.addSubview(tableView)
          
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieListCell.nib(), forCellReuseIdentifier: MovieListCell.identifier)
          
          
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}


extension MovieListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 140
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as! MovieListCell
        let movie = data[indexPath.row]
        cell.parseData(movie:movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailVC()
        let movie = data[indexPath.row]
        vc.data = movie
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            if movie?.total_pages ?? 1 > page {
                page += 1
                fetchMovieList()
            }
        }
    }
    
}


extension MovieListVC {
    private func fetchMovieList(){
        guard let type = self.type else {return}
             self.tableViewIndicator.isHidden = false
             self.tableViewIndicator.startAnimating()
            NetworkingClient.getMovieList(page, type: type) { (data) in
                self.movie = data

                
                self.data.append(contentsOf: data.results)
                

                self.tableView.reloadData()
                self.tableViewIndicator.stopAnimating()
            }
    }
}
