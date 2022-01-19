// swiftlint:disable todo
//  TODO+CoreDataClass.swift
//  
//
//  Created by 김호종 on 2022/01/10.
//
//

import Foundation
import UIKit
import CoreData

@objc(TODO)
public class TODO: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.dday = Date()
        self.writeDate = Date()
        
    }
    
    func attributedString(_ type: AttributeType, withSize size: CGFloat) -> NSAttributedString {
        var text = ""
        var attr: [NSAttributedString.Key: NSObject] = [:]
        
        switch type {
        case .title:
            attr[NSAttributedString.Key.foregroundColor] = UIColor.darkGray
            attr[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: size)
            guard let title = title else { fatalError("TitleError") }
            text = title
        case .message:
            break
        case .writeDate:
            break
        case .dday:
            attr[NSAttributedString.Key.foregroundColor] = UIColor.darkGray
            attr[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: size)
            
            guard let dDay = dday else { fatalError("DateError") }
            let today = Date()
            
            guard let day = Calendar.current.dateComponents([.day], from: dDay, to: today)
                    .day else { fatalError("DateError") }
            text = "\(day)"
        case .noti:
            break
        case .hide:
            break
        }
        
        return NSAttributedString(string: text, attributes: attr)
    }
    
    
}
// swiftlint:enable todo
