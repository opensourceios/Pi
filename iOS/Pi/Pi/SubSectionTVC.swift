//
//  SubSectionTVC.swift
//  Pi
//
//  Created by Rigoberto Molina on 8/17/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class SubSectionTVC: UITableViewController {
    
    var sectionTitle: String = ""
    var subjectID: Int = 0
    var ssID: Int = 0
    
    var formulas: [Formula] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sectionTitle
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
        
        let formulaJSON = JSONData["data"]["subjects"][self.subjectID]["formulas"][self.ssID]["formulas"]
        
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formulas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.tableView.rowHeight = 110
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ss_cell", for: indexPath) as! FormulaCell
        
        cell.formulaTitle.text = self.formulas[indexPath.row].title
        cell.formulaEquation.latex = self.formulas[indexPath.row].equation
        
        return cell
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
