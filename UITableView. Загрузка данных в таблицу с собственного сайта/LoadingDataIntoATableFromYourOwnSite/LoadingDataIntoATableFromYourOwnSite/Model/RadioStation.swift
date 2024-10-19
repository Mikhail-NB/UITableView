//
//  RadioStation.swift
//  LoadingDataIntoATableFromYourOwnSite
//
//  Created by Михаил on 14.10.2024.
//

import Foundation

struct RadioStation: Codable {
    
    var name: String
    var imageURL: String
    
}

extension RadioStation: Equatable {
    
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return (lhs.name == rhs.name) && (lhs.imageURL == rhs.imageURL)
    }
}
