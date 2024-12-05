//
//  PokemonCardDetailViewController.swift
//  Asn4
//
//  Created by Marina Carvalho on 2024-12-05.
//

import UIKit

class PokemonCardDetailViewController: UIViewController {

    var pokemonCard: Card?
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupLayout(for: view.bounds.size)
        updateDetails()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.setupLayout(for: size)
        })
    }

    private func setupSubviews() {
        view.addSubview(pokemonImageView)
        view.addSubview(pokemonNameLabel)
    }

    private func setupLayout(for size: CGSize) {
        // Remove existing constraints
        view.removeConstraints(view.constraints)

        if size.width > size.height {
            // Horizontal layout: Image on the left, name on the right
            NSLayoutConstraint.activate([
                pokemonImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                pokemonImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                pokemonImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
                pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor),
                
                pokemonNameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
                pokemonNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                pokemonNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            // Vertical layout: Image on top, name below
            NSLayoutConstraint.activate([
                pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pokemonImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor),
                
                pokemonNameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
                pokemonNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                pokemonNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }
    }

    private func updateDetails() {
        guard let pokemonCard = pokemonCard else { return }
        pokemonNameLabel.text = pokemonCard.name
        if let imageUrl = URL(string: pokemonCard.images.large) {
            loadImage(from: imageUrl)
        }
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.pokemonImageView.image = image
                }
            }
        }
    }
}
