//
//  GearButton.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/19/23.
//

import UIKit

@objc protocol GearButtonDelegate {
    func gearButtonTapped()
}

class GearButton: UIButton {
    
    var delegate: GearButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
        tintColor = UIColor.rgb(red: 150, green: 150, blue: 150, alpha: 1.0)
        setImage(UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(gearButtonTapped), for: .touchUpInside)
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
    
    @objc func gearButtonTapped() {
        self.delegate?.gearButtonTapped()
    }
}

