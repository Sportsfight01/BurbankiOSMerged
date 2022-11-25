//
//  ImagePicker.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 08/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


//public protocol ImagePickerDelegate: class {
//    func didSelect(image: UIImage?)
//}


open class ImagePicker: NSObject {

    
    var selectImageFromPicker: ((_ image: UIImage?) -> Void)?
    
    
//    static let shared: ImagePicker = ImagePicker()

    
    private let pickerController: UIImagePickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
//    private weak var delegate: ImagePickerDelegate?

    
    override public init() {
        super.init()
        
    }
    
    
    func showPicker (presentationController: UIViewController, /*delegate: ImagePickerDelegate,*/ sourceView: UIView, _ allowEditEdit: Bool = true) {
        
        self.presentationController = presentationController
//        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowEditEdit
        self.pickerController.mediaTypes = ["public.image"]
        
        present(from: sourceView)

    }
    
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        
        controller.dismiss(animated: true) {
            //        self.delegate?.didSelect(image: image)
            if let handler = self.selectImageFromPicker, let img = image {
                handler(img)
            }
        }
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if picker.allowsEditing {
            
            guard let image = info[.editedImage] as? UIImage else {
                return self.pickerController(picker, didSelect: nil)
            }
            self.pickerController(picker, didSelect: image)
        }else {
            guard let originalImage = info[.originalImage] as? UIImage else {
                return self.pickerController(picker, didSelect: nil)
            }
            self.pickerController(picker, didSelect: originalImage)
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
