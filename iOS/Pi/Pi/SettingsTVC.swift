//
//  Settings.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/1/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
	
    /* 
	let settings: [String: [String]] = [
        "Contact Us": [
            "Help",
            "Website",
            "Twitter",
            "Instagram"
        ],
        "About": [
            "About Pi",
            "Pi Version",
            "Acknowledgements"
        ]
    ]
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
	
	*/
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		/*
		for (key, value) in settings {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        self.title = "Settings"
		*/
        
    }
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 3 && indexPath.row == 0 {
			self.dismiss(animated: true) {
				
			}
		}
		
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
	
	
	
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
