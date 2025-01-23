//
//  EventDesign1View.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 15-01-25.
//
import SwiftUI




struct EventDesign1View :View {
    @StateObject var viewModel = EventsViewModel()
    @State private var isPresentedDetailView = false
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
                                    RectangleItemScrollView(
                                        selectedItem: $viewModel.selectedComic,
                                        isPresentedDetailView: $isPresentedDetailView, itemsType: $itemsType,
                                        items: viewModel.comicsByEvent
                                    )
                                    
                                    
                                    
                                    
                                    NavigationLink("Ver Personajes") {
                                        
                                    }
                                    CircleItemScrollView(
                                        items: viewModel.charactersByEvent,
                                        isPresentedDetailView: $isPresentedDetailView
                                    )
                                    
                                    
                                    NavigationLink("Ver series") {
                                        ItemsByEventScrollView(
                                            viewModel: viewModel, 
                                            itemsType: $itemsType,
                                            groupedType: .series
                                        )
                                            .navigationTitle("Series")
                                    }
                                    RectangleItemScrollView(
                                        selectedItem: $viewModel.selectedSerie,
                                        isPresentedDetailView: $isPresentedDetailView, 
                                        itemsType: $itemsType,
                                        items: viewModel.seriesByEvent
                                    )
                                }
                            }
                        }
                    }
                    .navigationDestination(isPresented: $isPresentedDetailView) {
                        
                        ItemSelectedDetailView(
                            viewModel: viewModel,
                            itemsType: $itemsType
                        )
                        
                    }
                }
                .clipped()
                .navigationTitle("Evento")
                
            }
        }
        
    }
}

struct CircleItemScrollView: View {
    let items: [Character]
    @Binding var isPresentedDetailView: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 10) {
                ForEach(items) { item in
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 120)
                            
                            let securePath = item.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                            if let imageUrl = URL(string: "\(securePath).\(item.thumbnailExtension)") {
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
                        Text(item.displayText)
                            .lineLimit(2)
                            .frame(width: 120)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 120)
                    .onTapGesture {
                        
                    }
                }
                .padding(.horizontal, 10)
                .frame(height: 160)
            }
        }
    }
}
    
    struct RectangleItemScrollView<T: Identifiable>: View {
        @Binding var selectedItem: T?
        @Binding var isPresentedDetailView: Bool
        @Binding var itemsType: GroupType
        var items: [T]
        
        
        var body: some View {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(items) { item in
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.ultraThinMaterial)
                                    .frame(width: 120, height: 160)
                                
                                Group {
                                    if let comic = item as? Comic {
                                        let securePath = comic.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                                        if let imageUrl = URL(string: "\(securePath).\(comic.thumbnailExtension)") {
                                            AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 110, height: 150)
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    } else if let serie = item as? Serie {
                                        let securePath = serie.thumbnailPath.replacingOccurrences(of: "http://", with: "https://")
                                        if let imageUrl = URL(string: "\(securePath).\(serie.thumbnailExtension)") {
                                            AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 110, height: 150)
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                            }
                            Group {
                                if let comic = item as? Comic {
                                    Text(comic.title)
                                        .lineLimit(2)
                                        .frame(width: 120)
                                        .multilineTextAlignment(.center)
                                } else if let serie = item as? Serie {
                                    Text(serie.title)
                                        .lineLimit(2)
                                        .frame(width: 120)
                                        .multilineTextAlignment(.center)
                                }

                            }
                                                    }
                        .frame(width: 120)
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
    }

