//
//  weward.swift
//  playground
//
//  Created by Aravind Bilugu on 1/2/25.
//

import SwiftUI

struct Leader: Identifiable {
    let id = UUID()
    let username: String
    let rank: String
    let score: String
}

struct Weward: View {
    let leaders = [
        Leader(username: "John", rank: "1", score: "300"),
        Leader(username: "Alice", rank: "2", score: "160"),
        Leader(username: "Michael", rank: "3", score: "148"),
        Leader(username: "Emma", rank: "4", score: "145")
    ]
    
    var body: some View {
        
        Text("Rankings")
            .font(.headline)
        Spacer()
        HStack{
            Spacer()
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("League")
                    .foregroundColor(Color.black)
            }
            Spacer()
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("Friends")
                    .foregroundColor(Color.black)
            }
            Spacer()
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("Championships")
                    .foregroundColor(Color.black)
            }
            Spacer()
        }
        
        Spacer()
        
        VStack{
            Spacer()
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text("Barefoot")
            Text("The top 20 will be promoted")
                .font(.footnote)
            Spacer()
            
            HStack{
                Spacer()
                VStack{
                    Text("13th")
                    Text("Position")
                        .font(.footnote)
                }
                .padding()
                .padding(.horizontal, 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 3)
                )
                .cornerRadius(10)
                Spacer()
                VStack{
                    Text("3 days")
                    Text("Time Left")
                        .font(.footnote)
                }
                .padding()
                .padding(.horizontal, 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 3)
                )
                .cornerRadius(10)
                Spacer()
                
            }
        }
        
        
        HStack {
            
            List(leaders) { leader in
                LeaderRow(leader: leader)
            }
        }
    }
}

struct LeaderRow: View {
    
    let leader: Leader
    
    
    var body: some View {
        HStack {
                
            Text(leader.rank)

            Text(leader.username)
                    .font(.headline)
                
            Spacer()
                
            Text(leader.score)
                .font(.headline)
            
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    Weward()
}

