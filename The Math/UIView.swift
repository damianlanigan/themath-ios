//
//  UIView.swift
//  The Math
//
//  Created by Michael Kavouras on 1/31/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func viewFromNib(name: String) -> UIView! {
        let views = NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil)
        return views[0] as! UIView
    }
    
    func colorAtPoint(point: CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, bitmapInfo)
        
        CGContextTranslateCTM(context, -point.x, -point.y)
        layer.renderInContext(context)
        var color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0, green: CGFloat(pixel[1])/255.0, blue: CGFloat(pixel[2])/255.0, alpha: CGFloat(pixel[3])/255.0)
        
        pixel.dealloc(4)
        return color
    }
}