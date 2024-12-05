//
//  ViewController.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-04.
//

import UIKit

class ViewController: UIViewController {
       
    let pokemonLogo: UIImageView = {
        let pokemonLogo = UIImageView()
        pokemonLogo.image = UIImage(named: "pokemon8bitlogo")
        pokemonLogo.translatesAutoresizingMaskIntoConstraints = false
        return pokemonLogo
    }()

    var pokemonStorageButton: UIButton!
    var pokedexButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonStorageButton = createButton(withTitle: "Pokémon Storage")
        pokedexButton = createButton(withTitle: "Pokédex")
        
        pokemonStorageButton.addTarget(self, action: #selector(showPokemonStorage), for: .touchUpInside)
        pokedexButton.addTarget(self, action: #selector(showPokedex), for: .touchUpInside)
        
        
        view.addSubview(pokemonLogo)
        view.addSubview(pokemonStorageButton)
        view.addSubview(pokedexButton)

        setupLayout()
        
//        FetchCards()
    }
    
    @objc func showPokemonStorage() {
        let pokemonListVC = PokemonListViewController()
        pokemonListVC.source = .local
        navigationController?.pushViewController(pokemonListVC, animated: true)
    }

    @objc func showPokedex() {
        let pokemonListVC = PokemonListViewController()
        pokemonListVC.source = .api
        navigationController?.pushViewController(pokemonListVC, animated: true)
    }

    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            pokemonLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            pokemonLogo.widthAnchor.constraint(equalToConstant: 317),
            pokemonLogo.heightAnchor.constraint(equalTo: pokemonLogo.widthAnchor, multiplier: 1040/2640)
        ])
                
        setButtonConstraints(pokedexButton, topAnchor: pokemonLogo.bottomAnchor, topPadding: 75)
        setButtonConstraints(pokemonStorageButton, topAnchor: pokedexButton.bottomAnchor, topPadding: 20)
        
        personalizeButton(pokedexButton)
        personalizeButton(pokemonStorageButton)
    }
    
    func setButtonConstraints(_ button: UIButton, topAnchor: NSLayoutYAxisAnchor, topPadding: CGFloat) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func personalizeButton(_ myButton: UIButton) {
        myButton.layer.shadowColor = UIColor.black.cgColor
        myButton.layer.shadowOpacity = 0.2
        myButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        myButton.layer.shadowRadius = 4
    }

    fileprivate func FetchCards() {
        // Fetch Pokémon cards
        var i = 1
        APIManager.shared.fetchCards { cards in
            if let cards = cards {
                for card in cards { // Print the first 5 cards
                    print("\(i) Card Name: \(card.name), Image URL: \(card.images.small)")
                    i += 1
                }
            } else {
                print("Failed to fetch cards.")
            }
        }
    }
    
    
    
    
}

