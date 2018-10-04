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
    
    private var collectionViewDriver: ImageListViewModel!
    private let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    private lazy var paginationOngoing = false
    private lazy var paginationIndicatorHeight: CGFloat = 44
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionViewDriver = ImageListViewModel(collectionView: outletObjects.collectionView)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
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
                                print(photos)
                            } else {
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
}
