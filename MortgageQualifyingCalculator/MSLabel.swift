//
//  MSLabel.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 3/12/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit
import Foundation

class MSLabel: UILabel {
    
    var value: Double {
        get {
            return Double(text!)!
        }
        set {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = NumberFormatter.Style.currency
            text = formatter.string(from: NSNumber(value: newValue))
        }
    }
}
