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
        let storedCards = CoreDataManager.shared.fetchPokemonCards()
        pokemonCards = storedCards.map { Card(from: $0) }
        tableView.reloadData()
    }
    
    private func fetchAPICards() {
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
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func isCardStored(_ card: Card) -> Bool {
        let storedCards = CoreDataManager.shared.fetchPokemonCards()
        return storedCards.contains { $0.id == card.id }
    }
    
    @objc private func handleButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedCard = pokemonCards[index]
        
        if source == .api {
            // Add Pokémon card to local storage
            if !isCardStored(selectedCard) {
                
                let encoder = JSONEncoder()
                let weaknessesJSON: String?
                if let weaknesses = selectedCard.weaknesses,
                   let jsonData = try? encoder.encode(weaknesses) {
                    weaknessesJSON = String(data: jsonData, encoding: .utf8)
                } else {
                    weaknessesJSON = nil
                }
                
                CoreDataManager.shared.savePokemonCard(
                    id: selectedCard.id,
                    name: selectedCard.name,
                    imageURLSmall: selectedCard.images.small,
                    imageURLLarge: selectedCard.images.large,
                    hp: selectedCard.hp,
                    types: selectedCard.types,
                    evolvesFrom: selectedCard.evolvesFrom,
                    weaknesses: weaknessesJSON
                )
                showSuccessAlert(message: "\(selectedCard.name) was added to storage!")
                tableView.reloadData()
            }
        } else {
            // Remove Pokémon card from local storage
            CoreDataManager.shared.deletePokemonCard(id: selectedCard.id)
            pokemonCards.remove(at: index)
            tableView.reloadData()
            showSuccessAlert(message: "\(selectedCard.name) was removed from storage!")
        }
    }
}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let card = pokemonCards[indexPath.row]
        
        cell.textLabel?.text = card.name
        cell.imageView?.loadImage(from: card.images.small)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        button.tag = indexPath.row
        
        if source == .api {
            button.setTitle(isCardStored(card) ? "Stored" : "Add", for: .normal)
            button.isEnabled = !isCardStored(card)
        } else {
            button.setTitle("Remove", for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        cell.accessoryView = button
        
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
