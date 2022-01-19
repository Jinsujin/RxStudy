//
//  UIFont+.swift
//  DoItSomeday
//
//  Created by 김호종 on 2022/01/17.
//

import UIKit

private let fontDefaultName = "AppleSDGothicNeo-"

private let fontDefaultSize = 12

enum FontType: String {
    case regular = "Regular"
    case bold = "Bold"
    case medium = "Medium"
    case light = "Light"
    case semibold = "SemiBold"
    case ultralight = "UltraLight"
    case thin = "Thin"
}

extension UIFont {
    static func base(_ type: FontType = .regular, _ size: Int = fontDefaultSize) -> UIFont {
        let fontSize = CGFloat(size)
        let fontName = fontDefaultName + type.rawValue
        
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
