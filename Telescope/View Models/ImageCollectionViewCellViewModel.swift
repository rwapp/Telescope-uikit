//
//  ImageCollectionViewCellViewModel.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import Foundation
import UIKit

final class ImageCollectionViewCellViewModel {
    let item: ImageItem
    private(set) var image: UIImage?
    private let favourites = FavouriteStorage()

    var showImage: () -> Void = {}
    var showLikeStatus: () -> Void = {}

    init(imageItem: ImageItem) {
        self.item = imageItem

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favouritesChanged),
                                               name: .favouritesChanged,
                                               object: nil)
    }

    func getImage() {
        Task {
            let (image, _) = await FetchImage.fetchImage(url: item.imageURL)
            guard let image = image else { return }
            self.image = image

            await MainActor.run { [weak self] in
                self?.showImage()
            }
        }
    }

    @objc
    private func favouritesChanged() {
        showLikeStatus()
    }
}
