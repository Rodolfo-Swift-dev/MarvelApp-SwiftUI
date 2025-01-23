//
//  ItemsByEventScrollView.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 20-01-25.
//

import SwiftUI

struct ItemsByEventScrollView: View {
    
        @ObservedObject var viewModel: EventsViewModel
        @State private var isPresentedDetailView = false // Para almacenar la URL seleccionada
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

        var GridView: some View {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                switch groupedType {
                    
                case .comics:
                    ForEach(viewModel.comicsByEvent, id: \.id) { comic in
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 180, height: 220)
                                .foregroundStyle(.ultraThinMaterial)
                            
                            let securePath = comic.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                            if let imageUrl = URL(string: "\(securePath).\(comic.thumbnailExtension)") {
                                AsyncImage(url: imageUrl) { image in
                                    VStack {
                                        image
                                            .resizable()
                                            .frame(width: 120, height: 160)
                                            .aspectRatio(contentMode: .fit)
                                        Text(comic.displayText)
                                            .lineLimit(2)
                                            .frame(width: 160)
                                            .multilineTextAlignment(.center)
                                    }
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 170, height: 210)
                                .onTapGesture {
                                    
                                    viewModel.selectedComic = comic
                                    isPresentedDetailView = true
                                    itemsType = .comics
                                }
                            }
                        }
                        .frame(width: 180, height: 220)
                    }
                    
                case .characters:
                    ForEach(viewModel.charactersByEvent, id: \.id) { character in
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 180, height: 220)
                                .foregroundStyle(.ultraThinMaterial)
                            
                            let securePath = character.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                            if let imageUrl = URL(string: "\(securePath).\(character.thumbnailExtension)") {
                                AsyncImage(url: imageUrl) { image in
                                    VStack {
                                        image
                                            .resizable()
                                            .frame(width: 120, height: 160)
                                            .aspectRatio(contentMode: .fit)
                                        Text(character.displayText)
                                            .lineLimit(2)
                                            .frame(width: 160)
                                            .multilineTextAlignment(.center)
                                    }
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 170, height: 210)
                                .onTapGesture {
                                    
                                    viewModel.selectedCharacter = character
                                    isPresentedDetailView = true
                                    itemsType = .characters
                                }
                            }
                        }
                        .frame(width: 180, height: 220)
                    }
                    
                case .series:
                    ForEach(viewModel.seriesByEvent, id: \.id) { serie in
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 180, height: 220)
                                .foregroundStyle(.ultraThinMaterial)
                            
                            let securePath = serie.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                            if let imageUrl = URL(string: "\(securePath).\(serie.thumbnailExtension)") {
                                AsyncImage(url: imageUrl) { image in
                                    VStack {
                                        image
                                            .resizable()
                                            .frame(width: 120, height: 160)
                                            .aspectRatio(contentMode: .fit)
                                        Text(serie.displayText)
                                            .lineLimit(2)
                                            .frame(width: 160)
                                            .multilineTextAlignment(.center)
                                    }
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 170, height: 210)
                                .onTapGesture {
                                    
                                    viewModel.selectedSerie = serie
                                    isPresentedDetailView = true
                                    itemsType = .series
                                   
                                }
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
