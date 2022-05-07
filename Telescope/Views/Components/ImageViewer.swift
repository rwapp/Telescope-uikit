//
//  ImageViewer.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import Foundation
import UIKit

final class ImageViewer: UIScrollView {
    private let imageView = UIImageView()

    var removeFromView: () -> Void = {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    convenience init(image: UIImage) {
        self.init(frame: .zero)
        imageView.image = image
    }

    private func setupImageView() {
        imageView.isAccessibilityElement = true
        accessibilityViewIsModal = true
        backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityLabel = accessibilityLabel

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        minimumZoomScale = 1
        maximumZoomScale = 3
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
    }
}

extension ImageViewer: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if zoomScale < 0.65 {
            removeFromSuperview()
        }
    }
}
