//
//  ImageButtonsViewModel.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import Foundation
import UIKit
import KRProgressHUD

final class ImageButtonsViewModel: NSObject {
    var item: ImageItem?
    var image: UIImage?

    var setFavouriteStatus: (Bool) -> Void = {_ in}

    private let favourites = FavouriteStorage()
    var isFavourite: Bool {
        guard let item = item else {
            return false
        }

        return favourites.isFavourite(image: item)
    }

    override init() {
        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favouritesChanged),
                                               name: .favouritesChanged,
                                               object: nil)
    }

    func favouriteImage() {
        guard let item = item else { return }
        favourites.setFavourite(!isFavourite, image: item)
    }

    func shareImage() {
        guard let image = image else { return }
        let shareSheet = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { _, success, _, error in
            if !success || error != nil {
                KRProgressHUD.showError(withMessage: "Failed to share image")
            } else {
                KRProgressHUD.showSuccess()
            }
        }
        // TODO: present this properly
        UIApplication.shared.windows.first?.rootViewController?.present(shareSheet, animated: true, completion: nil)
    }

    func saveImage() {
        guard let image = image else { return }
        KRProgressHUD.show()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc
    private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            KRProgressHUD.showError(withMessage: "Failed to save image")
        } else {
            KRProgressHUD.showSuccess()
        }
    }

    @objc
    private func favouritesChanged() {
        setFavouriteStatus(isFavourite)
    }
}
