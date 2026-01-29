import SwiftUI
import SwiftData

/// 编辑习惯弹窗
struct EditHabitSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    
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
            .navigationTitle("编辑习惯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveChanges()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                name = habit.name
                selectedIcon = habit.icon
                selectedColor = habit.color
            }
        }
    }
    
    private func saveChanges() {
        habit.name = name.trimmingCharacters(in: .whitespaces)
        habit.icon = selectedIcon
        habit.color = selectedColor
        
        try? modelContext.save()
        dismiss()
    }
}
