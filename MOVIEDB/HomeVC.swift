//
//  HomeVC.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit


class HomeVC: UIViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"

    var movieCollectionView: UICollectionView! = nil

    var dataSource: UICollectionViewDiffableDataSource<Section<AnyHashable, [AnyHashable]>,AnyHashable>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        configureCollectionView()
        configureDataSource()
        fetchDataAsynchronously()
    }
}


extension HomeVC {
    
    fileprivate func fetchDataAsynchronously(){
        
        var sections: [Section<AnyHashable, [AnyHashable]>] = []
        
        let group = DispatchGroup()
        let queueLoader = DispatchQueue(label: "com.Loader")

        group.enter()
        queueLoader.async(group: group){
            NetworkingClient.getMovieList(1, type: .nowPlaying) { (movie) in
                sections.append(Section(headerItem: NowPlayingSection(items: movie.results), sectionItems: movie.results))
            
            group.leave()
                
            }
        }
        
        group.enter()
        queueLoader.async(group: group){
            NetworkingClient.getMovieList(1, type: .topRated) { (movie) in
                sections.append(Section(headerItem: TopRatedSection(items: movie.results), sectionItems: movie.results))
            group.leave()
        }
                   
        }
        
        group.enter()
        queueLoader.async(group: group){
            NetworkingClient.getMovieList(1, type: .popular){ (movie) in
                 sections.append(Section(headerItem: PopularMovieSection(items: movie.results), sectionItems: movie.results))
            group.leave()
               
            }
        }
        
        group.enter()
        queueLoader.async(group:group) {
            NetworkingClient.getGenreList { (genre) in
                sections.append(Section(headerItem: GenreListSection(items: genre.genres), sectionItems:genre.genres))
                group.leave()
            }
        }
        
        
        group.notify(queue: .main){
            self.addItem(with: sections)
            self.movieCollectionView.reloadData()
        }

    }
    
    
    private func addItem(with sections: [Section<AnyHashable, [AnyHashable]>]){
        
        var snapshot = NSDiffableDataSourceSnapshot<Section<AnyHashable, [AnyHashable]>,AnyHashable>()
           
        snapshot.deleteAllItems()
        
        let payloadDatasource = DataSource(sections: sections)
        
        payloadDatasource.sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.sectionItems)
        }

        dataSource?.apply(snapshot)
    }
    
}



extension HomeVC {
    
    
    
    func configureCollectionView(){
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        collectionView.register(TopRatedItem.nib(), forCellWithReuseIdentifier: TopRatedItem.identifier)
        collectionView.register(NowPlayingItem.nib(), forCellWithReuseIdentifier: NowPlayingItem.identifier)
        collectionView.register(LatestPlayingItem.nib(), forCellWithReuseIdentifier: LatestPlayingItem.identifier)
        collectionView.register(GenreCell.nib(), forCellWithReuseIdentifier: GenreCell.identifier)
        collectionView.register(
        HeaderView.self,
        forSupplementaryViewOfKind: HomeVC.sectionHeaderElementKind,
        withReuseIdentifier: HeaderView.reuseIdentifier)
        
         movieCollectionView = collectionView
         view.addSubview(movieCollectionView)
       
    }
    
    func configureDataSource(){
     dataSource = UICollectionViewDiffableDataSource<Section<AnyHashable, [AnyHashable]>, AnyHashable>(collectionView:
        movieCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            if let nowPlaying = item as? MovieResult {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingItem.identifier, for: indexPath) as? NowPlayingItem else {
                    return nil
                }
                cell.parseData(movie: nowPlaying)
                return cell
            }
            
            if let topRated = item as? MovieResult {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedItem.identifier, for: indexPath) as? TopRatedItem else {
                    return nil
                }
                cell.parseData(movie: topRated)
            }
            
