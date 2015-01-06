//
//  RoundView.swift
//  The Math
//
//  Created by Mike Kavouras on 1/6/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class RoundView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2.0
    }

}
