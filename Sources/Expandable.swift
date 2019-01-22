import UIKit

public extension TimeInterval {
    
    static let defaultExpandableAnimationDuration: TimeInterval = 0.3
    
}

public protocol Expandable {
    
    associatedtype ViewModelType: ExpandableCellViewModel
    
    var viewModel: ViewModelType? { get }
    
    func configure(state: ExpandableState)
    
}

extension Expandable where Self: UITableViewCell & ConfigurableCell {
    
    public func initState() {
        guard let viewModel = viewModel else {
            return
        }
        
        changeState(expandableState: viewModel.expandableState)
    }
    
    private func changeState(expandableState: ExpandableState) {
        // layout to get right frames, frame of bottom subview can be used to get expanded height
        setNeedsLayout()
        layoutIfNeeded()
        
        // apply changes
        configure(state: expandableState)
        layoutIfNeeded()
    }
    
    public func toggleState(animated: Bool = true,
                            animationDuration: TimeInterval = .defaultExpandableAnimationDuration) {
        
        guard let viewModel = viewModel,
              let stateIndex = viewModel.availableStates.index(where: { $0 == viewModel.expandableState }) else {
            return
        }
        
        let targetState = stateIndex == viewModel.availableStates.count - 1
            ? viewModel.availableStates[0]
            : viewModel.availableStates[stateIndex + 1]
        
        transition(to: targetState,
                   animated: animated,
                   animationDuration: animationDuration)
    }
    
    public func transition(to state: ExpandableState,
                           animated: Bool = true,
                           animationDuration: TimeInterval = .defaultExpandableAnimationDuration) {
        
        guard let tableView = tableView,
            let viewModel = viewModel,
            viewModel.expandableState != state else {
                return
        }
        
        let contentOffset = tableView.contentOffset
        
        if animated {
            UIView.animate(withDuration: animationDuration,
                           animations: { [weak self] in
                            self?.applyChanges(expandableState: state)
                }, completion: { _ in
                    viewModel.expandableState = state
            })
        } else {
            applyChanges(expandableState: state)
            viewModel.expandableState = state
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    public func applyChanges(expandableState: ExpandableState) {
        changeState(expandableState: expandableState)
        
        if let indexPath = indexPath,
            let tableDirector = (tableView?.delegate as? TableDirector),
            let cellHeightCalculator = tableDirector.rowHeightCalculator as? ExpandableCellHeightCalculator {
            cellHeightCalculator.updateCached(height: expandableState.height ?? height(layoutType: Self.layoutType), for: indexPath)
        }
    }
    
}
