import UIKit
import RxSwift
import RxCocoa
import CoreData

class TodoViewController: UIViewController {
    var container: NSPersistentContainer!
    
    private lazy var viewModel = TodoViewModel(repository: TodoRepository.shared)
//    private lazy var viewModel = TodoViewModel(repository: CoreDataRepository.shared)
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
//        CoreDataRepository.shared.deleteAll()
                
        self.title = "TODO"
        tableView.delegate = self
        
        bindUI()
    }
    
    
    private func bindUI() {
        viewModel.dataListOb
            .bind(to: self.tableView.rx.items(cellIdentifier: "TodoCell", cellType: TodoCell.self)) { index, item, cell in
            cell.setData(item)
        }.disposed(by: disposeBag)
        
    }
    
    @IBAction func touchedAllDeleteBtn(_ sender: Any) {
        viewModel.clearAllMenus()
    }
    
    
    @IBAction func touchedAddButton(_ sender: Any) {
        let vc = AddTodoViewController()
        vc.completion = createAction
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func createAction(_ title: String) {
        self.viewModel.add(title)
    }
    
    
    private func deleteAction(_ indexPath: IndexPath) {
        viewModel.delete(at: indexPath.row) { }
    }
    
    private func checkDoneAction(_ indexPath: IndexPath) {
        viewModel.checkDone(at: indexPath.row) {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}




// MARK:- TableView delegate & datasource
extension TodoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion: @escaping (Bool) -> Void) in
            self.deleteAction(indexPath)
            completion(true)
        }
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion: @escaping (Bool) -> Void) in
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
