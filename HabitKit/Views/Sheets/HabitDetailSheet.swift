import SwiftUI

/// 习惯详情弹窗（从网格视图点击卡片后显示）
struct HabitDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let habit: Habit
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 习惯信息
                    HStack(spacing: 16) {
                        Image(systemName: habit.icon)
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color.from(string: habit.color))
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(habit.name)
                                .font(.system(size: 24, weight: .bold))
                            
                            Text("创建于 \(habit.createdAt.monthYearString())")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    // 统计信息
                    HStack(spacing: 16) {
                        StatCard(
                            title: "连续天数",
                            value: "\(habit.getCurrentStreak())",
                            color: Color.from(string: habit.color)
                        )
                        
                        StatCard(
                            title: "总完成",
                            value: "\(habit.completionDates.count)",
                            color: Color.from(string: habit.color)
                        )
                    }
                    .padding(.horizontal)
                    
                    // 完成历史
                    VStack(alignment: .leading, spacing: 12) {
                        Text("完成历史")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.horizontal)
                        
                        LargeHeatmapView(habit: habit)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// 统计卡片
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
