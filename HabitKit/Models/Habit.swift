import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var icon: String
    var color: String
    var createdAt: Date
    var completionDates: [Date]
    var targetCount: Int?
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String = "heart.fill",
        color: String = "red",
        createdAt: Date = Date(),
        completionDates: [Date] = [],
        targetCount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.createdAt = createdAt
        self.completionDates = completionDates
        self.targetCount = targetCount
    }
    
    // MARK: - 业务逻辑方法
    
    /// 检查指定日期是否已完成
    func isCompleted(on date: Date) -> Bool {
        let calendar = Calendar.current
        return completionDates.contains { completionDate in
            calendar.isDate(completionDate, inSameDayAs: date)
        }
    }
    
    /// 切换指定日期的完成状态
    func toggleCompletion(on date: Date) {
        let calendar = Calendar.current
        
        if let index = completionDates.firstIndex(where: { completionDate in
            calendar.isDate(completionDate, inSameDayAs: date)
        }) {
            completionDates.remove(at: index)
        } else {
            completionDates.append(date)
        }
    }
    
    /// 获取当前连续打卡天数
    func getCurrentStreak() -> Int {
        guard !completionDates.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let sortedDates = completionDates
            .map { calendar.startOfDay(for: $0) }
            .sorted(by: >)
        
        guard let mostRecent = sortedDates.first else { return 0 }
        
        // 如果最近一次打卡不是今天或昨天，则连续记录中断
        let daysDiff = calendar.dateComponents([.day], from: mostRecent, to: today).day ?? 0
        if daysDiff > 1 {
            return 0
        }
        
        var streak = 0
        var currentDate = today
        
        for completionDate in sortedDates {
            if calendar.isDate(completionDate, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if completionDate < currentDate {
                break
            }
        }
        
        return streak
    }
    
    /// 获取指定日期的完成次数
    func getCompletionCount(on date: Date) -> Int {
        let calendar = Calendar.current
        return completionDates.filter { completionDate in
            calendar.isDate(completionDate, inSameDayAs: date)
        }.count
    }
    
    // MARK: - 统计相关方法
    
    /// 计算指定时间范围内的完成率
    /// - Parameter range: 时间范围（开始日期到结束日期）
    /// - Returns: 完成率（0.0 - 1.0），如果范围无效返回 0.0
    func getCompletionRate(in range: ClosedRange<Date>) -> Double {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: range.lowerBound)
        let endDate = calendar.startOfDay(for: range.upperBound)
        let today = calendar.startOfDay(for: Date())
        
        // 计算实际应该统计的天数（不包括未来日期和习惯创建之前的日期）
        let habitStartDate = calendar.startOfDay(for: createdAt)
        let actualStartDate = max(startDate, habitStartDate)
        let actualEndDate = min(endDate, today)
        
        // 如果开始日期晚于结束日期，返回 0
        guard actualStartDate <= actualEndDate else { return 0.0 }
        
        // 计算天数
        let totalDays = calendar.dateComponents([.day], from: actualStartDate, to: actualEndDate).day ?? 0
        guard totalDays >= 0 else { return 0.0 }
        
        // 加1是因为包含开始和结束日期
        let totalDaysIncluded = totalDays + 1
        
        // 计算完成的天数
        let completedDays = completionDates.filter { completionDate in
            let dayStart = calendar.startOfDay(for: completionDate)
            return dayStart >= actualStartDate && dayStart <= actualEndDate
        }.count
        
        return totalDaysIncluded > 0 ? Double(completedDays) / Double(totalDaysIncluded) : 0.0
    }
    
    /// 计算历史最长连续打卡天数
    /// - Returns: 历史最长连续天数
    func getLongestStreak() -> Int {
        guard !completionDates.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let uniqueDates = Set(completionDates.map { calendar.startOfDay(for: $0) })
        let sortedDates = Array(uniqueDates).sorted()
        
        var longestStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedDates.count {
            let previousDate = sortedDates[i - 1]
            let currentDate = sortedDates[i]
            
            // 检查是否是连续的一天
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(nextDay, inSameDayAs: currentDate) {
                currentStreak += 1
                longestStreak = max(longestStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return longestStreak
    }
    
    /// 获取指定时间范围内的打卡记录
    /// - Parameter range: 时间范围（开始日期到结束日期）
    /// - Returns: 该范围内的打卡日期数组
    func getCheckInsInRange(_ range: ClosedRange<Date>) -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: range.lowerBound)
        let endDate = calendar.startOfDay(for: range.upperBound)
        
        return completionDates.filter { completionDate in
            let dayStart = calendar.startOfDay(for: completionDate)
            return dayStart >= startDate && dayStart <= endDate
        }
    }
    
    /// 获取总打卡天数（去重）
    /// - Returns: 总打卡天数
    func getTotalCheckInDays() -> Int {
        let calendar = Calendar.current
        let uniqueDates = Set(completionDates.map { calendar.startOfDay(for: $0) })
        return uniqueDates.count
    }
    
    /// 获取从创建至今的天数
    /// - Returns: 从创建至今的天数（包含创建当天，最小为 0）
    func getDaysSinceCreation() -> Int {
        let calendar = Calendar.current
        let creationDay = calendar.startOfDay(for: createdAt)
        let today = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: creationDay, to: today)
        return max(0, components.day ?? 0)
    }
}
