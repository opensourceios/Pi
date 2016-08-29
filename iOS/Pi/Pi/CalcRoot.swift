
//
//  CalcRoot.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/8/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

/*
class CalcRoot: PagerController, PagerDataSource {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.dataSource = self
		
		let calcSB = UIStoryboard(name: "Calculators", bundle: nil)
		
		let tutorialsVC = calcSB.instantiateViewController(withIdentifier: "TutorialVC")
		let calcVC = calcSB.instantiateViewController(withIdentifier: "MainCalculator")
		let variableDefinitionsVC = calcSB.instantiateViewController(withIdentifier: "VariableDefinitionsVC")
		
		let tabsControllers = [tutorialsVC, calcVC, variableDefinitionsVC]
		let tabNames = ["Tutorials", "Calculator", "Variables"]
		
		let queue = DispatchQueue(label: "queue")
		queue.async { 
			self.setupPager(tabNames, tabControllers: tabsControllers)
			self.customizeTab()
		}
		
	}
	
	override func willMove(toParentViewController parent: UIViewController?) {
		if parent == nil {
			print("Leaving Calc.")
		}
	}
	
	func customizeTab() {
		self.indicatorColor = UIColor(netHex: 0x6430a3)
		self.tabsViewBackgroundColor = UIColor.white()
		self.tabsTextColor = UIColor(netHex: 0x6430a3)
		self.startFromSecondTab = false
		self.centerCurrentTab = false
		self.tabLocation = PagerTabLocation.top
		self.tabHeight = 49
		self.tabOffset = 36
		self.tabWidth = self.view.frame.width / 3 /* 96.0 */
		self.fixFormerTabsPositions = false
		self.fixLaterTabsPosition = false
		self.animation = PagerAnimation.during
	}

}
*/

class CalcRoot: UIViewController {
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var segmentedViewPicker: UISegmentedControl!
	
	var childVC: UIViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.segmentedViewPicker.selectedSegmentIndex = 1
		
		self.loadChildViewController()
		
		/* Remove View
		MainCalculator().willMove(toParentViewController: nil)
		MainCalculator().view.removeFromSuperview()
		MainCalculator().removeFromParentViewController()
		*/
	}
	
	func loadChildViewController(_ callingFunction: String = #function) {
		switch self.segmentedViewPicker.selectedSegmentIndex {
		case 0:
			self.childVC.willMove(toParentViewController: nil)
			self.childVC.view.removeFromSuperview()
			self.childVC.removeFromParentViewController()
			self.childVC = TutorialVC()
		case 1:
			
			print(callingFunction)
			
			if callingFunction == "viewDidLoad()" {
				
			} else {
				self.childVC.willMove(toParentViewController: nil)
				self.childVC.view.removeFromSuperview()
				self.childVC.removeFromParentViewController()
			}
			
			self.childVC = MainCalculator()
		case 2:
			self.childVC.willMove(toParentViewController: nil)
			self.childVC.view.removeFromSuperview()
			self.childVC.removeFromParentViewController()
			self.childVC = VariableDefinitionsVC()
		default:
			fatalError("Which fucking view controller is this?")
		}
		
		self.addChildViewController(childVC)
		self.containerView.addSubview(childVC.view)
		childVC.didMove(toParentViewController: self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
	@IBAction func didClickViewSelector(_ sender: AnyObject) {
		self.loadChildViewController()
	}
}
