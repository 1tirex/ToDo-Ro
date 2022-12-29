//
//  +UIAlertController.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

extension UIAlertController {
    private enum AlertForWhat {
        case taskList, tasks
    }
    
    static func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
            
        UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
    }
    
    // MARK: - taskList
    func action(with taskList: TaskLists?, for alert: UIAlertController, delegate: UITextFieldDelegate? = nil, completion: @escaping (String) -> Void) {
                
        let saveAction = saveAction(
            for: .taskList,
            taskList: taskList,
            alert: alert) { newValue in
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addTextField { textField in
            textField.placeholder = "List Name"
            textField.delegate = delegate
            textField.text = taskList?.name
        }
    }
    
    // MARK: - task
    func action(with task: Task?,
                for alert: UIAlertController,
                delegate: UITextFieldDelegate? = nil,
                completion: @escaping (String, String) -> Void) {
        
        let saveAction = saveAction(for: .tasks, alert: alert) { newValue in
            if let note = alert.textFields?.last?.text, !note.isEmpty {
                completion(newValue, note)
            } else {
                completion(newValue, "")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        alert.addTextField { textField in
            textField.placeholder = "New task"
            textField.delegate = delegate
            textField.text = task?.name
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Note"
            textField.text = task?.note
        }
    }
    
    // MARK: - logicSave
    private func saveAction(for cases: AlertForWhat,
                            taskList: TaskLists? = nil,
                            task: Task? = nil,
                            alert: UIAlertController,
                            completion: @escaping (String) -> Void) -> UIAlertAction {
        
        var doneButton: String
        switch cases {
        case .taskList:
            doneButton = taskList == nil ? "Save" : "Update"
        case .tasks:
            doneButton = task == nil ? "Save" : "Update"
        }
        
       let save = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newValue = alert.textFields?.first?.text else { return }
            guard !newValue.isEmpty, newValue.count >= 1 else { return completion("no Value")}
            completion(newValue)
        }
        save.isEnabled = false
        return save
    }
}
