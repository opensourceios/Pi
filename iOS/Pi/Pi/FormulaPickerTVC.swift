//
//  FormulaPickerTVC.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/1/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit
import iosMath

class FormulaPickerTVC: UITableViewController {
    
    var subjectTitle: String = ""
    var subjectID: Int = 0
	
	var formulas: [Formula] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.subjectTitle
        
        self.setData()
        
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
        
        let formulaJSON = JSONData["data"]["subjects"][self.subjectID]["formulas"]
        
        for i in 0 ..< formulaJSON.count {
			
			let currentFormulaLoop = formulaJSON[i]
			let storyboardID = currentFormulaLoop["storyboardID"].stringValue
			
			if currentFormulaLoop["isSection"].boolValue == true {
				
				let sectionTitle = currentFormulaLoop["section_name"].stringValue
				// TODO: If only one formula only --> (s)
				// TODO: Fix JSON/Plist Value to Section Subtitle rather than "formula_equation" for sections only
				let sectionSubtitle = "\(currentFormulaLoop["formulas"].count) Formulas"
                
                var tfPlaceholders: [String] = []
                
                for placeholderJSON in currentFormulaLoop["placeholders"].arrayValue {
                    tfPlaceholders.append(placeholderJSON.stringValue)
                }
                
                var formula = Formula()
                formula.title = sectionTitle
                formula.equation = sectionSubtitle
                formula.isSection = true
                formula.id = storyboardID
                formula.numberOfTextFields = currentFormulaLoop["numberOfTextFields"].intValue
                formula.placeholders = tfPlaceholders
                
                self.formulas.append(formula)
                
			} else {
				
				let formulaTitle = currentFormulaLoop["formula_name"].stringValue
				let formulaEquation = currentFormulaLoop["formula_equation"].stringValue
                
                var tfPlaceholders: [String] = []
                
                for placeholderJSON in currentFormulaLoop["placeholders"].arrayValue {
                    tfPlaceholders.append(placeholderJSON.stringValue)
                }
                
                var formula = Formula()
                formula.title = formulaTitle
                formula.equation = formulaEquation
                formula.isSection = false
                formula.id = storyboardID
                formula.numberOfTextFields = currentFormulaLoop["numberOfTextFields"].intValue
                formula.placeholders = tfPlaceholders
                
				self.formulas.append(formula)
                
			}
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formulas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.formulas[indexPath.row].isSection == true {
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "formula_cell", for: indexPath) as! FormulaSectionTableViewCell
            normalCell.sectionTitle.text = self.formulas[indexPath.row].title
            normalCell.formulaCount.text = self.formulas[indexPath.row].equation
            normalCell.accessoryType = .disclosureIndicator
            self.tableView.rowHeight = 70.0 // Sets Row Height
            return normalCell
        } else {
            let latexCell = tableView.dequeueReusableCell(withIdentifier: "formula_cell_latex", for: indexPath) as! FormulaCell
            latexCell.formulaTitle?.text = self.formulas[indexPath.row].title
            latexCell.formulaEquation?.latex = self.formulas[indexPath.row].equation
            self.tableView.rowHeight = 110.0 // Sets Row Height
            return latexCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If section, else
		
		if self.formulas[indexPath.row].isSection == true {
			self.performSegue(withIdentifier: "toSubsection", sender: self)
			self.tableView.deselectRow(at: indexPath, animated: true)
		} else {
			self.performSegue(withIdentifier: "toCalc", sender: self)
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
		
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toSubsection" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let destinationVC = segue.destination as! SubSectionTVC
            
            destinationVC.sectionTitle = self.formulas[indexPath.row].title
            destinationVC.subjectID = self.subjectID
            destinationVC.ssID = indexPath.row
            
		} else if segue.identifier == "toCalc" {
			let indexPath = self.tableView.indexPathForSelectedRow!
			let destinationVC = segue.destination as! RMCalculatorViewController
			destinationVC.formulaTitle = self.formulas[indexPath.row].title
			destinationVC.formulaEquation = self.formulas[indexPath.row].equation
            destinationVC.numberOfTextFields = self.formulas[indexPath.row].numberOfTextFields
			destinationVC.textFieldPlaceholders = self.formulas[indexPath.row].placeholders
			destinationVC.storyboardID = self.formulas[indexPath.row].id
			destinationVC.subjectID = self.subjectID
			destinationVC.formulaID = indexPath.row
			destinationVC.title = self.formulas[indexPath.row].title
		}
     }
}
