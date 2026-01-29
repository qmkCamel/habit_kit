import SwiftUI
import SwiftData

/// 添加习惯弹窗
struct AddHabitSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedIcon: String = "heart.fill"
    @State private var selectedColor: String = "red"
    
    let icons = [
        "heart.fill", "figure.walk", "bed.double.fill", "drop.fill",
        "book.fill", "dumbbell.fill", "brain.head.profile", "leaf.fill",
        "fork.knife", "cup.and.saucer.fill", "pill.fill", "moon.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("习惯名称") {
                    TextField("输入习惯名称", text: $name)
                }
                
                Section("选择图标") {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 60))
                    ], spacing: 16) {
                        ForEach(icons, id: \.self) { icon in
                            IconButton(
                                icon: icon,
                                isSelected: selectedIcon == icon,
                                color: Color.from(string: selectedColor)
                            ) {
                                selectedIcon = icon
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("选择颜色") {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 60))
                    ], spacing: 16) {
                        ForEach(Color.habitColors, id: \.self) { color in
                            ColorButton(
                                color: color,
                                isSelected: selectedColor == color
                            ) {
                                selectedColor = color
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("添加习惯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        saveHabit()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let habit = Habit(
            name: name.trimmingCharacters(in: .whitespaces),
            icon: selectedIcon,
            color: selectedColor
        )
        
        modelContext.insert(habit)
        try? modelContext.save()
        dismiss()
    }
}

/// 图标按钮
struct IconButton: View {
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : color)
                .frame(width: 60, height: 60)
                .background(isSelected ? color : color.opacity(0.2))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: isSelected ? 3 : 0)
                )
        }
    }
}

/// 颜色按钮
struct ColorButton: View {
    let color: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.from(string: color))
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .padding(2)
                        .overlay(
                            Circle()
                                .stroke(Color.from(string: color), lineWidth: 4)
                        )
                        .opacity(isSelected ? 1 : 0)
                )
        }
    }
}
