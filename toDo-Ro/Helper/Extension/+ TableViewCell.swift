//
//  + UITableViewCell.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

extension UITableViewCell {
    
    func configure(with task: Task) {
        var content = defaultContentConfiguration()
        
        content.text = task.name
        content.secondaryText = task.note
        
        contentConfiguration = content
    }
}
