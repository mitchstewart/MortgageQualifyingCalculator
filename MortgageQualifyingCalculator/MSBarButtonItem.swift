//
//  MSBarButtonItem.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 2/18/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

class MSBarButtonItem: UIBarButtonItem {
    
    private let blue: UIColor = UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    
    override init() {
        super.init()
        self.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                NSForegroundColorAttributeName: UIColor.white
            ],
            for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                NSForegroundColorAttributeName: UIColor.white
            ],
            for: .normal)
    }
    
}
