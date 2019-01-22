public protocol ExpandableCellViewModel: class {
    
    var expandableState: ExpandableState { get set }
    
    var availableStates: [ExpandableState] { get }
    
}

public extension ExpandableCellViewModel {
    
    var availableStates: [ExpandableState] {
        return [.collapsed, .expanded]
    }
    
}
