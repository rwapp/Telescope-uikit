//
//  CollectionImageView.swift
//  Telescope
//
//  Created by Rob Whitaker on 03/05/2022.
//

import Foundation
import UIKit

final class CollectionImageView: UIImageView {
    convenience init() {
        self.init(frame: .zero)

        isAccessibilityElement = true
        accessibilityIgnoresInvertColors = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        accessibilityTraits.insert(.button)
    }
}
