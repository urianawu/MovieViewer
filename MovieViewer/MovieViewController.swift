//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by you wu on 1/21/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()

        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            movies = tbc.likedMovies
        }
        // init refresh
            refreshControl.addTarget(self, action: #selector(MovieViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.reloadData()
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            movies = tbc.likedMovies
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.setImageWith(imageUrl!)
        cell.title.text = title
        cell.overview.text = overview
        cell.selectionStyle = .none

        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let detailViewController = segue.destination as! DetailViewController

        let movie = movies[(indexPath?.row)!]
        detailViewController.movie = movie
    }
    


    
    
}
