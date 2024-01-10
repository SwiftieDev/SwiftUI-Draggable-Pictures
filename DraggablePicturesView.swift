//
//  DraggablePicturesView.swift
//  DraggablePictures
//
//  Created by SwiftieDev on 13/12/2023.
//  MARK: SwiftieDev

import SwiftUI

struct DraggablePicturesView: View {
    @State private var images: [String] = ["image", "image1", "image2", "image3", "image4"]
    @State private var draggingItem: String?
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                let columns = Array(repeating: GridItem(spacing: 15), count: 2)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(images, id: \.self) { imageName in
                        GeometryReader { geometry in
                            let size = geometry.size
                            
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .draggable(imageName) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.clear)
                                        .frame(maxWidth: size.width, maxHeight: size.height)
                                        .onAppear {
                                            draggingItem = imageName
                                        }
                                }
                                .dropDestination(for: String.self) { items, location in
                                    draggingItem = nil
                                    return false
                                } isTargeted: { status in
                                    if let draggingItem = draggingItem, status, draggingItem != imageName {
                                        if let sourceIndex = images.firstIndex(of: draggingItem),
                                           let destinationIndex = images.firstIndex(of: imageName) {
                                            withAnimation(.easeInOut) {
                                                let sourceItem = images.remove(at: sourceIndex)
                                                images.insert(sourceItem, at: destinationIndex)
                                            }
                                        }
                                    }
                                }
                        }
                        .frame(height: 150)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Draggable Pictures")
        }
    }
}

#Preview {
    DraggablePicturesView()
}
