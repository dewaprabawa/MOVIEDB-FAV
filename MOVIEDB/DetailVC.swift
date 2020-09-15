//
//  DetailVC.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 10/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var detailCollectiomView: UICollectionView?
    
    var data:MovieResult?
    
     override func viewDidLoad() {
         super.viewDidLoad()
        collectionViewSetups()
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailCollectiomView?.frame = view.bounds
        view.backgroundColor = .white
    }
    
    private func collectionViewSetups(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detailCollectiomView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        detailCollectiomView?.delegate = self
        detailCollectiomView?.dataSource = self
        detailCollectiomView?.register(ImageDetailCell.nib(), forCellWithReuseIdentifier: ImageDetailCell.identifier)
        detailCollectiomView?.backgroundColor = .white
        view.addSubview(detailCollectiomView ?? UICollectionView())
    }
}


extension DetailVC: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageDetailCell.identifier, for: indexPath) as! ImageDetailCell
        cell.nameDetailLabel.text = data?.movieTitle
        cell.backgroundColor = .purple
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 200, height: 200)
    }
    
}
