//
//  ImageDetailViewController.swift
//  Telescope
//
//  Created by Rob Whitaker on 01/05/2022.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    private var item: ImageItem?
    private lazy var imageView: UIImageView = {
        let imageView = InteractiveImageView()
        imageView.accessibilityLabel = item?.title
        imageView.imageTapped = { [weak self] in
            self?.imageTapped()
        }
        return imageView
    }()

    private lazy var imageButtonViewModel = ImageButtonsViewModel()
    private lazy var imageButtons = ImageButtons(viewModel: imageButtonViewModel)
    private lazy var buttonStack = imageButtons.buttonStack

    private lazy var contentStack: UIStackView = {
        var descriptionLabels = [UILabel]()

        let titleLabel = TSLabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.text = item?.title

        descriptionLabels.append(titleLabel)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: item!.date)

        let dateLabel = TSLabel()
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.text = formattedDate

        descriptionLabels.append(dateLabel)

        if let description = item?.description {
            let descriptionLabel = TSLabel()
            descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
            descriptionLabel.text = description
            descriptionLabels.append(descriptionLabel)
        }

        if let center = item?.center {
            let centerLabel = TSLabel()
            centerLabel.font = UIFont.preferredFont(forTextStyle: .body)
            centerLabel.text = "NASA center: \(center)"
            descriptionLabels.append(centerLabel)
        }

        let contentStack = UIStackView(arrangedSubviews: descriptionLabels)
        contentStack.axis = .vertical
        contentStack.spacing = 4
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        return contentStack
    }()

    private var image: UIImage?

    convenience init(imageItem: ImageItem) {
        self.init()
        self.item = imageItem
        imageButtonViewModel.item = item
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { return }

        getImage(url: item.imageURL)

        navigationItem.title = item.title

        let contentView = UIView()
        let scrollView = UIScrollView()

        contentView.addSubview(imageView)
        view.backgroundColor = .systemBackground
        contentView.addSubview(contentStack)
        contentView.addSubview(buttonStack)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: contentStack.topAnchor),
            buttonStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0),

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc
    private func imageTapped() {
        guard let image = image else { return }
        let imageViewer = ImageViewer(image: image)
        imageViewer.frame = view.frame
        imageViewer.accessibilityLabel = item?.title
        view.addSubview(imageViewer)
        view.bringSubviewToFront(imageViewer)

        NSLayoutConstraint.activate([
            imageViewer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewer.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func getImage(url: String) {
        Task {
            let (image, _) = await FetchImage.fetchImage(url: url)
            guard let image = image else { return }

            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
                self?.imageButtonViewModel.image = image
                self?.image = image
            }
        }
    }
}
