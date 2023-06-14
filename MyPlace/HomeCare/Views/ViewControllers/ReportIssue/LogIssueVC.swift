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
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!
    
    
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
        setUpUI()
       
    
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
        imagesPickerColectionView.isHidden = true
        if isEditIssueScreen{
            [logIssueBTN].forEach({$0?.isHidden = true})
        }else{
            [saveEditBTN,deleteBTN,cancelBTN].forEach({$0?.isHidden = true})
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
        imagesPickerColectionView.isHidden = false
        
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
    var collectionDataSource : [UIImage] = []
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
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalWidth(1/7)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(4)
        let section = NSCollectionLayoutSection(group: group)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
    
}
extension ImagePickerCollectionView :  UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = collectionDataSource[indexPath.item]
        cell.imageView.layer.cornerRadius = 6
        return cell
    }
}

class ImageCell : UICollectionViewCell
{
    var imageView : UIImageView!
    var deleteImgBTN : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: contentView.frame)
        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = APPCOLORS_3.GreyTextFont.cgColor
        imageView.layer.borderWidth = 1
//        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        let closeImage  = UIImage(systemName: "xmark.circle.fill")
        let width = imageView.frame.size.width
        deleteImgBTN = UIButton(frame: CGRect(x:  width-20 , y: -5, width: 20, height: 20))
        deleteImgBTN.setImage(closeImage, for: .normal)
        deleteImgBTN.tintColor = .white
        deleteImgBTN.layer.cornerRadius = 10
        deleteImgBTN.backgroundColor = .orange
        imageView.addSubview(deleteImgBTN)
        imageView.bringSubviewToFront(deleteImgBTN)
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.frame
    }
}
