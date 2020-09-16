//
//  Protocols.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 10/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation



protocol SectionAdaptable {
    
    associatedtype T
    
    var items:[T]? {get}
    
    var sectionTitle:String{get set}

}

