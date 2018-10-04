//
//  PhotoModel.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

enum PhotoModelState { /* Determines what is the status of the image download operation in the queue */
    case new, downloaded, failed
}

class PhotoModel {
    
    var id: String?
    var secret: String?
    var server: String?
    var title: String?
    var farm: Int?
    var url: URL?
    var image: UIImage? /* Image will be added only after the state changes to .downloaded */
    var state = PhotoModelState.new
    
    init(dataSource: [String: Any]) {
        
        self.title = dataSource["title"] as? String
        
        if let id = dataSource["id"] as? String,
            let secret = dataSource["secret"] as? String,
            let server = dataSource["server"] as? String,
            let farm = dataSource["farm"] as? Int {
            
            self.id = id
            self.secret = secret
            self.server = server
            self.farm = farm
            
            if let url = URL(string: "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg") {
                self.url = url
            }
        }
    }
}
