//
//  ItemsByEventScrollView.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 20-01-25.
//

import SwiftUI

struct ItemsByEventScrollView: View {
    
        @ObservedObject var viewModel: EventsViewModel
        @State private var isPresentedDetailView = false 
        @Binding var itemsType: GroupType
        var groupedType: GroupType
    
       

        var body: some View {
            ScrollView {
                VStack {
                    imageView()
                    GridView
                }
            }
            .ignoresSafeArea(edges: [.top])
            .navigationDestination(isPresented: $isPresentedDetailView) {
                
                ItemSelectedDetailView(
                    viewModel: viewModel,
                    itemsType: $itemsType
                )
                    
            }
        }
    
    private func secureUrlText(path: String, typeImage: String) -> String {
        let securePath = path.replacingOccurrences(of: "http://", with: "https://")
        let safeUrlText = "\(securePath).\(typeImage)"
        return safeUrlText
    }

        var GridView: some View {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                switch groupedType {
                    
                case .comics:
                    ForEach(viewModel.comicsByEvent, id: \.id) { comic in
                        ZStack(alignment: .top) {
                            
                            let safeUrlText = secureUrlText(path: comic.thumbnailPath, typeImage: comic.thumbnailExtension)
                             
                            ImageAndTextView(text: comic.displayText, image: safeUrlText)
                                .onTapGesture {
                                    
                                    viewModel.selectedComic = comic
                                    viewModel.selectedCharacter = nil
                                    viewModel.selectedSerie = nil
                                    isPresentedDetailView = true
                                    itemsType = .comics
                                }
                            
                        }
                        .frame(width: 180, height: 220)
                    }
                    
                case .characters:
                    ForEach(viewModel.charactersByEvent, id: \.id) { character in
                        ZStack(alignment: .top) {
                            let safeUrlText = secureUrlText(path: character.thumbnailPath, typeImage: character.thumbnailExtension)
                             
                            ImageAndTextView(text: character.displayText, image: safeUrlText)
                                .onTapGesture {
                                    
                                    viewModel.selectedComic = nil
                                    viewModel.selectedCharacter = character
                                    viewModel.selectedSerie = nil
                                    isPresentedDetailView = true
                                    itemsType = .characters
                                }
                        }
                        .frame(width: 180, height: 220)
                    }
                    
                case .series:
                    ForEach(viewModel.seriesByEvent, id: \.id) { serie in
                        ZStack(alignment: .top) {
                            
                            let safeUrlText = secureUrlText(path: serie.thumbnailPath, typeImage: serie.thumbnailExtension)
                             
                            ImageAndTextView(text: serie.displayText, image: safeUrlText)
                                .onTapGesture {
                                    
                                    viewModel.selectedComic = nil
                                    viewModel.selectedCharacter = nil
                                    viewModel.selectedSerie = serie
                                    isPresentedDetailView = true
                                    itemsType = .series
                                }
                            
                        }
                        .frame(width: 180, height: 220)
                    }
                case .none:
                    EmptyView()
                }
            }
            .padding(.horizontal, 10)
        }
    
    @ViewBuilder
    func imageView() -> some View{
        
        if let safeEvent = viewModel.selectedEvent {
            let securePath = safeEvent.thumbnail.path.replacingOccurrences(of: "http://", with: "https://")
                if let imageUrl = URL(string: "\(securePath).\(String(safeEvent.thumbnail.extension))") {
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .global).minY
                        let isScrolling = minY > 0
                        AsyncImage(url: imageUrl) { image in
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
                                                image
                                                    .resizable()
                                                    .frame(width: 130, height: 170)
                                                    .scaledToFit()
                                                    Rectangle().stroke(lineWidth: 4)
                                            }
                                            .frame(width: 130, height: 170)
                                            .clipShape(Rectangle())
                                            
                                            Text(safeEvent.title).bold().font(.title)
                                            
                                        }
                                        .frame(maxWidth: .infinity)
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
