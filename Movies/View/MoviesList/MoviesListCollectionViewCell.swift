//
//  MoviesCollectionViewCell.swift
//  Movies
//
//  Created by Marta on 8/3/24.
//

import UIKit
import Combine

class MoviesListCollectionViewCell: CollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var votesImageView: UIImageView!
    private var cancellables: Set<AnyCancellable> = []
    var didPressFavoriteButton:((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.votesImageView.image = UIImage(named: "popCorn")?.withRenderingMode(.alwaysTemplate)
        self.votesImageView.tintColor = .white
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

    func setupCell(with movie: Movie) {
        self.titleLabel.text = movie.title.uppercased()
        self.votesLabel.text = "\(movie.voteAverage) / \(movie.voteCount)"
        guard let imagePath = movie.imageBackdropPath else {
            loadPlaceHolderImage()
            return
        }
        favoriteButton.isSelected = movie.isFavorite
        ImageManager.shared.loadImage(from: "\(ImagesConstants.baseURl)\(imagePath)")
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print("Error: \(error)")
                            self?.loadPlaceHolderImage()
                        }
                    }, receiveValue: {[weak self] image in
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    })
                    .store(in: &cancellables)
    }

    private func loadPlaceHolderImage() {
        self.imageView.image = UIImage(named: "popCorn")?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = UIColor.white
        self.imageView.contentMode = .scaleAspectFit
    }

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let didPressFavoriteButton = didPressFavoriteButton else { return }
        didPressFavoriteButton(favoriteButton.isSelected)
    }
}
