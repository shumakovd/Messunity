//
//  BasicCVCell.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

class BasicCVCell: UICollectionViewCell {

    var className: String {
        return String(describing: type(of: self))
    }

    // MARK: - Class Methods
    class var className: String {
        return String(describing: self)
    }

    class var cellIdentifier: String {
        assertionFailure("Method 'cellIdentifier' need to be overriden in BasicCollectionViewCell subclass")
        return ""
    }

    class func nibName() -> String {
        return String(describing: className).components(separatedBy: ".").last!
    }

    class func registerForCollectionView(aCollectionView: UICollectionView) {
        let nib = UINib(nibName: className, bundle: nil)
        aCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
}
