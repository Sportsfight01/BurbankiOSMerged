//
//  HeaderBreadCrumpCV.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/09/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


protocol HeaderBreadCrumpDelegate: NSObject {
    
    func selectedBreadCrumb (_ str: String)
}



class HeaderBreadCrump: UIView {
    
//    var breadcrumbCollectionView = UICollectionView (frame: .zero, collectionViewLayout: UICollectionViewFlowLayout ())
    
//    var heightCollection: NSLayoutConstraint?
    
    var scrollView : UIScrollView = UIScrollView(frame: .zero)
    var stackView : UIStackView = UIStackView(frame: .zero)
    
    weak var delegate: HeaderBreadCrumpDelegate?
    
    var updateFrame: (() -> Void)?
    
    var heightBreadCrum: CGFloat = 18

    var arrBreadCrumbs = [BreadCrumb] ()
    var selectedBreadCrumb: BreadCrumb?

    var selectedBreadCrumbText: String?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // loadCollectionView ()
        //self.backgroundColor = .purple
        self.addSubview(scrollView)
        //scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints  = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //stackView
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        self.backgroundColor = COLOR_CLEAR //APPCOLORS_3.HeaderFooter_white_BG
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadCollectionView () {
        
////        (breadcrumbCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
//        (breadcrumbCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = CGSize (width: 1, height: 1)
//        //UICollectionViewFlowLayout.automaticSize
//
//        self.addSubview(breadcrumbCollectionView)
//
//        breadcrumbCollectionView.backgroundColor = COLOR_CLEAR
//
////        breadcrumbCollectionView.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
//
//        breadcrumbCollectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        heightCollection = breadcrumbCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
//
//        NSLayoutConstraint.activate([
//            breadcrumbCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
////            self.bottomAnchor.constraint(equalTo: breadcrumbCollectionView.bottomAnchor, constant: 0),
//            breadcrumbCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            breadcrumbCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//            heightCollection!
//        ])
//
//
//        breadcrumbCollectionView.register(BreadCrumbCell.self, forCellWithReuseIdentifier: "Cell")
//
//        breadcrumbCollectionView.delegate = self
//        breadcrumbCollectionView.dataSource = self
                
    }
    
    func addObserver () {
//        breadcrumbCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
    }
    
    func removeObserver () {
//        breadcrumbCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        tableView.layer.removeAllAnimations()
//        tableHeightConstraint.constant = tableView.contentSize.height
//        UIView.animate(withDuration: 0.5) {
//            self.updateViewConstraints()
//        }
        
//        heightCollection?.constant = breadcrumbCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
       
    
    func addBreadcrumb (_ str: String) {
        
        arrBreadCrumbs.append(BreadCrumb (breadcrumb: str))
//        breadcrumbCollectionView.reloadData()
        
        reloadViewItems ()
    }
    
    func removeBreadcrumb (_ str: String) {
        
        var itemToRemoveIndex: Int = -1
        
        for item in 0...arrBreadCrumbs.count-1 {
            let breadCrumb = arrBreadCrumbs[item]
            if breadCrumb.breadCrumb == str {
                itemToRemoveIndex = item
                break
            }
        }
        if itemToRemoveIndex > -1 {
            arrBreadCrumbs.remove(at: itemToRemoveIndex)
//            breadcrumbCollectionView.reloadData()
            
            reloadViewItems ()
        }
    }
    
    func removeAllBreadCrumbs () {
        
        arrBreadCrumbs.removeAll()
//        breadcrumbCollectionView.reloadData()
        
        reloadViewItems ()
    }
    
    func reloadViewItems () {

        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()}) // remove all buttons
        //scrollView.removeFromSuperview()
        
        guard arrBreadCrumbs.count > 0 else {return}

