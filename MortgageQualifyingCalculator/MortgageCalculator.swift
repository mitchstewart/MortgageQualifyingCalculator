//
//  CalculatorService.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 3/12/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import Foundation

class MortgageCalculator {
    
    func calculatePurchasePrice(calculationInputs: [PurchasePriceInput: Double]) -> [PurchasePriceOutput: Double] {
        let pitiAndMIAdjustment = 0.70
        let debtDefault = 0.00
        var calculationOutputs = [PurchasePriceOutput: Double]()
        calculationOutputs[.housingAndDebts] = 0.00
        calculationOutputs[.maxPITIAndMI] = 0.00
        calculationOutputs[.principleAndInterest] = 0.00
        calculationOutputs[.loanAmount] = 0.00
        calculationOutputs[.purchasePrice] = 0.00
        
        if(calculationInputs[.monthlyGrossIncome] == 0.00 || calculationInputs[.dti] == 0.00) { return calculationOutputs }
        
        calculationOutputs[.housingAndDebts] = calculationInputs[.monthlyGrossIncome]! * calculationInputs[.dti]!
        
        calculationOutputs[.maxPITIAndMI]   = calculationOutputs[.housingAndDebts]
        calculationOutputs[.maxPITIAndMI]! -= (calculationInputs[.carLoans] ?? debtDefault)
        calculationOutputs[.maxPITIAndMI]! -= (calculationInputs[.studentLoans] ?? debtDefault)
        calculationOutputs[.maxPITIAndMI]! -= (calculationInputs[.ccPayments] ?? debtDefault)
        
        calculationOutputs[.principleAndInterest] = calculationOutputs[.maxPITIAndMI]! * pitiAndMIAdjustment
        
        if(calculationInputs[.interestRate] == 0.00 || calculationInputs[.term] == 0.00) { return calculationOutputs }
        
        let financialCalculator = FinancialCalculator()
        
        calculationOutputs[.loanAmount] = financialCalculator.calculatePresentValue(interestRate: calculationInputs[.interestRate]!, payment: calculationOutputs[.principleAndInterest]!, term: calculationInputs[.term]!)
        
        if(calculationInputs[.loanToValue] == 0.00) { return calculationOutputs }
        
        calculationOutputs[.purchasePrice] = calculationOutputs[.loanAmount]! / calculationInputs[.loanToValue]!
        
        return calculationOutputs
    }
}

enum PurchasePriceInput {
    case monthlyGrossIncome
    case dti
    case carLoans
    case studentLoans
    case ccPayments
    case interestRate
    case term
    case loanToValue
}

enum PurchasePriceOutput {
    case housingAndDebts
    case maxPITIAndMI
    case principleAndInterest
    case loanAmount
    case purchasePrice
}
