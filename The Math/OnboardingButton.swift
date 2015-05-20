//
//  OnboardingButton.swift
//  HowAmIDoing
//
//  Created by Jay Schaul on 5/11/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class OnboardingButton: CabritoButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
