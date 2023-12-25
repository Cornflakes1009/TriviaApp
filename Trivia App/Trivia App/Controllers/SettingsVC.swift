//
//  SettingsVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/19/23.
//

import UIKit
import AVFoundation

class SettingsVC: UIViewController {
    
    var player: AVPlayer?
    
    // volume level
    // sound on/off
    // vibration
    // notification
    
    fileprivate let backButton = BackButton()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    fileprivate func setUpUI() {
        backButton.delegate = self
        playBackgroundVideo()
        let views: [UIView] = [backButton]
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            
        ])
    }
    
    // MARK: - Background Video
    func playBackgroundVideo() {
        if AppConstants.backgroundVideo != "" {
            let filePath = Bundle.main.path(forResource: AppConstants.backgroundVideo, ofType: ".mp4")
            if let path = filePath {
                player = AVPlayer(url: URL(fileURLWithPath: path))
                player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view.frame
                playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.view.layer.insertSublayer(playerLayer, at: 0)
                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
                player!.seek(to: CMTime.zero)
                player!.play()
                player?.isMuted = true
            }
        }
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }
}

extension SettingsVC: BackButtonDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
