//
//  FavouritesViewModel.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import Foundation

final class FavouritesViewModel {

    private(set) var photos = [ImageItem]()
    private let favourites = FavouriteStorage()

    var reloadResults: () -> Void = {}
    var presentDetail: (ImageItem) -> Void = {_ in}
    var showHint: (Bool) -> Void = {_ in}

    func imageSelected(imageItem: ImageItem) {
        presentDetail(imageItem)
    }

    init() {
        photos = favourites.allFavourites()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favouritesChanged),
                                               name: .favouritesChanged,
                                               object: nil)
    }

    @objc
    private func favouritesChanged() {
        photos = favourites.allFavourites()
        reloadResults()
        showHint(photos.isEmpty)
    }
}
