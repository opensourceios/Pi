//
//  MainSuperActionsVC.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/5/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class MainCalculator: UIViewController {
	
	@IBOutlet weak var formulaTitle: UILabel!
	@IBOutlet weak var formula: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func didMove(toParentViewController parent: UIViewController?) {
		super.didMove(toParentViewController: parent)
	}
}
