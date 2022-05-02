//
//  InteractiveImageView.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import UIKit

final class InteractiveImageView: UIImageView {

    var imageTapped: () -> Void = {}

    init() {
        super.init(frame: .zero)

        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIgnoresInvertColors = true
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func tapGesture() {
        imageTapped()
    }

    override func accessibilityActivate() -> Bool {
        imageTapped()
        return true
    }
}
