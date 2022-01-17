//
//  Todo+CoreDataProperties.swift
//  RxTodo
//
//  Created by jsj on 2022/01/16.
//
//

import Foundation
import CoreData


extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var uid: String
    @NSManaged public var title: String
    @NSManaged public var isDone: Bool

}

extension TodoEntity : Identifiable {

}
