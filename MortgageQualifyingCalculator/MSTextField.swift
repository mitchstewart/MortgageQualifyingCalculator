//
//  MSTextField.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/29/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

@IBDesignable
class MSTextField: UITextField {
    
    @IBInspectable
    var borderColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    @IBInspectable
    var borderWidth: CGFloat = 1 { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }

}
