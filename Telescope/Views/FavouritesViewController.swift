//
//  FavouritesViewController.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import UIKit

final class FavouritesViewController: UIViewController {

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, ImageItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ImageCollectionViewCell else { fatalError("Could not create new cell") }
        let viewModel = ImageCollectionViewCellViewModel(imageItem: item)
        cell.setViewModel(viewModel)
        return cell
    }

    private lazy var layout: UICollectionViewLayout = {
        let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fullWidth,
                heightDimension: .halfHeight))
        fullPhotoItem.contentInsets = contentInserts

        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fullWidth,
                heightDimension: .fullHeight),
            subitems: [fullPhotoItem])

        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()

    private lazy var collectionView = UICollectionView(frame: view.bounds,
                                                       collectionViewLayout: layout)

    private lazy var welcomeLabel: UILabel = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let globe = NSTextAttachment()
        globe.image = UIImage(systemName: "globe.americas.fill", withConfiguration: config)

        let imageString = NSMutableAttributedString(attachment: globe)
        let textString = NSAttributedString(string: " No favourited images")
        imageString.append(textString)

        let label = TSLabel()
        label.attributedText = imageString
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.sizeToFit()
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return label
    }()

    private let viewModel = FavouritesViewModel()
    private let contentInserts = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCallbacks()

        view.backgroundColor = .systemBackground
        welcomeLabel.isHidden = false
        collectionView.isHidden = true
        title = "Favourites"

        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

        reloadScreen()
        showHint(viewModel.photos.isEmpty)
    }

    private func setupCallbacks() {
        viewModel.reloadResults = { [weak self] in
            self?.reloadScreen()
        }

        viewModel.presentDetail = { [weak self] item in
            let imageViewer = ImageDetailViewController(imageItem: item)
            self?.navigationController?.pushViewController(imageViewer, animated: true)
        }

        viewModel.showHint = { [weak self] show in
            self?.showHint(show)

        }
    }

    private func reloadScreen() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageItem>()

        let items = viewModel.photos

        snapshot.appendSections([Section.images])
        snapshot.appendItems(items)

        dataSource.apply(snapshot)
    }

    private func showHint(_ show: Bool) {
        if show {
            collectionView.isHidden = true
            welcomeLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            welcomeLabel.isHidden = true
        }
    }
}

extension FavouritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.imageSelected(imageItem: item)
    }
}
