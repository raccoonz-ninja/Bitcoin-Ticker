//
//  RootViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIScrollViewDelegate {

    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var controllers: [UIViewController]!
    
    private let initialPageIndex = 1
    private var currentPage: Int!
    private var scrollEnabled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the controllers
        self.controllers = [
            SettingsPageViewController(),
            MainPageViewController(),
            TradePageViewController()
        ]
        
        let pageCount = self.controllers.count
        self.currentPage = initialPageIndex
        
        // Create the UIScrollView
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        // Create the UIPageControl
        self.pageControl = UIPageControl()
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.numberOfPages = pageCount
        self.view.addSubview(self.pageControl)
        
        // Layout the UIScrollView
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        // Layout the UIPageControl
        self.view.addConstraint(NSLayoutConstraint(item: self.pageControl, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.pageControl, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.pageControl, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 40))
        
        // Add the controller views to the UIScrollView
        for controller in self.controllers {
            self.scrollView.addSubview(controller.view)
        }
    }
    
    // Layout the subviews inside the UIScrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the content size of the UIScrollView
        let pageCount = self.controllers.count
        let pageWidth = self.view.frame.width
        let pageHeight = self.view.frame.height
        self.scrollView.contentSize = CGSizeMake(CGFloat(pageCount) * pageWidth, pageHeight)
        
        // Update the UIScrollView offset
        self.scrollView.scrollRectToVisible(CGRectMake(CGFloat(self.currentPage) * pageWidth, 0, pageWidth, pageHeight), animated: false)
        
        // Re-layout the controllers view inside the UIScrollView
        for (index, controller) in self.controllers.enumerate() {
            controller.view.frame = CGRectMake(CGFloat(index) * pageWidth, 0, pageWidth, pageHeight)
        }
    }
    
    // Prevent `scrollViewDidScroll` to update the current page during a resize so we have a chance to update
    // the UIScrollView offset using the correct current page.
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.scrollEnabled = false
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition(nil) { (_) -> Void in
            self.scrollEnabled = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Keep the UIPageControl in sync with the UIScrollView position
        if self.scrollEnabled {
            let pageWidth = self.view.frame.width
            self.currentPage = Int(round(scrollView.contentOffset.x / pageWidth))
            self.pageControl.currentPage = currentPage
        }
    }

}
