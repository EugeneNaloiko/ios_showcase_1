//
//  VideoPlayerView.swift
//
//  Created by Eugene Naloiko
//
import UIKit
import BMPlayer
import AVFoundation
import NVActivityIndicatorView

class VideoPlayerView: UIView {
  
  private var player: BMPlayer!
    
    private let heightDefaultValue: CGFloat = 224
    private var heightConstraint: NSLayoutConstraint!
    
    var height: CGFloat {
        set { self.heightConstraint.constant = newValue }
        get { return self.heightConstraint.constant }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        // If use the slide to back, remember to call this method
        // When using gestures to return, call the following method to manually destroy
        player.prepareToDealloc()
        print("VideoPlayViewController Deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupPlayerManager()
        preparePlayer()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
  
    @objc private func applicationWillEnterForeground() {
        
    }
    
    @objc private func applicationDidEnterBackground() {
        player.pause(allowAutoPlay: false)
    }
  
  /**
   prepare playerView
   */
  private func preparePlayer() {
    var controller: BMPlayerControlView? = BMPlayerCustomControlView()
    
    controller = BMPlayerCustomControlView()
    
    player = BMPlayer(customControlView: controller)
    self.addSubview(player)
    
    self.heightConstraint = self.player.heightAnchor.constraint(equalToConstant: heightDefaultValue)
    self.heightConstraint.isActive = true
    
    NSLayoutConstraint.activate([
        self.player.topAnchor.constraint(equalTo: self.topAnchor),
        self.player.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.player.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.player.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    
    player.delegate = self
    player.backBlock = { [weak self] (isFullScreen) in
        print("isFullScreen", isFullScreen)
    }
    
    self.layoutIfNeeded()
  }
  
    func setupPlayerResource(videoInfoModel: AllMuseVideosModel) {
        let quality = VideoQuality.q360p
        if let url = URL(string: videoInfoModel.getVideoUrl(videoQuality: quality) ?? "") {
            let asset = BMPlayerResource(name: videoInfoModel.title ?? "",
                                         definitions: [BMPlayerResourceDefinition(url: url, definition: quality.rawValue)],
                                         cover: nil,
                                         subtitles: nil)
            player.seek(30)
            player.setVideo(resource: asset)
        }
  }
  
    //Set player singleton, modify attributes
    private func setupPlayerManager() {
        resetPlayerManager()
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.tintColor = UIColor.tfOrangish
    }
  
  private func resetPlayerManager() {
    BMPlayerConf.allowLog = false
    BMPlayerConf.shouldAutoPlay = true
    BMPlayerConf.tintColor = UIColor.white
    BMPlayerConf.topBarShowInCase = .always
    BMPlayerConf.loaderType = NVActivityIndicatorType.ballRotateChase
  }
}

// MARK:- BMPlayerDelegate example
extension VideoPlayerView: BMPlayerDelegate {
  // Call when player orinet changed
  func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {

  }
  
  // Call back when playing state changed, use to detect is playing or not
  func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
  }
  
  // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
  func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
    print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
  }
  
  // Call back when play time change
  func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
  }
  
  // Call back when the video loaded duration changed
  func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
  }
}


