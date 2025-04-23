//
//  UnsplashImageService.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import SwiftUI
import Combine

class UnsplashImageService {
    
    //    static let accessKey = "YOUR_UNSPLASH_ACCESS_KEY"
    static let accessKey = "DE4IE8BCIBZkc5BQaPf2jRqdH5B2Ji7L_HxsBmH2vXM"
    
    static func fetchPhotos(page: Int = 1, perPage: Int = 10) -> AnyPublisher<[UnsplashImageModel], Error> {
        var components = URLComponents(string: "https://api.unsplash.com/photos")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [UnsplashImageModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func searchPhotos(query: String, page: Int = 1, perPage: Int = 10) -> AnyPublisher<[UnsplashImageModel], Error> {
        var components = URLComponents(string: "https://api.unsplash.com/search/photos")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .eraseToAnyPublisher()
    }
}

struct SearchResponse: Decodable {
    let results: [UnsplashImageModel]
}
