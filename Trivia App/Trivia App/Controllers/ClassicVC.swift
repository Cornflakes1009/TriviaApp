//
//  ClassicVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/23/23.
//

import UIKit
import AVFoundation

class ClassicVC: UIViewController {
    
    var player: AVPlayer?
    
    let questions = ClassicModelData(json: "harryPotterSoloQuestions.json")
                              
    fileprivate let gearButton = GearButton()
    fileprivate let backButton = BackButton()
    
//    fileprivate let modeCategoryStackView = {
//        let sv = UIStackView()
//        sv.distribution = .fill
//        sv.distribution = .fillEqually
//        sv.axis = .vertical
//        sv.spacing = 10
//        return sv
//    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(questions.questions.count)
        setUpUI()
    }
    
    // MARK: - Setting Up UI
    fileprivate func setUpUI() {
        backButton.delegate = self
        gearButton.delegate = self
        
        playBackgroundVideo()
        //setUpCategoryStackView()
        let views: [UIView] = [backButton, gearButton]
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
            
//            modeCategoryStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            modeCategoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            modeCategoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
//    fileprivate func setUpCategoryStackView() {
//        for (index, category) in AppConstants.gameCategories.enumerated() {
//            let button = GameButton(title: category.name, fontColor: .white)
//            button.tag = index
//            modeCategoryStackView.addArrangedSubview(button)
//            button.addTarget(self, action: #selector(modeCategoryTapped(_:)), for: .touchUpInside)
//            button.heightAnchor.constraint(equalToConstant: 75).isActive = true
//        }
//    }
    
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

extension ClassicVC: BackButtonDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ClassicVC: GearButtonDelegate {
    func gearButtonTapped() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
