//
//  ImageListViewModel.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

protocol ViewModelDelegate: class {
    func startPagination()
}

class ImageListViewModel: NSObject {

    weak var delegate: ViewModelDelegate?
    private let collectionView: UICollectionView
    private let cellIdentifier = "ImageListCollectionViewCell"
    private var photos: [PhotoModel] = []
    private let pendingOperations = PendingOperations()
    private let imageCache = NSCache<NSString, UIImage>()
    
    init(collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        super.init()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        self.collectionView.reloadData()
    }
    
    func reload(with dataSource: [PhotoModel]) {
        
        photos += dataSource
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
    func clearList() {
        collectionView.isHidden = true
        photos = [PhotoModel]()
        collectionView.reloadData()
    }
    
    private func startDownload(for photoData: PhotoModel, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil,
            let url = photoData.url else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            
            photoData.image = cachedImage
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            self.collectionView.reloadItems(at: [indexPath])
            
        } else {
            
            let downloader = ImageDownloader(photoData)
            downloader.completionBlock = {
                if downloader.isCancelled {
                    return
                }
                DispatchQueue.main.async {
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
            
            pendingOperations.downloadsInProgress[indexPath] = downloader
            pendingOperations.downloadQueue.addOperation(downloader)
        }
    }
}

extension ImageListViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageListCollectionViewCell {
            
            if indexPath.item < photos.count {
                
                let photoData = photos[indexPath.item]
                cell.configureCellWith(photoData: photoData)
                
                switch (photoData.state) {
                case .failed:
                    cell.failedLoading()
                case .new:
                    startDownload(for: photoData, at: indexPath)
                case .downloaded:
                    print("Download complete")
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ImageListViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.size.width/3
        let padding: CGFloat = 8
        let titleHeight: CGFloat = 20
        let cellHeight: CGFloat = cellWidth + (3*padding) + titleHeight
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ImageListViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            self.delegate?.startPagination()
        }
    }
}
