//
//  AlertViewController.swift
//  LHSticker
//
//  Created by luhao on 13/01/2018.
//

import UIKit
import SnapKit

public class AlertViewController: UIViewController {

    // MARK: Public property
    public var customView: UIView!
    public var customViewModel: StickerViewModel? // 这个功能还没加上, 后续会加上
    public var customBackgroundImage: UIImage?
    public var backBlurAlpha: CGFloat = 0
    public var backBblackAlpha: CGFloat = 0.3

    // MARK: Private propertt
    private var contentView: UIView!
    @IBOutlet private weak var _backgroundView: UIView!
    @IBOutlet private weak var _visuaEffectView: UIVisualEffectView!
    @IBOutlet private weak var _backgroundImageView: UIImageView!

    public override func viewDidLoad() {
        super.viewDidLoad()

        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        _visuaEffectView.effect = blur

        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGes)

        _backgroundImageView.image = customBackgroundImage

        customView.sizeToFit()
        view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Background animation
        _visuaEffectView.alpha = 0
        _backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self._visuaEffectView.alpha = self.backBlurAlpha
            self._backgroundView.alpha = self.backBblackAlpha
        }

        /// Custom view animation
        customView.alpha = 0
        let originTrans = customView.transform
        let newTrans = originTrans.scaledBy(x: 0.7, y: 0.7)
        customView.transform = newTrans
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 25.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.customView.alpha = 1
            self.customView.transform = originTrans
        }, completion: { finish in

        })
    }

}

// MARK: - Public method
extension AlertViewController {

    public class func getInstance() -> AlertViewController {
        let alert = AlertViewController(nibName: "AlertViewController", bundle: BundleHelper.resourcesBundle())
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.modalPresentationStyle = UIModalPresentationStyle.custom
        return alert
    }
}

// MARK: - Actions
extension AlertViewController {

    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
