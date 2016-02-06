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
        mGradient.frame.offsetInPlace(dx: 0, dy: 130)
        var colors_up = [CGColor]()
        colors_up.append(UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor)
        colors_up.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor)
        
        mGradient.startPoint = CGPointMake(0, 0)
        mGradient.endPoint = CGPointMake(1, 0)
        mGradient.colors = colors_up
        posterView.layer.insertSublayer(mGradient, atIndex: 0)

        
    }
}
