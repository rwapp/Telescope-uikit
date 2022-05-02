//
//  ImageCollectionViewCell.swift
//  Telescope
//
//  Created by Rob Whitaker on 26/04/2022.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ImageCollectionViewCell"

    private let favourites = FavouriteStorage()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isAccessibilityElement = true
        imageView.accessibilityIgnoresInvertColors = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel = TSLabel()
    private var viewModel: ImageCollectionViewCellViewModel?

    private lazy var likeButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favouriteImage), for: .touchUpInside)

        return button
    }()
    private lazy var shareButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.accessibilityLabel = "Share"
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.accessibilityLabel = "Save"
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView(arrangedSubviews: [likeButton, shareButton, saveButton])
        buttonStack.alignment = .leading
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        return buttonStack
    }()

    func setViewModel(_ viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel

        viewModel.showImage = { [weak self] in
            guard let self = self else { return }
            self.imageView.accessibilityLabel = self.viewModel?.item.title
            self.imageView.image = self.viewModel?.image
        }

        viewModel.showLikeStatus = { [weak self] in
            self?.setLikeStatus()
        }

        setLikeStatus()
        imageView.image = nil
        viewModel.getImage()
        setupView()
    }

    @objc
    private func saveImage() {
        viewModel?.saveImage()
    }

    @objc
    private func shareImage() {
        viewModel?.shareImage()
    }

    @objc
    private func favouriteImage() {
        viewModel?.favouriteImage()
    }

    private func setLikeStatus() {
        let favourite = viewModel!.isFavourite
        let imageName = favourite ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.accessibilityLabel = favourite ? "Liked" : "Like"
        if favourite {
            likeButton.accessibilityTraits.insert(.selected)
        } else {
            likeButton.accessibilityTraits.remove(.selected)
        }
    }

    private func setupView() {
        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        contentContainer.addSubview(imageView)
        contentContainer.addSubview(buttonStack)

        titleLabel.text = viewModel?.item.title
        contentContainer.addSubview(titleLabel)

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
