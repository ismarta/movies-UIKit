//
//  MoviesListUIMock.swift
//  MoviesTests
//
//  Created by Marta on 11/3/24.
//

import Foundation
@testable import Movies

class MoviesListUIMock: MoviesListUI {
    var showMoviesListCalled = false
    var showEmptyViewCalled = false
    var showErrorViewCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var updateMoviesListCalled = false
    var moviesListIsEmpty = false
    var movies: [Movie] = []
    func showMoviesList(movies: [Movies.Movie]) {
        showMoviesListCalled = true
        self.movies = movies
    }

    func showEmptyView() {
        showEmptyViewCalled = true
    }

    func showErrorView() {
        showErrorViewCalled = true
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func updateMoviesList(movies: [Movies.Movie]) {
        updateMoviesListCalled = true
    }

    func showMovieDetail(movie: Movies.Movie) {}

    func reloadMovieAtIndex(_ index: Int) {}

    func updateDataSource(with movies: [Movies.Movie]) {}
}
