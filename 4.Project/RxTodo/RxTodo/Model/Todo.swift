//
//  Todo.swift
//  RxTodo
//
//  Created by jsj on 2022/01/03.
//

import Foundation

struct Todo {
    let uid: UUID
    let title: String
    let isDone: Bool
    
    /// 할일 생성
    init(_ title: String) {
        self.title = title
        self.uid = UUID()
        self.isDone = false
    }
}
