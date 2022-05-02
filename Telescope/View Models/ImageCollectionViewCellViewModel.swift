//
//  ImageCollectionViewCellViewModel.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import Foundation
import UIKit
import KRProgressHUD

final class ImageCollectionViewCellViewModel: NSObject {
    let item: ImageItem
    private(set) var image: UIImage?

    var showImage: () -> Void = {}

    init(imageItem: ImageItem) {
        self.item = imageItem
    }

    func getImage() {
        Task {
            let (image, _) = await FetchImage.fetchImage(url: item.imageURL)
            guard let image = image else { return }
            self.image = image

            DispatchQueue.main.async { [weak self] in
                self?.showImage()
            }
        }
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
}
