//
//  PageContentViewController.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/24/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var titleText: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
    }
}
