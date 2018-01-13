//
//  SlideImagesView.swift
//  LHSticker
//
//  Created by luhao on 12/01/2018.
//

import UIKit

private let CONST_IMAGE_CELL_IDENTIFIER: String = "ImageCell"

public class SlideImagesView: UIView {

    // MARK: - Public property

    public var groupImage: [[String: Any]] = //[]
        [
            ["name": "客厅", "subcategories": [
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117526611.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117532050.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117539231.JPG!mobile"]
                ]],
            ["name": "卧室", "subcategories": [
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117545090.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117551436.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117557953.JPG!mobile"]
                ]],
            ["name": "厨房", "subcategories": [
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117551436.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117557953.JPG!mobile"]
                ]],
            ["name": "户型图", "subcategories": [
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117551436.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117557953.JPG!mobile"]
                ]],
            ["name": "卫生间", "subcategories": [
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117551436.JPG!mobile"],
                ["iconUrl": "http://image.mgzf.com//mogoroom/2016-03/imagefile/flats/8/2/38/38_1458117557953.JPG!mobile"]
                ]]
    ]

    /// 设置图片自动播放的时间间隔
    /// 如果 <= 0, 则不自动播放
    public var loopTimeInterval: TimeInterval = 5 {
        didSet { setupTimer() }
    }

    public var didSelectedHandle: ((_ section: Int, _ row: Int) -> Void)?
    public var selectIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    // MARK: - Private property

    private var _dataSource: [GroupImageModel] = []
    private var _collectionDatas: [[ImageModel]] = []
    private var _count: Int = 0
    private var _lastOffsetY: CGFloat = 0.0
    private var _isScrollDown: Bool = true
    private var _loopTimer: Timer!

    private var _flowlayout: UICollectionViewFlowLayout = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.scrollDirection = .horizontal
        return flowlayout
    }()

    lazy var _collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: _flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        let cellNib = UINib(nibName: "ImageCell", bundle: BundleHelper.resourcesBundle())
        collectionView.register(cellNib, forCellWithReuseIdentifier: CONST_IMAGE_CELL_IDENTIFIER)
        return collectionView
    }()

    // MARK: - Override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }

    public init() {
        super.init(frame: CGRect.zero)
        privateInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let thisWidth = self.bounds.width
        let thisHeight = self.bounds.height

        _flowlayout.itemSize = CGSize(width: thisWidth, height: thisHeight)
        _collectionView.frame = CGRect(x: 0, y: 0, width: thisWidth, height: thisHeight)
    }

    deinit {
        if _loopTimer != nil {
            _loopTimer.invalidate()
        }
    }

}

// MARK: - Public method
extension SlideImagesView {

    public func moveToIndexPath(at indexPath: IndexPath) {
        selectIndexPath = indexPath
        scrollToTop(section: indexPath.section, item: indexPath.row, animated: true)
        setupTimer()
    }

    public func reloadData(_ data: [[String: Any]]? = nil) {
        if let realData = data {
            groupImage = realData
        }
        configureData()
        _collectionView.reloadData()
    }
}

// MARK: - Private method
extension SlideImagesView {

    private func privateInit() {
        addSubview(_collectionView)
        reloadData()

        setupTimer()
    }

    /// 计算下一个 IndexPath
    private func nextIndexPath(_ indexPath: IndexPath) -> IndexPath {

        if groupImage.isEmpty {
            return IndexPath(row: 0, section: 0)
        }

        let sectionInfo = groupImage[indexPath.section]

        guard let rowList = sectionInfo["subcategories"] as? [[String: Any]] else {
            fatalError("传入的图片数据有问题")
        }

        var resultRow = indexPath.row
        var resultSec = indexPath.section

        resultRow += 1
        if resultRow >= rowList.count {
            resultRow = 0
            resultSec += 1
        }

        if resultSec >= groupImage.count {
            resultSec = 0
        }

        return IndexPath(row: resultRow, section: resultSec)
    }

    // 设置自动播放
    private func setupTimer() {

        if _loopTimer != nil {
            _loopTimer.invalidate()
        }

        /// 时间间隔 <= 0, 不自动播放
        if loopTimeInterval <= 0 {
            return
        }

        _loopTimer = Timer(timeInterval: loopTimeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(_loopTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    @objc
    private func timerAction() {
        let nextIndex = self.nextIndexPath(self.selectIndexPath)
        selectIndexPath = nextIndex
        print("\(nextIndex.section)------\(nextIndex.row)")
        self.scrollToTop(section: nextIndex.section, item: nextIndex.row, animated: true)
        self.didSelectedHandle?(selectIndexPath.section, selectIndexPath.row)
    }

    //解析数据
    private func configureData() {

        _dataSource.removeAll()
        _collectionDatas.removeAll()

        let categories = groupImage
        for category in categories {
            let model = GroupImageModel.decode(from: category)
            _dataSource.append(model)
            let subcategories = model.subcategories
            var datas = [ImageModel]()
            for subcategory in subcategories {
                datas.append(subcategory)
            }
            _collectionDatas.append(datas)
        }

        for dict in groupImage {
            if let arr = dict["subcategories"] as? [String: Any] {
                _count += arr.count
            }
        }
    }

    private func scrollToTop(section: Int, item: Int, animated: Bool) {
        let headerRect = frameForHeader(section: section, item: item)
        let topOfHeader = CGPoint(x: headerRect.origin.x - _collectionView.contentInset.top + bounds.size.width * CGFloat(item), y: 0)
        _collectionView.setContentOffset(topOfHeader, animated: animated)
    }

    private func frameForHeader(section: Int, item: Int) -> CGRect {
        let indexPath = IndexPath(item: item, section: section)
        let attributes = _collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        guard let frameForFirstCell = attributes?.frame else {
            return .zero
        }
        return frameForFirstCell
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SlideImagesView: UICollectionViewDelegate, UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionDatas[section].count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CONST_IMAGE_CELL_IDENTIFIER, for: indexPath) as? ImageCell else {
            return ImageCell()
        }
        let model = _collectionDatas[indexPath.section][indexPath.row]
        cell.assign(model: model)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
        selectIndexPath = indexPath
        didSelectedHandle?(indexPath.section, indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0.3, height: 0.3)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if _collectionView == scrollView {

            _isScrollDown = _lastOffsetY < scrollView.contentOffset.y
            _lastOffsetY = scrollView.contentOffset.y

            if (Int(scrollView.contentOffset.x) % Int(bounds.size.width)) == 0 {
                guard let cell = _collectionView.visibleCells.first else { return }
                let path = _collectionView.indexPath(for: cell)
                if let indexP = path {
                    selectIndexPath = indexP
                    didSelectedHandle?(indexP.section, indexP.row)
                    setupTimer()
                }
            }
        }
    }
}

extension UIView {

    internal func findBelongViewController() -> UIViewController? {

        var nextResponder = self.next
        while !(nextResponder is UIViewController) {
            nextResponder = nextResponder?.next
        }

        return (nextResponder as? UIViewController)
    }
}

internal struct GroupImageModel: Codable {
    var name: String = ""
    var subcategories: [ImageModel] = []

    static func decode(from dic: [String: Any]) -> GroupImageModel {
        do {
            let dicData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            let model = try JSONDecoder().decode(GroupImageModel.self, from: dicData)
            return model
        } catch let error {
            fatalError("Dictionary 转 Model 失败, error: \(error)")
        }

    }
}

internal struct ImageModel: Codable {
    var iconUrl: String = ""
}
