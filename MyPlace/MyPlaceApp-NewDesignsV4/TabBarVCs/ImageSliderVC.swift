//
//  ImageSliderVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 29/03/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class ImageSliderVC: UIViewController {
    //MARK: - Properties
    
    private var collectionView : UICollectionView! = nil
    var dataSource : UICollectionViewDiffableDataSource<Int, String>!
    var collectionDataSource : [SliderItem] = []
    var currentIndex : Int = 0
    var initialIndex : Int = 0
   
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        collectionView.backgroundColor = .systemBackground
        configureDataSource()
        // Do any additional setup after loading the view.jhjednnnn
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        collectionView.frame = view.frame
        guard collectionView.superview != nil else {return}
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
    }
    
    //MARK: - Helper Methods
    
    func setupUI()
    {
      
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ImageSliderCVCell.nib, forCellWithReuseIdentifier: ImageSliderCVCell.identifier)
        self.view.addSubview(collectionView)
        self.view.layoutIfNeeded()
       
    
    }
  
    //MARK: - CollectionView Layout & Datasource
    func createCompositionalLayout() -> UICollectionViewLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
        
            self?.currentIndex = visibleItems.last?.indexPath.item ?? 0
        }
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return compositionalLayout
    }
    func configureDataSource()
    {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCVCell.identifier, for: indexPath) as! ImageSliderCVCell
            cell.setup(item: self.collectionDataSource[indexPath.item])
            cell.prevNextClosure = { [weak self] isPrevious in
                
                if isPrevious
                {
                    self?.currentIndex -= 1
                    
                }else {
                    self?.currentIndex += 1
                }
                self?.collectionView.scrollToItem(at: IndexPath(item: self?.currentIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
                
            }
            return cell
            
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        snapShot.appendSections([0])
        let items = collectionDataSource.map({$0.url})
        snapShot.appendItems(items)
        dataSource.apply(snapShot, animatingDifferences: true)
        
        collectionView.scrollToItem(at: IndexPath(item: initialIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc
     private func startZooming(_ sender: UIPinchGestureRecognizer) {
       let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
       guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
       sender.view?.transform = scale
       sender.scale = 1
     }
    
}
//MARK: - ImageSliderModel
@available(iOS 13.0, *)
extension ImageSliderVC {
    struct SliderItem{
        let title : String
        let docDate : String
        let url : String
    }
}


