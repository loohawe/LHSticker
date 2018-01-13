//
//  ImageCell.swift
//  LHSticker
//
//  Created by luhao on 12/01/2018.
//

import UIKit
import SDWebImage

internal class ImageCell: UICollectionViewCell {

    // MARK: Public property

    // MARK: Private property
    @IBOutlet internal weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: - Public method
extension ImageCell {

    public func assign(model: ImageModel) {
        imageView.sd_setImage(with: URL(string: model.iconUrl), completed: nil)
    }
}
