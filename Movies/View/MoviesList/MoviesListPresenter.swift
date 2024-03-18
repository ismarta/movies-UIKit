//
//  MoviesListPresenter.swift
//  Movies
//
//  Created by Marta on 8/3/24.
//

import Foundation
import Combine

class MoviesListPresenter {
    private weak var ui: MoviesListUI?
    var movies: [Movie] = []
    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase
    let getTrendingMoviesWithFavoriteStatusUseCase: GetTrendingMoviesWithFavoriteStatusUseCase
    let saveFavoriteMovieUseCase: SaveFavoriteMovieUseCase
    let deleteFavoriteMovieUseCase: DeleteFavoriteMovieUseCase
    var cancellables: Set<AnyCancellable> = []
    
    init(ui: MoviesListUI, getTrendingMovies: GetTrendingMoviesUseCase, getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase, getTrendingMoviesWithFavoriteStatusUseCase: GetTrendingMoviesWithFavoriteStatusUseCase, saveFavoriteMovieUseCase: SaveFavoriteMovieUseCase, deleteFavoriteMovieUseCase: DeleteFavoriteMovieUseCase) {
        self.ui = ui
        self.getTrendingMoviesUseCase = getTrendingMovies
        self.getFavoriteMoviesUseCase = getFavoriteMoviesUseCase
        self.getTrendingMoviesWithFavoriteStatusUseCase = getTrendingMoviesWithFavoriteStatusUseCase
        self.saveFavoriteMovieUseCase = saveFavoriteMovieUseCase
        self.deleteFavoriteMovieUseCase = deleteFavoriteMovieUseCase
    }

    func uiLoaded() {
        ui?.showLoading()
        loadMovies()
    }

    func loadMovies() {
        let cancelable = getTrendingMoviesWithFavoriteStatusUseCase.execute().receive(on: DispatchQueue.main) .sink(receiveCompletion: {[weak self] completion in
            switch completion {
            case .finished:
                print("GetTrendingMoviesWithFavoriteStatusUseCase::success")
            case .failure(let error):
                print("GetTrendingMoviesWithFavoriteStatusUseCase::Error: \(error)")
                DispatchQueue.main.async {
                    self?.ui?.showErrorView()
                }
            }
            DispatchQueue.main.async {
                self?.ui?.hideLoading()
            }
        }, receiveValue: {[weak self] movies in
            self?.movies = movies
            DispatchQueue.main.async {
                if movies.isEmpty {
                    self?.ui?.showEmptyView()
                } else {
                    self?.ui?.showMoviesList(movies: movies)
                }
            }
        })
        cancelable.store(in: &cancellables)
    }

    func favoriteButtonPressed(for movie: Movie, isFavorite: Bool) {
        ui?.showLoading()
        if isFavorite {
            deleteFavoriteMovie(with: movie.identifier)
        } else {
            saveFavoriteMovie(movie)
        }
    }

    func movieDidSelected(movie: Movie) {
        ui?.showMovieDetail(movie: movie)
    }
    
    func didUpdateFavoriteState(for movie: Movie) {
        updateMovieList(with: movie.identifier, isFavorite: movie.isFavorite)
    }

    private func saveFavoriteMovie(_ movie: Movie) {
        saveFavoriteMovieUseCase.execute(movie: movie).sink(receiveCompletion:  {[weak self] completion in
            switch completion {
            case .finished:
                print("saveFavoriteUseCase::Success")
            case .failure(let error):
                print("saveFavoriteUseCase::Error: \(error)")
                DispatchQueue.main.async {
                    self?.ui?.hideLoading()
                }
            }
        }, receiveValue: { [weak self] saved in
            if saved {
                self?.updateMovieList(with: movie.identifier, isFavorite: true)
            }
            DispatchQueue.main.async {
                self?.ui?.hideLoading()
            }
        }).store(in: &cancellables)
    }

    private func deleteFavoriteMovie(with id: Int) {
        deleteFavoriteMovieUseCase.execute(idMovie: id).sink(receiveCompletion:  {[weak self] completion in
            switch completion {
            case .finished:
                print("deleteFavoriteMovieUseCase::Success")
            case .failure(let error):
                print("deleteFavoriteMovieUseCase::Error::\(error)")
                DispatchQueue.main.async {
                    self?.ui?.hideLoading()
                }
            }
        }, receiveValue: {[weak self] saved in
            if saved {
                self?.updateMovieList(with: id, isFavorite: false)
            }
            DispatchQueue.main.async {
                self?.ui?.hideLoading()
            }
        }).store(in: &cancellables)
    }

    private func updateMovieList(with identifier: Int, isFavorite: Bool) {
        guard let index = movies.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
        if movies[index].isFavorite != isFavorite {
            movies[index].isFavorite = isFavorite
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.ui?.updateDataSource(with: strongSelf.movies)
                strongSelf.ui?.reloadMovieAtIndex(index)
            }
        }
    }
}

protocol MoviesListUI: UI {
    func showMoviesList(movies: [Movie])
    func showMovieDetail(movie: Movie)
    func reloadMovieAtIndex(_ index: Int)
    func updateDataSource(with movies: [Movie])
    func showEmptyView()
    func showErrorView()
}
