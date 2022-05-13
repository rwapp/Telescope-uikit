//
//  ImageCollectionViewCell.swift
//  Telescope
//
//  Created by Rob Whitaker on 26/04/2022.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ImageCollectionViewCell"

    private lazy var imageButtonViewModel = ImageButtonsViewModel()
    private lazy var imageButtons = ImageButtons(viewModel: imageButtonViewModel)
    private lazy var buttonStack = imageButtons.buttonStack
    private(set) lazy var imageView = CollectionImageView()
    private let titleLabel = TSLabel()
    private var viewModel: ImageCollectionViewCellViewModel?

    func setViewModel(_ viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel

        viewModel.showImage = { [weak self] in
            guard let self = self else { return }
            self.imageView.accessibilityLabel = self.viewModel?.item.title
            self.imageView.image = self.viewModel?.image
            self.imageButtonViewModel.image = viewModel.image
        }

        viewModel.showLikeStatus = { [weak self] in
            self?.imageButtons.setLikeStatus(viewModel.item.liked)
            self?.accessibilityValue = viewModel.item.liked ? "Liked" : ""
        }

        imageButtonViewModel.item = viewModel.item
        imageButtons.setLikeStatus(viewModel.item.liked)
        imageView.image = nil

        viewModel.getImage()
        setupView()
    }

    private func setupView() {
        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        contentContainer.addSubview(imageView)
        contentContainer.addSubview(buttonStack)

        titleLabel.text = viewModel?.item.title
        contentContainer.addSubview(titleLabel)

        isAccessibilityElement = true
        accessibilityLabel = viewModel?.item.title
        accessibilityTraits.insert(.button)
        accessibilityTraits.insert(.image)
        accessibilityValue = viewModel?.item.liked ?? false ? "Liked" : ""

        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor),

            buttonStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            buttonStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0),

            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
    }
}
