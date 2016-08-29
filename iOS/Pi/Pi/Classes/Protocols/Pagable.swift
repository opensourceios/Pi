//
//  Pagable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 6/10/16.
//  Copyright (c) 2016 kitasuke. All rights reserved.
//

import Foundation

protocol Pagable {
    var currentPage: Int { get }
    var previousPage: Int { get }
    var nextPage: Int { get }
    func updateCurrentPage(_ page: Int)
}

extension Pagable {
    func updateCurrentPage(_ page: Int) {}
}
