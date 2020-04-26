import UIKit

struct Appearance {
    static let tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.00)
    static let textColor = UIColor(red: 0.90, green: 0.90, blue: 0.92, alpha: 1.00)
    static let backgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.24, alpha: 1.00)
    static let separatorColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.00)

    static func setUp(window: UIWindow?) {
        window?.tintColor = tintColor

        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: textColor]

        UIToolbar.appearance().barTintColor = backgroundColor

        UITableView.appearance().backgroundColor = backgroundColor
        UITableView.appearance().separatorColor = separatorColor
        UITableView.appearance().indicatorStyle = .white

        UITableViewCell.appearance().backgroundColor = backgroundColor
        UITableViewCell.appearance().tintColor = textColor

        UILabel.appearance().textColor = textColor
    }
}
