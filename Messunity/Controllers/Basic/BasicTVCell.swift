//
//  BasicTVCell.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

class BasicTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Class Methods

    class var className: String {
        return String(describing: self)
    }

    class var cellIdentifier: String {
        assertionFailure("Method 'cellIdentifier' need to be overriden in BasicTableViewCell subclass")
        return ""
    }

    class func nibName() -> String {
        return String(describing: className).components(separatedBy: ".").last!
    }

    class func registerForTableView(tableView: UITableView) {
        let nib = UINib(nibName: className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}
