//
//  Font.swift
//  HowAmIDoing
//
//  Created by Jay Schaul on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

let CabritoSansFontName = "HelveticaNeue"

extension UIFont {
    class func cabrito() -> UIFont {
        return UIFont(name: CabritoSansFontName, size: 14)!
    }
}