//
//  TODOViewModel.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/10.
//

import Foundation
import UIKit
import CoreData
import RxSwift

final class TODOViewModel {
    private var todos = [TODO]()
    
    private var todoSubject = BehaviorSubject<[TODO]>(value: [TODO]())
    var todoObservable: Observable<[TODO]> { todoSubject.asObservable() }
    
    private var sortSubject = BehaviorSubject<SortCategory>(value: .dDayDown)
    var sortObservable: Observable<SortCategory> { sortSubject.asObservable() }
    
    private var sortType: SortCategory = .dDayDown
    
    var count: Int { todos.count }
    
    private var disposeBag = DisposeBag()
    
    func get(at: Int) -> TODO? {
        if at >= 0, count > at {
            return todos[at]
        }
        
        return nil
    }
    
    func removeTODO(todo: TODO) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(todo)
            try? context.save()
            reloadTODO()
        }
    }
    
    func noti(_ todo: TODO, on: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            todo.setValue(on, forKey: "noti")
            try? context.save()
            reloadTODO()
        }
    }
    
    func sort(_ type: SortCategory) {
        sortSubject.onNext(type)
    }
    
    init() {
        sortSubject
            .subscribe(
                with: self,
                onNext: { owner, sort in
                    owner.sortType = sort
                    owner.reloadTODO()
                }
            )
            .disposed(by: disposeBag)
        
        reloadTODO()
    }
    
    func reloadTODO() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = TODO.fetchRequest()
            var key = ""
            var ascending = true
            
            switch sortType {
            case .dDayUp:
                key = "dday"
                ascending = false
            case .dDayDown:
                key = "dday"
            case .writeDateUp:
                key = "writeDate"
                ascending = false
            case .writeDateDown:
                key = "writeDate"
            case .nameUp:
                key = "title"
                ascending = false
            case .nameDown:
                key = "title"
            }
            
            let sort = NSSortDescriptor(key: key, ascending: ascending)
            fetchRequest.sortDescriptors = [sort]
            if let todos = try? context.fetch(fetchRequest) as [TODO] {
                self.todos = todos
                todoSubject.onNext(todos)
            }
        }
    }
}
