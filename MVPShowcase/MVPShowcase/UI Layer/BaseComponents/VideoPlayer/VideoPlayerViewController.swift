//
//  VideoPlayerViewController.swift
//
//  Created by Eugene Naloiko
//

import UIKit
import BMPlayer
import AVFoundation
import NVActivityIndicatorView

class VideoPlayerViewController: UIViewController {
    
    private var player: BMPlayer!
    private var videoInfoModel: AllMuseVideosModel
    
    private let defaultQuality = VideoQuality.q240p
    
    var backButtonTappedClosure: (() -> Void)?
    
    deinit {
        player.prepareToDealloc()
        print("VideoPlayViewController Deinit")
    }
    
    init(videoInfoModel: AllMuseVideosModel, backButtonTappedClosure: (() -> Void)?) {
        self.videoInfoModel = videoInfoModel
        super.init(nibName: nil, bundle: nil)
        self.backButtonTappedClosure = backButtonTappedClosure
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerManager()
        preparePlayer()
        setupPlayerResource(videoInfoModel: self.videoInfoModel)
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Or to rotate and lock
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.darkContent, animated: false)
        // If use the slide to back, remember to call this method
        // 使用手势返回的时候，调用下面方法
        player.autoPlay()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        player.pause(allowAutoPlay: true)
    }
    
    /**
     prepare playerView
     */
    private func preparePlayer() {
        let controller: BMPlayerControlView = BMPlayerControlView()
        
        player = BMPlayer(customControlView: controller)
        view.addSubview(player)
        
        player.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
        }
        
        player.delegate = self
        player.backBlock = { [weak self] (isFullScreen) in
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            self?.motionDismissViewController()
            self?.backButtonTappedClosure?()
        }
        self.view.layoutIfNeeded()
    }
    
    func setupPlayerResource(videoInfoModel: AllMuseVideosModel) {
        if let url = URL(string: videoInfoModel.getVideoUrl(videoQuality: self.defaultQuality) ?? "") {
            print("Playing URL: ", url)
            let asset = BMPlayerResource(url: url,
                                         name: "",
                                         cover: nil,
                                         subtitle: nil)
            player.setVideo(resource: asset)
        }
    }
    
    func setupPlayerManager() {
        resetPlayerManager()
    }
    
    func resetPlayerManager() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.tintColor = UIColor.white
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.loaderType = NVActivityIndicatorType.ballRotateChase
    }
    
}

// MARK:- BMPlayerDelegate example
extension VideoPlayerViewController: BMPlayerDelegate {
    // Call when player orient changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        player.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(view.snp.bottom)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
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
        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
