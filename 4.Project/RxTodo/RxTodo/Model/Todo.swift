//
//  Todo.swift
//  RxTodo
//
//  Created by jsj on 2022/01/03.
//

import Foundation

struct Todo {
    let uid: UUID
    var title: String
    var isDone: Bool
    
    /// 할일 생성
    init(_ title: String) {
        self.title = title
        self.uid = UUID()
        self.isDone = false
    }
    
    /// Entity -> Todo 변환
    init?(uid: String, title: String, isDone: Bool) {
        guard let uuid = UUID(uuidString: uid) else {
            return nil
        }
        self.uid = uuid
        self.title = title
        self.isDone = isDone
    }
}





extension Todo {
    mutating func toggleDone() {
        self.isDone = !self.isDone
    }
}
