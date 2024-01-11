//
//  WrongAnswerView.swift
//  Trivia App
//
//  Created by HaroldDavidson on 1/2/24.
//

import UIKit

protocol WrongAnswerViewDelegate {
    func nextQuestionTapped()
}

class WrongAnswerView: UIView {
    
    var delegate: WrongAnswerViewDelegate?
    
    let incorrectLabel = {
        let lbl = UILabel()
        //lbl.text = "Sorry, the correct answer to: "
        lbl.font = AppConstants.instructionLabelFont
        lbl.textColor = AppConstants.labelColor
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let questionLabel = {
        let lbl = UILabel()
        lbl.font = AppConstants.instructionLabelFont
        lbl.textColor = AppConstants.labelColor
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
    
    let nextQuestionButton = {
        let button = GameButton(title: "Next Question", fontColor: AppConstants.labelColor)
        button.addTarget(nil, action: #selector(nextQuestionTapped), for: .touchUpInside)
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
    
    convenience init(question: Question?) {
        self.init()
//        let options = [question?.optionZero, question?.optionOne, question?.optionTwo, question?.optionThree]
//        incorrectLabel.text = "\(incorrectLabel.text ?? "") \(question?.question ?? "") was:"
//        answerLabel.text = options[question?.answer ?? 0]
    }
    
    //common func to init our view
    private func setupView() {
        self.backgroundColor = .black
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [UIView] = [incorrectLabel, nextQuestionButton, answerLabel]
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)})
        self.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            incorrectLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            incorrectLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            incorrectLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            answerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            answerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            answerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            nextQuestionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            nextQuestionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            nextQuestionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
        ])
    }
    
    @objc func nextQuestionTapped() {
        self.delegate?.nextQuestionTapped()
    }
}

