//
//  ImageCollectionViewCell.swift
//  Telescope
//
//  Created by Rob Whitaker on 26/04/2022.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, AXCustomContentProvider {

    static let reuseIdentifier = "ImageCollectionViewCell"

    private lazy var imageButtonViewModel = ImageButtonsViewModel()
    private lazy var imageButtons = ImageButtons(viewModel: imageButtonViewModel)
    private lazy var buttonStack = imageButtons.buttonStack
    private(set) lazy var imageView = CollectionImageView()
    private let titleLabel = TSLabel()
    private var viewModel: ImageCollectionViewCellViewModel?
    var accessibilityCustomContent = [AXCustomContent]()

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
        setupAxActions()
        setupCustomContent()
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

    private func setupAxActions() {

        let likeAction = UIAccessibilityCustomAction(name: "Like",
                                                     image: UIImage(systemName: "heart")) { [weak self] _ in
            self?.imageButtonViewModel.favouriteImage()
            return true
        }

        let shareAction = UIAccessibilityCustomAction(name: "Share",
                                                      image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            self?.imageButtonViewModel.shareImage()
            return true
        }

        let saveAction = UIAccessibilityCustomAction(name: "Save",
                                                     image: UIImage(systemName: "square.and.arrow.down")) { [weak self] _ in
            self?.imageButtonViewModel.saveImage()
            return true
        }

        accessibilityCustomActions = [likeAction, shareAction, saveAction]
    }

    private func setupCustomContent() {
        var customContent = [AXCustomContent]()

        if let date = viewModel?.item.dateString {
            let dateContent = AXCustomContent(label: "Date", value: date)
            customContent.append(dateContent)
        }

        if let description = viewModel?.item.description {
            let descriptionContent = AXCustomContent(label: "Description", value: description)
            customContent.append(descriptionContent)
        }

        if let center = viewModel?.item.center {
            let descriptionContent = AXCustomContent(label: "NASA center", value: center)
            customContent.append(descriptionContent)
        }

        accessibilityCustomContent = customContent
    }
}
