//
//  TaskTableViewController.swift
//  ToDoList
//
//  Created by Nikita on 30.07.21.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    // MARK: Properties
    var list: ToDoList!
    var delegate: TaskTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = list.name
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        delegate.saveData(toDoList: list)
    }
}

// MARK: - Table view data source
extension TaskTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
       let task = list.tasks[indexPath.row]
            content.text = task.title
            content.secondaryText = task.isDone ? "выполнена" : ""
            content.image = UIImage(systemName: "clock")
        
        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var status = true
        
        let isDone = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            switch status {
            case false:
                self.getRowPostiton(indexPath: indexPath, isDone: status)
            default:
                self.getRowPostiton(indexPath: indexPath, isDone: status)
            }
            
            self.delegate.saveData(toDoList: self.list)
            self.tableView.reloadData()
        }
        
        switch list.tasks[indexPath.row].isDone {
        case false:
            isDone.image = UIImage(systemName: "checkmark.circle")
            isDone.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            status = true
        default:
            isDone.image = UIImage(systemName: "checkmark.circle.fill")
            isDone.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            status = false
        }
        
        return UISwipeActionsConfiguration(actions: [isDone])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.list.tasks.remove(at: indexPath.row)
            self.delegate.saveData(toDoList: self.list)
            self.tableView.reloadData()
        }
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - TaskViewControllerDelegate
extension TaskTableViewController: TaskViewControllerDelegate {
    func updateTask(title: String) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        list.tasks[indexPath.row].title = title
        delegate.saveData(toDoList: list)
        tableView.reloadData()
    }
    
    func createTask(task: Task) {
        list.tasks.insert(task, at: 0)
        delegate.saveData(toDoList: list)
        tableView.reloadData()
    }
}

// MARK: Navigation
extension TaskTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let taskVC = segue.destination as? TaskViewController else { return }
        
        switch segue.identifier {
        case "editingTask":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let task = list.tasks[indexPath.row]
            
            taskVC.currentTask = task
            taskVC.delegate = self
        default:
            taskVC.delegate = self
        }
        
        taskVC.segueIdentifire = identifier
    }
}

// MARK: Private Methods
extension TaskTableViewController {
    private func getRowPostiton(indexPath: IndexPath, isDone: Bool) {
        var element = list.tasks.remove(at: indexPath.row)
        
        element.isDone = isDone
        
        switch isDone {
        case false:
            list.tasks.insert(element, at: 0)
        default:
            list.tasks.append(element)
        }
    }
}
