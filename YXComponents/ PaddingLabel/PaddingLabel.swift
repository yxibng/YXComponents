//
//  PaddingLabel.swift
//  YXComponents
//
//  Created by yxibng on 2024/11/12.
//  参考：https://gist.github.com/konnnn/d43af3bd525bb4c58f5c29fb14575b0d

import UIKit

class PaddingLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .zero
    override func drawText(in rect: CGRect) {
        let insets = edgeInsets
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += edgeInsets.top + edgeInsets.bottom
        contentSize.width += edgeInsets.left + edgeInsets.right
        return contentSize
    }
}
