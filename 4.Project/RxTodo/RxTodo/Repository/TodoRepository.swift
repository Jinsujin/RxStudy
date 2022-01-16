//
//  Data.swift
//  RxTodo
//
//  Created by jsj on 2022/01/10.
//

import Foundation


class TodoRepository: Repository {

    static let shared = TodoRepository()
    private init() {}
    
    var dataList: [Todo] = []

    func add(_ title: String, completion: ((Todo?) -> Void)?) {
        let data = Todo(title)
        self.dataList.append(data)
        completion?(data)
    }
    
    func delete(at uid: UUID, completion: ((Bool) -> Void)?) {
        guard let findIdx = dataList.firstIndex(where: { $0.uid == uid }) else {
            completion?(false)
            return
        }
        dataList.remove(at: findIdx)
        completion?(true)
    }
    
    func checkDone(at uid: UUID, completion: ((Todo?) -> Void)?) {
        guard var findData = dataList.first(where: { $0.uid == uid }),
              let idx = dataList.firstIndex(where: { $0.uid == uid }) else {
            completion?(nil)
            return
        }
        
        findData.toggleDone()
        self.dataList[idx] = findData
        completion?(findData)
    }
    
    func fetchAll() -> [Todo] {
        return self.dataList
    }
}


