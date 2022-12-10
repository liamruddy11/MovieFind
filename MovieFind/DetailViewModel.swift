//
//  DetailViewModel.swift
//  MovieFind
//
//  Created by Liam Ruddy on 12/7/22.
//

import Foundation
@MainActor

class DetailViewModel: ObservableObject {
    struct Movie: Codable, Identifiable{
        let id : Int
        var poster_path: String?
        var overview: String?
        var release_date: String?
        var title: String?
        var vote_average: Double
        var runtime: Int
        var homepage: String?
    
    //    var genres: genres
    }
    
    struct genres: Codable {
        var id: Int
        var name: String
    }
    
    @Published var release_date = ""
    @Published var title = "temp title"
    @Published var vote_average = 0.0
    @Published var overview = ""
    @Published var poster_path = ""
    @Published var genre = ""
    @Published var id = 551
    @Published var imageURL = "https://image.tmdb.org/t/p/original"
    @Published var runTime = 0
    @Published var hours = 0
    @Published var mins = 0
    @Published var homePage = ""
    
    var urlString = ""
    
    
    func DetailgetData(id: Int) async {
        
        urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=29f86d4c9a2710dc0ff58b223dfc3f9b"
        guard let url = URL(string: urlString) else {
            print("Error: Could not create URL from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Movie.self, from: data) else {
                print("JSON Error:  Could not decode returned JSON data")
                return
            }
            self.id = returned.id
            self.title = returned.title ?? ""
            self.overview = returned.overview ?? ""
            self.imageURL = self.imageURL + (returned.poster_path ?? "")
            self.vote_average = returned.vote_average
            self.runTime = returned.runtime
            self.release_date = returned.release_date ?? ""
            self.homePage = returned.homepage ?? "https://www.fandango.com/02467_movietimes"
            
            
            
            hours = runTime/60
            mins = runTime%60
//            self.genre = returned.genres.name
           
        } catch {
            print("Error: Could not User URL at \(urlString) to get data and response")
        }
    }
    
    
    
    
    
}
