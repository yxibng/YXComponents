//
//  HorizontalCardCollectionLayout.swift
//  YXComponents
//
//  Created by yxibng on 2024/11/12.
// 参考： https://github.com/betzerra/EBCardCollectionViewLayout
// 参考： https://github.com/MaggiezzZ/CollectionCardPage

import UIKit

class HorizontalCardCollectionLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        var rect: CGRect = .zero
        rect.origin.y = 0
        rect.origin.x = proposedContentOffset.x
        rect.size = collectionView.bounds.size
        guard let layoutAttributes = layoutAttributesForElements(in: rect) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        func stopAtTheNearestItem() -> Int {
            let centerX = proposedContentOffset.x + rect.size.width / 2
            var minSpace = CGFLOAT_MAX
            var targetIndex = 0

            for layoutAttribute in layoutAttributes {
                if abs(minSpace) > abs(layoutAttribute.center.x - centerX) {
                    minSpace = layoutAttribute.center.x - centerX
                    targetIndex = layoutAttribute.indexPath.item
                }
            }
            return targetIndex
        }
        let pageWidth = itemSize.width + minimumLineSpacing
        var retVal = proposedContentOffset
        let velocityValue: CGFloat = velocity.x
        let realOffsetX = collectionView.contentOffset.x + collectionView.contentInset.left
        let rawPageValue = realOffsetX / pageWidth
        var nextPage: CGFloat = 0
        if velocityValue == 0.0 {
            let index = stopAtTheNearestItem()
            nextPage = CGFloat(index)
            if collectionView.allowsSelection {
                // 主动触发选中，此时可能scrollView 处于 Decelerating 状态，点击会停止滚动，但是选中事件不生效，手动触发一次
                collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(row: index, section: 0))
            }
        } else if velocityValue > 0.0 {
            nextPage = ceil(rawPageValue)
        } else {
            nextPage = floor(rawPageValue)
        }
        let itemTail = (collectionView.bounds.size.width - minimumLineSpacing * 2 - itemSize.width) / 2
        retVal.x = nextPage * pageWidth - (itemTail + minimumLineSpacing)
        if nextPage == 0 {
            retVal.x = collectionView.contentInset.left * -1
        }
        return retVal
    }
}
