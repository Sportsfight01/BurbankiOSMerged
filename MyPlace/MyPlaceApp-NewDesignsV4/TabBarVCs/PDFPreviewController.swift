//
//  PDFPreviewController.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 15/07/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
import QuickLook

class PDFPreviewController : UIViewController, QLPreviewControllerDataSource
{
    var pdfName : String?
    var fileURL : String!
//    lazy var webView : WKWebView  = {
//        let web = WKWebView()
//        return web
//    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pdfName
//         let url = URL(fileURLWithPath: fileURL)
//        webView.load(URLRequest(url: url))
//        webView.navigationDelegate = self
//
//        self.view.addSubview(webView)
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
     
        
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let previewController = QLPreviewController()
//        previewController.dataSource = self
//        present(previewController, animated: true)
        
        self.setupNavigationBarButtons(title:"", backButton: true, notificationIcon: false)
        self.view.backgroundColor = .blue

    }
    //MARK: - Quicklook Delegate
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//
//        webView.evaluateJavaScript(jscript)
//    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        let url = URL(fileURLWithPath: fileURL)
        return url as QLPreviewItem
    }

}
