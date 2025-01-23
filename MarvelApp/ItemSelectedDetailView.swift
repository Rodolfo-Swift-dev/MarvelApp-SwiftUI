//
//  itemSelectedDetailView.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 20-01-25.
//

import SwiftUI

struct ItemSelectedDetailView: View {
    
    @ObservedObject var viewModel: EventsViewModel
    @Binding var itemsType: GroupType
    
    var body: some View {
        
            ScrollView {
                VStack {
                    imageView()
                    
                }
            }
            .ignoresSafeArea(edges: [.top])
            .onDisappear {
                
                viewModel.selectedComic = nil
                viewModel.selectedCharacter = nil
                viewModel.selectedSerie = nil
                
            }
            
    }
    
    @ViewBuilder
    func imageView() -> some View{
        
        if let safeEvent = viewModel.selectedEvent {
            let securePath = safeEvent.thumbnail.path.replacingOccurrences(of: "http://", with: "https://")
                if let safeImageUrl = URL(string: "\(securePath).\(String(safeEvent.thumbnail.extension))") {
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .global).minY
                        let isScrolling = minY > 0
                        AsyncImage(url: safeImageUrl) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: isScrolling ? 160 + minY : 160)
                                .clipped()
                                .offset(y: isScrolling ? -minY : 0)
                                .blur(radius: isScrolling ? minY / 80 : 0)
                                .scaleEffect( isScrolling ? 1 + minY / 2000 : 1)
                                .overlay() {
                                    
                                    GeometryReader { geo in
                                        VStack {
                                            ZStack {
                                                
                                                
                                                switch itemsType {
                                                    
                                                case .comics:
                                                    if let safeComic = viewModel.selectedComic {
                                                        let securePath = safeComic.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                                                        if let imageUrl = URL(string: "\(securePath).\(safeComic.thumbnailExtension)") {
                                                            AsyncImage(url: imageUrl) { image in
                                                                
                                                                image
                                                                    .resizable()
                                                                    .frame(width: 130, height: 170)
                                                                    .scaledToFit()
                                                                Rectangle().stroke(lineWidth: 4)
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                        }
                                                    }
                                                    
                                                case .characters:
                                                    if let safeCharacter = viewModel.selectedCharacter {
                                                        let securePath = safeCharacter.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                                                        if let imageUrl = URL(string: "\(securePath).\(safeCharacter.thumbnailExtension)") {
                                                            AsyncImage(url: imageUrl) { image in
                                                                
                                                                image
                                                                    .resizable()
                                                                    .frame(width: 130, height: 170)
                                                                    .scaledToFit()
                                                                Rectangle().stroke(lineWidth: 4)
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                        }
                                                    }
                                                case .series:
                                                    if let safeSerie = viewModel.selectedSerie {
                                                        let securePath = safeSerie.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                                                        if let imageUrl = URL(string: "\(securePath).\(safeSerie.thumbnailExtension)") {
                                                            AsyncImage(url: imageUrl) { image in
                                                                
                                                                image
                                                                    .resizable()
                                                                    .frame(width: 130, height: 170)
                                                                    .scaledToFit()
                                                                Rectangle().stroke(lineWidth: 4)
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                        }
                                                    }
                                                case .none:
                                                    EmptyView()
                                                    
                                                }
                                                
                                                
                                                
                                                
                                            }
                                            .frame(width: 130, height: 170)
                                            .clipShape(Rectangle())
                                            switch itemsType {
                                                
                                            case .comics:
                                                
                                                if let safeComic = viewModel.selectedComic {
                                                    Text(safeComic.title)
                                                        .bold()
                                                        .font(.headline)
                                                        .lineLimit(3)
                                                        .frame(width: 220)
                                                        .multilineTextAlignment(.center)
                                                }
                                                
                                                
                                            case .characters:
                                                if let safeCharacter = viewModel.selectedCharacter {
                                                    Text(safeCharacter.displayText)
                                                        .bold()
                                                        .font(.headline)
                                                        .lineLimit(3)
                                                        .frame(width: 220)
                                                        .multilineTextAlignment(.center)
                                                }
                                                
                                                
                                            case .series:
                                                if let safeSerie = viewModel.selectedSerie {
                                                    
                                                    Text(safeSerie.title)
                                                        .bold()
                                                        .font(.headline)
                                                        .lineLimit(3)
                                                        .frame(width: 220)
                                                        .multilineTextAlignment(.center)
                                                }
                                                
                                            case .none:
                                                EmptyView()
                                                
                                            }
                                            
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 250)
                                        .offset(y: geo.size.height - 85)
                                        .offset(y: isScrolling ? -minY : 0)
                                    }
                                }
                           
                        } placeholder: {
                            Text("Cargando imagen...")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 300)
                }
        }
        
        
    }
    
}
