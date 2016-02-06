//
//  CatalogViewController.swift
//  MovieViewer
//
//  Created by you wu on 1/28/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class CatalogViewController: UICollectionViewController {

    var genreList = NSDictionary()
    var genreNameList = [String]()
    var genreIDList = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            genreList = tbc.genreList
        }
        for (id, name) in genreList {
            genreIDList.append(Int(id as! NSNumber))
            genreNameList.append(name as! String)
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

    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "GenreHeader",
                    forIndexPath: indexPath)
                    as! GenreHeaderView
                headerView.genre.text = self.genreNameList[indexPath.section]
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return genreList.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        let userNameLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 300, height: 30))
        userNameLabel.clipsToBounds = true
        userNameLabel.text = genreNameList[section]
        userNameLabel.textColor = UIColor(white: 1, alpha: 0.8)
        userNameLabel.font = UIFont.boldSystemFontOfSize(12)
        headerView.addSubview(userNameLabel)
        
        return headerView
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as! GenreCell

        // Configure the cell...
        cell.genreCollection
        
        return cell
    }
    
*/
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

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return genreNameList.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreIDList.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreMovieCell", forIndexPath: indexPath) as! GenreMovieCell
        cell.backgroundColor = UIColor.whiteColor()
        // Configure the cell
        return cell
    }
}
