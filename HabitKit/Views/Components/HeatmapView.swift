import SwiftUI

/// 热力图视图 - 显示习惯完成情况的日历点阵
struct HeatmapView: View {
    let habit: Habit
    let columns: Int
    let dotSize: CGFloat
    let spacing: CGFloat
    
    init(
        habit: Habit,
        columns: Int = 7,
        dotSize: CGFloat = 12,
        spacing: CGFloat = 4
    ) {
        self.habit = habit
        self.columns = columns
        self.dotSize = dotSize
        self.spacing = spacing
    }
    
    var body: some View {
        let dates = habit.createdAt.datesToToday()
        let rows = Int(ceil(Double(dates.count) / Double(columns)))
        
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < dates.count {
                            DotView(
                                date: dates[index],
                                isCompleted: habit.isCompleted(on: dates[index]),
                                color: Color.from(string: habit.color),
                                size: dotSize
                            )
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                }
            }
        }
    }
}

/// 单个日期点视图
struct DotView: View {
    let date: Date
    let isCompleted: Bool
    let color: Color
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(isCompleted ? color : color.opacity(0.15))
            .frame(width: size, height: size)
    }
}
