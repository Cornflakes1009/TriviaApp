//
//  BlitzVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/23/23.
//

import UIKit
import AVFoundation
//import GoogleMobileAds

class BlitzVC: UIViewController {
    
    var player: AVPlayer?
    fileprivate var timer = Timer()
    fileprivate var time: Double = 120

    fileprivate let gearButton = GearButton()
    fileprivate let backButton = BackButton()
    fileprivate let helpButton = HelpButton()
    fileprivate let exitView = ExitView()
    fileprivate let explanationView = BlitzExplanationView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addExplanationView()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if time < 121 {
            timer.invalidate()
        }
    }
    
    @objc func appMovedToForeground() {
        if time < 120 {
            
        }
    }
    
    // MARK: - Setup Views
    private func setUpUI() {
        playBackgroundVideo()
        
        backButton.delegate = self
        gearButton.delegate = self
        exitView.delegate = self
        
        exitView.alpha = 0
        
        let views = [backButton, gearButton, helpButton]
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            gearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            gearButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            gearButton.heightAnchor.constraint(equalToConstant: 50),
            gearButton.widthAnchor.constraint(equalToConstant: 50),
            
            helpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            helpButton.rightAnchor.constraint(equalTo: gearButton.leftAnchor, constant: 0),
            helpButton.heightAnchor.constraint(equalToConstant: 50),
            helpButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        

        
    }
    
    fileprivate func addExplanationView() {
        view.addSubview(explanationView)
        
        NSLayoutConstraint.activate([
            explanationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            explanationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            explanationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            explanationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        UIView.animate(withDuration: 1.2) {
            self.explanationView.alpha = 1
        }
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

extension BlitzVC: BackButtonDelegate {
    func backButtonTapped() {
        UIView.animate(withDuration: 1.2) {
            self.exitView.alpha = 1
        }
        
        view.addSubview(exitView)
        NSLayoutConstraint.activate([
            exitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            exitView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            exitView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            exitView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
}

extension BlitzVC: GearButtonDelegate {
    func gearButtonTapped() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BlitzVC: ExitViewDelegate {
    func exitTapped() {
        self.exitView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancelTapped() {
        UIView.animate(withDuration: 1.2, delay: 0.0, options:[.allowUserInteraction, .curveEaseInOut], animations: { [self] in
            self.exitView.alpha = 0
        }, completion: {_ in
            self.exitView.removeFromSuperview()
        })
    }
}
