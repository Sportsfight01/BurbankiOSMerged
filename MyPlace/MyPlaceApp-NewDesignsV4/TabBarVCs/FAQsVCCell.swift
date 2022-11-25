//
//  FAQsVCCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 16/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit
import WebKit

class FAQsVCCell: UITableViewCell {
    
    static let identifier = "FAQsVCCell"
    
    @IBOutlet weak var videoContainerView: UIView!
    {
        didSet
        {
            videoContainerView.layer.borderColor = AppColors.appOrange.cgColor
            videoContainerView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var questionLb: UILabel!
    @IBOutlet weak var answerLb: UILabel!
    @IBOutlet weak var videoStackView: UIStackView!
    lazy var webView : WKWebView  = {
        let configuration = WKWebViewConfiguration()
        //configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: frame, configuration: configuration)
       
        return webView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    func addVideo(url : String)
    {
       // let player = webView
        //player.backgroundColor = .orange
        //videoContainerView.backgroundColor = .systemPink
        videoContainerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
        
        ])
        if let urlR = URL(string: url){
            webView.load(URLRequest(url: urlR))
           
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension FAQsVCCell : WKNavigationDelegate
{
    
    //MARK: - WebView Delegate & Datasource
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        webView.evaluateJavaScript(jscript)
    }
    
}
