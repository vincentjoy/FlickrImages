//
//  PhotoOperations.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class PendingOperations {
    
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        return queue
    }()
}

class ImageDownloader: Operation {
    
    let photoObject: PhotoModel
    
    init(_ photoObject: PhotoModel) {
        self.photoObject = photoObject
    }
    
    override func main() {
        
        if isCancelled {
            /* The code can optimise more by suspending the operation while user scrolling, then start image downloading of only the visible cells and cancel the other. For that purpose we can make use of isCancelled */
            return
        }
        
        guard let url = photoObject.url, let imageData = try? Data(contentsOf: url) else { return }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            photoObject.image = UIImage(data:imageData)
            photoObject.state = .downloaded
        } else {
            /* Image download failed. In this case image views colour will be gray and the title will be "Image failed to load", just to understand the situation */
            photoObject.state = .failed
            photoObject.image = nil
        }
    }
}
