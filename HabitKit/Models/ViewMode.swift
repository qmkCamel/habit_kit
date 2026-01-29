import Foundation

/// 视图模式枚举
enum ViewMode: String, CaseIterable {
    case grid = "网格视图"
    case list = "列表视图"
    case detail = "详情视图"
    
    var iconName: String {
        switch self {
        case .grid:
            return "square.grid.2x2"
        case .list:
            return "list.bullet"
        case .detail:
            return "equal.square"
        }
    }
}
