//
//  CategoryView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var selected: Bool = false {
        didSet {
            circleView.backgroundColor = selected ? color() : UIColor.clearColor()
            circleView.layer.borderWidth = selected ? 0.0 : 2.0
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        selected = !selected
    }
    
    func name() -> String {
        return category().rawValue.lowercaseString
    }
    
    func color() -> UIColor {
        return UIColor.colorForCategoryType(category())
    }
    
    func image() -> UIImage {
        return UIImage.imageForCategoryType(category())
    }
    
    func category() -> CategoryType {
        return .Undefined
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleView.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.6).CGColor
        circleView.layer.borderWidth = 2.0
        nameLabel.text = name().capitalizedString
        imageView.image = image()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = (frame.size.width - 28.0) / 2
    }
}
