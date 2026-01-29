import SwiftUI
import Charts

/// 趋势图表组件
struct TrendChart: View {
    let data: [TrendDataPoint]
    let timeRange: StatisticsTimeRange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("打卡趋势")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            
            if data.isEmpty {
                emptyState
            } else {
                chart
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var chart: some View {
        Chart(data) { point in
            LineMark(
                x: .value("日期", point.date),
                y: .value("打卡数", point.count)
            )
            .foregroundStyle(Color.purple.gradient)
            .interpolationMethod(.catmullRom)
            
            AreaMark(
                x: .value("日期", point.date),
                y: .value("打卡数", point.count)
            )
            .foregroundStyle(Color.purple.opacity(0.1).gradient)
            .interpolationMethod(.catmullRom)
            
            // 高亮今天的数据点
            if Calendar.current.isDateInToday(point.date) {
                PointMark(
                    x: .value("日期", point.date),
                    y: .value("打卡数", point.count)
                )
                .foregroundStyle(Color.purple)
                .symbolSize(100)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(formatDate(date))
                            .font(.system(size: 10))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("暂无数据")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        switch timeRange {
        case .thisWeek:
            formatter.dateFormat = "E" // 星期
        case .thisMonth, .all:
            formatter.dateFormat = "M/d" // 月/日
        }
        return formatter.string(from: date)
    }
}

/// 趋势数据点
struct TrendDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

#Preview {
    let calendar = Calendar.current
    let today = Date()
    
    let weekData = (0..<7).map { dayOffset in
        TrendDataPoint(
            date: calendar.date(byAdding: .day, value: -dayOffset, to: today) ?? today,
            count: Int.random(in: 0...10)
        )
    }.reversed()
    
    return VStack(spacing: 20) {
        TrendChart(data: Array(weekData), timeRange: .thisWeek)
        TrendChart(data: [], timeRange: .thisWeek)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
