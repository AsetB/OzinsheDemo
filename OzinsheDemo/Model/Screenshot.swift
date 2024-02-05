//
//  Screenshot.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 08.01.2024.
//

import Foundation
import SwiftyJSON

class Screenshot {
    public var id: Int = 0
    public var link: String = ""
//    var fileId: Int = 0
//    var movieId: Int = 0
    init() {
    }
    
    init(json: JSON) {
        if let data = json["id"].int {
            self.id = data
        }
        if let data = json["link"].string {
            self.link = data
        }
    }
    
}
