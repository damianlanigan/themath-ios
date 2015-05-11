//
//  AnimatingCircleContainerView.swift
//  HEH
//
//  Created by Jay Schaul on 5/11/15.
//  Copyright (c) 2015 Jay Schaul. All rights reserved.
//

import UIKit

class AnimatingCircleContainerView: UIView {
    
    let MaxCircleCount = 40
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createCircles()
    }
    
    private func createCircles() {
        for i in 0..<MaxCircleCount {
            let view = AnimatingCircleView()
            addSubview(AnimatingCircleView())
        }
    }

}
