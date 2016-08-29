//
//  RMHorizontalPush.swift
//  Pi
//
//  Created by Rigoberto Molina on 8/1/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class RMHorizontalPushGo: UIStoryboardSegue {
	override func perform() {
		let firstClassView = self.source.view
		let secondClassView = self.destination.view
		
		let screenWidth = UIScreen.main.bounds.size.width
		let screenHeight = UIScreen.main.bounds.size.height
		secondClassView?.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
		
		if let window = UIApplication.shared.keyWindow {
			
			window.insertSubview(secondClassView!, aboveSubview: firstClassView!)
			
			UIView.animate(withDuration: 0.6, animations: { () -> Void in
				
				firstClassView?.frame = ((firstClassView?.frame)?.offsetBy(dx: -screenWidth, dy: 0))!
				secondClassView?.frame = ((secondClassView?.frame)?.offsetBy(dx: -screenWidth, dy: 0))!
				
			}) {(Finished) -> Void in
				
				self.source.navigationController?.pushViewController(self.destination, animated: false)
				
			}
			
		}
	}
}

class RMHorizontalPushBack: UIStoryboardSegue {
	override func perform() {
		let firstClassView = self.source.view
		let secondClassView = self.destination.view
		
		let screenWidth = UIScreen.main.bounds.size.width
		let screenHeight = UIScreen.main.bounds.size.height
		secondClassView?.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
		
		if let window = UIApplication.shared.keyWindow {
			
			window.insertSubview(secondClassView!, aboveSubview: firstClassView!)
			
			UIView.animate(withDuration: 0.3, animations: { () -> Void in
				
				firstClassView?.frame = ((firstClassView?.frame)?.offsetBy(dx: -screenWidth, dy: 0))!
				secondClassView?.frame = ((secondClassView?.frame)?.offsetBy(dx: -screenWidth, dy: 0))!
				
			}) {(Finished) -> Void in
				
				self.source.navigationController?.pushViewController(self.destination, animated: false)
				
			}
			
		}
	}
}

class FadeSegue: UIStoryboardSegue {
	override func perform() {
		let transition = CATransition()
		transition.duration = 0.7
		transition.type = kCATransitionFade
		self.source.view.window?.layer.add(transition, forKey: kCATransitionFade)
		self.source.present(self.destination, animated: false, completion: {
            
		})
	}
}
