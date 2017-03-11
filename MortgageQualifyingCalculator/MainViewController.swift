//
//  MainViewController.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/24/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var pageTitles = [String]()
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        pageTitles = ["Zero", "One", "Two", "Three"]
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController!
        self.pageViewController.dataSource = self
        
        let startingVC = self.viewControllerAt(0)
        let viewControllers = [startingVC!]
        pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContainerViewController).pageIndex
        
        if((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index! -= 1
        return viewControllerAt(index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContainerViewController).pageIndex
        
        if(index == NSNotFound) {
            return nil
        }
        
        index! += 1
        
        if (index == pageTitles.count) {
            return nil
        }
        
        return viewControllerAt(index!)
    }
    
    func viewControllerAt(_ index: Int) -> UIViewController? {
        
        if(pageTitles.count == 0 || index >= pageTitles.count) {
            return nil
        }
        
        /*
        let pageContentVC = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentVC.titleText = pageTitles[index]
        pageContentVC.pageIndex = index
        */
        
        let pageContentVC = ContainerViewController()
        pageContentVC.pageIndex = index
        
        return pageContentVC
    }

}
