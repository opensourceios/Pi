//
//  FavoritesTVC.swift
//  Pi
//
//  Created by Rigoberto Molina on 6/22/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit
import iosMath

class FavoritesCell: UITableViewCell {
    
    @IBOutlet weak var formulaTitle: UILabel!
    @IBOutlet weak var formulaEquation: MTMathUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
