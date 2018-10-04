//
//  ImageListViewController.swift
//  FlickrImages
//
//  Created by Vincent Joy on 04/10/18.
//  Copyright © 2018 Testing. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var outletObjects: ImageListOutletObject!
    
    private var collectionViewDriver: ImageListViewModel! /* Where all the processes related to table view is happening */
    private let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    private lazy var searchText = ""
    private lazy var paginationOngoing = false /* When the user reaches the bottom, pagination starts and if he tries to scroll again, to avoid multiple API calls, we are setting this flag */
    private lazy var paginationIndicatorHeight: CGFloat = 44
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionViewDriver = ImageListViewModel(collectionView: outletObjects.collectionView)
        collectionViewDriver.delegate = self
        outletObjects.searchBar.inputAccessoryView = createInputAccessoryView()
        outletObjects.searchBar.becomeFirstResponder()
    }
    
    private func createInputAccessoryView () -> UIToolbar {
        
        let toolbarAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolbarAccessoryView.barStyle = .default
        toolbarAccessoryView.tintColor = UIColor.blue
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target:nil, action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:.done, target:self, action:#selector(ImageListViewController.doneTouched))
        toolbarAccessoryView.setItems([flexSpace, doneButton], animated: false)
        
        return toolbarAccessoryView
    }
    
    @objc func doneTouched() {
        outletObjects.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count==0 {
            self.searchText = ""
            collectionViewDriver.clearList()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            self.searchText = searchText
            fetchImages(imageSearch: searchText)
        }
    }
    
    private func fetchImages(imageSearch: String) {
        
        var photos: [PhotoModel] = []
        
        if let dataSourceURL = URL(string: (baseURL + imageSearch)) {
            
            let request = URLRequest(url: dataSourceURL)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
                
                if let data = data {
                    do {
                        let datasourceDictionary = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                        
                        if let photoDictionary = datasourceDictionary["photos"] as? [String:Any],
                            let photoArray = photoDictionary["photo"] as? [Dictionary<String, Any>] {
                            
                            for photo in photoArray {
                                let photoObj = PhotoModel(dataSource: photo)
                                photos.append(photoObj)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                            if photos.count>0 {
                                
                                if self.paginationOngoing {
                                    self.paginationOngoing = false
                                    self.presentPaginationIndicator(false)
                                }
                                self.collectionViewDriver.reload(with: photos)
                                
                            } else {
                                self.collectionViewDriver.clearList()
                                self.showAlert(title: "No results found", message: "Try again with another search")
                            }
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    }
                }
                
                if error != nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.showAlert()
                    }
                }
            }
            
            task.resume()
        }
    }
    
    private func showAlert(title: String? = nil, message: String? = nil) {
        
        let alertController = UIAlertController(title: title ?? "Sorry",
                                                message: message ?? "There was an error in fetching images",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentPaginationIndicator(_ show: Bool) {
        
        if show {
            
            outletObjects.paginationIndicatorView.isHidden = false
            outletObjects.paginationIndicator.startAnimating()
            outletObjects.paginationIndicatorBottom.constant = 0
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            
            outletObjects.paginationIndicatorBottom.constant = -paginationIndicatorHeight
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.outletObjects.paginationIndicator.stopAnimating()
                self.outletObjects.paginationIndicatorView.isHidden = true
            }
        }
    }
}

extension ImageListViewController: ViewModelDelegate {
    
    func startPagination() {
        
        if !paginationOngoing {
            paginationOngoing = true
            self.presentPaginationIndicator(true)
            fetchImages(imageSearch: searchText)
        }
    }
}
