//
//  BackButton.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/19/23.
//

import UIKit

protocol BackButtonDelegate {
    func backButtonTapped()
}

class BackButton: UIButton {
    
    var delegate: BackButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
        tintColor = UIColor.rgb(red: 150, green: 150, blue: 150, alpha: 1.0)
        setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
    
    @objc func backButtonTapped() {
        self.delegate?.backButtonTapped()
    }
}
