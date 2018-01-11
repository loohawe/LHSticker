//
//  StickerView.swift
//  MGBrokerRoomDetail
//
//  Created by luhao on 27/12/2017.
//

import Foundation
import UIKit

/// 可以当 Sticker 的 UIView
public protocol StickerView {

    /// 开始获取数据
    func willFetchModel()

    /// 设置 Model, 在这里给页面填充数据
    func didFetchModelSuccess(_ success: Bool, model aModel: Any?)
}

extension StickerView where Self: UIView {

    /// 从 Xib 初始化自己
    public func loadFormNib(_ bundle: Bundle? = BundleHelper.resourcesBundle()) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let selfNib = UINib(nibName: "\(type(of: self))", bundle: bundle)
        if let selfView = selfNib.instantiate(withOwner: self, options: nil).first as? UIView {
            selfView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(selfView)
            let leadingCons = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: selfView, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let trailingCons = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: selfView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let topCons = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: selfView, attribute: .top, multiplier: 1.0, constant: 0.0)
            let bottomCons = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: selfView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            bottomCons.priority = UILayoutPriority(rawValue: 999)

            self.addConstraints([topCons, trailingCons, bottomCons, leadingCons])
        }
    }

    /// 开始获取数据
    public func willFetchModel() {
        setSubview(forView: self, isLoading: true)
    }

    /// 设置子 View 的 subview 为 Loading 状态
    public func setSubview(forView view: UIView, isLoading loading: Bool) {
        view.subviews.forEach { subItem in
            subItem.isLoading = loading
        }
    }
}

public class XibView: UIView {}
