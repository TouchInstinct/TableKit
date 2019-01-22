import UIKit

public enum ExpandableState {
    
    case collapsed
    
    case expanded
    
    case height(value: CGFloat)
    
}

extension ExpandableState: Equatable { }

extension ExpandableState {
    
    public var isCollapsed: Bool {
        guard case .collapsed = self else {
            return false
        }
        
        return true
    }
    
    public var isExpanded: Bool {
        guard case .expanded = self else {
            return false
        }
        
        return true
    }
    
    public var height: CGFloat? {
        guard case let .height(value: height) = self else {
            return nil
        }
        
        return height
    }
    
}
