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
    
    init(title: String) {
        self.title = title
    }
    
    class func allMenuItems() -> Array<MenuItem> {
        return
            [
                MenuItem(title: "Saved Calculations")
            ]
    }
}
