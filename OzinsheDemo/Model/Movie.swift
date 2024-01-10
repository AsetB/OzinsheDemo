//
//  Movie.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 08.01.2024.
//

import Foundation
import SwiftyJSON

//        "id": 109,
//        "movieType": "MOVIE",
//        "name": "Махамбет",
//        "keyWords": "Махамбет батыр",
//        "description": "Махамбет",
//        "year": 2020,
//        "trend": true,
//        "timing": 45,
//        "director": "Қасиет Сақиолла",
//        "producer": "Қасиет Сақиолла",
//        "poster": {
//            "id": 129,
//            "link": "http://api.ozinshe.com/core/public/V1/show/643",
//            "fileId": 643,
//            "movieId": 109
//        },
//        "video": {
//            "id": 365,
//            "link": "Kq0dkn0W0jE",
//            "seasonId": null,
//            "number": 0
//        },
//        "watchCount": 5729,
//        "seasonCount": 0,
//        "seriesCount": 0,
//        "createdDate": "2022-01-31T05:09:15.703+00:00",
//        "lastModifiedDate": "2022-07-14T05:50:03.680+00:00",
//        "screenshots": [
//            {
//                "id": 129,
//                "link": "http://api.ozinshe.com/core/public/V1/show/593",
//                "fileId": 593,
//                "movieId": 109
//            }
//        ],
//        "categoryAges": [
//            {
//                "id": 2,
//                "name": "10-12",
//                "fileId": 257,
//                "link": "http://api.ozinshe.com/core/public/V1/show/257",
//                "movieCount": null
//            },
//            {
//                "id": 1,
//                "name": "8-10",
//                "fileId": 353,
//                "link": "http://api.ozinshe.com/core/public/V1/show/353",
//                "movieCount": null
//            },
//            {
//                "id": 4,
//                "name": "14-16",
//                "fileId": 357,
//                "link": "http://api.ozinshe.com/core/public/V1/show/357",
//                "movieCount": null
//            },
//            {
//                "id": 3,
//                "name": "12-14",
//                "fileId": 356,
//                "link": "http://api.ozinshe.com/core/public/V1/show/356",
//                "movieCount": null
//            }
//        ],
//        "genres": [
//            {
//                "id": 58,
//                "name": "Отбасымен көретіндер",
//                "fileId": 661,
//                "link": "http://api.ozinshe.com/core/public/V1/show/661",
//                "movieCount": null
//            },
//            {
//                "id": 29,
//                "name": "Шытырман оқиғалы",
//                "fileId": 349,
//                "link": "http://api.ozinshe.com/core/public/V1/show/349",
//                "movieCount": null
//            }
//        ],
//        "categories": [
//            {
//                "id": 8,
//                "name": "Толықметрлі мультфильмдер",
//                "fileId": null,
//                "link": null,
//                "movieCount": null
//            }
//        ],
//        "favorite": true
//    }

class Movie {
    public var id: Int = 0
    public var movieType: String = ""
    public var name: String = ""
    public var keyWords: String = ""
    public var description: String = ""
    public var year: Int = 0
    public var trend: Bool = false
    public var timing: Int = 0
    public var director: String = ""
    public var producer: String = ""
    public var posterLink: String = ""
    public var videoLink: String = ""
    public var watchCount: Int = 0
    public var seasonCount: Int = 0
    public var seriesCount: Int = 0
    public var createdDate: String = ""
    public var lastModifiedDate: String = ""
    public var screenshots: [Screenshot] = []
    public var categoryAges: [CategoryAge] = []
    public var genres: [Genre] = []
    public var categories: [Category] = []
    public var favorite: Bool = false
    
    init() {
    }
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["movieType"].string {
            self.movieType = temp
        }
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["keyWords"].string {
            self.keyWords = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        if let temp = json["year"].int {
            self.year = temp
        }
        if let temp = json["trend"].bool {
            self.trend = temp
        }
        if let temp = json["timing"].int {
            self.timing = temp
        }
        if let temp = json["director"].string {
            self.director = temp
        }
        if let temp = json["producer"].string {
            self.producer = temp
        }
        if json["poster"].exists() {
            if let temp = json["poster"]["link"].string {
                self.posterLink = temp
            }
        }
        if json["video"].exists() {
            if let temp = json["video"]["link"].string {
                self.videoLink = temp
            }
        }
        if let temp = json["watchCount"].int {
            self.watchCount = temp
        }
        if let temp = json["seasonCount"].int {
            self.seasonCount = temp
        }
        if let temp = json["seriesCount"].int {
            self.seriesCount = temp
        }
        if let temp = json["createdDate"].string {
            self.createdDate = temp
        }
        if let temp = json["lastModifiedDate"].string {
            self.lastModifiedDate = temp
        }
        if let array = json["screenshots"].array {
            for item in array {
                let temp = Screenshot(json: item)
                self.screenshots.append(temp)
            }
        }
        if let array = json["categoryAges"].array {
            for item in array {
                let temp = CategoryAge(json: item)
                self.categoryAges.append(temp)
            }
        }
        if let array = json["genres"].array {
            for item in array {
                let temp = Genre(json: item)
                self.genres.append(temp)
            }
        }
        if let array = json["categories"].array {
            for item in array {
                let temp = Category(json: item)
                self.categories.append(temp)
            }
        }
        if let temp = json["favorite"].bool {
            self.favorite = temp
        }
    }
}
