import UIKit
import Cosmos

let kHeaderHeight:CGFloat = 200
let lightGreen: UIColor = UIColor(red: 207/255, green: 251/255, blue: 183/255, alpha: 1)
class DetailViewController: UITableViewController {
    
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    let titleBGView: UIImageView = UIImageView()
    let titleDesView: UIView = UIView()
    let titleLabel : UILabel = UILabel()
    let posterView : UIImageView = UIImageView()
    let genreLabel : UILabel = UILabel()
    let ratingView : CosmosView = CosmosView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        let rightButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.likedSelector))
        self.navigationItem.rightBarButtonItem = rightButton
        
        var genre = ""
        
        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            let genres = tbc.genreList
            let genreIds = movie["genre_ids"] as! NSArray
            for id in genreIds {
                let curGenre = genres[id as! Int] as! String
                genre += curGenre + " "
            }
        }
        
        var posterURL : URL
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            posterURL = posterUrl!
            posterView.setImageWith(posterUrl!)
        }
        else {
            posterURL = URL(string:"")!
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            posterView.image = nil
        }
        
        if let bgPath = movie["backdrop_path"] as? String {
            let BaseUrl = "http://image.tmdb.org/t/p/w500"
            let bgUrl = URL(string: BaseUrl + bgPath)
            titleBGView.setImageWith(bgUrl!)
        }
        else {
            titleBGView.setImageWith(posterURL)
        }
        
        
        let headerW = self.view.frame.width
        //title description
        self.titleDesView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.titleDesView.frame = CGRect(x: 0, y: -kHeaderHeight/4, width: headerW, height: kHeaderHeight*5/4)
        self.titleDesView.clipsToBounds = true
        
        //title label
        self.titleLabel.frame = CGRect(x: headerW/3, y: kHeaderHeight/2, width: headerW/2, height: kHeaderHeight/3)
        titleLabel.textColor = UIColor.white
        titleLabel.text = movie["title"] as? String
        formatText(titleLabel, fontSize: 18)

        //poster
        posterView.frame = CGRect(x: headerW/20, y: kHeaderHeight/2, width: headerW/4, height: kHeaderHeight*2/3)
        posterView.clipsToBounds = true
        posterView.contentMode = UIViewContentMode.scaleAspectFill

        //genre
        self.genreLabel.frame = CGRect(x: headerW/3, y: kHeaderHeight*3/4, width: headerW*2/3, height: kHeaderHeight/4)
        genreLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        genreLabel.text = genre
        formatText(genreLabel, fontSize: 10)

        //rating
        self.ratingView.frame = CGRect(x: headerW/3, y: kHeaderHeight*7/8, width: headerW/2, height: kHeaderHeight/4)
        ratingView.settings.fillMode = .precise

        ratingView.settings.filledColor = lightGreen
        ratingView.settings.emptyBorderColor = lightGreen

        let rating = movie["vote_average"] as! Double
        ratingView.rating = rating/2
        
        self.titleDesView.addSubview(titleLabel)
        self.titleDesView.addSubview(posterView)
        self.titleDesView.addSubview(genreLabel)
        self.titleDesView.addSubview(ratingView)
        
        //title background
        self.titleBGView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: kHeaderHeight)
        self.titleBGView.contentMode = .scaleAspectFill
        self.titleBGView.clipsToBounds = true
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: kHeaderHeight));
        tableHeaderView.backgroundColor = UIColor.purple
        tableHeaderView.addSubview(self.titleBGView)
        tableHeaderView.addSubview(self.titleDesView)

        self.tableView.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = tableHeaderView
        
        let releaseDateBase = "RELEASED ON:"
        let overviewBase = "OVERVIEW:"
        let releaseDate = movie["release_date"] as? String
        let overview = movie["overview"] as? String
        releaseLabel!.text = releaseDateBase + releaseDate!
        formatText(releaseLabel, fontSize: 14)
        overviewLabel.text = overviewBase + overview!
        formatText(overviewLabel, fontSize: 14)

    }
    
    func formatText(_ label: UILabel, fontSize: CGFloat) {
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if (yPos > 0) {
            var imgRect: CGRect = self.titleBGView.frame
            imgRect.origin.y = scrollView.contentOffset.y
            imgRect.size.height = kHeaderHeight+yPos
            self.titleBGView.frame = imgRect
            self.titleDesView.alpha = 1 - ((yPos-64)/80)
        }
    }
    
    func likedSelector() {
        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            tbc.likedMovies.append(movie)
        }
    }
}
