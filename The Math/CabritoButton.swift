//
//  CabritoButton.swift
//  HowAmIDoing
//
//  Created by Jay Schaul on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CabritoButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        if let label = titleLabel {
            label.font = UIFont(name: CabritoSansFontName, size: label.font.pointSize)!
        }
        
    }

}
