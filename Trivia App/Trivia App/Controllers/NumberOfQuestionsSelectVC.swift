//
//  NumberOfQuestionsSelectVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/27/23.
//

import UIKit
import AVFoundation

class NumberOfQuestionsSelectVC: UIViewController {
    
    var player: AVPlayer?
    
    fileprivate let gearButton = GearButton()
    fileprivate let backButton = BackButton()
    fileprivate let helpButton = HelpButton()
    
    fileprivate let instructionLabel = {
        let label = UILabel()
        label.text = "Select the Number of Questions"
        label.font = AppConstants.instructionLabelFont
        label.textAlignment = .center
        label.numberOfLines = 0
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
        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    // MARK: - Setting Up UI
    fileprivate func setUpUI() {
        backButton.delegate = self
        gearButton.delegate = self
        helpButton.delegate = self
        
        playBackgroundVideo()
        setUpCategoryStackView()
        let views: [UIView] = [backButton, gearButton, helpButton, instructionLabel, modeCategoryStackView]
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
            
            instructionLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            modeCategoryStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            modeCategoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modeCategoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    fileprivate func setUpCategoryStackView() {
        for (option, index) in AppConstants.questionNumberOptions {
            let button = GameButton(title: option, fontColor: AppConstants.labelColor)
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
    
    @objc func modeCategoryTapped(_ sender: UIButton) {
        let vc = ClassicVC()
        vc.selectedNumberOfQuestions = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NumberOfQuestionsSelectVC: BackButtonDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NumberOfQuestionsSelectVC: GearButtonDelegate {
    func gearButtonTapped() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NumberOfQuestionsSelectVC: HelpButtonDelegate {
    func helpButtonTapped() {
        print("G")
    }
}
