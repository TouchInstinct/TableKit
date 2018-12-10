import UIKit

extension UITableViewCell {

    public var tableView: UITableView? {
        var view = superview

        while view != nil && !(view is UITableView) {
            view = view?.superview
        }

        return view as? UITableView
    }

    public var indexPath: IndexPath? {
        guard let indexPath = tableView?.indexPath(for: self) else {
            return nil
        }
        
        return indexPath
    }

    public var height: CGFloat {
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }

}
