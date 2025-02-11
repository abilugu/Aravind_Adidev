//
//  ContentView.swift
//  playground
//
//  Created by Aravind Bilugu on 1/2/25.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let username: String
    let messageText: String
    let timestamp: String
}

struct Snapchat: View {
    let messages = [
        Message(username: "John", messageText: "Received", timestamp: "12:45 PM"),
        Message(username: "Alice", messageText: "Called", timestamp: "11:30 AM"),
        Message(username: "Michael", messageText: "Opened", timestamp: "10:15 AM"),
        Message(username: "Emma", messageText: "Received", timestamp: "9:00 AM")
    ]
    
    var body: some View {
        
        Text("Chat")
            .font(.headline)
        Spacer()
        HStack{
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("All")
                    .foregroundColor(Color.black)
            }
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("Groups")
                    .foregroundColor(Color.black)
            }
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("Stories")
                    .foregroundColor(Color.black)
            }
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("Best Friends")
                    .foregroundColor(Color.black)
            }
            Button(action: {
                        print("Button pressed!")
            }) {
                Text("New")
                    .foregroundColor(Color.black)
            }
         
        }
        HStack {
            
            List(messages) { message in
                MessageRow(message: message)
            }
        }
    }
}

struct MessageRow: View {
    
    let message: Message
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {

                Text(message.username)
                    .font(.headline)
                HStack{
                    Text(message.messageText)
                        .font(.footnote)
                    
                    Text(message.timestamp)
                        .font(.footnote)
                }
            }
            
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    Snapchat()
}
