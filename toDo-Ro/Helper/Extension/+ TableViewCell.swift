//
//  + UITableViewCell.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

extension UITableViewCell {
    
    func configure(with task: Task, index: IndexPath) {
        var content = defaultContentConfiguration()
        
//        if index.section == 0 {
            content.text = task.name
//        } else {
//            let attributeString = NSMutableAttributedString(string: task.name ?? "")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
//                                         value: 2,
//                                         range: NSRange(location: 0,
//                                                        length: attributeString.length)
//            )
//            content.attributedText = attributeString
//        }
        
        content.secondaryText = task.note
        contentConfiguration = content
    }
}
