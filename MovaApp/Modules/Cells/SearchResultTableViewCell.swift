//
//  SearchResultTableViewCell.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {
    private var loadingModel: LoadingModel?

    private let containerView = UIView().thenUI {
        $0.layer.cornerRadius = 10
        $0.layer.setupShadow(radius: 4, opacity: 0.4, height: 2)
        $0.backgroundColor = Asset.ligthGrey.color
    }

    private let mainImageView = UIImageView().thenUI {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }

    private let titleLabel = UILabel().prepareForAutoLayout()

    private let descriptionLabel = UILabel().thenUI {
        $0.numberOfLines = 0
    }

    private let loadingView = LoadingView().thenUI {
        $0.color = Asset.green.color
        $0.lineWidth = 3
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureContainerView()
        configureMainImageView()
        configureTitleLabel()
        configureDescriptionLabel()
        configureLoadingView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        setupLoadingView(isShow: false)
    }

    func configure(with model: SearchResultEntity?, loadingModel: LoadingModel, service: SearchServiceProtocol) {
        self.loadingModel = loadingModel
        setupLoadingView(isShow: true)

        titleLabel.text = model?.text
        descriptionLabel.text = model?.descriptions

        if let urlString = model?.url, let url = URL(string: urlString) {
            service.getImage(url) { [weak self] in
                self?.setupLoadingView(isShow: false)
                self?.mainImageView.image = $0
            }
        }
    }

    private func configureContainerView() {
        addSubview(containerView)
        containerView.centerX(7).top().bottom(10).right(30)
    }

    private func configureMainImageView() {
        containerView.addSubview(mainImageView)
        mainImageView.left(-25).top(12).bottom(12).width(75)
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.top(10).right().height(20)
        titleLabel.leadingAnchor ~ mainImageView.trailingAnchor + 20
    }

    private func configureDescriptionLabel() {
        containerView.addSubview(descriptionLabel)
        descriptionLabel.bottom(8)
        descriptionLabel.leadingAnchor ~ titleLabel.leadingAnchor
        descriptionLabel.trailingAnchor ~ titleLabel.trailingAnchor
        descriptionLabel.topAnchor ~ titleLabel.bottomAnchor + 5
    }

    private func configureLoadingView() {
        mainImageView.addSubview(loadingView)
        loadingView.centerX().centerY().height(30).aspectRatio()
    }

    private func setupLoadingView(isShow: Bool) {
        guard let loadingModel = loadingModel else {
            loadingView.stopAnimating()
            return
        }
        loadingModel.setLoading(isShow)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            loadingModel.isLoading ?
                self.loadingView.startAnimating() :
                self.loadingView.stopAnimating()
        }
    }
}
