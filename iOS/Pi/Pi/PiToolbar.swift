//
//  PiToolbar.swift
//  Pi
//
//  Created by Rigoberto Molina on 8/19/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class PiToolbar: UIToolbar {
    
    override func draw(_ rect: CGRect) {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        if Device().isPhone || Device().isPod {
            imageView.image = UIImage(named: "splash-800.png")
            self.insertSubview(imageView, at: 0)
        } else {
            imageView.image = UIImage(named: "splash-1200.png")
            self.insertSubview(imageView, at: 0)
        }
        
        self.isTranslucent = false
        self.tintColor = UIColor.white
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
