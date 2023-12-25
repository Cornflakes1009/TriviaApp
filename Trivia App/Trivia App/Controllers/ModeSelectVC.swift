//
//  ModeSelectVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/19/23.
//

import UIKit
import AVFoundation

class ModeSelectVC: UIViewController {
    
    var player: AVPlayer?
    
    fileprivate let gearButton = GearButton()
    fileprivate let backButton = BackButton()
    fileprivate let helpButton = HelpButton()
    
    var titleLabel = {
        let label = UILabel()
        //label.text = AppConstants.appName
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppConstants.titleFont
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    fileprivate let instructionLabel = {
        let label = UILabel()
        label.text = "Select a Game Mode"
        label.font = AppConstants.instructionLabelFont
        label.textAlignment = .center
        label.textColor = AppConstants.labelColor
        return label
    }()
    
    fileprivate let modeCategoryStackView = {
        let sv = UIStackView()
        sv.distribution = .fill
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // making the title label fade in
        UIView.animate(withDuration: 4.5) {
            self.titleLabel.alpha = 1
        }
    }
    
    // MARK: - Setting Up UI
    fileprivate func setUpUI() {
        backButton.delegate = self
        gearButton.delegate = self
        helpButton.delegate = self
        
        playBackgroundVideo()
        setUpCategoryStackView()
        let views: [UIView] = [backButton, gearButton, helpButton, titleLabel, instructionLabel, modeCategoryStackView]
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
            
            titleLabel.topAnchor.constraint(equalTo: gearButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            modeCategoryStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            modeCategoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modeCategoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            
        ])
    }
    
    fileprivate func setUpCategoryStackView() {
        for (index, category) in AppConstants.gameCategories.enumerated() {
            let button = GameButton(title: category.name, fontColor: .white)
            button.tag = index
            modeCategoryStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(modeCategoryTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 75).isActive = true
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
    
    // TODO: maybe pass in an index here instead
    @objc func modeCategoryTapped(_ sender: UIButton) {
        let vc = AppConstants.gameCategories[sender.tag].vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ModeSelectVC: BackButtonDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ModeSelectVC: GearButtonDelegate {
    func gearButtonTapped() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ModeSelectVC: HelpButtonDelegate {
    func helpButtonTapped() {
        print("G")
    }
}
