//
//  ImagePickerCollectionView.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 26/06/23.
import Foundation
import PhotosUI

class ImagePickerCollectionView : UIView
{
    //MARK: - Propeties

    var imagesSelectionClosure : ((_ count : Int)->())?
    var collectionDataSource : [UIImage?] = [UIImage?](repeating: nil, count: 6)
    {
        didSet {
            collectionView.reloadData()
            imagesSelectionClosure?(collectionDataSource.count)
        }
    }
    var maxPhotosCount : Int = 0
    private var collectionView : UICollectionView!
   // private lazy var dataSource : UICollectionViewDiffableDataSource<Int,UIImage> = makeDataSource()
     //MARK: - Life Cycle
    var isDeleteEnabled : Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
 
    }
     //MARK: - SetupUI & Setup Constraints
    
    private func commonInit()
    {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        if #available(iOS 14.0, *) {
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        } else {
            // Fallback on earlier versions
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
//        collectionView.showsHorizontalScrollIndicator = true
        self.addSubview(collectionView)
        
        ///LayoutSetup
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        ])
    
        
    }
    
    private func createLayout() -> UICollectionViewLayout
    {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/6), heightDimension: .fractionalWidth(1/6)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
    
    //MARK: - Camera & Photo Album Options
    func showOptions()
    {
        if collectionDataSource.compactMap({$0}).count >= maxPhotosCount
        {
//            if collectionDataSource.count == maxPhotosCount {
                 showAlert("maximum photos selected")
                 return
//            }
        }
        let actionSheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle : .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] action in
            debugPrint("camera tapped")
            self?.openCamera()
        }
        let photoAlbum = UIAlertAction(title: "PhotoAlbum", style: .default) { [weak self] action in
            debugPrint("photo album tapped")
            if #available(iOS 14.0, *) {
                self?.openPhotoAlbum()
            } else {
                // Fallback on earlier versions
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            debugPrint("cancel tapped")
            actionSheet.dismiss(animated: true)
        }
        [camera, photoAlbum, cancel].forEach({ actionSheet.addAction($0) })
        if let parentVc = self.parentContainerViewController()
        {
            parentVc.present(actionSheet, animated: true)
        }
    }
     //MARK: - Camera Options
    private func openCamera()
    {
        if  collectionDataSource.filter({$0 == nil}).count == 0{
            showAlert("maximum photos selected")
            return
        }
        let imageController = UIImagePickerController()
        imageController.sourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imageController.cameraCaptureMode = .photo
            imageController.showsCameraControls = true
            imageController.delegate = self
            parentContainerViewController()?.dismiss(animated: true)
            parentContainerViewController()?.present(imageController, animated: true)
            
        }else {
            showAlert("Camera is not available")
        }
    }
    
     //MARK: - Photo Selection Options
    @available(iOS 14.0, *)
    private func openPhotoAlbum()
    {
        var photoConfig = PHPickerConfiguration()
//        if let maxPhotosCount {
            photoConfig.selectionLimit =  collectionDataSource.filter({$0 == nil}).count
//        }
        photoConfig.filter = .images
        if #available(iOS 15.0, *) {
            photoConfig.selection = .ordered
        }
        let photoPickerVc = PHPickerViewController(configuration: photoConfig)
        photoPickerVc.delegate = self
        parentContainerViewController()?.present(photoPickerVc, animated: true)
        
    }
}

 //MARK: - UIImagePickerController Delegate
extension ImagePickerCollectionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage
        {
            let index = collectionDataSource.firstIndex(where: {$0 == nil})
            collectionDataSource[index!] = image
        }
    }
}
 //MARK: - PHPickerViewControllerDelegate
@available(iOS 14.0, *)
extension ImagePickerCollectionView : PHPickerViewControllerDelegate
{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // dismiss a picker
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) } // filter for possible UIImages
        
        let dispatchGroup = DispatchGroup()
        var images = [UIImage?]()
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
            #if DEBUG
            debugPrint(images.count)
            #endif
            if images.count <= 0{
                return
            }
            guard let index : Int = self.collectionDataSource.firstIndex(where: {$0 == nil}) else { return }
            
            self.collectionDataSource[index...(index + images.count - 1)] = images[images.indices]
           
//            self.collectionDataSource.append(contentsOf: images)
            
        }
    }
    
}

 //MARK: - CollectionView DataSource & Delegate
extension ImagePickerCollectionView:  UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if #available(iOS 14.0, *) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
            if collectionDataSource[indexPath.item] == nil{
                cell.imageView.image = UIImage(named: "imageAdd")?.withTintColor(APPCOLORS_3.GreyTextFont, renderingMode: .alwaysTemplate)
                cell.imageView.tintColor = APPCOLORS_3.LightGreyDisabled_BG
                cell.deleteImgBTN.isHidden = true
            }else{
                cell.imageView.image = collectionDataSource[indexPath.item]
                cell.deleteImgBTN.isHidden = false
            }
            if isDeleteEnabled{
                cell.deleteImgBTN.isHidden = true
            }
            return cell
        } else {
            // Fallback on earlier versions
            return UICollectionViewCell()
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDeleteEnabled || collectionDataSource[indexPath.item] == nil {
            maxPhotosCount = 6
            showOptions()
            return 
        }
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alertVc.addImage(image: collectionDataSource[indexPath.item]!)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            #if DEBUG
            debugPrint("Delete tapped")
            #endif
            self.collectionDataSource.remove(at: indexPath.item)
            self.collectionDataSource.append(nil)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        cancelAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alertVc.addAction(deleteAction)
        alertVc.addAction(cancelAction)
        self.parentContainerViewController()?.present(alertVc, animated: true)
    }
}

@available(iOS 14.0, *)
class ImageCell : UICollectionViewCell
{
    var imageView : UIImageView!
    var deleteImgBTN : UIImageView!
    var deleteBtnAction : ((_ index : Int)->())?
     //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        ///ImageView
        imageView = UIImageView(frame: contentView.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = APPCOLORS_3.LightGreyDisabled_BG.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ///Layout of ImageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        ])
        ///Delete Button
//        let closeIcon = UIImage(systemName: "xmark.circle.fill")
        let closeIcon = UIImage(named: "Ico-Remove")
        deleteImgBTN = UIImageView(image: closeIcon)
        deleteImgBTN.tintColor = .orange
        self.contentView.addSubview(deleteImgBTN)
        deleteImgBTN.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteImgBTN.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            deleteImgBTN.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -1),
            deleteImgBTN.heightAnchor.constraint(equalToConstant: 15),
            deleteImgBTN.widthAnchor.constraint(equalToConstant: 15)
        ])
        
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       // imageView.frame = contentView.frame
    }
}

