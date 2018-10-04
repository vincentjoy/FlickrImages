//
//  ImageListOutletObject.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class ImageListOutletObject: NSObject {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var paginationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var paginationIndicatorView: UIView!
    @IBOutlet weak var paginationIndicatorBottom: NSLayoutConstraint!
}
