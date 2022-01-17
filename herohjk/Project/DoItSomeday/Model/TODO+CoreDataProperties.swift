// swiftlint:disable todo
//
//  TODO+CoreDataProperties.swift
//  
//
//  Created by 김호종 on 2022/01/10.
//
//

import UIKit
import CoreData

extension TODO {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<TODO> {
        NSFetchRequest<TODO>(entityName: "TODO")
    }

    @NSManaged public var title: String?
    @NSManaged public var message: String?
    @NSManaged public var writeDate: Date?
    @NSManaged public var dday: Date?
    @NSManaged public var noti: Bool
    @NSManaged public var hide: Bool
    
    public enum AttributeType {
        case title
        case message
        case writeDate
        case dday
        case noti
        case hide
    }
}
// swiftlint:enable todo
