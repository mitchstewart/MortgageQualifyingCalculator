//
//  MenuItem.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/22/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import Foundation

class MenuItem {
    
    let title: String
    let mortgageCalculation: MortgageCalculation
    
    init(mortgageCalculation: MortgageCalculation) {
        self.title = mortgageCalculation.name!
        self.mortgageCalculation = mortgageCalculation
    }
}
