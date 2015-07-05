//
//  ToDoItem.swift
//  RealmExample
//
//  Created by Raphael Silva on 7/4/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import Foundation
import Realm

class ToDoItem: RLMObject {
    dynamic var name = ""
    dynamic var finished = false
    dynamic var created = NSDate()
}