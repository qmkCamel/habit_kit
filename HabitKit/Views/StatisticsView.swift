import SwiftUI
import SwiftData

/// 统计视图
struct StatisticsView: View {
    @Query private var habits: [Habit]
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTimeRange: StatisticsTimeRange = .all
    @State private var selectedRankingMetric: RankingMetric = .completionRate
    
    private var statistics: HabitStatistics {
        HabitStatistics(habits: habits, timeRange: selectedTimeRange)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 时间范围选择器
                    timeRangePicker
                    
                    if habits.isEmpty {
                        emptyStateView
                    } else {
                        // 核心统计指标
                        coreMetricsSection
                        
                        // 完成率可视化
                        completionRateSection
                        
                        // 趋势图表
                        trendSection
                        
                        // 习惯排名
                        rankingSection
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("统计")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - 时间范围选择器
    
    private var timeRangePicker: some View {
        Picker("时间范围", selection: $selectedTimeRange) {
            ForEach(StatisticsTimeRange.allCases) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }
    
    // MARK: - 核心统计指标
    
    private var coreMetricsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatisticsCard(
                title: "总打卡",
                value: "\(statistics.totalCheckIns)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatisticsCard(
                title: "活跃习惯",
                value: "\(statistics.activeHabitsCount)",
                icon: "flame.fill",
                color: .orange
            )
            
            StatisticsCard(
                title: "平均完成率",
                value: String(format: "%.1f%%", statistics.averageCompletionRate * 100),
                icon: "chart.bar.fill",
                color: .purple
            )
            
            StatisticsCard(
                title: "当前最长",
                value: "\(statistics.currentLongestStreak) 天",
                icon: "star.fill",
                color: .yellow
            )
        }
    }
    
    // MARK: - 完成率可视化
    
    private var completionRateSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("整体完成率")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ProgressRing(
                progress: statistics.averageCompletionRate,
                lineWidth: 16,
                color: .purple
            )
            .frame(width: 150, height: 150)
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - 趋势图表
    
    private var trendSection: some View {
        TrendChart(
            data: generateTrendData(),
            timeRange: selectedTimeRange
        )
    }
    
    // MARK: - 习惯排名
    
    private var rankingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("习惯排名")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Picker("排序", selection: $selectedRankingMetric) {
                    Text("完成率").tag(RankingMetric.completionRate)
                    Text("连续天数").tag(RankingMetric.streak)
                }
                .pickerStyle(.menu)
                .font(.system(size: 14))
            }
            
            VStack(spacing: 8) {
                let rankedHabits = getRankedHabits()
                let displayHabits = rankedHabits.prefix(5)
                
                ForEach(Array(displayHabits.enumerated()), id: \.element.id) { index, habit in
                    HabitRankingRow(
                        rank: index + 1,
                        habit: habit,
                        metricValue: getMetricValue(for: habit),
                        metricLabel: selectedRankingMetric.label
                    )
                }
                
                if rankedHabits.count > 5 {
                    Text("还有 \(rankedHabits.count - 5) 个习惯")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - 空状态
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("还没有习惯")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("快去创建你的第一个习惯吧！")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
    
    // MARK: - 辅助方法
    
    private func generateTrendData() -> [TrendDataPoint] {
        let calendar = Calendar.current
        let range = selectedTimeRange.dateRange
        let today = calendar.startOfDay(for: Date())
        
        var dataPoints: [TrendDataPoint] = []
        var currentDate = calendar.startOfDay(for: range.lowerBound)
        let endDate = min(calendar.startOfDay(for: range.upperBound), today)
        
        // 根据时间范围决定采样间隔
        let interval: Int
        switch selectedTimeRange {
        case .thisWeek:
            interval = 1 // 每天
        case .thisMonth:
            interval = 1 // 每天
        case .all:
            interval = 7 // 每周
        }
        
        while currentDate <= endDate {
            let checkInsCount = habits.reduce(0) { total, habit in
                total + (habit.isCompleted(on: currentDate) ? 1 : 0)
            }
            
            dataPoints.append(TrendDataPoint(date: currentDate, count: checkInsCount))
            
            guard let nextDate = calendar.date(byAdding: .day, value: interval, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return dataPoints
    }
    
    private func getRankedHabits() -> [Habit] {
        switch selectedRankingMetric {
        case .completionRate:
            return statistics.topHabitsByCompletionRate
        case .streak:
            return statistics.topHabitsByStreak
        }
    }
    
    private func getMetricValue(for habit: Habit) -> String {
        let range = selectedTimeRange.dateRange
        switch selectedRankingMetric {
        case .completionRate:
            let rate = habit.getCompletionRate(in: range) * 100
            return String(format: "%.1f%%", rate)
        case .streak:
            return "\(habit.getCurrentStreak()) 天"
        }
    }
}

/// 排名指标
enum RankingMetric {
    case completionRate
    case streak
    
    var label: String {
        switch self {
        case .completionRate: return "完成率"
        case .streak: return "连续天数"
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Habit.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    // 创建示例数据
    let habit1 = Habit(name: "跑步", icon: "figure.run", color: "blue")
    habit1.completionDates = (0..<20).compactMap { day in
        Calendar.current.date(byAdding: .day, value: -day, to: Date())
    }
    container.mainContext.insert(habit1)
    
    let habit2 = Habit(name: "阅读", icon: "book.fill", color: "purple")
    habit2.completionDates = (0..<15).compactMap { day in
        Calendar.current.date(byAdding: .day, value: -day, to: Date())
    }
    container.mainContext.insert(habit2)
    
    return StatisticsView()
        .modelContainer(container)
}
