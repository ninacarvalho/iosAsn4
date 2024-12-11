import UIKit

class PokemonCardDetailViewController: UIViewController {

    var pokemonCard: Card?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []

    // Creating labels
    private func createLabel(
        textColor: UIColor = .darkGray,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        isTitle: Bool = false
    ) -> UILabel {
        let label = UILabel()
        label.font = isTitle ? UIFont.boldSystemFont(ofSize: 24) : UIFont.systemFont(ofSize: 16)
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // UI Elements
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var pokemonNameLabel = createLabel(isTitle: true)
    private lazy var hpLabel = createLabel()
    private lazy var typesLabel = createLabel()
    private lazy var evolvesFromLabel = createLabel()
    private lazy var weaknessesLabel = createLabel(numberOfLines: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        updateDetails()
    }

    private func setupSubviews() {
        // Add scrollView and contentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add UI elements to the contentView
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonNameLabel)
        contentView.addSubview(hpLabel)
        contentView.addSubview(typesLabel)
        contentView.addSubview(evolvesFromLabel)
        contentView.addSubview(weaknessesLabel)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        // Common ScrollView and ContentView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Portrait Constraints
        portraitConstraints = [
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pokemonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pokemonImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor),

            pokemonNameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            hpLabel.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 10),
            hpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            typesLabel.topAnchor.constraint(equalTo: hpLabel.bottomAnchor, constant: 10),
            typesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            evolvesFromLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 10),
            evolvesFromLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            evolvesFromLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            weaknessesLabel.topAnchor.constraint(equalTo: evolvesFromLabel.bottomAnchor, constant: 10),
            weaknessesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weaknessesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weaknessesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]

        // Landscape Constraints
        landscapeConstraints = [
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pokemonImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor),

            pokemonNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            hpLabel.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 10),
            hpLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
            hpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            typesLabel.topAnchor.constraint(equalTo: hpLabel.bottomAnchor, constant: 10),
            typesLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
            typesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            evolvesFromLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 10),
            evolvesFromLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
            evolvesFromLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            weaknessesLabel.topAnchor.constraint(equalTo: evolvesFromLabel.bottomAnchor, constant: 10),
            weaknessesLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20),
            weaknessesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weaknessesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]

        // Activate initial constraints
        updateConstraintsForOrientation()
    }
    
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateConstraintsForOrientation()
        })
    }

    private func updateConstraintsForOrientation() {
        if view.bounds.width > view.bounds.height {
            // Landscape mode
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            // Portrait mode
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }

    private func updateDetails() {
        guard let pokemonCard = pokemonCard else { return }
        pokemonNameLabel.text = pokemonCard.name
        hpLabel.text = "HP: \(pokemonCard.hp ?? "N/A")"
        typesLabel.text = "Types: \(pokemonCard.types?.joined(separator: ", ") ?? "N/A")"
        evolvesFromLabel.text = "Evolves From: \(pokemonCard.evolvesFrom ?? "N/A")"

        if let weaknesses = pokemonCard.weaknesses {
            let weaknessDescriptions = weaknesses.map { "\($0.type): \($0.value)" }
            weaknessesLabel.text = "Weaknesses: \(weaknessDescriptions.joined(separator: ", "))"
        } else {
            weaknessesLabel.text = "Weaknesses: N/A"
        }

        if let imageUrl = URL(string: pokemonCard.images.large) {
            loadImage(from: imageUrl)
        } else if let fallbackUrl = URL(string: pokemonCard.images.small) {
            loadImage(from: fallbackUrl)
        } else {
            pokemonImageView.image = UIImage(named: "placeholder")
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
