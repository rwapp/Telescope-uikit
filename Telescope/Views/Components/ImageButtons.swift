//
//  ImageButtons.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import UIKit

final class ImageButtons {
    let viewModel: ImageButtonsViewModel

    init(viewModel: ImageButtonsViewModel) {
        self.viewModel = viewModel

        viewModel.setFavouriteStatus = { [weak self] liked in
            self?.setLikeStatus(liked)
        }

        setLikeStatus(viewModel.isFavourite)
    }

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

    private(set) lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView(arrangedSubviews: [likeButton, shareButton, saveButton])
        buttonStack.alignment = .leading
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        return buttonStack
    }()

    func setLikeStatus(_ liked: Bool) {
        let imageName = liked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.accessibilityLabel = liked ? "Liked" : "Like"
    }

    @objc
    func saveImage() {
        viewModel.saveImage()
    }

    @objc
    func shareImage() {
        viewModel.shareImage()
    }

    @objc
    func favouriteImage() {
        viewModel.favouriteImage()
    }
}
