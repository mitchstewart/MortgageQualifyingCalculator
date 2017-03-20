//
//  FinancialCalculator.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 3/14/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import Foundation

class FinancialCalculator {
    
    func calculatePresentValue(interestRate rate: Double, payment: Double, term: Double) -> Double {
        let monthlyRate: Double = rate / 12
        let termInMonths: Double = term * 12
        let pv = payment * (1 - pow( (1 + monthlyRate), -termInMonths)) / monthlyRate
        
        return pv
    }
}
