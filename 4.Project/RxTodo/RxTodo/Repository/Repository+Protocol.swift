//
//  Repository+Protocol.swift
//  RxTodo
//
//  Created by jsj on 2022/01/10.
//

import Foundation


protocol Repository {
    func add(_ title: String, completion: ((Bool) -> Void)?)
    func delete(at uid: UUID, completion: ((Bool) -> Void)?)
    func checkDone(at uid: UUID, completion: ((Todo?) -> Void)?)
    func fetchAll() -> [Todo]
}
