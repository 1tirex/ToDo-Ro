//
//  TaskListTableViewCell.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 14.01.23.
//

import UIKit

final class TaskListTableViewCell: UITableViewCell {
    
    var viewModel: TaskListCellViewModelProtocol! {
        didSet {
            name.text = viewModel.taskListName
            note.text = viewModel.noteText
            DispatchQueue.main.async { [unowned self] in
                ractagle.updateCirclePercentage(percent: viewModel.procent, count: viewModel.currentTasksCount)
            }
            print(viewModel.procent)
        }
    }
    
    private var name = UILabel()
    private var note = UILabel()
    private var ractagle = RatingView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(name, note, ractagle)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            name.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            
            note.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            note.leftAnchor.constraint(equalTo: name.leftAnchor),
            
            ractagle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            ractagle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ractagle.widthAnchor.constraint(equalToConstant: 50),
            ractagle.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
