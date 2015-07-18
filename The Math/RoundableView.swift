//
//  RoundableView.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable

class RoundableView: UIView {
    
    weak var delegate: TouchableDelegate?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        delegate?.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        delegate?.touchesEnded(touches, withEvent: event);
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        delegate?.touchesMoved(touches, withEvent: event)
    }
    
}

protocol TouchableDelegate: class {
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
}
