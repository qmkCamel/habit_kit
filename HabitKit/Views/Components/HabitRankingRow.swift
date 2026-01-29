import SwiftUI

/// 排行榜行组件
struct HabitRankingRow: View {
    let rank: Int
    let habit: Habit
    let metricValue: String
    let metricLabel: String
    
    var body: some View {
        HStack(spacing: 12) {
            // 排名
            rankBadge
            
            // 习惯图标
            Image(systemName: habit.icon)
                .font(.system(size: 20))
                .foregroundColor(Color(habit.color))
                .frame(width: 40, height: 40)
                .background(Color(habit.color).opacity(0.1))
                .cornerRadius(8)
            
            // 习惯名称
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(metricLabel)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 指标值
            Text(metricValue)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(rankColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(rank <= 3 ? rankColor.opacity(0.05) : Color.clear)
        .cornerRadius(8)
    }
    
    private var rankBadge: some View {
        ZStack {
            if rank <= 3 {
                // Top 3 显示奖牌
                Image(systemName: medalIcon)
                    .font(.system(size: 24))
                    .foregroundColor(rankColor)
            } else {
                // 其他显示数字
                Text("\(rank)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 28, height: 28)
            }
        }
        .frame(width: 32)
    }
    
    private var medalIcon: String {
        switch rank {
        case 1: return "trophy.fill"
        case 2: return "medal.fill"
        case 3: return "star.fill"
        default: return ""
        }
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .secondary
        }
    }
}

#Preview {
    let sampleHabits = [
        Habit(name: "跑步", icon: "figure.run", color: "blue"),
        Habit(name: "阅读", icon: "book.fill", color: "purple"),
        Habit(name: "冥想", icon: "heart.fill", color: "pink"),
        Habit(name: "写作", icon: "pencil", color: "green"),
        Habit(name: "健身", icon: "dumbbell.fill", color: "red")
    ]
    
    return VStack(spacing: 8) {
        ForEach(Array(sampleHabits.enumerated()), id: \.element.id) { index, habit in
            HabitRankingRow(
                rank: index + 1,
                habit: habit,
                metricValue: "\(95 - index * 10)%",
                metricLabel: "完成率"
            )
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
