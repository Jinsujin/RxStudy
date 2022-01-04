//
//  TodoViewModel.swift
//  RxTodo
//
//  Created by jsj on 2022/01/03.
//

import Foundation




final class TodoViewModel {
    
    var dataList: [Todo] = []
    
    init() {
        self.dataList = fetchDataList()
    }
    
    private func fetchDataList() -> [Todo] {
        let list: [Todo] = [
            .init(title: "스파게티 재로 사기", isDone: false),
            .init(title: "RxSwift 공부", isDone: false),
            .init(title: "건강검진", isDone: false),
            .init(title: "이불 빨래", isDone: false),
            .init(title: "화분 물주기", isDone: false)
        ]
        
        return list
    }
}
