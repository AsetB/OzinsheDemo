//
//  Storage.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 05.01.2024.
//

import Foundation

class Storage {
    public var accessToken: String = ""
    public var userData: User?
    static let sharedInstance = Storage()
}
