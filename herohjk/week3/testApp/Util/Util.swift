//
//  Util.swift
//  testApp
//
//  Created by 김호종 on 2021/12/30.
//

import Foundation

// https://stackoverflow.com/a/28872601
func doubleToTimeString(_ timeDouble: Double) -> String {
    let timeInt = Int(timeDouble)
    let ms = Int((timeDouble.truncatingRemainder(dividingBy: 1)) * 100) // 2자리만 표기하므로 100을 곱함.
    
    let hours = (timeInt / 3_600) == 0 ? "" : String(format: "%0.2d:", timeInt / 3_600)
    let minutes = (timeInt / 60) % 60 == 0 ? "" : String(format: "%0.2d:", (timeInt / 60) % 60)
    let seconds = String(format: "%0.2d.%0.2d", timeInt % 60, ms)

    return hours + minutes + seconds
}
