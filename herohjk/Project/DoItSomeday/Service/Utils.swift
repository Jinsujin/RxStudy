//
//  Utils.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/10.
//

import Foundation
import UIKit
import CoreData

func dayBetweenDates(_ oldDate: Date, _ newDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: oldDate, to: newDate)
    return components.day ?? 0
}

func getDMinute(date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.minute], from: date, to: Date())
    
    return components.minute ?? 0
}

func getDHour(date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour], from: date, to: Date())
    
    return components.hour ?? 0
}

func getDDay(date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: date, to: Date())
    return components.day ?? 0
}

func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> Float {
    
    let newDateMinutes = newDate.timeIntervalSinceReferenceDate / 60
    let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate / 60
    
    return Float(newDateMinutes - oldDateMinutes)
}

func getTODOCount() -> Int {
    var count = 0
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
        let context = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TODO")
        count = (try? context.count(for: fetchRequest)) ?? 0
    }
    return count
}

func makeTODO(title: String, message: String, dday: Date, hide: Bool = false, noti: Bool = false) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
        let context = delegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "TODO", in: context) {
            let todo = NSManagedObject(entity: entity, insertInto: context)
            
            todo.setValue(title, forKey: "title")
            todo.setValue(message, forKey: "message")
            todo.setValue(Date(), forKey: "writeDate")
            todo.setValue(dday, forKey: "dday")
            todo.setValue(noti, forKey: "noti")
            todo.setValue(hide, forKey: "hide")
            
            try? context.save()
        }
    }
}
