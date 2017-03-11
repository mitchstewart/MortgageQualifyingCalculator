//
//  SidePanelViewController.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/22/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

//@objc
protocol SidePanelViewControllerDelegate {
    func menuItemSelected(_ menuItem: MenuItem)
}

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    
    var menuItems: Array<MenuItem>!
    
    struct TableView {
        struct CellIdentifiers {
            static let menuItemCell = "MenuItemCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.menuItemCell, for: indexPath) as! MenuItemCell
        cell.configureFor(menuItem: menuItems[indexPath.row])
        return cell
    }
}

// MARK: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMenuItem = menuItems[indexPath.row]
        delegate?.menuItemSelected(selectedMenuItem)
    }
    
}

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var menuItemLabel: UILabel!
    
    func configureFor(menuItem: MenuItem) {
        menuItemLabel.text = menuItem.title
    }
}
