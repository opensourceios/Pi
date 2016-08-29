//
//  MainNav.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/15/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//
/*
import UIKit

class MainNav: UINavigationController {
    
    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = self.navigationBar.bounds
        // take into account the status bar
        updatedFrame.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white()
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.white() ]
        self.navigationBar.titleTextAttributes = fontDictionary
        // self.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default) : OLD
        
        if Device().isPhone || Device().isPod {
            self.navigationBar.setBackgroundImage(UIImage(named: "splash-800.png"), for: .default)
        } else {
            self.navigationBar.setBackgroundImage(UIImage(named: "splash-1200.png"), for: .default)
        }
        
        //self.navigationBar.setBackgroundImage(UIImage(named: "background-nav"), for: .default)
    }
}
*/

//
//  MainNav.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/15/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class MainNav: UINavigationController {
	
	private func imageLayerForGradientBackground() -> UIImage {
		var updatedFrame = self.navigationBar.bounds
		// take into account the status bar
		updatedFrame.size.height += 20
		
		let layer = UIImageView(frame: updatedFrame)
		
		if Device().isPhone || Device().isPod {
			layer.image = UIImage(named: "splash-800.png")
		} else {
			layer.image = UIImage(named: "splash-1200.png")
		}
		
		layer.contentMode = .scaleAspectFill
		// layer.clipsToBounds = true
		
		UIGraphicsBeginImageContext(layer.layer.bounds.size)
		layer.layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationBar.isTranslucent = false
		self.navigationBar.tintColor = UIColor.white
		let font = UIFont(name: "Avenir-Light", size: 20.0) // Used to be 22.0
		let fontDictionary: [String: AnyObject]? = [ NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: font! ]
		self.navigationBar.titleTextAttributes = fontDictionary
		self.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
		
		/*
		if Device().isPhone || Device().isPod {
		self.navigationBar.setBackgroundImage(UIImage(named: "splash-800.png"), for: .default)
		} else {
		self.navigationBar.setBackgroundImage(UIImage(named: "splash-1200.png"), for: .default)
		}*/
		
		//self.navigationBar.setBackgroundImage(UIImage(named: "background-nav"), for: .default)
	}
}
