//
//  PokemonListViewController.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-05.
////
//  PokemonListViewController.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-05.
//

import UIKit

enum DataSource {
    case local
    case api
}

class PokemonListViewController: UIViewController {
    
    var source: DataSource = .local
    var pokemonCards: [Card] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = source == .local ? "Pokémon Storage" : "Pokédex"
        
        setupTableView()
        fetchPokemonCards()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchPokemonCards() {
        switch source {
        case .local:
            fetchLocalCards()
        case .api:
            fetchAPICards()
        }
    }
    
    private func fetchLocalCards() {
        print("fetchLocalCards")
        
        let storedCards = CoreDataManager.shared.fetchPokemonCards()
        pokemonCards = storedCards.map { Card(from: $0) }
        tableView.reloadData()

    }
    
    private func fetchAPICards() {
        print("fetchAPICards")

        APIManager.shared.fetchCards { [weak self] cards in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let cards = cards {
                    self.pokemonCards = cards
                    self.tableView.reloadData()
                } else {
                    self.showErrorAlert(message: "Failed to fetch cards from API.")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pokemonCards.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
//        let card = pokemonCards[indexPath.row]
//        cell.textLabel?.text = card.name
//        cell.imageView?.loadImage(from: card.images.small)
//        return cell
//    }
//}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let card = pokemonCards[indexPath.row]
        cell.textLabel?.text = card.name
        cell.imageView?.loadImage(from: card.images.small)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCard = pokemonCards[indexPath.row]
        let detailVC = PokemonCardDetailViewController()
        detailVC.pokemonCard = selectedCard
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}



