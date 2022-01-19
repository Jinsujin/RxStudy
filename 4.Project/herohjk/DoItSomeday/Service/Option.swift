//
//  Option.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/10.
//

import Foundation

final class Option {
    static let share = Option()
    
    var dayDisplay: Bool {
        get { UserDefaults.standard.bool(forKey: "dayDisplay") }
        set(newVar) { UserDefaults.standard.set(newVar, forKey: "dayDisplay") }
    }
}
