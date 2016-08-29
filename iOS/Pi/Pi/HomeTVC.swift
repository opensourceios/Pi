//
//  Home.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/1/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class HomeTVC: UITableViewController {
    
    // MARK: Properties
    
    var subjects: [Subject] = []
    // MARK: Main Entry
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setData()
        self.setTitleView()
        
    }
	
    func setData() {
        // JSON File URL Path
        let JSONFileURLPath = Bundle.main.path(forResource: "Data", ofType: "json")
        
        // JSON File URL
        let JSONFileURL = URL(fileURLWithPath: JSONFileURLPath!)
        
        // Data from JSON File for JSON Data
        let data = try! Data(contentsOf: JSONFileURL)
        
        // Get JSON from data
        let JSONData: JSON = JSON(data: data)
        
        let subjectCount = JSONData["data"]["subjects"].count
        
        for i in 0 ..< subjectCount {
            
            let subjectTitle: String = JSONData["data"]["subjects"][i]["subject_name"].stringValue
            let formulaCount: Int = JSONData["data"]["subjects"][i]["formulas"].count
			let currentColor: Int = JSONData["data"]["subjects"][i]["color_hex"].intValue
			
			self.subjects.append(Subject(Name: subjectTitle, FormulaCount: formulaCount, txtColorHex: currentColor))
        }
		
    }
    
    func setTitleView() {
        // Pi Logo
        let navigationImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        navigationImage.image = UIImage(named: "Pi-Logo")
        
        // Shrink to fit Navbar
        let workaroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        workaroundImageView.addSubview(navigationImage)
        
        // Set title view to Pi logo
        self.navigationItem.titleView = workaroundImageView
    }
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home_subject_cell", for: indexPath) as! HomeSubjectCell // Get cell ID from Interface Builder
        
        var formulaStatement: String = ""
        
        if self.subjects[indexPath.row].FormulaCount == 1 {
            formulaStatement = "Formula"
        } else {
            formulaStatement = "Formulas"
        }
        
        cell.subjectTitle?.text = self.subjects[indexPath.row].Name // Set cell title as subject name
		cell.subjectTitle?.textColor = UIColor(netHex: self.subjects[indexPath.row].txtColorHex)
        cell.formulaCount?.text = "\(self.subjects[indexPath.row].FormulaCount) \(formulaStatement)"
        
        self.tableView.rowHeight = 70.0 // Sets Row Height
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform Segue & Deselect Cell
        self.performSegue(withIdentifier: "homeToFormulas", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Subjects"
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // If The Destination Is The Formula's Controller.
        if segue.identifier == "homeToFormulas" {
            
            let vc = segue.destination as! FormulaPickerTVC
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            vc.subjectTitle = self.subjects[indexPath.row].Name
            vc.subjectID = indexPath.row
            
        }
    }
    
}
