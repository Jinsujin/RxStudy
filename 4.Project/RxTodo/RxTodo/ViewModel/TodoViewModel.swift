//
//  TodoViewModel.swift
//  RxTodo
//
//  Created by jsj on 2022/01/03.
//

import Foundation


final class TodoViewModel {
    
    var dataList = [Todo]()
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        self.dataList = repository.fetchAll()
    }
    
    
    /// 할일 생성
    func add(_ title: String) {
//        let newData = Todo(title)
//        self.dataList.append(newData)
        self.repository.add(title) { isSuccess in
            print("할일 생성 성공")
        }
    }
    
    /// 할일 삭제
    func delete(at index: Int) {
//        self.dataList.remove(at: index)
        
        let todo = self.dataList[dataList.index(dataList.startIndex, offsetBy: index)]
        self.repository.delete(at: todo.uid) { isSucess in
            print("할일 삭제 성공")
        }
    }
    
    func checkDone(at index: Int, completion: @escaping () -> Void) {
        let todo = self.dataList[dataList.index(dataList.startIndex, offsetBy: index)]
        self.repository.checkDone(at: todo.uid) { todo in
            guard let updatedTodo = todo else { return }
            self.dataList[index] = updatedTodo
            completion()
        }
    }
}
