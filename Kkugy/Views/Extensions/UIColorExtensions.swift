//
//  UIColorExtensions.swift
//  Kkugy
//
//  Created by 신승재 on 4/18/24.
//

import Foundation
import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        // 랜덤 색상 생성
        let red = CGFloat(arc4random() % 256) / 255
        let green = CGFloat(arc4random() % 256) / 255
        let blue = CGFloat(arc4random() % 256) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
