//
//  ExitView.swift
//  Trivia App
//
//  Created by HaroldDavidson on 1/1/24.
//

import UIKit

protocol ExitViewDelegate {
    func exitTapped()
    func cancelTapped()
}

class ExitView: UIView {
    
    var delegate: ExitViewDelegate?
    
    let containerView = UIView()
    
    let exitLabel = {
        let lbl = UILabel()
        lbl.text = "Are you sure you wish to exit? Exiting will lose your current progress."
        lbl.font = AppConstants.instructionLabelFont
        lbl.textColor = AppConstants.labelColor
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let cancelButton = {
        let button = GameButton(title: "Cancel", fontColor: AppConstants.labelColor)
        button.addTarget(nil, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    let exitButton = {
        let button = GameButton(title: "Exit", fontColor: AppConstants.labelColor)
        button.addTarget(nil, action: #selector(exitTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let views: [UIView] = [containerView, exitLabel, cancelButton, exitButton]
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)})
        self.backgroundColor = .black.withAlphaComponent(0.85)
        containerView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            
            exitLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            exitLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            exitLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
        
            //cancelButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            cancelButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalTo: exitButton.widthAnchor),
            
            //exitButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            exitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            exitButton.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 20),
            exitButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
        ])
    }
    
    @objc func cancelTapped() {
        self.delegate?.cancelTapped()
    }
    
    @objc func exitTapped() {
        self.delegate?.exitTapped()
    }
}
