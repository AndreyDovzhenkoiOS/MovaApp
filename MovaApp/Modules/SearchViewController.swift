//
//  SearchViewController.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 110
    }

    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.placeholder = Localized.searchPlaceholder
        $0.searchBar.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        $0.searchBar.searchBarStyle = .prominent
    }

    private let tableView = UITableView(frame: .zero, style: .plain).thenUI {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(SearchResultTableViewCell.self)
        $0.rowHeight = Constants.cellHeight
        $0.isHidden = true
    }

    private let loadingView = LoadingView().thenUI {
        $0.color = Asset.green.color
        $0.lineWidth = 3
    }

    private var viewModel: SearchViewModelProtocol

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
        completionHandlers()
        configureLoadingView()
        configureSettingsUI()
        showTableView()
    }

    private func configureSettingsUI() {
        hideKeyboardWhenTappedAround()
        title = Localized.searchTitle
        view.backgroundColor = .white
    }

    private func configureSearchController() {
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    private func configureTableView() {
        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.withoutSafeArea { $0.pin() }
    }

    private func configureLoadingView() {
        view.addSubview(loadingView)
        loadingView.centerX().centerY(-30).height(50).aspectRatio()
    }

    private func showTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.tableView.isHidden = false
            self.tableView.reloadWithAnimationFadeInTop()
        }
    }

    private func setupLoadingView(isShow: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShow ?
                self.loadingView.startAnimating() :
                self.loadingView.stopAnimating()
        }
    }

    private func completionHandlers() {
        viewModel.completionHandler = { [weak self] in
            guard let self = self else {
                return
            }

            self.searchController.searchBar.text = nil
            self.setupLoadingView(isShow: false)

            switch $0 {
            case .update:
                self.tableView.reloadWithAnimationFadeInTop()
            case .error:
                self.present(on: UIAlertController.showAlertController(Localized.Alert.message))
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(for: indexPath) as SearchResultTableViewCell).then {
            $0.configure(with: viewModel.results?[indexPath.row],
                         loadingModel: viewModel.loadingModels[indexPath.row],
                         service: viewModel.searchService)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        setupLoadingView(isShow: true)
        viewModel.requestSerachImage(text: searchBar.text)
    }
}
