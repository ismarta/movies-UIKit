//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Marta on 6/3/24.
//

import UIKit                                                           
import Combine

protocol FavoriteStatusDelegate {
    func didUpdateFavoriteState(for movie: Movie)
}

class MoviesListViewController: BaseViewController  {
    @IBOutlet var adapter: MoviesListAdapter!
    var presenter: MoviesListPresenter?
    private var overlayUIView: OverlayUIView = OverlayUIView.createView()

    override func viewDidLoad() {
        super.viewDidLoad()
        customise()
        setupAdapter()
        presenter?.uiLoaded()
    }

    private func customise() {
        title = "MOVIES"
    }

    private func setupAdapter() {
        adapter?.registerCells()
        adapter?.didPressFavoriteButton = { [weak self] isSelected, movie in
            self?.presenter?.favoriteButtonPressed(for: movie, isFavorite: isSelected)
        }
        adapter?.didPressMovie = { [weak self] movie in
            self?.presenter?.movieDidSelected(movie: movie)
        }
    }

    private func showOverlay(overlay: OverlayUIView) {
        if overlay.superview == nil {
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.frame = view.bounds
        }
        view.addSubview(overlay)
    }
}

extension MoviesListViewController: MoviesListUI {
    func showMoviesList(movies: [Movie]) {
        adapter?.setup(movies: movies)
    }

    func showEmptyView() {
        showOverlay(overlay: overlayUIView.customiseEmptyView())
    }

    func showErrorView() {
        showOverlay(overlay: overlayUIView.customiseErrorView())
        overlayUIView.reloadButtonPressed = { [weak self] in
            self?.presenter?.loadMovies()
        }
    }

    func updateDataSource(with movies: [Movie]) {
        adapter.updateDataSource(with: movies)
    }

    func showMovieDetail(movie: Movie) {
        router?.showMovieDetailScreen(with: movie, favoriteStatusDelegate: self)
    }

    func reloadMovieAtIndex(_ index: Int) {
        adapter.reloadItemsAtIndex(index)
    }
}

extension MoviesListViewController: FavoriteStatusDelegate {
    func didUpdateFavoriteState(for movie: Movie) {
        presenter?.didUpdateFavoriteState(for: movie)
    }
}
