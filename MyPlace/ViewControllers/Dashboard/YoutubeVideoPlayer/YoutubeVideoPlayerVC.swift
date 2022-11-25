//
//  YoutubeVideoPlayerVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 02/11/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView


class YoutubeVideoPlayerVC: UIViewController, WKYTPlayerViewDelegate {

    
    let youTubePlayer: WKYTPlayerView = WKYTPlayerView ()
    
    var url: String = "" {
        didSet {
            if url.count > 0 {
//                let trimmedurl = url //.replacingOccurrences (of: "https://www.youtube.com/watch?v=", with: "")
                print(log: url)
//                youTubePlayer.loadVideo(byURL: url, startSeconds: 1, suggestedQuality: .default)
//                youTubePlayer.load
//                youTubePlayer.playVideo()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = COLOR_APPTHEME
        
        addPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        youTubePlayer.load(withVideoId: url.replacingOccurrences (of: "https://www.youtube.com/watch?v=", with: ""))
//        youTubePlayer.loadVideo(byURL: url, startSeconds: 1, suggestedQuality: .default)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        youTubePlayer.load(withVideoId: "Nz8ib76ni-0")
        if url.contains("https://www.youtube.com/watch?v=") {
            youTubePlayer.load(withVideoId: url.replacingOccurrences (of: "https://www.youtube.com/watch?v=", with: ""))
        }else {
            youTubePlayer.loadVideo(byURL: url, startSeconds: 0, suggestedQuality: .auto)
        }
//        youTubePlayer.loadVideo(byURL: "https://www.youtube.com/watch?v=Nz8ib76ni-0", startSeconds: 1, suggestedQuality: .auto)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        youTubePlayer.pauseVideo()
    }
    
    
    
    func addPlayer () {
        
        youTubePlayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(youTubePlayer)
        
        youTubePlayer.delegate = self
        
        NSLayoutConstraint.activate([
            youTubePlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            youTubePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            youTubePlayer.topAnchor.constraint(equalTo: view.topAnchor),
            youTubePlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    
    
    
    
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        
    }
    
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
        
    }
    
//    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
//
//    }
    
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
        print(log: error)
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo quality: WKYTPlaybackQuality) {
        
    }
    
//    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
//
//    }
    
    
}
