//
//  API.swift
//  playground
//
//  Created by Aravind Bilugu on 1/21/25.

import Combine
import Foundation


//import Combine
//
//protocol AnyInteractor {
//    func getUser() -> AnyPublisher<Any, Error>
//}
//
//class UserInteractor: AnyInteractor {
//    
//    func getUser() -> AnyPublisher<Any, Error> {
//        print("step1")
//        guard let url = URL(string: "https://mobile-code-challenge-ece386891a1c.herokuapp.com/?since=[timestamp_in_seconds]") else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//        print("step2")
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { output -> Any in
//                let jsonObject = try JSONSerialization.jsonObject(with: output.data, options: [])
//                return jsonObject
//            }
//            .eraseToAnyPublisher()
//    }
//}


struct User: Decodable {
//    let id: Int
    let name: String
//    let username: String
//    let email: String
}

// Define the protocol
protocol AnyInteractor {
    func getUser() -> AnyPublisher<[User], Error>
}

// Implement the interactor
class UserInteractor: AnyInteractor {
    func getUser() -> AnyPublisher<[User], Error> {
        print("Step 1: Starting the request")
        
        // Ensure URL is valid
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            print("Step 2: Invalid URL")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        print("Step 2: Valid URL, starting network request")
        
        // Perform the network request and decode the response
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .handleEvents(receiveSubscription: { _ in
                print("Step 3: Subscribed to pipeline")
            }, receiveOutput: { users in
                print("Step 4: Received \(users.count) users")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Step 5: Pipeline completed successfully")
                case .failure(let error):
                    print("Step 5: Pipeline failed with error: \(error)")
                }
            }, receiveCancel: {
                print("Step 6: Pipeline canceled")
            })
            .eraseToAnyPublisher()
    }
}


