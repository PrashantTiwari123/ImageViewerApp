//
//  ImageGridViewModel.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import SwiftUI
import Combine

class ImageCollectionViewModel: ObservableObject {
    @Published var images: [UnsplashImageModel] = []
    @Published var isLoading = false
    @Published var searchText: String = "" {
        didSet {
            filterTypes()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private let perPage = 10
    
    func filterTypes() {
        if searchText.isEmpty {
            fetchImages(reset: false)
        } else {
            fetchImages(reset: true)
        }
    }
    
    func handleNextPageRequest(currentItem: UnsplashImageModel?) {
        guard let currentItem = currentItem else {
            fetchImages()
            return
        }
        
        let thresholdIndex = images.index(images.endIndex, offsetBy: -5)
        if images.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            fetchImages()
        }
    }
    
    func fetchImages(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        if reset {
            currentPage = 1
            images.removeAll()
        }
        
        let publisher: AnyPublisher<[UnsplashImageModel], Error> = searchText.isEmpty
        ? UnsplashImageService.fetchPhotos(page: currentPage, perPage: perPage)
        : UnsplashImageService.searchPhotos(query: searchText, page: currentPage, perPage: perPage)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] newImages in
                self?.images.append(contentsOf: newImages)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
}

