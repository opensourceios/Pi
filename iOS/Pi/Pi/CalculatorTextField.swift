//
//  CalculatorTextField.swift
//  Pi
//
//  Created by Rigoberto Molina on 8/14/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

class CalculatorTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        // self.layer.borderColor = UIColor(netHex: 0x7b40c1).cgColor
        self.layer.borderColor = UIColor.black.cgColor
        self.textColor = UIColor.black
        self.textAlignment = .center
    }
    
}
