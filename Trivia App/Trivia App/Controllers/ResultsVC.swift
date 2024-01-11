//
//  ResultsVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 1/1/24.
//

import UIKit
import AVFoundation

class ResultsVC: UIViewController {
    var player: AVPlayer?
    var score: Int = 0
    
    fileprivate let gearButton = GearButton()
    fileprivate let helpButton = HelpButton()
    
    fileprivate let titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppConstants.titleFont
        label.textColor = AppConstants.labelColor
        label.text = "Game Over"
        return label
    }()
    
    fileprivate let scoreLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppConstants.instructionLabelFont
        label.textColor = AppConstants.labelColor
        label.alpha = 0
        return label
    }()
    
    fileprivate let backToMenuButton = {
        let btn = GameButton(title: "Back to Menu", fontColor: AppConstants.labelColor)
        btn.addTarget(self, action: #selector(backToMenuTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playBackgroundVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }

    fileprivate func setUpUI() {
        let views = [gearButton, helpButton, titleLabel, scoreLabel, backToMenuButton]
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
        
        NSLayoutConstraint.activate([
            gearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            gearButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            gearButton.heightAnchor.constraint(equalToConstant: 50),
            gearButton.widthAnchor.constraint(equalToConstant: 50),
            
            helpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            helpButton.rightAnchor.constraint(equalTo: gearButton.leftAnchor, constant: 0),
            helpButton.heightAnchor.constraint(equalToConstant: 50),
            helpButton.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: gearButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
            backToMenuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backToMenuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            backToMenuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
    
    @objc func backToMenuTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
