//
//  ContentView.swift
//  MovieFind
//
//  Created by Liam Ruddy on 12/3/22.
//

import SwiftUI

struct ContentView: View {
    @State var movie_id: Int = 550
    @StateObject var listVM = ListViewModel()
    var body: some View {
        VStack {
            NavigationStack {
                Text("🍿 Movies In Theaters 🍿")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                    .font(.custom("Avenir Next Condensed", size: 60))
                    .background(.orange)
                List(listVM.movies)  { movie in
                    LazyVStack(alignment: .center) {
                        NavigationLink {
                            MovieDetailView(id: movie.id)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(movie.title ?? "")
                                        .font(.custom("Impact", size: 30))
                                        .font(.title)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.orange)
                                    
                                    Text(movie.release_date?.prefix(4) ?? "")
                                    
                                }
                                Spacer()
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(movie.poster_path ?? "")")) {
                                    poster in
                                    if let image = poster.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 80)
                                            .cornerRadius(20)
                                            .shadow(radius: 50, x: 10, y: 10)
                                            .minimumScaleFactor(0.5)
                                            .padding()
                                        
                                    } else if poster.error != nil {
                                        Image(systemName: "questionmark.square.dashed")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 40)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                                            }
                                    } else {
                                        Image(systemName: "rectangle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 40)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .listStyle(.plain)
                
                
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            listVM.pageNumber += 1
                            Task {
                                await listVM.getData()
                            }
                        } label: {
                            Text("More Movies")
                            Image(systemName: "square.and.arrow.down.fill")
                        }
                        .tint(.orange)
                        .buttonStyle(.borderedProminent)
                        .frame(width: 500)
                    }
                }
            }
        }
        .onAppear {
            Task {
                
                await listVM.getData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
