//
//  TemporaryImageCache.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import UIKit
import SwiftUI
import Combine

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

class TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ url: URL) -> UIImage? {
        get { cache.object(forKey: url as NSURL) }
        set {
            if let image = newValue {
                cache.setObject(image, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.cache = cache
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        if let cachedImage = cache?[url] {
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache?[url] = $0 })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct CachedAsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let imageBuilder: (UIImage) -> Image
    
    init(url: URL,
         cache: ImageCache? = nil,
         image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
        self.imageBuilder = image
    }
    
    var body: some View {
        content
    }
    
    private var content: some View {
        Group {
            if let uiImage = loader.image {
                imageBuilder(uiImage)
                    .resizable()
            } else {
                ProgressView()
            }
        }
    }
}
