//
//  TableViewCell.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 16.01.23.
//

import UIKit

final class TableViewCell: UITableViewCell {
    var viewModel: TaskListsCellProtocol! {
        didSet {
            var content = defaultContentConfiguration()
            content.text = viewModel.name
            content.secondaryText = viewModel.date
            contentConfiguration = content

            round?.updateCirclePercentage(percent: viewModel.roundData.0,
                                          count: viewModel.roundData.1)
        }
    }
    
    private var round: RatingView? = RatingView()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        round = nil
    }
}
    
// MARK: Extension
private extension TableViewCell {
    // MARK: Private Properties
    private func configure() {
        addSubviews(round ?? .init())
        setConstraints()
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraints() {
        round?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        round?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        round?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        round?.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
