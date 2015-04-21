//
//  TransformableColorView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/17/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class TransformableColorView: UIView {

    @IBInspectable var fromColor: UIColor! {
        didSet {
            backgroundColor = fromColor
        }
    }
    
    @IBInspectable var toColor: UIColor! {
        didSet {
            backgroundColor = toColor
        }
    }
    
    @IBInspectable var percentage: CGFloat = 0.0 {
        didSet {
            backgroundColor = UIColor.colorAtPercentage(fromColor, color2: toColor, perc: percentage)
        }
    }

}
