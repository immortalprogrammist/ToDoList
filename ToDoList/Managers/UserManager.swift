//
//  UserManager.swift
//  ToDoList
//
//  Created by Nikita on 30.07.21.
//

import Foundation

class UserManager {
    let shared = UserManager()
    
    var lists: [ToDoList] = []
    var tasks: [Task] = []
    
    private init() {}
}
