//
//  MoviesListAssembler.swift
//  Movies
//
//  Created by Marta on 8/3/24.
//

import Foundation

protocol MoviesListAssembler: FavoritesAssembler {
    func resolve(router: AppRouter) -> MoviesListViewController
    func resolve(ui: MoviesListUI) -> MoviesListPresenter
    func resolve() -> GetTrendingMoviesUseCase
}

extension MoviesListAssembler {
    func resolve(router: AppRouter) -> MoviesListViewController {
        let moviesListViewController = MoviesListViewController(router: router, nibName: "MoviesListViewController", bundle: nil)
        moviesListViewController.presenter = resolve(ui: moviesListViewController)
        return moviesListViewController
    }

    func resolve(ui: MoviesListUI) -> MoviesListPresenter {
        MoviesListPresenter(ui: ui, getTrendingMovies: resolve(), getFavoriteMoviesUseCase: resolve(), getTrendingMoviesWithFavoriteStatusUseCase: resolve(), saveFavoriteMovieUseCase: resolve(), deleteFavoriteMovieUseCase: resolve())
    }

    func resolve() -> GetTrendingMoviesWithFavoriteStatusUseCase {
        GetTrendingMoviesWithFavoriteStatusUseCase(moviesRepository: resolve())
    }

    func resolve() -> GetTrendingMoviesUseCase {
        GetTrendingMoviesUseCase(moviesRepository: resolve())
    }

    func resolve() -> GetFavoriteMoviesUseCase {
        GetFavoriteMoviesUseCase(moviesRepository: resolve())
    }
}

class MoviesListAssemblerInjection: MoviesListAssembler {}
