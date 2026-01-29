import SwiftUI
import SwiftData

/// 列表视图 - 显示最近N天的完成情况
struct ListView: View {
    @Query private var habits: [Habit]
    let numberOfDays: Int = 5
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 标题
                HStack {
                    Text("Last \(numberOfDays) days")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // 日期标题
                    HStack(spacing: 12) {
                        ForEach(Date.lastNDays(n: numberOfDays), id: \.self) { date in
                            VStack(spacing: 4) {
                                Text(weekdayString(from: date))
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 44)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // 习惯列表
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        HabitListRow(habit: habit, numberOfDays: numberOfDays)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
    
    private func weekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

/// 习惯列表行
struct HabitListRow: View {
    let habit: Habit
    let numberOfDays: Int
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack(spacing: 12) {
            // 图标
            Image(systemName: habit.icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.from(string: habit.color))
                .cornerRadius(8)
            
            // 习惯名称
            Text(habit.name)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color.from(string: habit.color).opacity(0.1))
                .cornerRadius(8)
            
            // 最近N天的状态
            HStack(spacing: 12) {
                ForEach(Date.lastNDays(n: numberOfDays), id: \.self) { date in
                    DayStatusButton(
                        habit: habit,
                        date: date,
                        size: 44
                    )
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

/// 日期状态按钮
struct DayStatusButton: View {
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
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(habit.isCompleted(on: date) 
                        ? Color.from(string: habit.color)
                        : Color.from(string: habit.color).opacity(0.1))
                
                if habit.isCompleted(on: date) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
