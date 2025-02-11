import Combine
import Foundation

class Network {
    private var cancellables = Set<AnyCancellable>()
    private var latestLetters = [Letter]()
    
    func getStreamOfLetters() -> AnyPublisher<Letter, Never> {
        let currentTime = Int(Date().timeIntervalSince1970)
        guard let url = URL(string: "https://mobile-code-challenge-ece386891a1c.herokuapp.com/?since=\(currentTime)") else {
            fatalError("Invalid URL")
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .map { data in String(data: data, encoding: .utf8) ?? "" }
            .flatMap { rawData -> AnyPublisher<Letter, Never> in
                let lines = rawData.split(separator: "\n").map(String.init)
                return Publishers.Sequence(sequence: lines)
                    .compactMap { line -> Data? in
                        guard let data = line.data(using: .utf8) else {
                            print("Skipping invalid line: \(line)")
                            return nil
                        }
                        return data
                    }
                    .flatMap { data -> AnyPublisher<Letter, Never> in
                        Just(data)
                            .decode(type: Letter.self, decoder: JSONDecoder())
                            .catch { error -> Empty<Letter, Never> in
                                print("Decoding error for line, skipping: \(error)")
                                return Empty()
                            }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .catch { error -> Empty<Letter, Never> in
                print("Stream failed with error: \(error).")
                return Empty()
            }
            .eraseToAnyPublisher()
    }
    
}
