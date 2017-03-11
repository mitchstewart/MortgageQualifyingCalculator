//
//  CenterViewController.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/22/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}

class CenterViewController: UIViewController {
    
    @IBOutlet weak fileprivate var scrollView: UIScrollView!
    
    @IBOutlet weak var purchasePriceView: UIView!
    
    @IBOutlet weak var MonthlyGrossIncomeTextField: UITextField!
    @IBOutlet weak var DTITextField: UITextField!
    
    @IBOutlet weak var CarLoansTextField: UITextField!
    @IBOutlet weak var StudentLoansTextField: UITextField!
    @IBOutlet weak var CCPaymentsTextField: UITextField!
    
    @IBOutlet weak var InterestRateTextField: UITextField!
    @IBOutlet weak var TermTextField: UITextField!
    
    @IBOutlet weak var LoanToValueTextField: UITextField!
    
    var centerDelegate: CenterViewControllerDelegate?
    var firstResponderTextField: UITextField!
    var fullContentInset: UIEdgeInsets!
    var scrollIndicatorInset: UIEdgeInsets!
    var toolbar: DoneCancelNumberPadToolbar!
    
    override func viewDidLoad() {
        registerKeyboardNotifications()
        
        MonthlyGrossIncomeTextField.delegate = self
        MonthlyGrossIncomeTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: MonthlyGrossIncomeTextField, withPadDelegate: self)
        
        DTITextField.delegate = self
        DTITextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: DTITextField, withPadDelegate: self)
        
        CarLoansTextField.delegate = self
        CarLoansTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: CarLoansTextField, withPadDelegate: self)
        StudentLoansTextField.delegate = self
        StudentLoansTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: StudentLoansTextField, withPadDelegate: self)
        CCPaymentsTextField.delegate = self
        CCPaymentsTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: CCPaymentsTextField, withPadDelegate: self)
        
        InterestRateTextField.delegate = self
        InterestRateTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: InterestRateTextField, withPadDelegate: self)
        TermTextField.delegate = self
        TermTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: TermTextField, withPadDelegate: self)
        
        LoanToValueTextField.delegate = self
        LoanToValueTextField.inputAccessoryView = DoneCancelNumberPadToolbar().initWith(textField: LoanToValueTextField, withPadDelegate: self)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    // MARK: Private methods
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    // MARK: Button actions
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        centerDelegate?.toggleLeftPanel?()
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
        
        let info = notification.userInfo
        let kbSize = (info?[UIKeyboardFrameBeginUserInfoKey] as! CGRect).size
        print("kbSize: \(kbSize)")
        
        let rect = CGRect(x: view.frame.minX,
                          y: view.frame.minY,
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height - kbSize.height + scrollView.contentInset.bottom)
        print("contentInset: \(scrollView.contentInset)")
        print("rect: \(rect)")
        
        let checkPoint = CGPoint(x: (firstResponderTextField.superview?.frame.origin.x)!,
                                 y: (firstResponderTextField.superview?.frame.origin.y)! + firstResponderTextField.frame.origin.y)
        print("checkPoint: \(checkPoint)")
        
        if(!rect.contains(checkPoint)) {
            let contentInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: kbSize.height,
                                             right: 0.0)
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            self.scrollView.scrollRectToVisible(firstResponderTextField.frame, animated: true)
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
        centerDelegate?.collapseSidePanels?()
    }
}
