//
//  UIView.swift
//  The Math
//
//  Created by Michael Kavouras on 1/31/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func viewFromNib(name: String) -> UIView! {
        let views = NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)
        return views[0] as UIView
    }
}