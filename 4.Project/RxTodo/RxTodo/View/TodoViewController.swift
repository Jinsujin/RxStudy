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
}




// MARK:- TableView delegate & datasource
extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.titleLabel.text = viewModel.dataList[indexPath.row].title
        return cell
    }
}
