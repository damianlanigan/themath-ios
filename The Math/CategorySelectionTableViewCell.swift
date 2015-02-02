//
//  CategorySelectionTableViewCell.swift
//  The Math
//
//  Created by Michael Kavouras on 2/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CategorySelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImageView.layer.cornerRadius = 22.0
        categoryImageView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        categoryImageView.layer.borderWidth = 1.0
    }

}
