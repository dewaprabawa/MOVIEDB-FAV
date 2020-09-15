//
//  HeaderView.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 24/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
  static let reuseIdentifier = "header-reuse-identifier"

    var segue: (() -> ())?
    
    let label:UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lb
    }()

    let SeeAllButton:UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("See More", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .trailing
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(segueToMVL), for: .touchUpInside)
        return btn
    }()
    
   @objc private func segueToMVL(){
        self.segue?()
    }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}

extension HeaderView {
  func configure() {
    backgroundColor = .systemBackground

    let stackView = UIStackView(arrangedSubviews: [label, SeeAllButton])
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .center
    stackView.spacing = 10

    let inset = CGFloat(10)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
    ])
    label.font = UIFont.preferredFont(forTextStyle:.headline)
  }
}

extension HeaderView {
    func setupView() {
           label.textColor = UIColor.white
           label.adjustsFontForContentSizeCategory = true
       }
       
       func configureHeader(sectionType: AnyHashable) {
        if let header = sectionType as? NowPlayingSection {
            label.text = header.sectionTitle
        }
        
        if let header = sectionType as? TopRatedSection {
            label.text = header.sectionTitle
        }
        
        if let header = sectionType as? PopularMovieSection {
            label.text = header.sectionTitle
        }
        
        if let header = sectionType as? GenreListSection {
            label.text = header.sectionTitle
        }
        
       }
}
