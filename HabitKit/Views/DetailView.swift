import SwiftUI
import SwiftData

/// 详情视图 - 显示所有习惯的详细完成历史
struct DetailView: View {
    @Query private var habits: [Habit]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(habits) { habit in
                    HabitDetailCard(habit: habit)
                }
            }
            .padding(16)
        }
    }
}

/// 习惯详情卡片
struct HabitDetailCard: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 头部
            HStack {
                Image(systemName: habit.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.from(string: habit.color))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(streakText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 完成状态按钮
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        habit.toggleCompletion(on: Date())
                        try? modelContext.save()
                    }
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(habit.isCompleted(on: Date()) 
                            ? Color.from(string: habit.color)
                            : Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            
            // 大尺寸热力图
            LargeHeatmapView(habit: habit)
                .padding(.top, 8)
            
            // 操作按钮
            HStack(spacing: 12) {
                Button(action: {
                    showingEditSheet = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("编辑")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    deleteHabit()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("删除")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .sheet(isPresented: $showingEditSheet) {
            EditHabitSheet(habit: habit)
        }
    }
    
    private var streakText: String {
        let streak = habit.getCurrentStreak()
        return streak > 0 ? "\(streak)+ 天连续" : "今天开始吧！"
    }
    
    private func deleteHabit() {
        modelContext.delete(habit)
        try? modelContext.save()
    }
}

/// 大尺寸热力图
struct LargeHeatmapView: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        let dates = habit.createdAt.datesToToday()
        let columns = 7
        let rows = Int(ceil(Double(dates.count) / Double(columns)))
        
        VStack(spacing: 6) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < dates.count {
                            LargeDotButton(
                                habit: habit,
                                date: dates[index],
                                size: 14
                            )
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 14, height: 14)
                        }
                    }
                }
            }
        }
    }
}

/// 大尺寸可点击的日期点
struct LargeDotButton: View {
    let habit: Habit
    let date: Date
    let size: CGFloat
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                habit.toggleCompletion(on: date)
                try? modelContext.save()
            }
        }) {
            Circle()
                .fill(habit.isCompleted(on: date) 
                    ? Color.from(string: habit.color)
                    : Color.from(string: habit.color).opacity(0.15))
                .frame(width: size, height: size)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
