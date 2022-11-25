//
//  UIBarButtonItem+Badge.swift
//  Burbank app
//
//  Created by BURBANK on 10/09/18.
//  Copyright © 2018 cykul. All rights reserved.
//

import Foundation
import UIKit
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIView {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self as? UIImageView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        var badgeWidth = 8
        var numberOffset = 4
        
        if number > 9 {
            badgeWidth = 12
            numberOffset = 6
        }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(10)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.addSublayer(badge)
      //  view.bringSubviewToFront(badge)
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
//        badge.bringSubviewToFront(label)
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}

protocol BadgeContainer: class {
    var badgeView: UIView? { get set }
    var badgeLabel: UILabel? { get set }
    func showBadge(blink: Bool, text: String?)
    func hideBadge()
}
//default protocol implementation
extension BadgeContainer where Self: UIView {
    func showBadge(blink: Bool, text: String?) {
        if badgeView != nil {
            if badgeView?.isHidden == false {
                return
            }
        } else {
            badgeView = UIView()
        }

        badgeView?.backgroundColor = .red
        guard let badgeViewUnwrapped = badgeView else {
            return
        }
        //adds the badge at the top
        addSubview(badgeViewUnwrapped)
        badgeViewUnwrapped.translatesAutoresizingMaskIntoConstraints = false

        var size = CGFloat(6)
        if let textUnwrapped = text {
            if badgeLabel == nil {
                badgeLabel = UILabel()
            }
            
            guard let labelUnwrapped = badgeLabel else {
                return
            }
            
            labelUnwrapped.text = textUnwrapped
            labelUnwrapped.textColor = .white
            labelUnwrapped.font = .systemFont(ofSize: 8)
            labelUnwrapped.translatesAutoresizingMaskIntoConstraints = false

            badgeViewUnwrapped.addSubview(labelUnwrapped)
            let labelConstrainst = [labelUnwrapped.centerXAnchor.constraint(equalTo: badgeViewUnwrapped.centerXAnchor),                                    labelUnwrapped.centerYAnchor.constraint(equalTo: badgeViewUnwrapped.centerYAnchor)]
            NSLayoutConstraint.activate(labelConstrainst)
            
            size = CGFloat(12 + 2 * textUnwrapped.count)
        }
        
        let sizeConstraints = [badgeViewUnwrapped.widthAnchor.constraint(equalToConstant: size), badgeViewUnwrapped.heightAnchor.constraint(equalToConstant: size)]
        NSLayoutConstraint.activate(sizeConstraints)
        
        badgeViewUnwrapped.cornerRadius1 = size / 2
        
        let position = [badgeViewUnwrapped.topAnchor.constraint(equalTo: self.topAnchor, constant: -size / 2),
        badgeViewUnwrapped.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: size/2)]
        NSLayoutConstraint.activate(position)
        
        if blink {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 1.2
            animation.repeatCount = .infinity
            animation.fromValue = 0
            animation.toValue = 1
            animation.timingFunction = .init(name: .easeOut)
            badgeViewUnwrapped.layer.add(animation, forKey: "badgeBlinkAnimation")
        }
    }
    
    func hideBadge() {
        badgeView?.layer.removeAnimation(forKey: "badgeBlinkAnimation")
        badgeView?.removeFromSuperview()
        badgeView = nil
        badgeLabel = nil
    }
}

//custom class
class BadgeButton: UIView, BadgeContainer {
    var badgeTimer: Timer?
    var badgeView: UIView?
    var badgeLabel: UILabel?
}
//extension of UIView for proper positioning of visual children
extension UIView {
    @IBInspectable var cornerRadius1: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
