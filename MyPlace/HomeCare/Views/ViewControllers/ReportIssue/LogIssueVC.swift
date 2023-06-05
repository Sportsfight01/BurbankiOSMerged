//
//  LogIssueVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import PhotosUI

class LogIssueVC: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var addImagesView: UIView!
    @IBOutlet weak var TopFlagView: UIView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhotosClicker))
            addImagesView.addGestureRecognizer(tapGesture)
        } else {
            // Fallback on earlier versions
        }
       
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TopFlagView.addBorder()
        self.setupNavigationBarButtons()
    }
    
    //MARK: - Helper Methods
    
    @available(iOS 14.0, *)
    @objc func addPhotosClicker()
    {
        var photoConfig = PHPickerConfiguration()
        photoConfig.selectionLimit = 6
        let photoPickerVc = PHPickerViewController(configuration: photoConfig)
        photoPickerVc.delegate = self
        self.present(photoPickerVc, animated: true)
    }

}

@available(iOS 14.0, *)
extension LogIssueVC : PHPickerViewControllerDelegate
{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let images = results.map({$0.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            if error != nil { debugPrint("error loading an image")}
        }})
    }
    
}


class ImagePickerCollectionView : UIView
{
    var collectionDataSource : [UIImage] = [UIImage(systemName: "plus.square")!]
    {
        didSet {  collectionView.reloadData()  }
    }
    private var maxPhots : Int = 6
    private var collectionView : UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()
    {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .red
        self.backgroundColor = .purple
       
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        ])
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       // collectionView.frame = self.bounds
    }
    private func createLayout() -> UICollectionViewLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/6), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
extension ImagePickerCollectionView :  UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return collectionDataSource.count < maxPhots ? collectionDataSource.count + 1 : maxPhots
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = collectionDataSource[indexPath.item]
        
        return cell
    }
    
    
}

class ImageCell : UICollectionViewCell
{
    var imageView : UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: contentView.frame)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.frame
    }
}
