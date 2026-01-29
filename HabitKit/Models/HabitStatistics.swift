import Foundation

/// 统计时间范围枚举
enum StatisticsTimeRange: String, CaseIterable, Identifiable {
    case all = "全部"
    case thisMonth = "本月"
    case thisWeek = "本周"
    
    var id: String { rawValue }
    
    /// 获取对应的日期范围
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .all:
            // 从很早以前到现在（使用2000年1月1日作为起点）
            let startDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? now
            return startDate...now
            
        case .thisMonth:
            // 本月1号到今天
            let components = calendar.dateComponents([.year, .month], from: now)
            let startDate = calendar.date(from: components) ?? now
            return startDate...now
            
        case .thisWeek:
            // 本周一到今天
            let startOfWeek = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now)
            let startDate = calendar.date(from: startOfWeek) ?? now
            return startDate...now
        }
    }
}

/// 习惯统计数据模型
struct HabitStatistics {
    let habits: [Habit]
    let timeRange: StatisticsTimeRange
    
    init(habits: [Habit], timeRange: StatisticsTimeRange = .all) {
        self.habits = habits
        self.timeRange = timeRange
    }
    
    // MARK: - 总体统计
    
    /// 总打卡次数
    var totalCheckIns: Int {
        let range = timeRange.dateRange
        return habits.reduce(0) { total, habit in
            total + habit.getCheckInsInRange(range).count
        }
    }
    
    /// 活跃习惯数（至少有一次打卡的习惯）
    var activeHabitsCount: Int {
        habits.filter { !$0.completionDates.isEmpty }.count
    }
    
    /// 平均完成率
    var averageCompletionRate: Double {
        guard !habits.isEmpty else { return 0.0 }
        
        let range = timeRange.dateRange
        let totalRate = habits.reduce(0.0) { sum, habit in
            sum + habit.getCompletionRate(in: range)
        }
        
        return totalRate / Double(habits.count)
    }
    
    // MARK: - 连续记录
    
    /// 当前最长连续天数（所有习惯中最长的当前连续）
    var currentLongestStreak: Int {
        habits.map { $0.getCurrentStreak() }.max() ?? 0
    }
    
    /// 历史最长连续天数（所有习惯中最长的历史连续）
    var historicalLongestStreak: Int {
        habits.map { $0.getLongestStreak() }.max() ?? 0
    }
    
    /// 当前最长连续的习惯
    var habitWithLongestCurrentStreak: Habit? {
        habits.max { $0.getCurrentStreak() < $1.getCurrentStreak() }
    }
    
    /// 历史最长连续的习惯
    var habitWithLongestHistoricalStreak: Habit? {
        habits.max { $0.getLongestStreak() < $1.getLongestStreak() }
    }
    
    // MARK: - 习惯排名
    
    /// 按完成率排名（降序）
    var topHabitsByCompletionRate: [Habit] {
        let range = timeRange.dateRange
        return habits.sorted { habit1, habit2 in
            habit1.getCompletionRate(in: range) > habit2.getCompletionRate(in: range)
        }
    }
    
    /// 按当前连续天数排名（降序）
    var topHabitsByStreak: [Habit] {
        habits.sorted { $0.getCurrentStreak() > $1.getCurrentStreak() }
    }
    
    /// 按总打卡天数排名（降序）
    var topHabitsByTotalCheckIns: [Habit] {
        habits.sorted { $0.getTotalCheckInDays() > $1.getTotalCheckInDays() }
    }
    
    // MARK: - 时间范围统计
    
    /// 指定范围内的打卡数
    var checkInsInRange: Int {
        totalCheckIns
    }
    
    /// 指定范围内的天数
    var daysInRange: Int {
        let calendar = Calendar.current
        let range = timeRange.dateRange
        let components = calendar.dateComponents([.day], from: range.lowerBound, to: range.upperBound)
        return max(0, (components.day ?? 0) + 1) // +1 因为包含起始日期
    }
    
    /// 每日平均打卡数
    var averageCheckInsPerDay: Double {
        let days = daysInRange
        return days > 0 ? Double(checkInsInRange) / Double(days) : 0.0
    }
}
