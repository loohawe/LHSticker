//
//  UIView+Placeholder.swift
//  Cosmos
//
//  Created by luhao on 29/12/2017.
//

import Foundation
import SnapKit

/// 给 UIView 设置 placeholder
extension UIView {

    public var isLoading: Bool {
        get {
            for i in 0..<subviews.count {
                if let _ = subviews[i] as? PlaceHolderView {
                    return true
                }
            }
            return false
        }

        set {
            if newValue {
                for i in 0..<subviews.count {
                    if let pView = subviews[i] as? PlaceHolderView {
                        bringSubview(toFront: pView)
                        return
                    }
                }

                let pView = PlaceHolderView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 50))
                self.addSubview(pView)
                pView.snp.makeConstraints({ make in
                    make.edges.equalToSuperview()
                })
//                let leadingCons = NSLayoutConstraint(item: pView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
//                leadingCons.priority = UILayoutPriority.init(750)
//                let trailingCons = NSLayoutConstraint(item: pView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
//                trailingCons.priority = UILayoutPriority.init(750)
//                let topCons = NSLayoutConstraint(item: pView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
//                topCons.priority = UILayoutPriority.init(750)
//                let bottomCons = NSLayoutConstraint(item: pView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
//                bottomCons.priority = UILayoutPriority.init(750)
//                self.addConstraints([topCons, trailingCons, bottomCons, leadingCons])

            } else {
                subviews.forEach({ item in
                    if let pView = item as? PlaceHolderView {
                        pView.removeFromSuperview()
                    }
                })
            }
        }
    }
}

private class PlaceHolderView: UIView {

    let label: UILabel = UILabel()
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    init() {
        super.init(frame: CGRect.zero)
        privateInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        subviews.forEach { subView in
            subView.removeFromSuperview()
        }

        let thisWidth = self.bounds.width
        let thisHeight = self.bounds.height

        if thisHeight >= 136 {
            addView(CGRect(x: 20, y: 20, width: 85, height: 85), loading: true)
            addView(CGRect(x: 127, y: 20, width: thisWidth - 127 - 20, height: 22))
            addView(CGRect(x: 127, y: 66, width: thisWidth - 127 - 70, height: 22))
        } else if thisHeight > 100 {
            addView(CGRect(x: 20, y: 20, width: thisWidth - 20 - 140, height: 22))
            addView(CGRect(x: 20 + 140, y: 66, width: thisWidth - 20 - 140, height: 22))
        } else {
            indicator.frame = CGRect(x: (thisWidth - 30) / 2, y: (thisHeight - 30) / 2, width: 30.0, height: 30.0)
            addSubview(indicator)
            indicator.startAnimating()
        }
    }

    private func privateInit() {
        self.backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        indicator.startAnimating()

        //label.text = "🏡"
        //addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
//        indicator.snp.makeConstraints { (make) in
//            make.top.equalTo(label.snp.bottom).offset(0)
//            make.centerX.equalTo(label).offset(2)
//            make.width.equalTo(30)
//            make.height.equalTo(30)
//        }

    }

    @discardableResult
    private func addView(_ frame: CGRect, loading: Bool = false) -> UIView {
        let aView = UIView(frame: frame)
        aView.backgroundColor = UIColor(red: 249.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
        if loading {
            indicator.frame = CGRect(x: (frame.size.width - 30) / 2, y: (frame.size.height - 30) / 2, width: 30.0, height: 30.0)
            aView.addSubview(indicator)
            indicator.startAnimating()
        }
        addSubview(aView)
        return aView
    }
}
