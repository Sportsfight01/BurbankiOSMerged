//
//  InfoCentreDetailsVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 17/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class InfoCentreDetailsVC: UIViewController {
    
    @IBOutlet weak var titleLBL: UILabel!
    var infoCentreDetails : LstInfo?
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var textLBL: UILabel!
    
    lazy var webView : WKWebView  = {
        let configuration = WKWebViewConfiguration()
        //configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
       
        return webView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addVideo()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBarButtons()
    }
    //MARK: - Helper Funcs
    func setupUI()
    {
        titleLBL.text = infoCentreDetails?.heading
        textLBL.text = infoCentreDetails?.lstFAQDescription.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
    }
    func addVideo()
    {
        
           // let player = webView
            //player.backgroundColor = .orange
            //videoContainerView.backgroundColor = .systemPink
            videoContainerView.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
          //  webView.navigationDelegate = self
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
                webView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
                webView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)

            ])
        if let urlR = URL(string: infoCentreDetails?.videoURL ?? ""){
                webView.load(URLRequest(url: urlR))

            }

        
        
        
//        //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
//        
//        let playerView = VideoPlayerView(videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" , frame: videoContainerView.frame)
//        self.videoContainerView.addSubview(playerView)
//        playerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            playerView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
//            playerView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor),
//            playerView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
//            playerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
//        ])
        
    //    guard let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else {return}
//        let player = AVPlayer(url: videoURL)
//       // player.currentItem?.duration
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.videoContainerView.bounds
//        playerLayer.videoGravity = .resize
//        self.videoContainerView.layer.addSublayer(playerLayer)
//        player.play()
//        player.isMuted = true
    }
    
    @IBAction func didTappedOnBackBTN(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func didTappedOnSupport(_ sender: UIButton) {
        
    }
    
    
}
