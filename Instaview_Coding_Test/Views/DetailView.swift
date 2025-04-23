//
//  DetailView.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import SwiftUI
import Photos
import CoreData

struct DetailView: View {
    @State private var isFavorited: Bool = false
    let image: UnsplashImageModel
    private let cache = TemporaryImageCache()
    
    var body: some View {
        VStack(spacing: 16) {
            if let url = URL(string: image.urls.full) {
                CachedAsyncImage(url: url, cache: cache)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
            }
            
            HStack {
                AsyncImage(url: URL(string: image.user.profile_image.small)) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                }
                VStack(alignment: .leading) {
                    Text(image.user.name)
                    Text("@\(image.user.username)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Button(action: {
                    // TODO: worked on Download
                    // Apologies, I'm currently running short on time and won’t be able to capture this feature at the moment.
                }) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                }
                
                Button(action: {
                    if isFavorited {
                        removeImageFromFavorites(imageID: image.id)
                    } else {
                        saveImageToFavorites(image: image)
                    }
                    isFavorited.toggle()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .gray)
                        .font(.title2)
                }
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            isFavorited = isImageAlreadyFavorited(imageID: image.id)
        }
        .padding()
    }
    
    func isImageAlreadyFavorited(imageID: String) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
        fetchRequest.predicate = NSPredicate(format: "id == %@", imageID)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Fetch error: \(error)")
            return false
        }
    }
    
    func saveImageToFavorites(image: UnsplashImageModel) {
        let context = PersistenceController.shared.container.viewContext
        let favorite = FavoriteImage(context: context)
        favorite.id = image.id
        favorite.imageUrl = image.urls.small
        favorite.name = image.user.name
        favorite.userName = image.user.username
        
        do {
            try context.save()
            print("Image saved to favorites.")
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func removeImageFromFavorites(imageID: String) {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
        fetchRequest.predicate = NSPredicate(format: "id == %@", imageID)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Failed to remove: \(error)")
        }
    }
    
}



