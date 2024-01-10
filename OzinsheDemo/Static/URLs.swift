//
//  URLs.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 05.01.2024.
//

import Foundation

class URLs {
    static let BASE_URL = "http://api.ozinshe.com/core/V1/"
    static let SIGN_IN_URL = "http://api.ozinshe.com/auth/V1/signin"
    static let SIGN_UP_URL = "http://api.ozinshe.com/auth/V1/signup"
    static let FAVORITE_URL = BASE_URL + "favorite/"
    static let CHANGE_PASS_URL = BASE_URL + "user/profile/changePassword"
    static let GET_PROFILE_URL = BASE_URL + "user/profile"
    static let UPDATE_PROFILE_URL = BASE_URL + "user/profile/"
}

