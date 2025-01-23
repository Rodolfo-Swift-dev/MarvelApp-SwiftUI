//
//  EventsViewModel.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import Foundation

class EventsViewModel: ObservableObject {
    
    let apiService = ApiMarvelService()
    
    @Published var allEvents: [Event] = []
    @Published var comicsByEvent: [Comic] = []
    @Published var charactersByEvent: [Character] = []
    @Published var storiesByEvent: [Storie] = []
    @Published var seriesByEvent: [Serie] = []
    
    
    @Published var selectedEvent: Event? = nil
    @Published var selectedComic: Comic? = nil
    @Published var selectedCharacter: Character? = nil
    @Published var selectedSerie: Serie? = nil
    
    
    
    
    
    
    init() {
        Task {
            await fetchEvents()
        }
        
    }
    
    @MainActor
    func fetchEvents() async {
        do {
            let eventsResponse = try await apiService.fetchData(endpoint: .allEvents, responseType: APIEventResponse.self, parameter: ["limit": "13"])
            let validEvents = eventsResponse.data.results.filter { $0.thumbnail.path.hasPrefix("http") == true }

            // Debug: Log the number of valid countries
            print("Loaded events: \(validEvents.count)")

            self.allEvents = validEvents
        } catch {
            print("Failed to load events: \(error)")
        }
    }
    
    @MainActor
    func fetchComicsByEvent(eventId: Int) async {
        do {
            let comicsResponse = try await apiService.fetchData(endpoint: .comicsByEvent(eventId: eventId), responseType: APIComicResponse.self)
            let validComics = comicsResponse.data.results.filter { $0.thumbnail.path.hasPrefix("http") == true }

            // Debug: Log the number of valid countries
            print("Loaded comics: \(validComics.count)")

            self.comicsByEvent = validComics
        } catch {
            print("Failed to load comics: \(error)")
        }
    }
    
    @MainActor
    func fetchCharactersByEvent(eventId: Int) async {
        do {
            let characterResponse = try await apiService.fetchData(endpoint: .characters(eventId: eventId), responseType: APICharacterResponse.self)
            let validCharacters = characterResponse.data.results.filter { $0.thumbnail.path.hasPrefix("http") == true }

            // Debug: Log the number of valid countries
            print("Loaded characters: \(validCharacters.count)")

            self.charactersByEvent = validCharacters
        } catch {
            print("Failed to load characters: \(error)")
        }
    }
    
    @MainActor
    func fetchStoriesByEvent(eventId: Int) async {
        do {
            let storiesResponse = try await apiService.fetchData(endpoint: .stories(eventId: eventId), responseType: APIStoriesResponse.self)
           
            let validStories = storiesResponse.data.results.filter {
                guard let safeThumnail = $0.thumbnail else {
                    return false
                    }
                let comprobation = safeThumnail.path.hasPrefix("http") == true
                return comprobation
                }
                

            // Debug: Log the number of valid countries
            print("Loaded stories: \(validStories.count)")

            self.storiesByEvent = storiesResponse.data.results
        } catch {
            print("Failed to load characters: \(error)")
        }
    }
    
    @MainActor
    func fetchSeriesByEvent(eventId: Int) async {
        do {
            let seriesResponse = try await apiService.fetchData(endpoint: .series(eventId: eventId), responseType: APISeriesResponse.self)
            let validSeries = seriesResponse.data.results.filter {

                guard let safeThumnail = $0.thumbnail else {
                    return false
                }
                let comprobation = safeThumnail.path.hasPrefix("http") == true
                return comprobation
                }
            // Debug: Log the number of valid countries
            print("Loaded series: \(validSeries.count)")

            self.seriesByEvent = validSeries
        } catch {
            print("Failed to load series: \(error)")
        }
    }
    
}

