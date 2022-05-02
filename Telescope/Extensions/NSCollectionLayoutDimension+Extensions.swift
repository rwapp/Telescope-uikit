//
//  NSCollectionLayoutDimension+Extensions.swift
//  Telescope
//
//  Created by Rob Whitaker on 01/05/2022.
//

import UIKit

extension NSCollectionLayoutDimension {
    static let fullWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
    static let thirdWidth = NSCollectionLayoutDimension.fractionalWidth(1/3)
    static let twoThirdsWidth = NSCollectionLayoutDimension.fractionalWidth(2/3)
    static let halfWidth = NSCollectionLayoutDimension.fractionalWidth(1/2)

    static let fullHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
    static let halfHeight = NSCollectionLayoutDimension.fractionalHeight(1/2)
    static let twoThirdsHeight = NSCollectionLayoutDimension.fractionalHeight(2/3)
}
