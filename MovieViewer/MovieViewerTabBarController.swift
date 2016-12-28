//
//  MovieViewerTabBarController.swift
//  MovieViewer
//
//  Created by you wu on 1/28/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import MBProgressHUD

class MovieViewerTabBarController: UITabBarController {
    var movies: [NSDictionary]?
    var genreList: NSDictionary = NSDictionary()
    var likedMovies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        //get genre list
        let genreList_url = URL(string: "http://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)")
        let genreList_request = URLRequest(
            url: genreList_url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let genreList_session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let genreList_task: URLSessionDataTask = genreList_session.dataTask(with: genreList_request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let genreDic: [NSDictionary] = (responseDictionary["genres"] as! [NSDictionary])
                            let tmpList : NSMutableDictionary = NSMutableDictionary()
                            for genreMap in genreDic{
                                let id = genreMap["id"] as! Int
                                let genre = genreMap["name"] as! String
                                tmpList[id] = genre
                            }
                            self.genreList = tmpList
                            
                    }
                }
        })
        genreList_task.resume()
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                
                // ... Use the new data to update the data source ...
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            // Tell the refreshControl to stop spinning
                            refreshControl.endRefreshing()
                    }
                }
        })
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
