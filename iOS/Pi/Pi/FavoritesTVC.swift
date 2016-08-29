//
//  FavoritesTVC.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/22/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class FavoritesTVC: UITableViewController {
    
    var favorites: [Int : [Formula]] = [
        0: [],
        1: [],
        2: [],
        3: [],
        4: [],
        5: [],
        6: []
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadFavorites()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadFavorites()
        self.tableView.reloadData()
    }
    
    func loadFavorites() {
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 0
        for i in self.favorites.keys {
            if self.favorites[i]?.count != 0 {
                count += 1
            }
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Algebra 1"
        case 1: return "Geometry"
        case 2: return "Algebra 2"
        case 3: return "Pre-Calculus"
        case 4: return "Calculus"
        case 5: return "Chemistry"
        case 6: return "Everyday Math"
        default:
            fatalError("Unknown subject for section.")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "favorites_cell", for: indexPath) as! FavoritesCell
        
        self.tableView.rowHeight = 110
        
        // TODO: Find a more convenient way of doing this.
        switch indexPath.section {
        case 0:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        case 1:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        case 2:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        case 3:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        case 4:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        case 5:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        case 6:
            cell.formulaTitle.text = self.favorites[indexPath.section]?[indexPath.row].title!
            cell.formulaEquation.latex = self.favorites[indexPath.section]?[indexPath.row].equation!
            return cell
        default:
            fatalError("Unknown section.")
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // TODO: Rearrange Logic
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
