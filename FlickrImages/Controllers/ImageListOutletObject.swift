//
//  ImageListOutletObject.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class ImageListOutletObject: NSObject {

    /* This class can be used to put all the IBOutlets in one place. If this is a big view controller with lots of outlets, then this separate class can help us to reduce the code in view controller */
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var paginationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var paginationIndicatorView: UIView!
    @IBOutlet weak var paginationIndicatorBottom: NSLayoutConstraint! /* At the time of pagination, a message saying "Loading more images.." will appear from the bottom like a flash card and dismiss after API call finish. */
}
