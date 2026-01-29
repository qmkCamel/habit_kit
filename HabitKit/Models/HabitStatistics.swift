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
        print("[DEBUG] HabitStatistics.init - 初始化统计: habitCount=\(habits.count), timeRange=\(timeRange.rawValue)")
    }
    
    // MARK: - 总体统计
    
    /// 总打卡次数
    var totalCheckIns: Int {
        print("[DEBUG] HabitStatistics.totalCheckIns - 开始计算总打卡")
        let range = timeRange.dateRange
        let result = habits.reduce(0) { total, habit in
            let checkIns = habit.getCheckInsInRange(range).count
            print("[DEBUG] HabitStatistics.totalCheckIns - 累加习惯: name=\(habit.name), checkIns=\(checkIns)")
            return total + checkIns
        }
        print("[DEBUG] HabitStatistics.totalCheckIns - 计算完成: result=\(result)")
        return result
    }
    
    /// 活跃习惯数（至少有一次打卡的习惯）
    var activeHabitsCount: Int {
        print("[DEBUG] HabitStatistics.activeHabitsCount - 开始计算活跃习惯数")
        let result = habits.filter { !$0.completionDates.isEmpty }.count
        print("[DEBUG] HabitStatistics.activeHabitsCount - 计算完成: result=\(result), totalHabits=\(habits.count)")
        return result
    }
    
    /// 平均完成率
    var averageCompletionRate: Double {
        print("[DEBUG] HabitStatistics.averageCompletionRate - 开始计算平均完成率")
        guard !habits.isEmpty else {
            print("[DEBUG] HabitStatistics.averageCompletionRate - 检测到空数据: 返回 0.0")
            return 0.0
        }
        
        let range = timeRange.dateRange
        let totalRate = habits.reduce(0.0) { sum, habit in
            let rate = habit.getCompletionRate(in: range)
            print("[DEBUG] HabitStatistics.averageCompletionRate - 累加习惯完成率: name=\(habit.name), rate=\(String(format: "%.2f", rate * 100))%")
            return sum + rate
        }
        
        let result = totalRate / Double(habits.count)
        print("[DEBUG] HabitStatistics.averageCompletionRate - 计算完成: result=\(String(format: "%.2f", result * 100))%")
        return result
    }
    
    // MARK: - 连续记录
    
    /// 当前最长连续天数（所有习惯中最长的当前连续）
    var currentLongestStreak: Int {
        print("[DEBUG] HabitStatistics.currentLongestStreak - 开始计算当前最长连续")
        let result = habits.map { $0.getCurrentStreak() }.max() ?? 0
        print("[DEBUG] HabitStatistics.currentLongestStreak - 计算完成: result=\(result)")
        return result
    }
    
    /// 历史最长连续天数（所有习惯中最长的历史连续）
    var historicalLongestStreak: Int {
        print("[DEBUG] HabitStatistics.historicalLongestStreak - 开始计算历史最长连续")
        let result = habits.map { $0.getLongestStreak() }.max() ?? 0
        print("[DEBUG] HabitStatistics.historicalLongestStreak - 计算完成: result=\(result)")
        return result
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
        print("[DEBUG] HabitStatistics.topHabitsByCompletionRate - 开始排序")
        let range = timeRange.dateRange
        let sorted = habits.sorted { habit1, habit2 in
            habit1.getCompletionRate(in: range) > habit2.getCompletionRate(in: range)
        }
        print("[DEBUG] HabitStatistics.topHabitsByCompletionRate - 排序完成: count=\(sorted.count)")
        return sorted
    }
    
    /// 按当前连续天数排名（降序）
    var topHabitsByStreak: [Habit] {
        print("[DEBUG] HabitStatistics.topHabitsByStreak - 开始排序")
        let sorted = habits.sorted { $0.getCurrentStreak() > $1.getCurrentStreak() }
        print("[DEBUG] HabitStatistics.topHabitsByStreak - 排序完成: count=\(sorted.count)")
        return sorted
    }
    
    /// 按总打卡天数排名（降序）
    var topHabitsByTotalCheckIns: [Habit] {
        print("[DEBUG] HabitStatistics.topHabitsByTotalCheckIns - 开始排序")
        let sorted = habits.sorted { $0.getTotalCheckInDays() > $1.getTotalCheckInDays() }
        print("[DEBUG] HabitStatistics.topHabitsByTotalCheckIns - 排序完成: count=\(sorted.count)")
        return sorted
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
