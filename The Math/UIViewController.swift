//
//  UIViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func _addContentViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func _addContentViewController(viewController: UIViewController, belowView view: UIView) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.insertSubview(viewController.view, belowSubview: view)
        viewController.didMoveToParentViewController(self)
    }
    
    func _addContentViewController(viewController: UIViewController, aboveView view: UIView) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.insertSubview(viewController.view, aboveSubview: view)
        viewController.didMoveToParentViewController(self)
    }
    
    func _addContentViewController(viewController: UIViewController, toView view: UIView) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func _removeContentViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
}