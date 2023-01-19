//
//  TextFieldExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
}

@IBDesignable
class DesignableUITextField: UITextField,UITextFieldDelegate
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.delegate = self;
        self.returnKeyType=UIReturnKeyType.done;

        self.font = regularFontWith(size: FONT_16)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self;
        self.returnKeyType=UIReturnKeyType.done;
        
        self.font = regularFontWith(size: FONT_16)
    }

   /* required init?(coder aDecoder: NSCoder) {


    }*/

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }

    @IBInspectable var leftImage: UIImage? {
        didSet {
            self.perform(#selector(updateView), with: nil, afterDelay: 0.0);
        }
    }

    @IBInspectable var leftPadding: CGFloat = 0

    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            self.perform(#selector(updateView), with: nil, afterDelay: 0.0);
        }
    }

   @objc func updateView() {
        if let image = leftImage {

            let TempLeftView = UIView(frame: CGRect(x: 0, y: 0, width:self.frame.size.height, height: self.frame.size.height))
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width:TempLeftView.frame.size.height-10, height: TempLeftView.frame.size.height-10))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true;
            imageView.image = image
            imageView.tintColor = color
            TempLeftView.addSubview(imageView);
            leftView = TempLeftView
        }
        else
        {
            let TempLeftView = UIImageView(frame: CGRect(x: 0, y: 0, width:10, height: 10))
            leftViewMode = UITextField.ViewMode.always
            leftView = TempLeftView
        }

    attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.resignFirstResponder();
        return true;
    }
}
extension UITextField {

    //MARK:- Set Image on the right of text fields

  func setupRightImage(imageName:String){
    let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 12))
    imageView.image = UIImage(named: imageName)
   // let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
    self.addSubview(imageView)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
      imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
      imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
      imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//    rightView = imageContainerView
//    rightViewMode = .always
      self.tintColor = .lightGray
      self.addSubview(imageView)
}

 //MARK:- Set Image on left of text fields

    func setupLeftImage(imageName:String){
       let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 15))
       imageView.image = UIImage(named: imageName)
       let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
       imageContainerView.addSubview(imageView)
       leftView = imageContainerView
       leftViewMode = .always
       self.tintColor = .lightGray
     }

  }
