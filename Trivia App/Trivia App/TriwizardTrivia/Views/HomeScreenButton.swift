//
//  HomeScreenButton.swift
//  TriwizardTrivia
//
//  Created by HaroldDavidson on 12/16/23.
//

import UIKit

class HomeScreenButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, fontColor: UIColor) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
        configuration.title = title
        
        self.configuration = configuration
        //setTitle(title, for: .normal)
        setTitleColor(AppConstants.labelColor, for: .normal)
        titleLabel?.font = AppConstants.instructionLabelFont
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        layer.masksToBounds = false
//        layer.borderColor = CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//        layer.borderWidth = 1
//        layer.cornerRadius = 5
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

