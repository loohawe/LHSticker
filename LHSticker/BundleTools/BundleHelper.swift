//
//  BundleHelper.swift
//  MGBrokerRoomDetail
//
//  Created by luhao on 27/12/2017.
//

import UIKit

public class BundleHelper: NSObject {

    static public func resourceBundleURL() -> URL? {
        let thisBundle = Bundle(for: BundleHelper.self)
        return thisBundle.url(forResource: "Resources", withExtension: "bundle")
    }

    static public func resourcesBundle() -> Bundle? {
        //return Bundle(for: BundleHelper.self)
        if let bundleURL = resourceBundleURL() {
            return Bundle(url: bundleURL)
        }
        return nil
    }

    static public func resourcesBundleFilePath(_ name: String, ofType: String) -> String {
        return resourcesBundle()?.path(forResource: name, ofType: ofType) ?? ""
    }

    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}
