//
//  MainTabBarController.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/14/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if #available(iOS 10.0, *) {
			self.tabBar.unselectedItemTintColor = UIColor(netHex: 0xCCCCCC)
			
			let titleAttributes: [String : AnyObject]? = [
				NSFontAttributeName: UIFont(name: "Avenir-Book", size: 10.0)!
			]
			
			UITabBarItem.appearance().setTitleTextAttributes(titleAttributes, for: .normal)
			UITabBarItem.appearance().setTitleTextAttributes(titleAttributes, for: .selected)
		} else {
			// TODO: ADD NON iOS 10 LOGIC
			// Fallback on earlier versions
			/*
			let titleAttributes = [
			NSForegroundColorAttributeName: UIColor(netHex: 0xFF0000)
			]
			
			let lol = [
			NSForegroundColorAttributeName: UIColor(netHex: 0x00FF00)
			]
			
			UITabBarItem.appearance().setTitleTextAttributes(titleAttributes, for: .normal)
			
			UITabBarItem.appearance().setTitleTextAttributes(lol, for: .selected)
			*/
		}
		
		print(UITabBarItem.appearance().titleTextAttributes(for: .normal))
		
		self.selectedIndex = 2
		
		print(self.tabBar.bounds)
		
		self.tabBar.isTranslucent = false
		self.tabBar.tintColor = UIColor.white
		
		let imageView = UIImageView(frame: self.tabBar.bounds)
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		if Device().isPhone || Device().isPod {
			imageView.image = UIImage(named: "splash-800.png")
			self.tabBar.insertSubview(imageView, at: 0)
		} else {
			imageView.image = UIImage(named: "splash-1200.png")
			self.tabBar.insertSubview(imageView, at: 0)
		}
		
        // Do any additional setup after loading the view.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
	}
	
    /*
    // MARK: - Navigation
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
}
