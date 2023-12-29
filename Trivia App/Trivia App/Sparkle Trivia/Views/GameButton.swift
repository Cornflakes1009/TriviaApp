//
//  GameButton.swift
//  sparkle-trivia
//
//  Created by HaroldDavidson on 12/26/23.
//


import UIKit

class GameButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, backgroundColor: UIColor = UIColor.rgb(red: 125, green: 25, blue: 21, alpha: 1), fontColor: UIColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.setTitleColor(fontColor, for: .normal)
        self.backgroundColor = UIColor.rgb(red: 125, green: 25, blue: 21, alpha: 1)
        layer.cornerRadius = 5
        titleLabel?.font = AppConstants.buttonFont
        setTitleShadowColor(.black, for: .normal)
        titleLabel?.layer.shadowRadius = 3.0
        titleLabel?.layer.shadowOpacity = 1.0
        titleLabel?.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel?.layer.masksToBounds = false
        titleLabel?.font = AppConstants.buttonFont
        isEnabled = true
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.95).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        layer.masksToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        titleLabel?.alpha = 0.2
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        titleLabel?.alpha = 1
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        titleLabel?.alpha = 1
        vibrate()
    }
}


