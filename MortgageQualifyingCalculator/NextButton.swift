//
//  NextButton.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/15/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

@IBDesignable
class NextButton: UIButton {
    
    @IBInspectable
    var scale: CGFloat = 0.80 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.white { didSet { setNeedsDisplay() } }
    
    private var buttonRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var buttonCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private func pathForCircleCentered(AtPoint midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: CGFloat(2*M_PI),
                                clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCentered(AtPoint: buttonCenter, withRadius: buttonRadius).stroke()
        super.draw(rect)
    }

}
