//
//  UIView+Screenshot.swift
//  LHSticker
//
//  Created by luhao on 13/01/2018.
//

import UIKit

extension UIView {

    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    public func screenShot() -> UIImage? {

        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
