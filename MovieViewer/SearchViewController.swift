//
//  SearchViewController.swift
//  MovieViewer
//
//  Created by you wu on 1/27/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var titles: [String] = []
    var movies: [NSDictionary]?
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            
                            if let movies = self.movies {
                                for movie in movies{
                                    let title = movie["title"] as! String
                                    self.titles.append(title)
                                }

                            }else {
                                print("no movies available")
                            }
                            
                            self.filteredData = self.titles
                            self.tableView.reloadData()
                    }
                }
        })
        task.resume()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")! as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        }else {
            return 0
        }
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = titles
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = titles.filter({(dataItem: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
            
            if (filteredData.isEmpty) {
                filteredData = ["No movies match your search.."]
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
