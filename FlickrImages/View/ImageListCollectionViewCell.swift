//
//  ImageListCollectionViewCell.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class ImageListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    func configureCellWith(photoData: PhotoModel) {
        
        imageName.text = photoData.title ?? "He who must not be named"
    }
}
