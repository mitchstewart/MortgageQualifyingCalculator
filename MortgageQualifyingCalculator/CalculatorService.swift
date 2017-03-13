//
//  CalculatorService.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 3/12/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import Foundation

class CalculatorService {
    
    func calculate(calculationInputs: [CalculationInput: Double]) -> [CalculationOutput: Double] {
        var calculationOutputs = [CalculationOutput: Double]()
        calculationOutputs[.housingAndDebts] = 9.99
        calculationOutputs[.maxPITIAndMI] = 9.99
        calculationOutputs[.principleAndInterest] = 9.99
        calculationOutputs[.loanAmount] = 9.99
        calculationOutputs[.purchasePrice] = 9.99
        return calculationOutputs
    }
}

enum CalculationInput {
    case monthlyGrossIncome
    case dti
    case carLoans
    case studentLoans
    case ccPayments
    case interestRate
    case term
    case loanToValue
}

enum CalculationOutput {
    case housingAndDebts
    case maxPITIAndMI
    case principleAndInterest
    case loanAmount
    case purchasePrice
}
