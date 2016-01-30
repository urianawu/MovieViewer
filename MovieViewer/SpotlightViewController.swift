//
//  SpotlightViewController.swift
//  MovieViewer
//
//  Created by you wu on 1/27/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class SpotlightViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies:[NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        // Do any additional setup after loading the view.
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
                            if let tbc = self.tabBarController as? MovieViewerTabBarController {
                                tbc.movies = self.movies
                            }
                            
                            let refreshControl = UIRefreshControl()
                            
                            if let tbc = self.tabBarController as? MovieViewerTabBarController {
                                // init refresh
                                refreshControl.addTarget(tbc, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
                                
                                self.collectionView.insertSubview(refreshControl, atIndex: 0)
                                self.collectionView.reloadData()
                            }

                            
                    }
                }
        })
        task.resume()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SpotlightViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }else {
            return 0
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpotlightCell", forIndexPath: indexPath) as! SpotlightCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        var posterURL : NSURL
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            posterURL = posterUrl!
            cell.posterView.setImageWithURL(posterUrl!)
        }
        else {
            posterURL = NSURL()
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }
        
        if let bgPath = movie["backdrop_path"] as? String {
            let BaseUrl = "http://image.tmdb.org/t/p/w500"
            let bgUrl = NSURL(string: BaseUrl + bgPath)
            cell.bgView.setImageWithURL(bgUrl!)
        }
        else {
            cell.bgView.setImageWithURL(posterURL)
        }
        
        
        
        cell.title.text = title.uppercaseString
        cell.releaseDate.text = "Released On "+(movie["release_date"] as? String)!
        let rating = movie["vote_average"] as? Double
        cell.ratingStar.rating = rating!/2
        let voter = movie["vote_count"] as? Int
        cell.ratingStar.text = "("+String(voter!)+")"
        return cell
        
    }
    
}

extension SpotlightViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(indexPath.row, forKey: "movieIndex")
        defaults.synchronize()
    }
}

