//
//  ViewExtensions.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /**
     The radius to use when drawing rounded corners for the layer’s background.
     The default value of this property is 0.0.
     The property can display in Drag and drop file to change value for Every UIView element
     */
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /**
     
     The width of the layer’s border.
     The default value of this property is 0.0.
     The property can display in Drag and drop file to change value for Every UIView element
     */
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /**
     
     The color of the layer’s border.
     The default value of this property is an opaque black color.
     The property can display in Drag and drop file to change value for Every UIView element
     */
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    /**
     A Boolean value that determines whether the view is hidden.
     Setting the value of this property to true hides the receiver and setting it to false shows the receiver. The default value is false.
     */
    func isMyHidden()
    {
        if isHidden == true
        {
            isHidden = false
        }
        else if isHidden == false
        {
            isHidden = true
        }
    }
    
    func changeAlpha()
    {
        if alpha == 0.0
        {
            alpha = 1.0
        }else if alpha == 1.0
        {
            alpha = 0.0
        }
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
       func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem!,
          attribute: constraint.firstAttribute,
          relatedBy: constraint.relation,
          toItem: constraint.secondItem,
          attribute: constraint.secondAttribute,
          multiplier: multiplier,
          constant: constraint.constant)

        newConstraint.priority = constraint.priority

        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])

        return newConstraint
      }


}
