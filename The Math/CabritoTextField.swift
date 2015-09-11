//
//  CabritoTextField.swift
//  HowAmIDoing
//
//  Created by Jay Schaul on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CabritoTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont(name: CabritoSansFontName, size: font!.pointSize)
    }

}
