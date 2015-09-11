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
            circleView.backgroundColor = selected ? UIColor.whiteColor() : UIColor.clearColor()
            circleView.layer.borderWidth = selected ? 0.0 : 2.0
            imageView.tintColor = selected ? color() : UIColor.whiteColor()
            nameLabel.textColor = selected ? UIColor.whiteColor() : UIColor.whiteColor().colorWithAlphaComponent(0.60)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        let i = UIImage.imageForCategoryType(category())
        return i.imageWithRenderingMode(.AlwaysTemplate)
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
        imageView.tintColor = UIColor.whiteColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = (frame.size.width - 28.0) / 2
    }
}
