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
    private var collectionView : UICollectionView! = nil
    var dataSource : UICollectionViewDiffableDataSource<Int, String>!
    var collectionDataSource : [SliderItem] = []
    var currentIndex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
       
        setupUI()
        collectionView.backgroundColor = .systemBackground
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
//            collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
//        ])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarButtons()
    }
    func setupUI()
    {
      
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
    
    }
  
    func createCompositionalLayout() -> UICollectionViewLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return compositionalLayout
    }
    func configureDataSource()
    {
        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.contentView.backgroundColor = .red
            cell.titleLb.text = self.collectionDataSource[indexPath.item].title.capitalized
            cell.dateLb.text = self.collectionDataSource[indexPath.item].docDate
            let imageView = cell.zoomImageView.imageView
            imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
            let imgURL = URL(string:"\(clickHomeBaseImageURL)/\(itemIdentifier)")
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //  cell.imView.sd_setImage(with: imgURL)
            imageView.sd_setImage(with: imgURL, placeholderImage: nil) { _, _, _, _ in
                imageView.backgroundColor = .white
            }
        
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        snapShot.appendSections([0])
        let items = collectionDataSource.map({$0.url})
        snapShot.appendItems(items)
        dataSource.apply(snapShot, animatingDifferences: false)
        
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
}

@available(iOS 13.0, *)
class ImageCell : UICollectionViewCell {
    static let identifier = "ImageCell"
    var zoomImageView : ZoomImageView = {
        return ZoomImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    }()
    
    var titleLb : UILabel = UILabel()
    var dateLb : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure()
    {
        
        setAppearanceFor(view: titleLb, backgroundColor: .clear, textColor: AppColors.darkGray, textFont: ProximaNovaSemiBold(size: 17.0))
        setAppearanceFor(view: dateLb, backgroundColor: .clear, textColor: AppColors.darkGray, textFont: ProximaNovaRegular(size: 14.0))
    
//        zoomImageView.backgroundColor = .red
        //zoomImageView.ima.contentMode = .scaleAspectFit
        let stackView = UIStackView(arrangedSubviews: [titleLb, dateLb, zoomImageView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
    
}
@available(iOS 13.0, *)
extension ImageSliderVC {
    struct SliderItem{
        let title : String
        let docDate : String
        let url : String
    }
}

class ZoomImageView : UIScrollView, UIScrollViewDelegate
{
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit()
    {
              
               // Setup image view
               imageView.translatesAutoresizingMaskIntoConstraints = false
               imageView.contentMode = .scaleAspectFit
               addSubview(imageView)
               NSLayoutConstraint.activate([
                
                imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: self.heightAnchor),
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                   
               ])

              // Setup scroll view
               minimumZoomScale = 1
               maximumZoomScale = 5
               showsHorizontalScrollIndicator = false
               showsVerticalScrollIndicator = false
               delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
