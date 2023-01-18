//
//  MyPlace3DVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 05/08/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import CoreMotion
import WebKit

class MyPlace3DVC: UIViewController,UINavigationControllerDelegate {
    
    //MARK:- Properties
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var btnback : UIButton!
    
    @IBOutlet weak var webViewSuperView : UIView!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imagePortrait: UIImageView!
    @IBOutlet weak var imageTilt: UIImageView!
    @IBOutlet weak var labelPortrait: UILabel!
    
    @IBOutlet weak var heightHeader : NSLayoutConstraint!
    var motionManager: CMMotionManager!
    var preZoomScale : CGFloat?
//    var webView: WKWebView!
    
    var url: String?
    
    var notLoaded = true
    let names: [String] = [   //Pull down Hardware -> Orientation
            "unknown",            //0
            "portrait",           //1 home button at bottom
            "portraitUpsideDown", //2 home button at top
            "landscapeLeft",      //3 home button on right
            "landscapeRight",     //4 home button on left
            "faceUp",             //5 screen facing upwards
            "faceDown",           //6 screen facing downwards
        ];
//    override func loadView() {
//            let webConfiguration = WKWebViewConfiguration()
//            webView = WKWebView(frame: .zero, configuration: webConfiguration)
//            webView.uiDelegate = self
//        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(orientationChanged),
                   name: UIDevice.orientationDidChangeNotification,
                   object: nil
               );
        
        // Do any additional setup after loading the view.
        
        CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_myPlace3d_screen_loading)
        
        //MARK: Changed text myPlace3D to HomeX
        
        _ = setAttributetitleFor(view: titleLabel, title: "HomeX", rangeStrings: ["Home", "X"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [logoFont, logoFont], alignmentCenter: false)
        
        labelPortrait.text = "ROTATE YOUR \nPHONE TO ENTER"
        setAppearanceFor(view: labelPortrait, backgroundColor: .clear, textColor: .white, textFont: FONT_LABEL_SUB_HEADING(size: FONT_18))
        addWebView()
      webView.isHidden = true
        
        self.view.bringSubviewToFront (imagePortrait)
        self.view.bringSubviewToFront(imageTilt)
        
        
        imageTilt.loadGif(name: "Turn-Phone-Large3_with-Circle")
        
     // webViewSuperView.isHidden = true
      //  webView.isHidden = true
        
        btnback.superview?.isHidden = false
        imagePortrait.isHidden = false
        imageTilt.isHidden = false
        labelPortrait.isHidden = false
        heightHeader.constant = 80
        webView.uiDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startDeviceMotionUpdates()
        
        if let accelerometerData = motionManager.accelerometerData {
//            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func keyboardWillAppear() {
        //Do something here
        print(webView.scrollView.zoomScale)
        self.preZoomScale = self.preZoomScale ?? webView.scrollView.zoomScale
    }
    
    
    
    
    @objc func keyboardWillDisappear() {
        //Do something here
        print("keyboard hiden")
        print(webView.scrollView.zoomScale)
        webView.scrollView.zoomScale = preZoomScale ?? 0.8
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    func addWebView () {
//        webView = WKWebView (frame: .zero , configuration: WKWebViewConfiguration ())
        webView.uiDelegate = self
        webView.backgroundColor = .green
        webView.navigationDelegate = self
        
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        webView.fullscreenState = .enteringFullscreen
     //   webView.translatesAutoresizingMaskIntoConstraints = false
        
        webViewSuperView.backgroundColor = .red
//        self.webViewSuperView.addSubview(webView)
//
//        self.view.bringSubviewToFront(webView)
                
//        NSLayoutConstraint.activate([
//            webView.leadingAnchor.constraint(equalTo: webViewSuperView.leadingAnchor, constant: 0),
//            webView.trailingAnchor.constraint(equalTo: webViewSuperView.trailingAnchor, constant: 0),
//            webView.topAnchor.constraint(equalTo: webViewSuperView.topAnchor, constant: 0),
//            webView.bottomAnchor.constraint(equalTo: webViewSuperView.bottomAnchor, constant: 0)
//        ])
    }
    
    func loadWeb () {
      addWebView()
        notLoaded = false
        
        if let urlstr = url {
            if let reqURL = URL (string: urlstr) {
                print(reqURL)
                
                showActivityFor(view: self.view)
                
                let request = URLRequest (url: reqURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
                print("webView URL:- \(urlstr)")
                //              let request = URLRequest(url: URL(string: urlstr)!)
                webView.load(request)
                if #available(iOS 15.4, *) {
                    webView.configuration.preferences.isElementFullscreenEnabled = true
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    
    
    @IBAction func handleButtonAction (_ sender: UIButton) {
        
        if sender == btnback {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeDesigns_detailView_myPlace3d_back_button_touch)
            
            //            if webView.canGoBack {
            //                webView.goBack()
            //            }else {
            self.navigationController?.popViewController(animated: true)
            //            }
        }
    }
    
    
    func updateModes (_ mode: UIInterfaceOrientationMask) {
        
        if mode == .landscape || mode == .landscapeLeft || mode == .landscapeRight {
           
                if self.notLoaded {
                    self.loadWeb ()
                }
                self.webView.isHidden = false
                self.btnback.superview?.isHidden = true
                self.imagePortrait.isHidden = true
                self.imageTilt.isHidden = true
                self.labelPortrait.isHidden = true
                self.heightHeader.constant = 0
        }else {
            if webView != nil || btnback != nil || imagePortrait != nil{
                webView.isHidden = true
                btnback.superview?.isHidden = false
                imagePortrait.isHidden = false
                imageTilt.isHidden = false
                labelPortrait.isHidden = false
                heightHeader.constant = 80
            }
            
        }
    }
    
    @objc func orientationChanged(_ notification: NSNotification) {
           //current is a type property of class UIDevice.
           print(names[UIDevice.current.orientation.rawValue])
        
        
        if UIDevice.current.orientation.isLandscape{
            updateModes(.landscape)
        }else{
            updateModes(.portrait)
        }
        
       }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("+++++++++++++++++++++++++++++ \(UIDevice.current.orientation)")
    }
    
    
}


extension MyPlace3DVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        hideActivityFor(view: self.view)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      print(error.localizedDescription)
        
        hideActivityFor(view: self.view)
    }
    
}


extension AppDelegate {
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) ->
        UIInterfaceOrientationMask {
            
            if let navigation = window?.rootViewController as? UINavigationController {
                if navigation.visibleViewController is MyPlace3DVC {
                    if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                        
                        (navigation.visibleViewController as! MyPlace3DVC).updateModes(.landscape)
                        return .landscape
                    }
                    (navigation.visibleViewController as! MyPlace3DVC).updateModes(.portrait)
                    return .portrait
                }
            }
            return .portrait
    }
    
}
class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
