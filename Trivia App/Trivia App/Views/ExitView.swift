//
//  ExitView.swift
//  Trivia App
//
//  Created by HaroldDavidson on 1/1/24.
//

import UIKit

class ExitView: UIView {
    
    let exitLabel = {
        let lbl = UILabel()
        lbl.text = "Are you sure you wish to exit? Exiting will lose your current progress."
        lbl.font = AppConstants.instructionLabelFont
        return lbl
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
        backgroundColor = .red
    }
}
