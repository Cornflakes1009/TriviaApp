//
//  BlitzExplanationView.swift
//  Trivia App
//
//  Created by HaroldDavidson on 1/14/24.
//

import UIKit

protocol BlitzExplanationViewDelegate {
    func readyButtonTapped()
}

class BlitzExplanationView: UIView {
    
    var delegate: BlitzExplanationViewDelegate?
    
    let explanationLabel = {
        let lbl = UILabel()
        lbl.font = AppConstants.titleFont
        lbl.textColor = AppConstants.labelColor
        lbl.text = "How it works"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let answerLabel = {
        let lbl = UILabel()
        lbl.font = AppConstants.instructionLabelFont
        lbl.textColor = AppConstants.labelColor
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let readyButton = {
        let button = GameButton(title: "Ready", fontColor: AppConstants.labelColor)
        button.addTarget(nil, action: #selector(readyButtonTapped), for: .touchUpInside)
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
    
    //common func to init our view
    private func setupView() {
        self.backgroundColor = .black
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [UIView] = [explanationLabel, readyButton, answerLabel]
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)})
        self.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            explanationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            explanationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            answerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            answerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            answerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            readyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            readyButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            readyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
        ])
    }
    
    @objc func readyButtonTapped() {
        self.delegate?.readyButtonTapped()
    }
}


