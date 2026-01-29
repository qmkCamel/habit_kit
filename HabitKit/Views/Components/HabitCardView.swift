import SwiftUI

/// 习惯卡片视图 - 网格视图中的单个卡片
struct HabitCardView: View {
    let habit: Habit
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 头部：图标和标题
            HStack(spacing: 12) {
                Image(systemName: habit.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.from(string: habit.color))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(habit.createdAt.monthYearString())
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // 热力图
            HeatmapView(
                habit: habit,
                columns: 7,
                dotSize: 10,
                spacing: 3
            )
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
    }
}
