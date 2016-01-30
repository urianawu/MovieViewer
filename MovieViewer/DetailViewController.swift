import UIKit
import Cosmos

let kHeaderHeight:CGFloat = 200
let lightGreen: UIColor = UIColor(red: 207/255, green: 251/255, blue: 183/255, alpha: 1)
class DetailViewController: UITableViewController {
    
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    let titleBGView: UIImageView = UIImageView()
    let titleDesView: UIView = UIView()
    let titleLabel : UILabel = UILabel()
    let posterView : UIImageView = UIImageView()
    let genreLabel : UILabel = UILabel()
    let ratingView : CosmosView = CosmosView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let movieIndex = defaults.integerForKey("movieIndex")
        var movie : NSDictionary = NSDictionary()
        var genre = ""
        
        if let tbc = self.tabBarController as? MovieViewerTabBarController {
            let movies = tbc.movies
            movie = movies![movieIndex]
            let genres = tbc.genreList
            let genreIds = movie["genre_ids"] as! NSArray
            for id in genreIds {
                let curGenre = genres[id as! Int] as! String
                genre += curGenre + " "
            }
        }
        
        var posterURL : NSURL
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            posterURL = posterUrl!
            posterView.setImageWithURL(posterUrl!)
        }
        else {
            posterURL = NSURL()
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            posterView.image = nil
        }
        
        if let bgPath = movie["backdrop_path"] as? String {
            let BaseUrl = "http://image.tmdb.org/t/p/w500"
            let bgUrl = NSURL(string: BaseUrl + bgPath)
            titleBGView.setImageWithURL(bgUrl!)
        }
        else {
            titleBGView.setImageWithURL(posterURL)
        }
        
        
        let headerW = CGRectGetWidth(self.view.frame)
        //title description
        self.titleDesView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.titleDesView.frame = CGRectMake(0, -kHeaderHeight/4, headerW, kHeaderHeight*5/4)
        self.titleDesView.clipsToBounds = true
        
        //title label
        self.titleLabel.frame = CGRectMake(headerW/3, kHeaderHeight/2, headerW/2, kHeaderHeight/3)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = movie["title"] as? String
        formatText(titleLabel, fontSize: 18)

        //poster
        posterView.frame = CGRect(x: headerW/20, y: kHeaderHeight/2, width: headerW/4, height: kHeaderHeight*2/3)
        posterView.clipsToBounds = true
        posterView.contentMode = UIViewContentMode.ScaleAspectFill

        //genre
        self.genreLabel.frame = CGRectMake(headerW/3, kHeaderHeight*3/4, headerW*2/3, kHeaderHeight/4)
        genreLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        genreLabel.text = genre
        formatText(genreLabel, fontSize: 10)

        //rating
        self.ratingView.frame = CGRectMake(headerW/3, kHeaderHeight*7/8, headerW/2, kHeaderHeight/4)
        ratingView.settings.fillMode = .Precise

        ratingView.settings.colorFilled = lightGreen
        ratingView.settings.borderColorEmpty = lightGreen

        let rating = movie["vote_average"] as! Double
        ratingView.rating = rating/2
        
        self.titleDesView.addSubview(titleLabel)
        self.titleDesView.addSubview(posterView)
        self.titleDesView.addSubview(genreLabel)
        self.titleDesView.addSubview(ratingView)
        
        //title background
        self.titleBGView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderHeight)
        self.titleBGView.contentMode = .ScaleAspectFill
        self.titleBGView.clipsToBounds = true
        
        let tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderHeight));
        tableHeaderView.backgroundColor = UIColor.purpleColor()
        tableHeaderView.addSubview(self.titleBGView)
        tableHeaderView.addSubview(self.titleDesView)

        self.tableView.backgroundColor = UIColor.clearColor()
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
    
    func formatText(label: UILabel, fontSize: CGFloat) {
        label.textAlignment = NSTextAlignment.Left
        label.font = UIFont.boldSystemFontOfSize(fontSize)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if (yPos > 0) {
            var imgRect: CGRect = self.titleBGView.frame
            imgRect.origin.y = scrollView.contentOffset.y
            imgRect.size.height = kHeaderHeight+yPos
            self.titleBGView.frame = imgRect
            self.titleDesView.alpha = 1 - ((yPos-64)/80)
        }
    }
}