//
//  UIKit+lh.swift
//  LHSticker
//
//  Created by luhao on 13/01/2018.
//

import UIKit

public struct LHFeatures<Base> {

    public var base: Base

    init(_ aBase: Base) {
        base = aBase
    }

}

public protocol LHFeatureCompatible {

    associatedtype CompatibleType

    var lh: LHFeatures<CompatibleType> { get set }
}

extension LHFeatureCompatible {

    public var lh: LHFeatures<Self> {
        get {
            return LHFeatures(self)
        }
        set {
            fatalError("Property lh can not assign")
        }
    }
}
