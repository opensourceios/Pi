//
//  PageLoadable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 6/10/16.
//  Copyright (c) 2016 kitasuke. All rights reserved.
//

import Foundation

protocol PageLoadable {
    func shouldLoadPage(_ page: Int) -> Bool
    func isVisibleController(_ controller: UIViewController) -> Bool
    func showVisibleControllers()
    func hideVisibleControllers()
}
