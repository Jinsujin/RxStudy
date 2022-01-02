//
//  ViewController.swift
//  RxTodo
//
//  Created by jsj on 2022/01/03.
//

import UIKit

class TodoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "TODO"
    }
}
