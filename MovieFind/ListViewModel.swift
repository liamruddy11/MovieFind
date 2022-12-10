//
//  ListViewModel.swift
//  MovieFind
//
//  Created by Liam Ruddy on 12/3/22.
//

import Foundation
@MainActor

class ListViewModel: ObservableObject {

    
    struct Returned: Codable {
        var page: Int
        var results: [Movie]
        var total_pages: Int
        var total_results: Int
    }

    struct Movie: Codable, Identifiable{
        let id : Int

        var poster_path: String?
//        var genre_ids: genres
        var overview: String?
        var release_date: String?
        var title: String?

    }
    @Published var imageurl = ""
    var urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=29f86d4c9a2710dc0ff58b223dfc3f9b&language=en-US&page=1"
    
    @Published var release_date = ""
    @Published var title = "temp title"
    @Published var vote_average = 0.0
    @Published var overview = ""
    @Published var id = 550
    @Published var poster_path = ""
    
    @Published var movies: [Movie] = []
    
    
    var pageNumber = 1

    func getData() async {
        guard pageNumber != 0 else {return} // Don't access more pages if you have pageNumber == 0. You're done!
        urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=29f86d4c9a2710dc0ff58b223dfc3f9b&language=en-US&page=\(pageNumber)"
        print("We are accessing the URL \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Error: Could not create URL from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("JSON Error:  Could not decode returned JSON data")
                return
            }
            self.movies = self.movies + returned.results
            
            if returned.results.count < 20 {
                pageNumber = 0
            } else {
                pageNumber += 1
            }
        } catch {
            print("Error: Could not User URL at \(urlString) to get data and response")
        }
    }

}

