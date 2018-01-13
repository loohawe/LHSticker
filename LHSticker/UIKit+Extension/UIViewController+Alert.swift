//
//  UIViewController+Alert.swift
//  LHSticker
//
//  Created by luhao on 13/01/2018.
//

import UIKit

extension UIViewController: LHFeatureCompatible {}

extension LHFeatures where Base: UIViewController {

    /// Alert view
    public func showAlert(view customView: UIView, viewModel aViewModel: StickerViewModel? = nil) {
        let alert = AlertViewController.getInstance()
        alert.customView = customView
        alert.customViewModel = aViewModel
        base.present(alert, animated: false, completion: nil)
    }

}
