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
}
