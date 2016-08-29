//
//  RMThemeTableViewCell.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/28/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class RMThemeTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var themeColorView: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