        var buttonArray : [UIButton] = []
        for i in 0...arrBreadCrumbs.count-1 {

            let item = arrBreadCrumbs[i]
            let text = (item.breadCrumb?.trim() ?? "") + (i == arrBreadCrumbs.count-1 ? "" : " |")

            let titleBtn = UIButton(type: .system)
            titleBtn.tag = 100 + i
            titleBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            let font = FONT_LABEL_SUB_HEADING (size: FONT_11)
            setAppearanceFor(view: titleBtn, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: font)
            titleBtn.setTitle(text, for: .normal)

            if let _ = self.delegate {
                titleBtn.isUserInteractionEnabled = true
                titleBtn.addTarget(self, action: #selector(handleBreadCrumbButtonAction(_:)), for: .touchUpInside)
            }else {
                titleBtn.isUserInteractionEnabled = false
            }

            buttonArray.append(titleBtn)

        }

        setupStackView(views: buttonArray)
        
        if let str = selectedBreadCrumbText {
            changeColorForSelectedBreadCrumb (str)
        }
        
        
        
        //
        //        for item in self.subviews {
        //            if item.isKind(of: UIButton.self) {
        //                item.removeFromSuperview()
        //            }
        //        }
        //
        //        if arrBreadCrumbs.count > 0 {
        //
        //            var xPos: CGFloat = 0
        //            var yPos: CGFloat = 0
        //            let totalWidth = self.frame.size.width
        //            let height: CGFloat = 15
        //
        //            let font = FONT_LABEL_SUB_HEADING (size: FONT_11)
        //
        //
        //            for i in 0...arrBreadCrumbs.count-1 {
        //
        //                let item = arrBreadCrumbs[i]
        //                let text = (item.breadCrumb?.trim() ?? "") + (i == arrBreadCrumbs.count-1 ? "" : "  |")
        //
        //                let btnTitle = UIButton (type: .system)
        //                //(frame: CGRect (x: xPos, y: yPos, width: 0, height: height))
        //                btnTitle.tag = 100 + i
        //                btnTitle.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        //                setAppearanceFor(view: btnTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: font)
        //                btnTitle.setTitle(text, for: .normal)
        //
        //                if let _ = self.delegate {
        //                    btnTitle.isUserInteractionEnabled = true
        //                    btnTitle.addTarget(self, action: #selector(handleBreadCrumbButtonAction(_:)), for: .touchUpInside)
        //                }else {
        //                    btnTitle.isUserInteractionEnabled = false
        //                }
        //                self.addSubview(btnTitle)
        //                self.bringSubviewToFront(btnTitle)
        //
        //
        //                let width = text.widthOfString(usingFont: font) + 15
        //                print(width)
        //                if width > self.frame.width{
        //                   print(log: "size overlaps")
        //                    btnTitle.frame.size.width = self.frame.width
        //                }else{
        //                    btnTitle.frame.size.width = width
        //                }
        //
        //                if (xPos + width) > totalWidth {
        //                    xPos = 0
        //                    yPos = yPos + height
        //                }
        //
        //                print(xPos)
        //                btnTitle.frame = CGRect (x: xPos, y: yPos, width: width, height: height)
        //
        //                xPos = xPos + width
        //            }
        //
        ////            heightBreadCrumb.constant = yPos + height
        ////            self.layoutIfNeeded()
        ////            self.updateConstraints()
        ////
        ////            self.superview?.layoutIfNeeded()
        ////            self.superview?.updateConstraints()
        //
        //            heightBreadCrum = yPos + height
        //
        //            if let update = updateFrame {
        //                update ()
        //            }
        //
        //            if let str = selectedBreadCrumbText {
        //                changeColorForSelectedBreadCrumb (str)
        //            }
        //        }
    }
    
    
    
    func setupStackView(views : [UIView])
    {
    
       
        
        //stackView = UIStackView(arrangedSubviews: views)
        views.forEach({stackView.addArrangedSubview($0)})
     
        scrollView.showsHorizontalScrollIndicator = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 4
        print(log: "Beforen :- \(scrollView.contentSize.width)")
        
        scrollView.layoutIfNeeded()
        
        print(log: "after :- \(scrollView.contentSize.width)")
        
        if scrollView.contentSize.width > scrollView.frame.width{
            scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.width + 5, y: 0), animated: true)
        }
      //  scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: scrollView.contentSize.width - scrollView.frame.width, y: 0), size: CGSize(width: scrollView.frame.width, height: scrollView.frame.height)), animated: true)
        
    }
    
    
    
    func changeColorForSelectedBreadCrumb (_ str: String) {
        
        selectedBreadCrumbText = str
        
        makeDefaultThemesForBreadCrumbButtons ()
        
        guard stackView.arrangedSubviews.count > 0 else {return}
        let btnArray = stackView.arrangedSubviews
        for btn in btnArray where btn.isKind(of: UIButton.self)
        {
            if (btn as! UIButton).title(for: .normal) == str || (btn as! UIButton).title(for: .normal)?.replacingOccurrences(of: "  |", with: "") == str {
                (btn as! UIButton).titleLabel?.font = FONT_LABEL_HEADING (size: FONT_11)
            }
        }
        
//        for item in self.subviews {
//            if item.isKind(of: UIButton.self) {
//                if (item as! UIButton).title(for: .normal) == str || (item as! UIButton).title(for: .normal)?.replacingOccurrences(of: "  |", with: "") == str {
//                    (item as! UIButton).titleLabel?.font = FONT_LABEL_HEADING (size: FONT_11)
//                }
//            }
//        }
    }
    
    func makeDefaultThemesForBreadCrumbButtons () {
        guard stackView.arrangedSubviews.count > 0  else {return}
        let btnArray = stackView.arrangedSubviews
        for btn in btnArray where btn.isKind(of: UIButton.self)
        {
            (btn as! UIButton).titleLabel?.font = FONT_LABEL_SUB_HEADING (size: FONT_11)
        }
//        for item in self.subviews {
//            if item.isKind(of: UIButton.self) {
//                (item as! UIButton).titleLabel?.font = FONT_LABEL_SUB_HEADING (size: FONT_11)
//            }
//        }
    }
    
    //MARK: - Action
    
    @objc func handleBreadCrumbButtonAction (_ sender: UIButton) {
        
        if let dele = delegate {
            dele.selectedBreadCrumb(arrBreadCrumbs[sender.tag-100].breadCrumb ?? "")
        }
    }
    
    
    
    //MARK: - CollectionView
    
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return delegate?.breadCrumbs().count ?? 0
//        return arrBreadCrumbs.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BreadCrumbCell
//
////        cell.breadCrumb = delegate?.breadCrumbs()[indexPath.row]
//
//        cell.breadCrumb = arrBreadCrumbs[indexPath.row].breadCrumb
//
//        cell.selectedBreadCrumb = false
//
//        if selectedBreadCrumb?.breadCrumb == cell.breadCrumb {
//            cell.selectedBreadCrumb = true
//        }
//
////        cell.btnTitle.layoutIfNeeded()
////        cell.layoutIfNeeded()
//
//        cell.setCellWidth (width: (cell.breadCrumb?.trim() ?? "").widthOfString(usingFont: cell.lableTitle.font))
//
////        cell.setCellWidth(width: calculatedSizeForLabel(text: cell.breadCrumb?.trim() ?? "", With: 18).width)
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        selectedBreadCrumb = arrBreadCrumbs[indexPath.row]
//        collectionView.reloadData()
//
//        delegate?.selectedBreadCrumb(selectedBreadCrumb?.breadCrumb ?? "")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize (width: (arrBreadCrumbs[indexPath.row].breadCrumb?.trim() ?? "").widthOfString(usingFont: FONT_LABEL_SUB_HEADING (size: FONT_11)), height: 18)
//    }
//
//    func calculatedSizeForLabel (text: String, With height: CGFloat) -> CGSize {
//
//        let constraint = CGSize (width: 20000.0, height: height)
//
//        let context = NSStringDrawingContext ()
//        let boundingbox = (text as NSString).boundingRect(with: constraint, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: FONT_LABEL_SUB_HEADING (size: FONT_11)], context: context).size
//
//        return CGSize (width: boundingbox.width + 10, height: boundingbox.height)
//    }
    
}



