//
//  CategoryAge.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 08.01.2024.
//

import Foundation
import SwiftyJSON

class CategoryAge {
    public var id: Int = 0
    public var name: String = ""
    //public var fileId: Int = 0
    public var link: String = ""
    //public var movieCount: Int = 0
    
    init(json: JSON) {
        if let data = json["id"].int {
            self.id = data
        }
        if let data = json["name"].string {
            self.name = data
        }
        if let data = json["link"].string {
            self.link = data
        }
    }
}
