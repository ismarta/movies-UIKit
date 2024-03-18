//
//  MoviesListAdapter.swift
//  Movies
//
//  Created by Marta on 8/3/24.
//

import Foundation
import UIKit

class MoviesListAdapter: NSObject {
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [Movie] = []
    var didPressFavoriteButton: ((Bool, Movie) -> Void)?
    var didPressMovie: ((Movie) -> Void)?

    func setup(movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }

    func updateDataSource(with movies: [Movie]) {
        self.movies = movies
    }

    func registerCells() {
        MoviesListCollectionViewCell.registerCell(collectionView: collectionView)
    }

    func reloadItemsAtIndex(_ index: Int){
        let indexPath = IndexPath(item: index, section: 0)
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension MoviesListAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListCollectionViewCell.reuseIdentifier(), for: indexPath) as! MoviesListCollectionViewCell
        cell.setupCell(with: movie)
        cell.didPressFavoriteButton = { [weak self] isSelected in
            guard let didPressFavoriteButton = self?.didPressFavoriteButton else { return }
            didPressFavoriteButton(isSelected, movie)
        }
        return cell
    }
}

extension MoviesListAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 400)
    }
}

extension MoviesListAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        guard let didPressMovie = didPressMovie else { return }
        didPressMovie(movie)
    }
}
