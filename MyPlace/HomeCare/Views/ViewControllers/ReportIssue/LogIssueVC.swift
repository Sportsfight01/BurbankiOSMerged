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
    @IBOutlet weak var logIssueBTN: UIButton!
    
    @IBOutlet weak var saveEditBTN: UIButton!
    //MARK: - Properties
    @IBOutlet weak var addImagesView: UIView!
    @IBOutlet weak var TopFlagView: UIView!
    
    var isEditIssueScreen = false
    
    @IBOutlet weak var imagesPickerColectionView: ImagePickerCollectionView!
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

    func setUpUI(){
        if isEditIssueScreen{
            
        }
    }
    
    @IBAction func didTappedOnIssues(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("log issues")
        case 1:
            print("log issues")
           
        case 2:
            print("save & edit issues")
            
            
        case 3:
            print("Delete issues")
            
        case 4:
            print("Cancel")
        default:
            print("log issues")
        }
    }
    
    
}

@available(iOS 14.0, *)
extension LogIssueVC : PHPickerViewControllerDelegate
{
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        let images = results.map({$0.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//            if error != nil { debugPrint("error loading an image")}
//        }})
//        picker.dismiss(animated: true, completion:nil)
//
//    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // dismiss a picker
        
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) } // filter for possible UIImages
        
        let dispatchGroup = DispatchGroup()
        var images = [UIImage]()
        
        for imageItem in imageItems {
            dispatchGroup.enter() // signal IN
            
            imageItem.loadObject(ofClass: UIImage.self) { image, _ in
                if let image = image as? UIImage {
                    images.append(image)
                }
                dispatchGroup.leave() // signal OUT
            }
        }
        
        // This is called at the end; after all signals are matched (IN/OUT)
        dispatchGroup.notify(queue: .main) {
            print(images.count)
            self.imagesPickerColectionView.collectionDataSource = images

            // DO whatever you want with `images` array
        }
    }
    
}


class ImagePickerCollectionView : UIView
{
    var collectionDataSource : [UIImage] = [UIImage(systemName: "plus.square")!,UIImage(systemName: "plus.square")!,UIImage(systemName: "plus.square")!,UIImage(systemName: "plus.square")!,UIImage(systemName: "plus.square")!]
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
        collectionView.backgroundColor = .clear
//        self.backgroundColor = .purple
       
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
        return collectionDataSource.count
//        < maxPhots ? collectionDataSource.count + 1 : maxPhots
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
        imageView.layer.cornerRadius = 3
        imageView.borderColor = APPCOLORS_3.GreyTextFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.frame
    }
}
