//
//  CatalogViewController.swift
//  MovieViewer
//
//  Created by you wu on 1/28/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
class CatalogViewController: UITableViewController {

    var genreList = NSDictionary()
    var genreNameList = [String]()
    var genreMovies = [[NSDictionary]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            genreList = tbc.genreList
        }

        for (id, name) in genreList {

            //get current genre movies
            let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let url = NSURL(string: "http://api.themoviedb.org/3/genre/"+String(id)+"/movies?api_key=\(apiKey)")
            let request = NSURLRequest(URL: url!)
            // Configure session so that completion handler is executed on main UI thread
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )

            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (dataOrNil, response, error) in
                    
                    // ... Use the new data to update the data source ...
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                    self.genreNameList.append(name as! String)

                                self.genreMovies.append((responseDictionary["results"] as? [NSDictionary])!)
                                self.tableView.reloadData()
                        }
                    }
            })
            task.resume()

        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return genreMovies.count
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return 1
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
        headerView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        let userNameLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 30))
        userNameLabel.clipsToBounds = true
        userNameLabel.text = genreNameList[section]
        userNameLabel.textColor = UIColor(red: 220/255, green: 255/255, blue: 201/255, alpha: 0.8)
        userNameLabel.font = UIFont.boldSystemFontOfSize(12)
        headerView.addSubview(userNameLabel)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreTableViewCell", forIndexPath: indexPath)
        cell.selectionStyle = .None

        return cell
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            guard let tableViewCell = cell as? GenreTableViewCell else { return }
            
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return genreMovies[collectionView.tag].count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreMovieCell",
                forIndexPath: indexPath) as! GenreMovieCell
            //cell.backgroundColor = genreMovies[collectionView.tag][indexPath.item]
            let movie = genreMovies[collectionView.tag][indexPath.row]
            if let posterPath = movie["poster_path"] as? String {
                let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
                let posterUrl = NSURL(string: posterBaseUrl + posterPath)
                cell.posterView.setImageWithURL(posterUrl!)
            }
            
            cell.title.text = movie["title"] as? String

            //animation
            cell.posterView.transform.tx = 100
            cell.posterView.alpha = 0
            cell.title.alpha = 0
            
            UIView.animateWithDuration(0.6, animations: {
                // This causes first view to fade in and second view to fade out
                cell.posterView.transform.tx = 0
                cell.posterView.alpha = 1
                cell.title.alpha = 1
                
            })
            
            return cell
    }
}
