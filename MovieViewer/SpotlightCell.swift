//
//  SpotlightCell.swift
//  MovieViewer
//
//  Created by you wu on 1/27/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import Cosmos

class SpotlightCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIImageView!
      @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var ratingStar: CosmosView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingStar.settings.fillMode = .precise
        
        ratingStar.settings.filledColor = lightGreen
        ratingStar.settings.emptyBorderColor = lightGreen
        //add gradient mask
        let mGradient_up = CAGradientLayer()
        mGradient_up.frame = bgView.bounds
        var colors_up = [CGColor]()
        colors_up.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor)
        colors_up.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor)
        
        mGradient_up.startPoint = CGPoint(x: 0, y: 0)
        mGradient_up.endPoint = CGPoint(x: 0, y: 0.7)
        mGradient_up.colors = colors_up
        bgView.layer.addSublayer(mGradient_up)
        
        
        let mGradient_down = CAGradientLayer()
        mGradient_down.frame = bgView.bounds
        var colors = [CGColor]()
        colors.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor)
        colors.append(UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        
        mGradient_down.startPoint = CGPoint(x: 0, y: 0.7)
        mGradient_down.endPoint = CGPoint(x: 0, y: 1)
        mGradient_down.colors = colors
        bgView.layer.addSublayer(mGradient_down)
        
    }
    
}
