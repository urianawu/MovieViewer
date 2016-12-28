//
//  TopRatedViewController.swift
//  MovieViewer
//
//  Created by you wu on 2/5/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

private let reuseIdentifier = "TopRatedCell"

class TopRatedViewController: UICollectionViewController {


    var movies = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "http://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
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
                            
                            self.movies = (responseDictionary["results"] as? [NSDictionary])!
                            self.collectionView?.reloadData()
                    }
                }
        })
        task.resume()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TopRatedCell
    
        // Configure the cell
        let movie = movies[indexPath.row]
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.posterView.setImageWith(posterUrl!)
        }
        cell.title.text = movie["title"] as? String
        cell.rating.text = String(format: "%.1f", movie["vote_average"] as! Float)

        //animation
        cell.posterView.transform.ty = CGFloat(arc4random_uniform(UInt32(cell.posterView.frame.size.height))+1)
        cell.posterView.alpha = 0
        cell.title.transform.ty = 50
        cell.title.alpha = 0
        cell.star.alpha = 0
        cell.rating.alpha = 0
        
        UIView.animate(withDuration: 0.6, animations: {
            // This causes first view to fade in and second view to fade out
            cell.posterView.transform.ty = 0
            cell.posterView.alpha = 1
            
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.7, options: [], animations: {
                cell.title.transform.ty = 0
                cell.title.alpha = 1
            
            }, completion: { finished in
        })
        
        UIView.animate(withDuration: 0.2, delay: 1.0 + (Double(indexPath.row).truncatingRemainder(dividingBy: 9.0))*0.1, options: [], animations: {
                cell.star.alpha = 1
                cell.rating.alpha = 1
            
            }, completion: { finished in
        })
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
