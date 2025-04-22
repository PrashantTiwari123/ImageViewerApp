//
//  ContentView.swift
//  Instaview_Coding_Test
//
//  Created by Prashant Tiwari on 23/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ImageCollectionViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    private let cache = TemporaryImageCache()
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.images) { image in
                            VStack {
                                NavigationLink(destination: DetailView(image: image)) {
                                    VStack {
                                        if let url = URL(string: image.urls.thumb) {
                                            CachedAsyncImage(url: url, cache: cache)
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width * 0.42, height: 150)
                                                .clipped()
                                                .cornerRadius(12)
                                        }
                                        Text(image.user.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .onAppear {
                                viewModel.handleNextPageRequest(currentItem: image)
                            }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView().padding()
                        }
                    }
                    .searchable(text: $viewModel.searchText, prompt: "Search images...")
                    .padding()
                }
            }
            .navigationTitle("Image Viewer")
            .onAppear {
                if viewModel.images.isEmpty {
                    viewModel.fetchImages()
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        
    }
}

#Preview {
    ContentView()
}
