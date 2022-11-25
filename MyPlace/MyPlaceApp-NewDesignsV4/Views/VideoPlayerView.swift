//
//  VideoPlayerView.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 03/02/22.
//  Copyright © 2022 DMSS. All rights reserved.
//
import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    //MARK: - Properties
    
    //Activity Indicater
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    //PlayPauseButton
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "icon_Play_Outline")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    
    var videoURL : String?
    var isPlaying = false
    var playerLayer: CALayer?
    var player = AVPlayer()

    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        view.backgroundColor = UIColor.clear
         
        return view
    }()
    
    //MARK: - Initializers
    
    required init(videoURL: String , frame : CGRect) {
        self.videoURL = videoURL
        super.init(frame: frame)
        // Setting up the view can be done here
        setupConstraints()
        setupPlayerView()
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
        
    //MARK: - Helper Methods
    private func setupConstraints()
    {
        //control containerView
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        controlsContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        controlsContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        controlsContainerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //activity IndicatorView
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //pausePlayButton
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    private func setupPlayerView() {
        guard let urlString = videoURL else {return}
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let avPlayer = AVPlayerLayer(player: player)
            avPlayer.videoGravity = .resize
            self.playerLayer = avPlayer
            guard self.playerLayer != nil else {return}
            self.layer.addSublayer(playerLayer!)
            playerLayer!.frame = self.bounds
            player.play()
            player.isMuted = true
            
           
            player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            controlsContainerView.bringSubviewToFront(pausePlayButton)
            isPlaying = true
        
        }
    }
    @objc func handlePause() {
        if isPlaying {
            player.pause()
            pausePlayButton.setImage(UIImage(named: "icon_Play_Outline"), for: .normal)
        } else {
            player.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    

}

