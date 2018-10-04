//
//  PhotoOperations.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class PendingOperations {
    
    /* This class contains a dictionary to keep track of active and pending download operations for each cell in the collection view, and a corresponding operation queue. */
    
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        return queue
    }()
}

class ImageDownloader: Operation {
    
    /* This class is using to track the status of each operation */
    
    let photoObject: PhotoModel
    
    init(_ photoObject: PhotoModel) {
        self.photoObject = photoObject
    }
    
    override func main() {
        
        if isCancelled {
            /* Check for cancellation before starting. Operations should regularly check if they have been cancelled before attempting long or intensive work. */
            return
        }
        
        guard let url = photoObject.url, let imageData = try? Data(contentsOf: url) else { return }
        
        if isCancelled {
            return
        }
        
        /* If there is data, create an image object and add it to the record, and move the state along. If there is no data, mark the record as failed and set the appropriate message as title. */
        
        if !imageData.isEmpty {
            photoObject.image = UIImage(data:imageData)
            photoObject.state = .downloaded
        } else {
            photoObject.state = .failed
            photoObject.image = nil
        }
    }
}
