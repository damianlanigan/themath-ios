//
//  Vendor.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation

enum VendorType: String {
    case Location = "Location"
    
    func image() -> UIImage {
        return UIImage.vendorAsset(rawValue)
    }
    
    func title() -> String {
        return rawValue
    }
}

class Vendor {
    
    let type: VendorType!
    let content: String!
    var image: UIImage { return type.image() }
    var title: String { return type.title() }
    
    init(type: VendorType, content: String) {
        self.type = type
        self.content = content
    }
    
}


