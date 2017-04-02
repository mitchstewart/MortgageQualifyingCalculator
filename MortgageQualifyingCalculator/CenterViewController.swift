//
//  CenterViewController.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/22/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit
import CoreData

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}

class CenterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var monthlyGrossIncomeTextField: MSTextField!
    @IBOutlet weak var dtiTextField: MSTextField!
    @IBOutlet weak var housingAndDebtsLabel: MSLabel!
    
    @IBOutlet weak var carLoansTextField: MSTextField!
    @IBOutlet weak var studentLoansTextField: MSTextField!
    @IBOutlet weak var ccPaymentsTextField: MSTextField!
    @IBOutlet weak var maxPITIAndMILabel: MSLabel!
    
    @IBOutlet weak var principleAndInterestLabel: MSLabel!
    
    @IBOutlet weak var interestRateTextField: MSTextField!
    @IBOutlet weak var termTextField: MSTextField!
    @IBOutlet weak var loanAmountLabel: MSLabel!
    
    @IBOutlet weak var loanToValueTextField: MSTextField!
    @IBOutlet weak var purchasePriceLabel: MSLabel!
    
    public var loadedMortgageCalculation: MortgageCalculation!
    
    @IBAction func touchedAddButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Save Calculation",
                                                message: "Enter a name for your calculation:",
                                                preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            (textField: UITextField) in
            textField.placeholder = "name"
        })
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: {
            action in
            print("Cancel pressed")
        })
        let saveAction = UIAlertAction(title:"Save", style: .default, handler: {
            action in
            let value = alertController.textFields!.first!.text
            self.saveCalculation(name: value!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func touchedDeleteButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete Calculation",
                                                message: "Are you sure?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: {
            action in
            print("Cancel pressed")
        })
        let yesAction = UIAlertAction(title:"Yes", style: .default, handler: {
            action in
            if let calculation = self.loadedMortgageCalculation {
                self.delete(calculation: calculation)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var centerDelegate: CenterViewControllerDelegate?
    var firstResponderTextField: UITextField!
    var fullContentInset: UIEdgeInsets!
    var scrollIndicatorInset: UIEdgeInsets!
    var toolbar: DoneCancelNumberPadToolbar!
    var calculationInputFields = [PurchasePriceInput: MSTextField]()
    var calculationOutputLabels = [PurchasePriceOutput: MSLabel]()
    let calculator = MortgageCalculator()
    var model: [NSManagedObject] = []
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        calculationInputFields[.monthlyGrossIncome] = monthlyGrossIncomeTextField
        calculationInputFields[.dti] = dtiTextField
        
        calculationInputFields[.carLoans] = carLoansTextField
        calculationInputFields[.studentLoans] = studentLoansTextField
        calculationInputFields[.ccPayments] = ccPaymentsTextField
        
        calculationInputFields[.interestRate] = interestRateTextField
        calculationInputFields[.term] = termTextField
        calculationInputFields[.loanToValue] = loanToValueTextField
        
        calculationOutputLabels[.housingAndDebts] = housingAndDebtsLabel
        calculationOutputLabels[.maxPITIAndMI] = maxPITIAndMILabel
        calculationOutputLabels[.principleAndInterest] = principleAndInterestLabel
        calculationOutputLabels[.loanAmount] = loanAmountLabel
        calculationOutputLabels[.purchasePrice] = purchasePriceLabel
        
        calculationInputFields.forEach {
            $0.value.delegate = self
            $0.value.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: $0.value, withPadDelegate: self)
            $0.value.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MortgageCalculation")
        
        do {
            model = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Button Actions
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        centerDelegate?.toggleLeftPanel?()
    }
    
    // MARK: Text Field Targets
    
    @objc private func textFieldDidChange(textField: MSTextField) {
        let outputs = calculator.calculatePurchasePrice(calculationInputs: calculationInputFields.map { (key, value) in (key, value.input) })
        update(calculation: outputs)
        if(textField.text!.characters.count > textField.maxLength) { textField.deleteBackward() }
    }

    // MARK: Public Methods
    
    public func update(calculation outputs: [PurchasePriceOutput: Double]) {
        calculationOutputLabels[.housingAndDebts]?.value = outputs[.housingAndDebts]!
        calculationOutputLabels[.maxPITIAndMI]?.value = outputs[.maxPITIAndMI]!
        calculationOutputLabels[.principleAndInterest]?.value = outputs[.principleAndInterest]!
        calculationOutputLabels[.loanAmount]?.value = outputs[.loanAmount]!
        calculationOutputLabels[.purchasePrice]?.value = outputs[.purchasePrice]!
    }
    
    // MARK: Private Methods
    
    private func saveCalculation(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MortgageCalculation", in: managedContext)!
        let mortgageCalculation = NSManagedObject(entity: entity, insertInto: managedContext)
        
        mortgageCalculation.setValue(UUID().hashValue, forKey: "id")
        mortgageCalculation.setValue(name, forKeyPath: "name")
        mortgageCalculation.setValue(calculationInputFields[.monthlyGrossIncome]?.input, forKeyPath: "monthlyGrossIncome")
        mortgageCalculation.setValue(calculationInputFields[.dti]?.input, forKeyPath: "dti")
        mortgageCalculation.setValue(calculationInputFields[.carLoans]?.input, forKeyPath: "carLoans")
        mortgageCalculation.setValue(calculationInputFields[.studentLoans]?.input, forKeyPath: "studentLoans")
        mortgageCalculation.setValue(calculationInputFields[.ccPayments]?.input, forKeyPath: "ccPayments")
        mortgageCalculation.setValue(calculationInputFields[.interestRate]?.input, forKeyPath: "interestRate")
        mortgageCalculation.setValue(calculationInputFields[.term]?.input, forKeyPath: "term")
        mortgageCalculation.setValue(calculationInputFields[.loanToValue]?.input, forKeyPath: "loanToValue")
        
        do {
            try managedContext.save()
            model.append(mortgageCalculation)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func delete(calculation: MortgageCalculation) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            managedContext.delete(calculation)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension CenterViewController: UITextFieldDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        fullContentInset = scrollView.contentInset
        scrollIndicatorInset = scrollView.scrollIndicatorInsets
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstResponderTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWasShown(notification: NSNotification) {
        guard let textField = firstResponderTextField else { return }
        
        let info = notification.userInfo
        let kbSize = (info?[UIKeyboardFrameBeginUserInfoKey] as! CGRect).size
        
        let rect = CGRect(x: view.frame.minX,
                          y: view.frame.minY + scrollView.contentOffset.y,
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height - kbSize.height + scrollView.contentInset.bottom)
        
        let checkPoint = CGPoint(x: (textField.superview?.frame.origin.x)!,
                                 y: (textField.superview?.frame.origin.y)! + textField.frame.origin.y)
        
        if(!rect.contains(checkPoint)) {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            self.scrollView.scrollRectToVisible(textField.frame, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.contentInset = fullContentInset
        scrollView.scrollIndicatorInsets = scrollIndicatorInset
    }
}

extension CenterViewController: DoneCancelNumberPadToolbarDelegate {
    func didClickCancel(controller: DoneCancelNumberPadToolbar, textField: UITextField) { }
    
    func didClickDone(controller: DoneCancelNumberPadToolbar, textField: UITextField) { }
}

extension CenterViewController: SidePanelViewControllerDelegate {
    func menuItemSelected(_ menuItem: MenuItem) {
        loadedMortgageCalculation = menuItem.mortgageCalculation
        
        calculationInputFields[.monthlyGrossIncome]?.input = menuItem.mortgageCalculation.monthlyGrossIncome
        calculationInputFields[.dti]?.input = menuItem.mortgageCalculation.dti
        
        calculationInputFields[.carLoans]?.input = menuItem.mortgageCalculation.carLoans
        calculationInputFields[.studentLoans]?.input = menuItem.mortgageCalculation.studentLoans
        calculationInputFields[.ccPayments]?.input = menuItem.mortgageCalculation.ccPayments
        
        calculationInputFields[.interestRate]?.input = menuItem.mortgageCalculation.interestRate
        calculationInputFields[.term]?.input = menuItem.mortgageCalculation.term
        
        calculationInputFields[.loanToValue]?.input = menuItem.mortgageCalculation.loanToValue
        
        let outputs = calculator.calculatePurchasePrice(calculationInputs: calculationInputFields.map { (key, value) in (key, value.input) })
        update(calculation: outputs)
        
        centerDelegate?.collapseSidePanels?()
    }
}

extension Dictionary {
    public func map<T: Hashable, U>( transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
    
    public func map<T: Hashable, U>( transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
}
