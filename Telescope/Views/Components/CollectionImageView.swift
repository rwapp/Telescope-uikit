//
//  CollectionImageView.swift
//  Telescope
//
//  Created by Rob Whitaker on 03/05/2022.
//

import Foundation
import UIKit

final class CollectionImageView: UIImageView {

    struct Content {
        let date: String?
        let description: String?
    }

    var content: Content?

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

extension CollectionImageView: AXCustomContentProvider {
    var accessibilityCustomContent: [AXCustomContent]! {
        get {
            var customContent = [AXCustomContent]()
            if let date = content?.date {
                let dateContent = AXCustomContent(label: "Date", value: date)
                customContent.append(dateContent)
            }
            if let description = content?.description {
                let descriptionContent = AXCustomContent(label: "Description", value: description)
                customContent.append(descriptionContent)
            }
            return customContent
        }
        set(accessibilityCustomContent) {}
    }
}
