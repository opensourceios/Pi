//
//  FormulaSectionTableViewCell.swift
//  Pi
//
//  Created by Rigoberto Molina on 8/15/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class FormulaSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var formulaCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
