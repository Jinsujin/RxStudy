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
            .init( "스파게티 재로 사기"),
            .init("RxSwift 공부"),
            .init("건강검진"),
            .init("이불 빨래"),
            .init("화분 물주기")
        ]
        return list
    }
    
    /// 할일 생성
    func add(_ title: String) {
        let newData = Todo(title)
        self.dataList.append(newData)
    }
    
    /// 할일 삭제
    func delete(at index: Int) {
        self.dataList.remove(at: index)
    }
    
    func checkDone(at index: Int) {
        var originData = self.dataList[index]
        originData.toggleDone()
        self.dataList[index] = originData
    }
}