            if let PopularMovie = item as? MovieResult {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestPlayingItem.identifier, for: indexPath) as? LatestPlayingItem else {
                    return nil
                }
                cell.parseData(movie: PopularMovie)
            }
            
            if let GenreList = item as? Genre {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else {
                    return nil
                }
                cell.parseData(genre: GenreList)
                return cell
            }
            
            
          return UICollectionViewCell()
    }
        dataSource?.supplementaryViewProvider = { (
             collectionView: UICollectionView,
             kind: String,
             indexPath: IndexPath) -> UICollectionReusableView? in

             guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
               ofKind: kind,
               withReuseIdentifier: HeaderView.reuseIdentifier,
               for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
            supplementaryView.configureHeader(sectionType: (self.dataSource?.snapshot().sectionIdentifiers[indexPath.section].headerItem)!)
            
            
            supplementaryView.segue = {
                let movieListVC = MovieListVC()
                
                let sectionType = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section].headerItem
                /*
                switch (sectionType) {
                    
                case .nowPlaying is NowPlayingSection:
                    movieListVC.type = .nowPlaying
                    movieListVC.cellTitle = sectionType.rawValue
                case .topRated:
                    movieListVC.type = .topRated
                    movieListVC.cellTitle = sectionType.rawValue
                case .popularMovie:
                    movieListVC.type = .popular
                    movieListVC.cellTitle = sectionType.rawValue
                case .genreList:
                    break
                }*/
                
                if let header = sectionType as? NowPlayingSection{
                    movieListVC.type = .nowPlaying
                    movieListVC.cellTitle = header.sectionTitle
                }
                
                if let header = sectionType as? TopRatedSection{
                    movieListVC.type = .topRated
                    movieListVC.cellTitle = header.sectionTitle
                }
                
                if let header = sectionType as? PopularMovieSection{
                    movieListVC.type = .popular
                    movieListVC.cellTitle = header.sectionTitle
                }
                
                if let header = sectionType as? GenreListSection{
                    movieListVC.type = .none
                    movieListVC.cellTitle = header.sectionTitle
                }
                
                
                
                self.navigationController?.pushViewController(movieListVC, animated: true)
            }
        
            
             return supplementaryView
           }
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex:Int, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
             let isWideView = env.container.effectiveContentSize.width > 500
       
            let sectionType = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex].headerItem
            
            if sectionType is NowPlayingSection {
               return self.generateNowPlayingLayout(isWide: isWideView)
            }
            
            if sectionType is TopRatedSection {
                return self.generateTopRated(isWide: isWideView)
            }
            
            if sectionType is PopularMovieSection {
                return self.generateLatestPlayingLayout(isWide: isWideView)
            }
            
            if sectionType is GenreListSection {
                return self.generateTopRated(isWide: isWideView)
            }
              
            return nil
            
        }
        return layout
    }
    
    func generateNowPlayingLayout(isWide:Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupFractionalWidth = isWide ? 0.475 : 0.95
        let groupFractionalHeight: Float = isWide ? 1/3 : 2/3
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)), heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeVC.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func generateTopRated(isWide:Bool) -> NSCollectionLayoutSection {
        
         let itemSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
             heightDimension: .fractionalWidth(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)

           let groupSize = NSCollectionLayoutSize(
             widthDimension: .absolute(140),
             heightDimension: .absolute(186))
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
           group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

           let headerSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
             heightDimension: .estimated(44))
           let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: headerSize,
             elementKind:  HomeVC.sectionHeaderElementKind,
             alignment: .top)

           let section = NSCollectionLayoutSection(group: group)
           section.boundarySupplementaryItems = [sectionHeader]
           section.orthogonalScrollingBehavior = .groupPaging

           return section
    }
    
    func generateLatestPlayingLayout(isWide: Bool) -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: groupHeight)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)

      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: HomeVC.sectionHeaderElementKind,
        alignment: .top)

      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = [sectionHeader]

      return section
    }
    
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let vc = DetailVC()
        present(vc, animated: true, completion: nil)
    }
}
