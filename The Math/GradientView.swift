//
//  GradientView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 8/25/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    lazy var topGradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.locations = [0.0, 0.5]
        return g
    }()
    
    lazy var bottomGradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.locations = [0.5, 1.0]
        return g
    }()

    var fromColor: UIColor = UIColor.clearColor() {
        didSet {
            topGradientLayer.colors = [
                fromColor.CGColor,
                fromColor.colorWithAlphaComponent(0.0).CGColor
            ]
        }
    }
    
    var toColor: UIColor = UIColor.clearColor() {
        didSet {
            bottomGradientLayer.colors = [
                toColor.colorWithAlphaComponent(0.0).CGColor,
                toColor.CGColor
            ]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.addSublayer(topGradientLayer)
        layer.addSublayer(bottomGradientLayer)
    }
    
    override func layoutSubviews() {
        bottomGradientLayer.frame = bounds
        topGradientLayer.frame = bounds
    }
}
