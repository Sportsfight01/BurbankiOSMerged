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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
       
        setupUI()
        collectionView.backgroundColor = .systemBackground
        configureDataSource()
        // Do any additional setup after loading the view.jhjednnnn
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // collectionView.frame = view.frame
        guard collectionView.superview != nil else {return}
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
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
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
    
    }
  
    //MARK: - CollectionView Layout & Datasource
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
            cell.titleLb.text = self.collectionDataSource[indexPath.item].title.capitalized
            cell.dateLb.text = self.collectionDataSource[indexPath.item].docDate
            let imageView = cell.zoomImageView
            imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
            let imgURL = URL(string:"\(clickHomeBaseImageURL)/\(itemIdentifier)")
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //  cell.imView.sd_setImage(with: imgURL)
            imageView.sd_setImage(with: imgURL, placeholderImage: nil) { _, _, _, _ in
                imageView.backgroundColor = .white
            }
//            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.startZooming(_:)))
//            imageView.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(pinchGesture)
            
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        snapShot.appendSections([0])
        let items = collectionDataSource.map({$0.url})
        snapShot.appendItems(items)
        dataSource.apply(snapShot, animatingDifferences: true)
        
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    @objc
     private func startZooming(_ sender: UIPinchGestureRecognizer) {
       let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
       guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
       sender.view?.transform = scale
       sender.scale = 1
     }
    
}
//MARK:  - ImageCollectionViewCell
@available(iOS 13.0, *)
class ImageCell : UICollectionViewCell {
    static let identifier = "ImageCell"
    var zoomImageView : UIImageView = {
        return UIImageView()
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
        
        setAppearanceFor(view: titleLb, backgroundColor: .clear, textColor: AppColors.darkGray, textFont: ProximaNovaSemiBold(size: 20.0))
        setAppearanceFor(view: dateLb, backgroundColor: .clear, textColor: AppColors.darkGray, textFont: ProximaNovaRegular(size: 16.0))
        [titleLb, dateLb].forEach({$0.textAlignment = .center})
//        zoomImageView.backgroundColor = .red
        //zoomImageView.ima.contentMode = .scaleAspectFit
        dateLb.transform = CGAffineTransform(translationX: 0, y: -10)
        let stackView = UIStackView(arrangedSubviews: [titleLb, dateLb, zoomImageView])
        stackView.spacing = 20
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
//MARK: - ImageSliderModel
@available(iOS 13.0, *)
extension ImageSliderVC {
    struct SliderItem{
        let title : String
        let docDate : String
        let url : String
    }
}

//MARK: - ScrollableImageView
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
                
                imageView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
                imageView.heightAnchor.constraint(equalTo: self.frameLayoutGuide.heightAnchor),
                imageView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor)
                   
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
