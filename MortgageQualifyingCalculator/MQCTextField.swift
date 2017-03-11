//
//  MQCTextField.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/15/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

@IBDesignable
class MQCTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable
    var borderWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var borderColor: CGColor = UIColor.white.cgColor { didSet { setNeedsDisplay() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawBorder() {
        let border = CALayer()
        border.borderColor = borderColor
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - borderWidth,
                              width:  self.frame.size.width,
                              height: self.frame.size.height)
        
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = 0
    }
    
    override func draw(_ rect: CGRect) {
        drawBorder()
        super.draw(rect)
    }

}
