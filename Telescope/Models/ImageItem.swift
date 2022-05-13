//
//  ImageItem.swift
//  Telescope
//
//  Created by Rob Whitaker on 01/05/2022.
//

import Foundation

struct ImageItem: Codable, Hashable {
    let imageURL: String
    let title: String
    let description: String?
    let center: String?
    let date: Date
    let nasaID: String
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: self.date)
        return formattedDate
    }
    var liked: Bool {
        FavouriteStorage().isFavourite(image: self)
    }
}
