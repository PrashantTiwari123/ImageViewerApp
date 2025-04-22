//
//  UnsplashImage.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import SwiftUI

struct UnsplashImageModel: Codable, Identifiable {
    let id: String
    let urls: URLS
    let user: User

    struct URLS: Codable {
        let small: String
        let full: String
        let regular: String
        let thumb: String
        let raw: String
    }

    struct User: Codable {
        let name: String
        let username: String
        let profile_image: ProfileImage

        struct ProfileImage: Codable {
            let small: String
        }
    }
}
