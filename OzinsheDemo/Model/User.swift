//
//  User.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 09.01.2024.
//

import Foundation
import SwiftyJSON

class User {
    public var id: Int = 0
    public var email: String = ""
    
    init(json: JSON) {
        if let data = json["id"].int {
            self.id = data
        }
        if let data = json["email"].string {
            self.email = data
        }
    }
    
    init(dictionary: [String: JSON]) {
            if let data = dictionary["id"]?.int {
                self.id = data
            }
            if let data = dictionary["email"]?.string {
                self.email = data
            }
        }
}
