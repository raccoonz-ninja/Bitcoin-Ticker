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
    
    private var pageCount: Int!
    private var pageWidth: CGFloat!
    private var pageHeight: CGFloat!
    
    private let initialPageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the controllers
        self.controllers = [
            SettingsPageViewController(),
            MainPageViewController(),
            TradePageViewController()
        ]
        
        self.pageCount = self.controllers.count
        self.pageWidth = self.view.frame.width
        self.pageHeight = self.view.frame.height
        
        // Create the UIScrollView
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.contentSize = CGSizeMake(CGFloat(pageCount) * self.pageWidth, self.view.frame.height)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        // Create the UIPageControl
        self.pageControl = UIPageControl()
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.numberOfPages = self.pageCount
        self.view.addSubview(self.pageControl)
        
        // Add the controller views to the UIScrollView (and position them)
        for (index, controller) in self.controllers.enumerate() {
            self.scrollView.addSubview(controller.view)
            controller.view.frame = CGRectMake(CGFloat(index) * self.pageWidth, 0, self.pageWidth, self.pageHeight)
        }
        
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
        
        // Scroll to the inital page
        self.scrollView.scrollRectToVisible(CGRectMake(0, 0, self.pageWidth, self.pageHeight), animated: false)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Keep the UIPageControl in sync with the UIScrollView position
        print(scrollView.contentOffset.x)
        let currentPage = Int(round(scrollView.contentOffset.x / self.pageWidth))
        self.pageControl.currentPage = currentPage
    }

}
