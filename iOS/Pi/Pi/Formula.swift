//
//  Formula.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/5/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

struct Formula {
    
    init() {
        
    }
    
    init(title: String, equation: String, isSection: Bool, id: String, numberOfTextFields: Int, placeholders: [String], subjectID: Int) {
        self.title = title
        self.equation = equation
        self.isSection = isSection
        self.id = id
        self.numberOfTextFields = numberOfTextFields
        self.placeholders = placeholders
        self.subjectID = subjectID
    }
    
	var title: String!
	var equation: String!
	var isSection: Bool!
	var id: String!
    var numberOfTextFields: Int!
    var placeholders: [String]!
    var subjectID: Int!
}
