//
//  UIColor+.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/17.
//

import UIKit

extension UIColor {
    static func rgb(_ rgbValue: Int) -> UIColor {
        UIColor(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0
        )
    }
    
    static func rgb(red: Int, green: Int, blue: Int) -> UIColor {
        UIColor(
            red: CGFloat(Float(red) / 255.0),
            green: CGFloat(Float(green) / 255.0),
            blue: CGFloat(Float(blue) / 255.0),
            alpha: 1.0
        )
    }
}
