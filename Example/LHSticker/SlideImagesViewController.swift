//
//  SlideImagesViewController.swift
//  LHSticker_Example
//
//  Created by luhao on 13/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import LHSticker
import SnapKit

public class SlideImagesViewController: UIViewController {

    @IBOutlet weak var slideImages: SlideImagesView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        slideImages.didSelectedHandle = { (section, row) in
            print("********\(section)--\(row)")
        }
    }
    
    @IBAction public func showAlertAction(_ sender: UIButton) {
        let view = UIView()
        view.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        view.backgroundColor = UIColor.blue
        lh.showAlert(view: view)
    }
    
}
