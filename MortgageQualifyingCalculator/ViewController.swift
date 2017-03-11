//
//  ViewController.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/15/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        pageViewController = UIPageViewController()
        pageTitles = ["Page One", "Page Two", "Page Three"]
        
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startingViewController = viewControllerAtIndex(0)!
        let viewControllers: [UIViewController] = [startingViewController]
        pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }

    func viewControllerAtIndex(_ index: Int) -> PageContentViewController? {
        if((pageTitles.count == 0) || (index >= pageTitles.count)) {
            return nil
        }
        
        let controller: PageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        controller.titleText = pageTitles[index]
        controller.pageIndex = index;
        
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex
        
        if((index == 0) || (index == NSNotFound)) {
            return nil;
        }
        
        index = index! - 1
        return viewControllerAtIndex(index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex
        
        if (index == NSNotFound) {
            return nil
        }
        
        index = index! + 1
        if (index == pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index!)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
