//
//  Constants.swift
//  HW.FileManagerApp
//
//  Created by Роман on 25.01.2022.
//

import UIKit
import RealmSwift

let user = UserData()

let localRealm = try? Realm()

class UserData: Object {
    
    @Persisted var login: String = ""
    @Persisted var password: String = ""
}
