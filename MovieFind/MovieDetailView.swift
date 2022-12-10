//
//  MovieDetailView.swift
//  MovieFind
//
//  Created by Liam Ruddy on 12/7/22.
//

import SwiftUI

struct MovieDetailView: View {
    //    @StateObject var listVM = ListViewModel()
    @StateObject var DetailVM = DetailViewModel()
    //    var movie: Movie
    var id: Int
    var body: some View {
        VStack {
            ScrollView{
                posterImage
                    Text(DetailVM.title)
                        .bold()
                        .font(.custom("Avenir Next Condensed", size: 40))
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                
                Text(DetailVM.release_date.prefix(4))
                    .font(.caption)

                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Public Rating:")
                                .font(.custom("Avenir Next Condensed Bold", size: 20))
                            Text("\(DetailVM.vote_average, specifier: "%.2f")")
                            Text(DetailVM.vote_average > 7.0 ? "🔥" : "")
                        }
                        
                        HStack{
                            Text("Run Time:")
                                .font(.custom("Avenir Next Condensed Bold", size: 20))
                            Text("\(DetailVM.hours):\(DetailVM.mins < 10 ? "0": "")\(DetailVM.mins)")
                        }
                    }
                    .padding(.leading)
                    Spacer()
                    
                    Link(destination: URL(string: DetailVM.homePage) ?? URL(string: "https://www.fandango.com/02467_movietimes")!, label: {
                        VStack{
                            Image("popcorn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text("Get Tickets")
                        }
                    })
                    .padding(.trailing)
                }
                
                HStack{
                    Text("Synopsis:")
                        .frame(alignment: .leading)
                        .padding(.leading)
                        .font(.custom("Avenir Next Condensed Bold", size: 20))
                    Spacer()
                }
                
                Text(DetailVM.overview)
                    .padding(.leading)
                    .padding(.bottom)
                    .padding(.trailing)
                    .font(.custom("Avenir Next Condensed", size: 17))
                
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                await DetailVM.DetailgetData(id: id)
            }
        }
    }
}

extension MovieDetailView {
    var posterImage: some View {
        AsyncImage(url: URL(string: DetailVM.imageURL)) {
            poster in
            if let image = poster.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .cornerRadius(20)
                    .shadow(color: .orange, radius: 100, x: 10, y: 10)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                
            } else if poster.error != nil {
                Image("popcorn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
            } else {
                Image(systemName: "rectangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 300)
            }
        }
    }
}


struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(id: 550)
    }
}
