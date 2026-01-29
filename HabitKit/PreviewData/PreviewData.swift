import Foundation
import SwiftData

/// 预览数据扩展
extension Habit {
    /// 创建示例习惯
    static func sampleHabits() -> [Habit] {
        let calendar = Calendar.current
        let today = Date()
        
        // 习惯1：下蹲
        let habit1 = Habit(
            name: "下蹲",
            icon: "figure.strengthtraining.traditional",
            color: "red",
            createdAt: calendar.date(byAdding: .day, value: -30, to: today)!
        )
        // 添加一些完成记录
        for i in 0..<20 {
            if Bool.random() {
                let date = calendar.date(byAdding: .day, value: -i, to: today)!
                habit1.completionDates.append(date)
            }
        }
        
        // 习惯2：有氧运动
        let habit2 = Habit(
            name: "有氧 or 散步",
            icon: "figure.walk",
            color: "green",
            createdAt: calendar.date(byAdding: .day, value: -25, to: today)!
        )
        for i in 0..<15 {
            if i % 2 == 0 {
                let date = calendar.date(byAdding: .day, value: -i, to: today)!
                habit2.completionDates.append(date)
            }
        }
        
        // 习惯3：饭前喝水
        let habit3 = Habit(
            name: "饭前喝水",
            icon: "drop.fill",
            color: "blue",
            createdAt: calendar.date(byAdding: .day, value: -20, to: today)!
        )
        for i in 0..<18 {
            if i % 3 != 0 {
                let date = calendar.date(byAdding: .day, value: -i, to: today)!
                habit3.completionDates.append(date)
            }
        }
        
        // 习惯4：引体向上
        let habit4 = Habit(
            name: "引体向上",
            icon: "dumbbell.fill",
            color: "orange",
            createdAt: calendar.date(byAdding: .day, value: -15, to: today)!
        )
        for i in 0..<10 {
            if Bool.random() {
                let date = calendar.date(byAdding: .day, value: -i, to: today)!
                habit4.completionDates.append(date)
            }
        }
        
        return [habit1, habit2, habit3, habit4]
    }
}

/// 模型容器配置
@MainActor
class PreviewContainer {
    static let shared = PreviewContainer()
    
    let container: ModelContainer
    
    init() {
        let schema = Schema([Habit.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        
        do {
            container = try ModelContainer(for: schema, configurations: configuration)
            
            // 插入示例数据
            let habits = Habit.sampleHabits()
            for habit in habits {
                container.mainContext.insert(habit)
            }
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}
