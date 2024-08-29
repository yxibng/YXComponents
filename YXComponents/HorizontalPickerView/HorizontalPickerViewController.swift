//
//  HorizontalPickerViewController.swift
//  YXComponents
//
//  Created by yxibng on 2024/8/29.
// 参考文章： https://medium.com/@bidhan.cse/horizontal-uipickerview-like-camera-in-swift-5-1-674616d90c12


import SnapKit
import UIKit

extension String {
    func sizeWithFont(_ font: UIFont) -> CGSize {
        let size = self.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity),
                                options: .usesLineFragmentOrigin,
                                attributes: [.font: font],
                                context: nil).size
        return size
    }
}

class HorizontalPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let titles = ["dumbell: 啞鈴",
                          "barbell: 槓鈴",
                          "bench: 平板凳",
                          "curl-bar: 彎曲bar",
                          "plate: 槓片",
                          "free weights: 槓啞鈴運動",
                          "kettle bell: 壺鈴",
                          "balance ball: 平衡球",
                          "medicine ball: 藥球"]

    private func pickerViewHeight() -> CGFloat {
        //这里的宽度，反转后，变成了 pickerView 的高度
        let height = titles[0].sizeWithFont(Layout.titleFont).height + 2 * Layout.padding
        return height
    }

    enum Layout {
        static let titleFont = UIFont.systemFont(ofSize: 17)
        static let padding: CGFloat = 10
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = Layout.titleFont
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180)) // 内容同步翻转
        label.text = titles[row]
        label.sizeToFit()
        label.backgroundColor = .red
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        //这里的 height 变成了横向滚动时 cell 的宽度
        let height = titles.map { $0.sizeWithFont(Layout.titleFont).width }.max()! + Layout.padding * 2
        return height
    }

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .gray
        pickerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2) // pickerView 需要做反转
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pickerView)
        
        /*pickerView 反转以后，长宽调转*/
        pickerView.snp.makeConstraints { make in
            make.width.equalTo(self.pickerViewHeight())
            make.center.equalTo(self.view)
            make.height.equalTo(self.view.snp.width).multipliedBy(1.5)
        }

        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
