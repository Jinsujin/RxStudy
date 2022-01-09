//
//  ViewController.swift
//  RxTodo
//
//  Created by jsj on 2022/01/03.
//

import UIKit

class TodoViewController: UIViewController {
    
    private let viewModel = TodoViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "TODO"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func touchedAddButton(_ sender: Any) {
        let vc = AddTodoViewController()
        vc.completion = { [weak self] title in
            self?.viewModel.add(title)
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //
    func deleteAction(_ indexPath: IndexPath) {
        viewModel.delete(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func checkDoneAction(_ indexPath: IndexPath) {
        viewModel.checkDone(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}




// MARK:- TableView delegate & datasource
extension TodoViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        let data = viewModel.dataList[indexPath.row]
        cell.setData(data)
        return cell
    }
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion: @escaping (Bool) -> Void) in
            self.deleteAction(indexPath)
            completion(true)
        }
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion: @escaping (Bool) -> Void) in
            print("edit!!")
            completion(true)
        }
        edit.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal, title: "Done") { (action, view, completion: @escaping (Bool) -> Void) in
            self.checkDoneAction(indexPath)
            completion(true)
        }
        done.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [done])
    }
}
