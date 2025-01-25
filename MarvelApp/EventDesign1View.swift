//
//  EventDesign1View.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 15-01-25.
//
import SwiftUI




struct EventDesign1View :View {
    @StateObject var viewModel = EventsViewModel()
    @State private var isPresentedCollection = false
    @State private var groupedType: GroupType = .none
    @State private var itemsType: GroupType = .none
    
    
    
    var body: some View {
        NavigationStack {
            if viewModel.allEvents.isEmpty {
                Text("Cargando eventos...")
                    .foregroundColor(.gray)
            } else {
                GeometryReader { geometry in
                    ScrollView(.vertical) {
                        VStack(alignment: .center) {
                            Text(viewModel.selectedEvent?.title ?? "")
                                .bold()
                                .font(.title)
                                .padding(.top)
                            
                            // ScrollView de eventos
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.allEvents) { event in
                                        
                                        let securePath = event.thumbnail.path.replacingOccurrences(of: "http://", with: "https://")
                                        
                                        if let imageUrl = URL(string: "\(securePath).\(event.thumbnail.extension)") {
                                            AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 200, height: 300)
                                                    .scaledToFit()
                                                    .onAppear {
                                                        viewModel.selectedEvent = event
                                                        if let safeId = viewModel.selectedEvent?.id {
                                                            Task {
                                                                await viewModel.fetchComicsByEvent(eventId: safeId)
                                                                await viewModel.fetchCharactersByEvent(eventId: safeId)
                                                                await viewModel.fetchStoriesByEvent(eventId: safeId)
                                                                await viewModel.fetchSeriesByEvent(eventId: safeId)
                                                            }
                                                        }
                                                    }
                                                
                                            } placeholder: {
                                                Text("Cargando imagen...")
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(width: 200, height: 300)
                                            .overlay {
                                                Rectangle().stroke(lineWidth: 4)
                                            }
                                        }
                                    }
                                    .onChange(of: viewModel.selectedEvent) {
                                        viewModel.comicsByEvent = []
                                        viewModel.charactersByEvent = []
                                        viewModel.seriesByEvent = []
                                    }
                                }
                            }
                            .frame(width: 200, height: 300)
                            .scrollTargetBehavior(.paging)
                            
                            VStack(alignment: .center, spacing: 15) {
                                Spacer()
                                Text("Relacionado al evento")
                                    .font(.headline)
                                
                                VStack(alignment: .leading) {
                                    NavigationLink("Ver comics") {
                                        
                                        ItemsByEventScrollView(
                                            viewModel: viewModel,
                                            itemsType: $itemsType,
                                            groupedType: .comics
                                        )
                                        .navigationTitle("Comics")
                                        
                                    }
                                    GenericItemScrollView(
                                        selectedItem: $viewModel.selectedComic,
                                        isPresentedDetailView: $isPresentedCollection, itemsType: $itemsType,
                                        items: viewModel.comicsByEvent,
                                        isRectangle: true
                                    )
                                    
                                    NavigationLink("Ver Personajes") {
                                        
                                    }
                                    GenericItemScrollView(
                                        selectedItem: $viewModel.selectedCharacter,
                                        isPresentedDetailView: $isPresentedCollection,
                                        itemsType: $itemsType,
                                        items: viewModel.charactersByEvent,
                                        isRectangle: false
                                    )
                                    
                                    
                                    NavigationLink("Ver series") {
                                        ItemsByEventScrollView(
                                            viewModel: viewModel,
                                            itemsType: $itemsType,
                                            groupedType: .series
                                        )
                                        .navigationTitle("Series")
                                    }
                                    GenericItemScrollView(
                                        selectedItem: $viewModel.selectedSerie,
                                        isPresentedDetailView: $isPresentedCollection,
                                        itemsType: $itemsType,
                                        items: viewModel.seriesByEvent,
                                        isRectangle: true
                                    )
                                }
                            }
                        }
                    }
                    .navigationDestination(isPresented: $isPresentedCollection) {
                        
                        ItemSelectedDetailView(
                            viewModel: viewModel,
                            itemsType: $itemsType
                        )
                    }
                }
                .clipped()
                .navigationTitle("Eventos Marvel")
                
            }
        }
    }
}



struct GenericItemScrollView<T: Identifiable>: View {
    @Binding var selectedItem: T?
    @Binding var isPresentedDetailView: Bool
    @Binding var itemsType: GroupType
    var items: [T]
    var isRectangle: Bool
    
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 10) {
                ForEach(items) { item in
                    
                    Group {
                        if let comic = item as? Comic {
                            
                            let safeUrlText = secureUrlText(path: comic.thumbnailPath, typeImage: comic.thumbnailExtension)
                            
                            ImageAndTextView(
                                text: comic.displayText,
                                image: safeUrlText
                            )
                           
                            
                        } else if let serie = item as? Serie {
                            
                            let safeUrlText = secureUrlText(path: serie.thumbnailPath, typeImage: serie.thumbnailExtension)
                            
                            ImageAndTextView(
                                text: serie.displayText,
                                image: safeUrlText
                            )
                        } else if let character = item as? Character {
                            
                            let safeUrlText = secureUrlText(path: character.thumbnailPath, typeImage: character.thumbnailExtension)
                            
                            ImageAndTextView(
                                text: character.displayText,
                                image: safeUrlText,
                                isRectangle: isRectangle
                            )
                        }
                    }
                    .onTapGesture {
                        selectedItem = item
                        isPresentedDetailView = true
                        
                        if ((item as? Comic) != nil) {
                            itemsType = .comics
                        } else if ((selectedItem as? Character) != nil) {
                            itemsType = .characters
                        } else if ((selectedItem as? Serie) != nil) {
                            itemsType = .series
                        } else {
                            itemsType = .none
                        }
                        
                    }
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 240)
        }
    }
    
    private func secureUrlText(path: String, typeImage: String) -> String {
        let securePath = path.replacingOccurrences(of: "http://", with: "https://")
        let safeUrlText = "\(securePath).\(typeImage)"
        return safeUrlText
    }
}





struct ImageAndTextView: View {
    
    var text: String
    var image: String
    var isRectangle: Bool
    
    init(text: String, image: String, isRectangle: Bool = true ) {
        self.text = text
        self.image = image
        self.isRectangle = isRectangle
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                
                if isRectangle {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: 120, height: 160)
                    
                    if let imageUrl = URL(string: image) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .frame(width: 110, height: 150)
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                } else {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: 120)
                    
                    if let imageUrl = URL(string: image) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .frame(width: 110, height: 110)
                                .scaledToFit()
                                .clipShape(Circle())
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            Text(text)
                .lineLimit(2)
                .frame(width: 120)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120, height: isRectangle ? 240 : 160)
    }
}
