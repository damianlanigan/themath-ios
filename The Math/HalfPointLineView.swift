//
//  HalfPointLineView.swift
//  HowAmIDoing
//
//  Created by Jay Schaul on 8/9/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class HalfPointLineView: UIView {

    @IBOutlet weak var heightContstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightContstraint.constant = 0.5
    }

}