//class BreadCrumbCell: UICollectionViewCell {
//
//    var cellWidthConstraint: NSLayoutConstraint?
//    var lableTitle = UILabel ()
//
////    var btnTitle = UIButton ()
//
//
//    var breadCrumb: String? {
//        didSet {
//
//        }
//    }
//
//    var selectedBreadCrumb: Bool? {
//        didSet {
//            fillDetails()
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        loadCellView ()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        loadCellView ()
//    }
//
//
//    func setCellWidth (width: CGFloat) {
//
//        cellWidthConstraint?.constant = width
//        cellWidthConstraint?.isActive = true
//    }
//
//
//    func loadCellView () {
//
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        cellWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0.0)
//
//
//
//        translatesAutoresizingMaskIntoConstraints = true
//
//        backgroundColor = COLOR_CLEAR
//
//        self.addSubview(lableTitle)
//
//        self.bringSubviewToFront(lableTitle)
//
//        setAppearanceFor(view: lableTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_11))
//        lableTitle.numberOfLines = 1
//
//
//        lableTitle.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            lableTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            lableTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
//            lableTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
//            self.rightAnchor.constraint(equalTo: lableTitle.rightAnchor, constant: 0),
////            lableTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5),
////            lableTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
//            lableTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
//        ])
//
////        self.addSubview(btnTitle)
////        self.bringSubviewToFront(btnTitle)
////
////        setAppearanceFor(view: btnTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_11))
////        btnTitle.titleLabel?.numberOfLines = 0
//
//
////        btnTitle.translatesAutoresizingMaskIntoConstraints = false
////
////        NSLayoutConstraint.activate([
////            btnTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
////            btnTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
////            btnTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
////            self.rightAnchor.constraint(equalTo: btnTitle.rightAnchor, constant: 0),
////            //            lableTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5),
////            //            lableTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
////            btnTitle.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
////        ])
//
//    }
//
//
//    func fillDetails () {
//
////        btnTitle.setTitle(breadCrumb ?? "", for: .normal)
////
////        if selectedBreadCrumb == true {
////
////            btnTitle.setTitleColor(APPCOLORS_3.Orange_BG, for: .normal)
////            btnTitle.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
////        }else {
////
////            btnTitle.setTitleColor(APPCOLORS_3.HeaderFooter_white_BG, for: .normal)
////            btnTitle.backgroundColor = APPCOLORS_3.Orange_BG
////        }
//
//        lableTitle.text = breadCrumb ?? ""
//
//        if selectedBreadCrumb == true {
//
//            lableTitle.textColor = APPCOLORS_3.Orange_BG
//            lableTitle.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
//        }else {
//
//            lableTitle.textColor = APPCOLORS_3.HeaderFooter_white_BG
//            lableTitle.backgroundColor = APPCOLORS_3.Orange_BG
//        }
//    }
//
//}

