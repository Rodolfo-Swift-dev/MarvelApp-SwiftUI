//
//  EventsResponse.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import Foundation


enum GroupType {
    case comics
    case characters
    case series
    case none
}

struct APIEventResponse: Decodable {
    let code: Int
    let status: String
    let data: EventsResponse
}

struct EventsResponse: Decodable {
    let results: [Event]
}

struct Event: Codable, Hashable, Identifiable {
    var id: Int
    let title: String
    let description: String
    let thumbnail: Thumbnail
}



struct Thumbnail: Codable, Hashable {
    let path: String
    let `extension`: String
}


protocol ThumbnailRepresentable {
    var thumbnailPath: String { get }
    var thumbnailExtension: String { get }
    var displayText: String { get }
    var displayDescription: String { get }
}

struct APIComicResponse: Decodable {
    let code: Int
    let status: String
    let data: ComicsResponse
}

struct ComicsResponse: Decodable {
    let results: [Comic]
}

struct Comic: Codable, Hashable, Identifiable {
    var id: Int
    let title: String
    let description: String
    let thumbnail: Thumbnail
}

extension Comic: ThumbnailRepresentable {
    var thumbnailPath: String { thumbnail.path }
    var thumbnailExtension: String { thumbnail.extension }
    var displayText: String { title }
    var displayDescription: String { description }
}


struct APICharacterResponse: Decodable {
    let code: Int
    let status: String
    let data: CharacterResponse
}

struct CharacterResponse: Decodable {
    let results: [Character]
}

struct Character: Codable, Hashable, Identifiable {
    var id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}

extension Character: ThumbnailRepresentable {
    var thumbnailPath: String { thumbnail.path }
    var thumbnailExtension: String { thumbnail.extension }
    var displayText: String { name }
    var displayDescription: String { description }
}





struct APISeriesResponse: Decodable {
    let code: Int
    let status: String
    let data: SeriesResponse
}

struct SeriesResponse: Decodable {
    let results: [Serie]
}

struct Serie: Codable, Hashable, Identifiable {
    var id: Int
    let title: String
    let description: String?
    let thumbnail: Thumbnail?
}

extension Serie: ThumbnailRepresentable {
    var thumbnailPath: String { thumbnail?.path ?? "" }
    var thumbnailExtension: String { thumbnail?.extension ?? "" }
    var displayText: String { title }
    var displayDescription: String { description ?? "" }
}



struct APIStoriesResponse: Decodable {
    let code: Int
    let status: String
    let data: StoriesResponse
}

struct StoriesResponse: Decodable {
    let results: [Storie]
}

struct Storie: Codable, Hashable, Identifiable {
    var id: Int
    let title: String
    let description: String
    let thumbnail: Thumbnail?
}

extension Storie: ThumbnailRepresentable {
    var thumbnailPath: String { thumbnail?.path ?? "" }
    var thumbnailExtension: String { thumbnail?.extension ?? "" }
    var displayText: String { title }
    var displayDescription: String { description }
}
