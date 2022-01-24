import Foundation
import RxSwift
import RxCocoa


final class TodoViewModel {
    private let repository: Repository
    
    var dataListOb = BehaviorRelay<[Todo]>(value: [])
    
    var dataList = [Todo]() {
        didSet {
            dataListOb.accept(dataList)
        }
    }
    
    
    init(repository: Repository) {
        self.repository = repository
        self.dataList = repository.fetchAll()
        dataListOb.accept(dataList)
    }
    
    
    /// 할일 생성
    func add(_ title: String) {
        self.repository.add(title) { todo in
            guard let createdTodo = todo else { return }
            self.dataList.append(createdTodo)
        }
    }
    
    /// 할일 삭제
    func delete(at index: Int, completion: @escaping() -> Void) {
        let todo = self.dataList[dataList.index(dataList.startIndex, offsetBy: index)]
        self.repository.delete(at: todo.uid) { isSucess in
            self.dataList.remove(at: index)
            completion()
        }
    }
    
    /// 할일 완료
    func checkDone(at index: Int, completion: @escaping () -> Void) {
        let todo = self.dataList[dataList.index(dataList.startIndex, offsetBy: index)]
        self.repository.checkDone(at: todo.uid) { todo in
            guard let updatedTodo = todo else { return }
            self.dataList[index] = updatedTodo
            completion()
        }
    }
    
    /// 전체 삭제
    func clearAllMenus() {
        self.dataList = []
    }
}
