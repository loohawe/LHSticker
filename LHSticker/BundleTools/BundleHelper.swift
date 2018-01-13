//
//  BundleHelper.swift
//  MGBrokerRoomDetail
//
//  Created by luhao on 27/12/2017.
//

import UIKit

internal class BundleHelper: NSObject {

    static internal func subBundleURL(with name: String) -> URL? {
        let thisBundle = Bundle(for: BundleHelper.self)
        return thisBundle.url(forResource: name, withExtension: "bundle")
    }

    static internal func resourceBundleURL() -> URL? {
        return subBundleURL(with: "Resources")
    }

    static internal func resourcesBundle() -> Bundle? {
        //return Bundle(for: BundleHelper.self)
        if let bundleURL = resourceBundleURL() {
            return Bundle(url: bundleURL)
        }
        return nil
    }

    static internal func resourcesBundleFilePath(_ name: String, ofType: String) -> String {
        return resourcesBundle()?.path(forResource: name, ofType: ofType) ?? ""
    }

    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}
