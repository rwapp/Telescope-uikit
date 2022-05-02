//
//  SearchViewModel.swift
//  Telescope
//
//  Created by Rob Whitaker on 26/04/2022.
//

import Foundation

final class SearchViewModel: NSObject {

    private(set) var photos = [ImageItem]()
    var reloadResults: () -> Void = {}
    var presentDetail: (ImageItem) -> Void = {_ in}
    var showHint: (Bool) -> Void = {_ in}

    func search(_ term: String?) {
        guard let term = term,
              term.count > 0,
              let searchService = SearchService(term: term) else {
            return
        }

        Task { [weak self] in
            let (results, error) = await searchService.start()

            if error != nil {
                print(String(describing: error?.localizedDescription))
                return
            }

            self?.photos = results?.collection.items
                .filter { !$0.links.isEmpty && !$0.data.isEmpty }
                .map {
                    ImageItem(imageURL: $0.links.first!.href,
                              title: $0.data.first!.title,
                              description: $0.data.first?.datumDescription,
                              center: $0.data.first?.center,
                              date: $0.data.first!.dateCreated)
                } ?? []

            DispatchQueue.main.async { [weak self] in
                self?.showHint(self?.photos.isEmpty ?? true)
                self?.reloadResults()
            }
        }
    }

    func imageSelected(imageItem: ImageItem) {
        presentDetail(imageItem)
    }
}
