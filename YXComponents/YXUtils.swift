//
//  YXUtils.swift
//  YXComponents
//
//  Created by yxibng on 2024/8/29.
//

import UIKit
enum YXUtils {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.width
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return NSStringFromClass(self)
    }
}
