//
//  MSLabel.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 3/12/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

class MSLabel: UILabel {
    
    var value: Double {
        get {
            return Double(text!)!
        }
        set {
           text = String(newValue)
        }
    }
}
