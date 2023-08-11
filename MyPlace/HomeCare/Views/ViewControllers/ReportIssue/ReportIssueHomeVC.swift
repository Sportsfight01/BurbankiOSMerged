//
//  ReportIssueHomeVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 31/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import AVKit


class ReportIssueHomeVC: HomeCareBaseProfileVC {
    
    @IBOutlet weak var playBTNBaseView: UIView!
    
    @IBOutlet weak var gettingStartedLBL: UILabel!
    
    @IBOutlet weak var gtngStrtDiscriptionLBL: UILabel!
    
    @IBOutlet weak var playBTN: UIButton!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var containerView: UIView!
    private var scrollView : UIScrollView!
    
    @IBOutlet weak var submittedIssuesBaseView: UIView!
    
    @IBOutlet weak var reportOtherIssueBTN: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var webView : WKWebView  = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
       
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI()
    {
        //profileSetup
        profileBaseView.baseImageView.image = nil
        profileBaseView.contentView.backgroundColor = AppColors.AppGray
        profileBaseView.navigationView.backgroundColor = AppColors.AppGray
        profileBaseView.titleLBL.text = "Report Issue"
        profileBaseView.profileView.image = UIImage(named: "BurbankLogo_Black")

        
        setAppearanceFor(view: profileBaseView.titleLBL, backgroundColor: .clear, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_22))
        setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "Your guide to issue reporting with you new Burbank home \(CurrentUser.jobNumber ?? "").", rangeStrings: ["Your guide to issue reporting with you new Burbank home ", "\(CurrentUser.jobNumber ?? "")."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_SEMI_BOLD (size: FONT_9)], alignmentCenter: false)
        
        self.submittedIssuesBaseView.isHidden = true
        
        let isLoggedIssueCompleted = UserDefaults.standard.string(forKey: "issueLoged")
        if isLoggedIssueCompleted == "1"{
            UserDefaults.standard.set("0", forKey: "issueLoged")
            self.submittedIssuesBaseView.isHidden = false
           
            setAttributetitleFor(view: profileBaseView.descriptionLBL, title: "Your guide to issue reporting with you new Burbank home \(CurrentUser.jobNumber ?? "").", rangeStrings: ["Your guide to issue reporting with you new Burbank home ", "\(CurrentUser.jobNumber ?? "")."], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_BODY (size: FONT_9), FONT_LABEL_SEMI_BOLD (size: FONT_9)], alignmentCenter: false)
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeCareIssueStatusTVC", bundle: nil), forCellReuseIdentifier: "HomeCareIssueStatusTVC")
        //addScrollView()
    }
    
    
    
    //MARK: - Button Actions
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.playBTNBaseView.isHidden = false
        addTopBordertoTabBar(vc: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        let isLoggedIssueCompleted = UserDefaults.standard.string(forKey: "issueLoged")
        if isLoggedIssueCompleted == "1"{
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    @IBAction func reportMinorDefectsBtnAction(_ sender: UIButton) {
        let vc = LogIssueVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTappedOnPlayBtn(_ sender: UIButton) {
        self.playBTNBaseView.isHidden = true
        addVideo()
    }
    
    @IBAction func reportOtherIssueBTNafterSubmit(_ sender: UIButton) {
        let vc = LoggedissuesVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func reportOtherIssuesBtnAction(_ sender: UIButton) {
        let vc = SelectIssueTypeVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func addVideo(){
        videoPlayerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: videoPlayerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: videoPlayerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: videoPlayerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor)
            
        ])
        
        
        
        if let urlR = URL(string: "https://www.youtube.com/embed/MYbzvpFb4XE"){
            webView.load(URLRequest(url: urlR))
            
            
        }
    }
}

extension ReportIssueHomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCareIssueStatusTVC", for: indexPath) as! HomeCareIssueStatusTVC
        cell.statusLBL.textColor = APPCOLORS_3.Orange_BG
        cell.statusLBL.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubmittedIssueListVC.instace(sb: .reports)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ReportIssueHomeVC : WKNavigationDelegate
{
    
    //MARK: - WebView Delegate & Datasource
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//
//        webView.evaluateJavaScript(jscript)
//    }
    
}
