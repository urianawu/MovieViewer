//
//  TopRatedCell.swift
//  MovieViewer
//
//  Created by you wu on 2/5/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class TopRatedCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var star: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let mGradient = CAGradientLayer()
        mGradient.frame = title.bounds
        mGradient.frame = mGradient.frame.offsetBy(dx: 0, dy: 130)
        var colors_up = [CGColor]()
        colors_up.append(UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        colors_up.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor)
        
        mGradient.startPoint = CGPoint(x: 0, y: 0)
        mGradient.endPoint = CGPoint(x: 1, y: 0)
        mGradient.colors = colors_up
        posterView.layer.insertSublayer(mGradient, at: 0)

        
    }
}
