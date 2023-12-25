//
//  HomeVC.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/10/23.
//

import UIKit
import AVFoundation
import UserNotifications

class HomeVC: UIViewController {
    
    var player: AVPlayer?
    
    fileprivate let backgroundImageView = {
        let imageView = UIImageView()
        imageView.image = AppConstants.backgroundImage
        return imageView
    }()
    
    fileprivate let appTitleLabel = {
        let label = UILabel()
        label.text = AppConstants.appName
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppConstants.titleFont
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    fileprivate let gearButton = GearButton()
    
    fileprivate let instructionLabel = {
        let label = UILabel()
        label.text = "Select a Category"
        label.font = AppConstants.instructionLabelFont
        label.textAlignment = .center
        label.textColor = AppConstants.labelColor
        return label
    }()
    
    fileprivate let categoryStackView = {
        let sv = UIStackView()
        sv.distribution = .fill
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    fileprivate let creditsButton = HomeScreenButton(title: "Credits", fontColor: AppConstants.labelColor)
    fileprivate let scoresButton = HomeScreenButton(title: "Scores", fontColor: AppConstants.labelColor)
    fileprivate let contactButton = HomeScreenButton(title: "Contact", fontColor: AppConstants.labelColor)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        requestNotificationPermission()
        scheduleLocalNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // making the title label fade in
        UIView.animate(withDuration: 4.5) {
            self.appTitleLabel.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    @objc func appMovedToBackground() {
        player?.pause()
    }
    
    @objc func appMovedToForeground() {
        player?.play()
    }
    
    // MARK: - Building UI
    fileprivate func setUpUI() {
        gearButton.delegate = self
        
        var views: [UIView] = [appTitleLabel, gearButton]
        view.backgroundColor = AppConstants.backgroundColor
        playBackgroundVideo()
        
        
        if AppConstants.showCategories.count > 1 {
            views.append(categoryStackView)
            views.append(instructionLabel)
        }
        
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
        
        if AppConstants.backgroundImage != UIImage(named: "") {
            view.addSubview(backgroundImageView)
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        
        // If an app has more than one category, show all of the categories. Otherwise, show a play button.
        if AppConstants.showCategories.count > 1 {
            setUpCategoryStackView()
            NSLayoutConstraint.activate([
                categoryStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                instructionLabel.bottomAnchor.constraint(equalTo: categoryStackView.topAnchor, constant: -10),
                instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
        } else {
            // TODO: show the play button here like in Weeb
        }
        
        NSLayoutConstraint.activate([
            gearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            gearButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            gearButton.heightAnchor.constraint(equalToConstant: 50),
            gearButton.widthAnchor.constraint(equalToConstant: 50),
            
            appTitleLabel.topAnchor.constraint(equalTo: gearButton.bottomAnchor, constant: 20),
            appTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoryStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    fileprivate func setUpCategoryStackView() {
        for category in AppConstants.showCategories {
            let button = GameButton(title: category.0, fontColor: .white)
            categoryStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    // MARK: - Notifications
    fileprivate func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.scheduleLocalNotification()
            }
        }
    }
    
    fileprivate func scheduleLocalNotification() {
        // content of the notification
        let center = UNUserNotificationCenter.current()
        // removing all scheduled notifications
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time for some trivia!"
        content.body = "Trivia gets the mind working."
        //content.categoryIdentifier = "alarm"
        //content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .defaultCritical
        
        // creating the notification trigger
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true) // happens every minute
        
        // triggering the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
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
    
    @objc func categoryTapped(_ sender: UIButton) {
        let vc = ModeSelectVC()
        vc.titleLabel.text = sender.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: GearButtonDelegate {
    func gearButtonTapped() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
