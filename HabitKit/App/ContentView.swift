import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedViewMode: ViewMode = .grid
    @State private var showingSettings = false
    @State private var showingAddHabit = false
    @State private var showingStatistics = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 主内容区域
                ZStack {
                    switch selectedViewMode {
                    case .grid:
                        GridView()
                            .transition(.opacity)
                    case .list:
                        ListView()
                            .transition(.opacity)
                    case .detail:
                        DetailView()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: selectedViewMode)
                
                // 底部视图切换栏
                ViewModeSelector(selectedMode: $selectedViewMode)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
            }
            .navigationTitle("HabitKit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // PRO 标签
                        Text("PRO")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple)
                            .cornerRadius(6)
                        
                        // 统计按钮
                        Button(action: {
                            showingStatistics = true
                        }) {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.primary)
                        }
                        
                        // 添加习惯按钮
                        Button(action: {
                            showingAddHabit = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitSheet()
            }
            .sheet(isPresented: $showingStatistics) {
                StatisticsView()
            }
        }
    }
}

/// 视图模式选择器
struct ViewModeSelector: View {
    @Binding var selectedMode: ViewMode
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMode = mode
                    }
                }) {
                    Image(systemName: mode.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(selectedMode == mode ? .purple : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }
        }
        .background(
            GeometryReader { geometry in
                Color.purple.opacity(0.1)
                    .frame(width: geometry.size.width / CGFloat(ViewMode.allCases.count))
                    .offset(x: geometry.size.width / CGFloat(ViewMode.allCases.count) * CGFloat(ViewMode.allCases.firstIndex(of: selectedMode) ?? 0))
                    .cornerRadius(10)
            }
        )
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
