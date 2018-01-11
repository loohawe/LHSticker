//
//  StickerViewModel.swift
//  MGBrokerRoomDetail
//
//  Created by luhao on 27/12/2017.
//

import Foundation

public protocol StickerViewModel {

    /// 计算 hash 值
    var hashValue: Int { get }
    func calculateHashValue() -> Int

    /// 数据请求成功以后的回调
    func fetchDataComplete(_ handle: @escaping (_ success: Bool, _ model: Any?) -> Void)
}

extension StickerViewModel {

    /// 如果类型名字一直则 判断为同一个对象
    public func calculateHashValue() -> Int {
        return "\(type(of: self))".hashValue
    }

    public var hashValue: Int {
        return calculateHashValue()
    }
}
