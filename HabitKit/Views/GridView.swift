import SwiftUI
import SwiftData

/// 网格视图 - 显示所有习惯的卡片
struct GridView: View {
    @Query private var habits: [Habit]
    @State private var selectedHabit: Habit?
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(habits) { habit in
                    HabitCardView(habit: habit) {
                        selectedHabit = habit
                    }
                }
                
                // 添加新习惯卡片
                AddHabitButton()
            }
            .padding(16)
        }
        .sheet(item: $selectedHabit) { habit in
            HabitDetailSheet(habit: habit)
        }
    }
}

/// 添加习惯按钮
struct AddHabitButton: View {
    @State private var showingAddSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                Text("添加习惯")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(height: 140)
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
        )
        .onTapGesture {
            showingAddSheet = true
        }
        .sheet(isPresented: $showingAddSheet) {
            AddHabitSheet()
        }
    }
}
