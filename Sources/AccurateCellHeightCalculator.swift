import UIKit

public class AccurateCellHeightCalculator: RowHeightCalculator {

    private(set) weak var tableView: UITableView?
    private var prototypes = [String: UITableViewCell]()
    private var cachedHeights = [Int: CGFloat]()

    public init(tableView: UITableView?) {
        self.tableView = tableView
    }

    open func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat {

        guard let tableView = tableView else { return 0 }

        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

        if let height = cachedHeights[hash] {
            return height
        }

        var prototypeCell = prototypes[row.reuseIdentifier]
        if prototypeCell == nil {

            prototypeCell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier)
            prototypes[row.reuseIdentifier] = prototypeCell
        }

        guard let cell = prototypeCell else { return  0 }
        let height = row.height(for: cell)

        cachedHeights[hash] = height

        return height
    }

    open func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat {
        return height(forRow: row, at: indexPath)
    }

    open func invalidate() {
        cachedHeights.removeAll()
    }
}
