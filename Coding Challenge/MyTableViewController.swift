import UIKit
import Combine

class MyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var letters = [Letter]()
    private var cancellables = Set<AnyCancellable>()
    private var isFilterActive = false
    private var allLetters: [Letter] = [] // Stores all objects from the stream
    private var displayedLetters: [Letter] = [] // Stores objects filtered for display

    
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Friends Only", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func handleNewLetter(_ letter: Letter) {
        // Add the new letter to the full dataset
        allLetters.insert(letter, at: 0)
        
        // Add to displayed dataset based on the current filter
        if !isFilterActive || letter.areFriends {
            displayedLetters.insert(letter, at: 0)
        }
        
        // Limit to the latest 2,000 items
        if allLetters.count > 2000 { allLetters.removeLast() }
        if displayedLetters.count > 2000 { displayedLetters.removeLast() }
        
        // Reload the table view on the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func toggleFilter() {
        
        isFilterActive.toggle()
        filterButton.setTitle(isFilterActive ? "Show All" : "Show Friends Only", for: .normal)
        
        if isFilterActive {
            displayedLetters = allLetters.filter { $0.areFriends }
        } else {
            displayedLetters = allLetters
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }



    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayedLetters = allLetters
        fetchStreamData()
    }

//    private func setupUI() {
//        title = "Letters Stream"
//        view.backgroundColor = .white
//
//        view.addSubview(tableView)
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
//    }
    
    private func setupUI() {
        // Set up the view
        title = "Letters"
        view.backgroundColor = .white

        // Configure the table view
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Add the filter button
        view.addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(toggleFilter), for: .touchUpInside)

        // Add constraints
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }


//    private func fetchStreamData() {
//        let network = Network()
//
//        network.getStreamOfLetters()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    print("Streaming finished")
//                case .failure(let error):
//                    print("Failed to fetch data: \(error)")
//                }
//            }, receiveValue: { [weak self] letter in
//                self?.letters.insert(letter, at: 0)
//                if self?.letters.count ?? 0 > 2000 {
//                    self?.letters.removeLast()
//                }
//                self?.tableView.reloadData()
//            })
//            .store(in: &cancellables)
//    }
    
    private func fetchStreamData() {
        let network = Network()
        network.getStreamOfLetters()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Stream completed.")
                    case .failure(let error):
                        print("Stream failed with error: \(error)")
                    }
                },
                receiveValue: { [weak self] letter in
                    print("Received new letter: \(letter)")
                    self?.handleNewLetter(letter)
                }
            )
            .store(in: &cancellables) // Store cancellables to keep the stream alive
    }


    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return letters.count
        return displayedLetters.count
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let letter = letters[indexPath.row]
//        
//        let timestampString = letter.timestamp
//        
//        if let timestampMilliseconds = Double(timestampString) {
//            let timestampSeconds = timestampMilliseconds / 1000
//            let date = Date(timeIntervalSince1970: timestampSeconds)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let formattedDate = dateFormatter.string(from: date)
//            
//            cell.textLabel?.text = "from \(letter.from.name) to \(letter.to.name) at \(formattedDate)"
//        } else {
//            print("Invalid timestamp string")
//        }
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if displayedLetters.isEmpty {
            print("No letters to display.")
            return UITableViewCell() // Return a default cell or handle gracefully
        }
        
        let letter = displayedLetters[indexPath.row]
//        cell.textLabel?.text = "\(letter.from.name) ↔ \(letter.to.name)"
                let timestampString = letter.timestamp
        
                if let timestampMilliseconds = Double(timestampString) {
                    let timestampSeconds = timestampMilliseconds / 1000
                    let date = Date(timeIntervalSince1970: timestampSeconds)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: date)
        
                    cell.textLabel?.text = "from \(letter.from.name) to \(letter.to.name) at \(formattedDate)"
                } else {
                    print("Invalid timestamp string")
                }
        return cell
    }
}
