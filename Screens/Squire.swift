//
//  Squire.swift
//  playground
//
//  Created by Aravind Bilugu on 1/2/25.
//

import SwiftUI
import Combine

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let distance: String
}



struct Squire: View {
    let locations = [
        Location(name: "J.M. Ward's barbershop", address: "116 Holmes street Shakopee, MN 55379", distance: "5.5 mi"),
        Location(name: "Man Cave Barber Co.", address: "7884 Market Blvd. Chanhassen, MN 55317", distance: "8.6 mi"),
        Location(name: "The Top Shave Lounge", address: "12993 Ridgedale Dr Phoenix Salon, Suite 134...", distance: "13.8 mi"),
        Location(name: "Smooth SMP & Barberlounge", address: "3034 Lyndale Ave S Suite 24 Minneapolis, MN 55408", distance: "14.1 mi")
    ]
    
    
    
    var body: some View {
        var cancellables = Set<AnyCancellable>()
        VStack{
            Text("Choose a location")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            HStack{
                VStack{
                    Button(action: {
                        Task {
                            do {
                                let interactor = UserInteractor()
//                                var cancellables = Set<AnyCancellable>()

                                interactor.getUser()
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            print("Pipeline completed successfully")
                                        case .failure(let error):
                                            print("Pipeline failed with error: \(error)")
                                        }
                                    }, receiveValue: { users in
                                        print("Received users: \(users)")
                                    })
                                    .store(in: &cancellables)
                                }
                        }
                    }) {
                        Text("NEARBY")
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .cornerRadius(10)
                VStack{
                    Button(action: {
                        Task {
                            do {
//                                try await NetworkManager.shared.request(.getPlaceholder(x: ""), type: Re.self)
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }) {
                        Text("SEARCH")
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .cornerRadius(10)
                Spacer()
                
            }.padding()
            
        }
        HStack {
            
            List(locations) { location in
                ShopRow(location: location)
            }
        }
    }
}

struct ShopRow: View {
    
    let location: Location
    
    
    var body: some View {
        HStack {
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Spacer()
            VStack (alignment: .leading){
                Text(location.name)
                    .font(.headline)
                Text(location.address)
                    .font(.footnote)
                HStack{
                    Button(action: {
                        Task {
                            do {
//                                try await NetworkManager.shared.request(.getPlaceholder(x: ""), type: Re.self)
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }) {
                        Text("Get directions")
                            .foregroundColor(Color.blue)
                            .font(.footnote)
                    }
                    Spacer()
                    Text(location.distance)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}


#Preview {
    Squire()
}
