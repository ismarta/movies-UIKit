//
//  MoviesListPresenterTests.swift
//  MoviesTests
//
//  Created by Marta on 11/3/24.
//

import XCTest
@testable import Movies

final class MoviesListPresenterTests: XCTestCase {
    func testShowEmptyView() {
        //GIVEN
        let moviesListUI = MoviesListUIMock()
        let moviesListPresenter = getMoviesListPresenter(moviesListUI: moviesListUI, moviesResult: [], simulateError: false)
        let expectation = XCTestExpectation(description: "Se espera que la operación asíncrona se complete")
        //WHEN
        moviesListPresenter.uiLoaded()
        XCTWaiter().wait(for: [expectation], timeout: 3.0)
        //THEN
        XCTAssertTrue(moviesListUI.showEmptyViewCalled)
        XCTAssertFalse(moviesListUI.showMoviesListCalled)
        XCTAssertFalse(moviesListUI.showErrorViewCalled)
        XCTAssertTrue(moviesListUI.showLoadingCalled)
        XCTAssertTrue(moviesListUI.hideLoadingCalled)
    }

    func testShowMoviesListView() {
        //GIVEN
        let moviesListUI = MoviesListUIMock()
        let moviesResult = [MovieEntityMock.givenAMovie(identifier: 1),MovieEntityMock.givenAMovie(identifier: 2), MovieEntityMock.givenAMovie(identifier: 3)]
        let moviesListPresenter = getMoviesListPresenter(moviesListUI: moviesListUI, moviesResult: moviesResult, simulateError: false)
        let expectation = XCTestExpectation(description: "Se espera que la operación asíncrona se complete")
        //WHEN
        moviesListPresenter.uiLoaded()
        XCTWaiter().wait(for: [expectation], timeout: 3.0)
        //THEN
        XCTAssertFalse(moviesListUI.showEmptyViewCalled)
        XCTAssertTrue(moviesListUI.showMoviesListCalled)
        XCTAssertFalse(moviesListUI.showErrorViewCalled)
        XCTAssertTrue(moviesListUI.showLoadingCalled)
        XCTAssertTrue(moviesListUI.hideLoadingCalled)
        XCTAssertEqual(moviesListUI.movies.count, moviesResult.count)
    }

    func testShowErrorView() {
        //GIVEN
        let moviesListUI = MoviesListUIMock()
        let moviesListPresenter = getMoviesListPresenter(moviesListUI: moviesListUI, moviesResult: [], simulateError: true)
        let expectation = XCTestExpectation(description: "Se espera que la operación asíncrona se complete")
        //WHEN
        moviesListPresenter.uiLoaded()
        XCTWaiter().wait(for: [expectation], timeout: 3.0)
        //THEN
        XCTAssertFalse(moviesListUI.showEmptyViewCalled)
        XCTAssertFalse(moviesListUI.showMoviesListCalled)
        XCTAssertTrue(moviesListUI.showErrorViewCalled)
        XCTAssertTrue(moviesListUI.showLoadingCalled)
        XCTAssertTrue(moviesListUI.hideLoadingCalled)
    }

    private func getMoviesListPresenter(moviesListUI: MoviesListUI, moviesResult: [Movie] = [], simulateError: Bool = false) -> MoviesListPresenter {
        let moviesRepositoryMock = MoviesRepositoryMock(movies: moviesResult, simulateError: simulateError)
        let getTrendingMoviesUseCase: GetTrendingMoviesUseCase = GetTrendingMoviesUseCase(moviesRepository: moviesRepositoryMock)
        let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase = GetFavoriteMoviesUseCase(moviesRepository: moviesRepositoryMock)
        let getTrendingMoviesWithFavoriteStatusUseCase: GetTrendingMoviesWithFavoriteStatusUseCase = GetTrendingMoviesWithFavoriteStatusUseCase(moviesRepository: moviesRepositoryMock)
        let saveFavoriteMovieUseCase: SaveFavoriteMovieUseCase = SaveFavoriteMovieUseCase(moviesRepository: moviesRepositoryMock)
        let deleteFavoriteMovieUseCase: DeleteFavoriteMovieUseCase = DeleteFavoriteMovieUseCase(moviesRepository: moviesRepositoryMock)

        let moviesListPresenter = MoviesListPresenter(ui: moviesListUI, getTrendingMovies: getTrendingMoviesUseCase, getFavoriteMoviesUseCase: getFavoriteMoviesUseCase, getTrendingMoviesWithFavoriteStatusUseCase: getTrendingMoviesWithFavoriteStatusUseCase, saveFavoriteMovieUseCase: saveFavoriteMovieUseCase, deleteFavoriteMovieUseCase: deleteFavoriteMovieUseCase)
        return moviesListPresenter
    }
}
