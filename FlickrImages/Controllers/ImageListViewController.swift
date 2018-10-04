//
//  ImageListViewController.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    
    @IBOutlet var outletObjects: ImageListOutletObject!
    
    private var collectionViewDriver: ImageListViewModel!
    private let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    private lazy var searchText = ""
    private lazy var paginationOngoing = false
    private lazy var paginationIndicatorHeight: CGFloat = 44
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionViewDriver = ImageListViewModel(collectionView: outletObjects.collectionView)
    }
}
