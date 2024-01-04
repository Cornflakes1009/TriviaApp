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
    var selectedNumberOfQuestions = 0
    fileprivate var questionIndex = 0
    fileprivate var score = 0
    
    fileprivate let gearButton = GearButton()
    fileprivate let backButton = BackButton()
    fileprivate let helpButton = HelpButton()
    
    fileprivate var gameButtons = [GameButton]()
    
    fileprivate let exitView = ExitView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    fileprivate let questionIndexLabel = {
        let label = UILabel()
        label.font = AppConstants.instructionLabelFont
        label.textColor = AppConstants.labelColor
        label.alpha = 0
        return label
    }()
    
    fileprivate let questionLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppConstants.instructionLabelFont
        label.textColor = AppConstants.labelColor
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
        getQuestions(num: selectedNumberOfQuestions)
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playBackgroundVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    // MARK: - Setting Up UI
    fileprivate func setUpUI() {
        backButton.delegate = self
        gearButton.delegate = self
        exitView.delegate = self
        
        exitView.alpha = 0
        
        updateUI()
        setUpAnswerStackView()
        
        let views: [UIView] = [backButton, gearButton, helpButton, questionIndexLabel, questionLabel, questionStackView, bannerView]
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
            
            questionIndexLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            questionIndexLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
    
    fileprivate func setUpAnswerStackView() {
        for index in 0...3 {
            let button = GameButton(title: "", fontColor: AppConstants.labelColor)
            button.tag = index
            button.titleLabel?.font = AppConstants.questionFont
            questionStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 75).isActive = true
            gameButtons.append(button)
        }
    }
    
    fileprivate func updateUI() {
        DispatchQueue.main.async { [self] in
            let answers = [questions?.questions[self.questionIndex].optionZero, questions?.questions[self.questionIndex].optionOne, questions?.questions[self.questionIndex].optionTwo, questions?.questions[self.questionIndex].optionThree]
            for (index, button) in gameButtons.enumerated() {
                UIView.animate(withDuration: 0.8, delay: 0.0, options:[.allowUserInteraction, .curveEaseInOut], animations: { [self] in button.titleLabel?.alpha = 0
                    questionLabel.alpha = 0
                    questionIndexLabel.alpha = 0
                }, completion: { [self]_ in
                    button.setTitle(answers[index], for: .normal)
                    button.setTitle("Himself with the Sorcerer's Stone", for: .normal)
                    questionLabel.text = questions?.questions[questionIndex].question
                    UIView.animate(withDuration: 0.8, delay: 0.0, options:[.allowUserInteraction, .curveEaseInOut], animations: { [self] in button.titleLabel?.alpha = 1
                        questionLabel.alpha = 1
                        questionIndexLabel.text = "\(questionIndex + 1)/\(questions?.questions.count ?? 0)"
                        questionIndexLabel.alpha = 1
                    }, completion: nil)
                })
            }
        }
    }
    
    fileprivate func getQuestions(num: Int) {
        questions = QuestionModelData(json: AppConstants.classicTrivia, numberOfQuestions: num)
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
    
    @objc func answerButtonTapped(_ sender: UIButton) {
        if sender.tag == questions?.questions[questionIndex].answer {
            score += 1
        } else {
            let wrongAnswerView = WrongAnswerView(question: questions!.questions[questionIndex])
            view.addSubview(wrongAnswerView)
            NSLayoutConstraint.activate([
                wrongAnswerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                wrongAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                wrongAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                wrongAnswerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            ])
        }
        
        if questionIndex + 1 == questions?.questions.count {
            let vc = ResultsVC()
            vc.score = score
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            questionIndex += 1
            self.updateUI()
        }
    }
}

extension ClassicVC: BackButtonDelegate {
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

extension ClassicVC: GearButtonDelegate {
    func gearButtonTapped() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ClassicVC: ExitViewDelegate {
    func exitTapped() {
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
