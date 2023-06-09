//
//  AboutBurbankWebVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/03/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
import WebKit
class AboutBurbankWebVC: UIViewController, WKNavigationDelegate,UIScrollViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var isFromAboutUs: Bool!
    var isFromTerms: Bool!
    var isFromPrivacy: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewData()
        webView.navigationDelegate = self
        self.setupNavigationBarButtons(shouldShowNotification: false)
        //  webView.scalesPageToFit = true
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setTextViewData() {
        if isFromAboutUs == true {
            self.title = "About Burbank"
           
            if let urlPath = Bundle.main.path(forResource: "AboutUS", ofType: "html")
            {
                DispatchQueue.main.async {
                    self.webView.load(URLRequest(url: URL(fileURLWithPath: urlPath, isDirectory: false)))
                }
                
            }
            
        }
       else if isFromTerms == true {
           self.title = "Terms of Use"
            webView.isHidden = false
//            textView.text = "Copyright conditions:\n\nAll photos and illustrations are representative and are to be used as a guide only. Floorplans and specifications may be varied by Burbank without notice, the dimensions are diagrammatic only and a Building Contract with final drawings will display the final dimensions and detail. The inclusion of furniture, floor coverings, wall paper, artwork, curtains, light fittings, lawns, planter boxes, fences, driveways, footpaths, patios and pergolas are intended merely as a guide and are not included in the price unless otherwise listed independently. All designs are the property of Burbank Group and must not be used, reproduced, copied or varied, wholly or in part without written permission from an authorised Burbank representative. All information provided on Burbank Group websites is provided for information purposes only and does not constitute a legal contract between Burbank Australia and any person or entity unless otherwise specified. This information is subject to change without prior notice. And while every reasonable effort is made to ensure current and accurate information is presented, Burbank Australia makes no guarantees of any kind. At times sites under Burbank Australia’s control may link to external sites or may contain community-based forums. Burbank Australia does not control, monitor or guarantee the information contained in these sites or information contained in links to other external websites, and does not endorse any views expressed or products or services offered therein. In no event shall Burbank Australia be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such site or resource."
//            textView.textColor = UIColor.black
//            textView.backgroundColor = UIColor.white
//            textView.isEditable = false
            
            let termsStr = "<p> <h3>Copyright conditions:</h3>\nAll photos and illustrations are representative and are to be used as a guide only. Floorplans and specifications may be varied by Burbank without notice, the dimensions are diagrammatic only and a Building Contract with final drawings will display the final dimensions and detail. The inclusion of furniture, floor coverings, wall paper, artwork, curtains, light fittings, lawns, planter boxes, fences, driveways, footpaths, patios and pergolas are intended merely as a guide and are not included in the price unless otherwise listed independently. All designs are the property of Burbank Group and must not be used, reproduced, copied or varied, wholly or in part without written permission from an authorised Burbank representative. All information provided on Burbank Group websites is provided for information purposes only and does not constitute a legal contract between Burbank Australia and any person or entity unless otherwise specified. This information is subject to change without prior notice. And while every reasonable effort is made to ensure current and accurate information is presented, Burbank Australia makes no guarantees of any kind. At times sites under Burbank Australia’s control may link to external sites or may contain community-based forums. Burbank Australia does not control, monitor or guarantee the information contained in these sites or information contained in links to other external websites, and does not endorse any views expressed or products or services offered therein. In no event shall Burbank Australia be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such site or resource. </p>"
            
            self.webView.loadHTMLStringWithMagic(content: termsStr, baseURL: nil)
            
//            self.privacyPolicyWebview.setf
            
        }else if isFromPrivacy == true {
            self.title = "Privacy Policy"
            webView.isHidden = false
            
            if let urlPath = Bundle.main.path(forResource: "Privacy Policy", ofType: "html")
            {
                DispatchQueue.main.async {
                    self.webView.load(URLRequest(url: URL(fileURLWithPath: urlPath, isDirectory: false)))
                }
                
            }
            
        }
    }
    
    
    //MARK: - WebView Delegate & Datasource
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"

        webView.evaluateJavaScript(jscript)
    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//        
//    }
}
extension WKWebView {

    /// load HTML String same font like the UIWebview
    ///
    //// - Parameters:
    ///   - content: HTML content which we need to load in the webview.
    ///   - baseURL: Content base url. It is optional.
    func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
