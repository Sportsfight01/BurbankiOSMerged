//
//  BreadCrump.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/09/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class BreadCrumb: NSObject {

    var breadCrumb: String?
    
    override init() {
        super.init()
    }
    
    init(breadcrumb: String) {
        super.init()
        breadCrumb = breadcrumb
    }
}
