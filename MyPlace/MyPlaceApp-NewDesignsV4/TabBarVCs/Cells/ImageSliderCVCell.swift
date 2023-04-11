//
//  ImageSliderCVCell.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 03/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import SDWebImage

class ImageSliderCVCell: UICollectionViewCell {
    
    @IBOutlet weak var prevBtn : UIButton!
    @IBOutlet weak var nextBtn : UIButton!
    @IBOutlet weak var photoTitle_Lb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    {
       didSet
        {
            imageView.contentMode = .scaleAspectFit
        }
    }
    var prevNextClosure : ((Bool) -> ())?
    @IBOutlet weak var scrollView: UIScrollView!
    static let identifier = "ImageSliderCVCell"
    static let nib = UINib(nibName: "ImageSliderCVCell", bundle: nil)
    var InitialprevNextBtsVisibility : [Bool] = []
    override func awakeFromNib() {
        super.awakeFromNib()
      

    }
    @available(iOS 13.0, *)
    func setup(item : ImageSliderVC.SliderItem, currentIndex : Int, totalCollectionCount : Int)
    {
        prevBtn.isHidden = currentIndex == 0 ? true : false
        nextBtn.isHidden = currentIndex + 1 < totalCollectionCount ? false : true
        setAppearanceFor(view: photoTitle_Lb, backgroundColor: .clear, textColor: AppColors.darkGray, textFont: ProximaNovaSemiBold(size: 20.0))
        setAppearanceFor(view: dateLb, backgroundColor: .clear, textColor: AppColors.darkGray, textFont: ProximaNovaRegular(size: 16.0))
        
        photoTitle_Lb.text = item.title.lowercased().capitalized
        dateLb.text = item.docDate
        
        //imageView
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        let imgURL = URL(string:"\(clickHomeBaseImageURL)/\(item.url)")
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray

        imageView.sd_setImage(with: imgURL, placeholderImage: nil) {[weak self] _, _, _, _ in
            self?.imageView.backgroundColor = .white
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.setZoomScale(1.0, animated: false)
        scrollView.delegate = self
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture))
        doubleTap.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTap)
        InitialprevNextBtsVisibility = [prevBtn,nextBtn].compactMap({$0.isHidden})
    }
    
    @objc func doubleTapGesture(_ gesture : UITapGestureRecognizer)
    {
        let point = gesture.location(in: gesture.view)
        debugPrint(point)
        let zoomScale = scrollView.zoomScale
        scrollView.setZoomScale(zoomScale == 1.0 ? 5.0 : 1.0, animated: true)
    }

    @IBAction func previousNextAction(_ sender: UIButton) {
        
        let isPrevious = sender.tag == 100 ? true : false
        prevNextClosure?(isPrevious)
    }
}
extension ImageSliderCVCell : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        [prevBtn,nextBtn].filter({$0?.isHidden == false}).forEach({ $0?.isHidden = scrollView.zoomScale > 1.1 ? true : false })
        
        for i in 0..<InitialprevNextBtsVisibility.count
        {
            if i == 0 //previous
            {
                prevBtn.isHidden = scrollView.zoomScale != 1.0 ? true : InitialprevNextBtsVisibility[i]
            }else {
                nextBtn.isHidden = scrollView.zoomScale != 1.0 ? true : InitialprevNextBtsVisibility[i]
            }
        }
    }
}
