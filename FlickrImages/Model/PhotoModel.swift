//
//  PhotoModel.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class PhotoModel {
    
    var id: String?
    var secret: String?
    var server: String?
    var title: String?
    var farm: Int?
    
    init(dataSource: [String: Any]) {
        
        self.title = dataSource["title"] as? String
        
        if let id = dataSource["id"] as? String {
            self.id = id
        }
        
        if let secret = dataSource["secret"] as? String {
            self.secret = secret
        }
        
        if let server = dataSource["server"] as? String {
            self.server = server
        }
        
        if let farm = dataSource["farm"] as? Int {
            self.farm = farm
        }
    }
}
