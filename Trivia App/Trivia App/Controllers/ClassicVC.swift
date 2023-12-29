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
    
    fileprivate var questions: QuestionModelData?
    //fileprivate var questions = QuestionModelData(json: AppConstants.classicTrivia, numberOfQuestions: 0).questions
    var selectedNumberOfQuestions = 0
    fileprivate var questionIndex = 0
    fileprivate var score = 0
                              
    fileprivate let gearButton = GearButton()
    fileprivate let backButton = BackButton()
    
    fileprivate var gameButtons = [GameButton]()
    
    fileprivate let questionLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppConstants.instructionLabelFont
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    fileprivate let questionStackView = {
        let sv = UIStackView()
        sv.distribution = .fill
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    fileprivate let bannerView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getQuestions(num: selectedNumberOfQuestions)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // making the question label fade in
        UIView.animate(withDuration: 3.5) {
            self.questionLabel.alpha = 1
        }
    }
    
    // MARK: - Setting Up UI
    fileprivate func setUpUI() {
        backButton.delegate = self
        gearButton.delegate = self
        
        playBackgroundVideo()
        updateUI()
        setUpQuestionStackView()
        
        let views: [UIView] = [backButton, gearButton, questionLabel, questionStackView, bannerView]
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
            
            questionLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            questionLabel.leftAnchor.constraint(equalTo: backButton.leftAnchor, constant: 20),
            questionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            questionStackView.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -20),
            questionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bannerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bannerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 50),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    fileprivate func setUpQuestionStackView() {
        for (index, category) in AppConstants.gameCategories.enumerated() {
            let button = GameButton(title: category.name, fontColor: .white)
            button.tag = index
            questionStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(modeCategoryTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 75).isActive = true
            gameButtons.append(button)
        }
    }
    
    fileprivate func updateUI() {
        questionLabel.text = questions?.questions[questionIndex].question
        
        for (index, button) in gameButtons.enumerated() {
            
        }
    }
    
    fileprivate func getQuestions(num: Int) {
        questions = QuestionModelData(json: AppConstants.classicTrivia, numberOfQuestions: num)
        dump(questions)
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
        // check if question index before incrementing - should transition to results screen if questionIndex == selectedNumberOfQuestions.
        questionIndex += 1
        UIView.animate(withDuration: 1, delay: 0.0, options:[.allowUserInteraction, .curveEaseInOut], animations: { self.questionLabel.alpha = 0 }, completion: {_ in
            self.updateUI()
            UIView.animate(withDuration: 1, delay: 0.0, options:[.allowUserInteraction, .curveEaseInOut], animations: { self.questionLabel.alpha = 1 }, completion: nil)
        })
        
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
