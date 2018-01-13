//
//  StickerTableView.swift
//  MGBrokerRoomDetail
//
//  Created by luhao on 27/12/2017.
//

import Foundation

/// Sticker Table View 要的数据
public struct StickerItem {
    let view: StickerView
    let viewModel: StickerViewModel
}

/// TableView 管理者
public class StickerTableView: NSObject {

    // MARK: - Public property
    var tableView: UITableView? {
        didSet {
            setup(tableView)
        }
    }

    /// 所有的 View
    var stickerViews: [UIView] {
        return _cellList.map { $0.view }
    }

    /// Section 之间的间距
    var sectionSpecing: CGFloat = 10.0

    // MARK: - Private property
    private var _cellList: [StickerCellContainer] = []
    private var _stickerItemList: [StickerItem] = []
    private var _viewViewModelManager: VVMManager = VVMManager([])

    // MARK: - Override
}

// MARK: - Private method
extension StickerTableView {

    /// 设置 tableView 的代理
    private func setup(_ tableView: UITableView?) {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.sectionFooterHeight = 1.0
        tableView?.sectionHeaderHeight = sectionSpecing > 1.0 ? sectionSpecing - 1.0 : 1.0
        tableView?.estimatedRowHeight = 44.0
    }
}

// MARK: - Public method
extension StickerTableView {

    /// 添加要显示的数据源
    public func add(item itemList: [StickerItem]) {
        _stickerItemList = itemList
        _viewViewModelManager = VVMManager(itemList)
        var containers: [StickerCellContainer] = []
        itemList.forEach { item in
            guard let aView = item.view as? UIView else {
                fatalError("StickerItem 中的 View 必须是 UIView 的子类")
            }
            let cellItem = StickerCellContainer(view: aView)
            containers.append(cellItem)
        }
        _cellList = containers
        tableView?.reloadData()
    }

    /// 开始获取数据
    public func beginFetchData() {

        /// 告诉 view 要开始请求数据啦
        _viewViewModelManager.connection
            .flatMap { $0.cellIndex }
            .map { self._cellList[$0] }
            .enumerated()
            .forEach({ enume in
                (enume.element.view as? StickerView)?.willFetchModel()
                tableView?.reloadSections(IndexSet(integer: enume.offset), with: UITableViewRowAnimation.fade)
            })
        reloadData()
    }

    /// 通知每个 viewModel 开始请求数据
    public func reloadData() {

        for i in 0..<_viewViewModelManager.connection.count {
            let item = _viewViewModelManager.connection[i]
            let vm = item.viewModel
            let cellIndexList = item.cellIndex
            let copyTableView = tableView
            vm.fetchDataComplete({ [weak copyTableView, weak self] success, model in
                guard let `self` = self else { return }
                cellIndexList.forEach({ index in
                    (self._cellList[index].view as? StickerView)?.didFetchModelSuccess(success, model: model)
                    self._cellList[index].isShow = success
                    //copyTableView?.reloadRows(at: [IndexPath.init(row: 0, section: i)], with: UITableViewRowAnimation.none)
                    copyTableView?.reloadSections(IndexSet(integer: index), with: UITableViewRowAnimation.none)
                })
            })
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension StickerTableView: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return _cellList.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellContai = _cellList[indexPath.section]
        cellContai.cell.isHidden = !cellContai.isShow
        return cellContai.cell
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        let cellContai = _cellList[section]
        if !cellContai.isShow {
            return 0.1
        } else {
            return sectionSpecing > 1.0 ? sectionSpecing - 1.0 : 1.0
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellContai = _cellList[indexPath.section]
        if !cellContai.isShow {
            return 0
        }
        return UITableViewAutomaticDimension
    }
}

/// TableViewCell 的携带者
private struct StickerCellContainer {

    var view: UIView
    var cell: UITableViewCell

    var isShow: Bool = true

    init(view stickerView: UIView) {
        view = stickerView
        let aCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        aCell.selectionStyle = .none
        aCell.contentView.addSubview(view)
        let contentView = aCell.contentView
        let topCons = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal,
                                         toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let trailingCons = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal,
                                              toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bottomCons = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal,
                                            toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingCons = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal,
                                             toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        contentView.addConstraints([topCons, trailingCons, bottomCons, leadingCons])
        cell = aCell
    }
}

/// 通过 ViewModel 去刷新数据
internal struct VVMManager {

    /// 里边是 viewModel 与 view 的对应关系
    var connection: [VVMConnection] = []

    init(_ stickers: [StickerItem]) {
        stickers.enumerated().forEach { item in
            connection.add(index: item.offset, to: item.element.viewModel)
        }
    }
}

/// 一个 ViewModel 可能对应好多个 View
/// 怎么对应用这个数据类型
internal struct VVMConnection {
    var viewModel: StickerViewModel
    var cellIndex: [Int] = []
}

extension Array where Element == VVMConnection {
    internal func contains(viewModel vm: StickerViewModel) -> Bool {
        // swiftlint:disable for_where
        for i in self {
            if i.viewModel.hashValue == vm.hashValue {
                return true
            }
        }
        return false
        // swiftlint:enable for_where
    }

    internal mutating func add(index: Int, to vm: StickerViewModel) {

        for i in 0..<self.count {
            let item = self[i]
            if item.viewModel.hashValue == vm.hashValue {
                self[i].cellIndex.append(index)
                return
            }
        }

        let connec = VVMConnection(viewModel: vm, cellIndex: [index])
        self.append(connec)
    }
}
