//
//  HorizontalCardCollectionViewController.swift
//  YXComponents
//
//  Created by yxibng on 2024/8/29.
// 参考： https://github.com/betzerra/EBCardCollectionViewLayout

import UIKit

class HorizontalCardCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCardCollection.identifier, for: indexPath) as! HorizontalCardCollection
        cell.titleLabel.text = String(indexPath.item)
        return cell
    }

    enum Layout {
        static let margin: CGFloat = 16
        static let height: CGFloat = 200
        static let lineSpacing: CGFloat = 8
        static let edgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        static let itemSize = CGSizeMake(YXUtils.screenWidth - margin * 2, height)
    }

    class HorizontalCardCollection: UICollectionViewCell {
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 50)
            return label
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .green
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.center.equalTo(self.contentView)
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = HorizontalCardCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Layout.lineSpacing
        layout.itemSize = Layout.itemSize // 默认尺寸
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(HorizontalCardCollection.self, forCellWithReuseIdentifier: HorizontalCardCollection.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .gray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast // 使滑动更加“紧凑”
        collectionView.contentInset = Layout.edgeInsets
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.height.equalTo(Layout.height)
            make.centerY.equalTo(self.view)
        }
    }
}

class HorizontalCardCollectionLayout: UICollectionViewFlowLayout {
    func flickVelocity() -> CGFloat {
        return 0.3
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        let pageWidth = itemSize.width + minimumLineSpacing
        var retVal = proposedContentOffset
        let velocityValue: CGFloat = velocity.x
        let realOffsetX = collectionView.contentOffset.x
        let rawPageValue = realOffsetX / pageWidth
        var nextPage: CGFloat = 0
        if velocityValue > 0.0 {
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
