//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Nikita on 01.08.21.
//

import UIKit

class TaskViewController: UIViewController {
        
    @IBOutlet weak var taskTextField: UITextField!
    
    // MARK: Properties
    var delegate: TaskViewControllerDelegate!
    var currentTask: Task!
    var segueIdentifire = ""
    
    // MARK: Ovveride methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateData()
    }
}

// MARK: Private Methods
extension TaskViewController {
    private func updateUI() {
        guard let task = currentTask else { return }
        taskTextField.text = task.title
    }
    
    private func updateData() {
        guard let title = taskTextField.text, title != "" else { return }
        
        switch segueIdentifire {
        case "addTask":
            currentTask = Task(title: title, isDone: false)
            delegate.createTask(task: currentTask)
        default:
            delegate.updateTask(title: title)
        }
    }
}
