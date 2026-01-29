import SwiftUI

extension Color {
    /// 根据字符串获取颜色
    static func from(string: String) -> Color {
        switch string.lowercased() {
        case "red":
            return .red
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "blue":
            return .blue
        case "purple":
            return .purple
        case "pink":
            return .pink
        case "indigo":
            return .indigo
        case "teal":
            return .teal
        case "cyan":
            return .cyan
        default:
            return .red
        }
    }
    
    /// 常用的习惯颜色列表
    static let habitColors: [String] = [
        "red", "orange", "yellow", "green",
        "blue", "purple", "pink", "indigo"
    ]
}
