import SwiftUI

/// 设置视图
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("showWeekends") private var showWeekends = true
    @AppStorage("enableNotifications") private var enableNotifications = false
    
    var body: some View {
        NavigationView {
            List {
                Section("显示设置") {
                    Toggle("显示周末", isOn: $showWeekends)
                }
                
                Section("通知设置") {
                    Toggle("启用提醒", isOn: $enableNotifications)
                }
                
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("隐私政策", destination: URL(string: "https://example.com")!)
                    Link("使用条款", destination: URL(string: "https://example.com")!)
                }
                
                Section {
                    Button(role: .destructive) {
                        // TODO: 清除所有数据
                    } label: {
                        HStack {
                            Spacer()
                            Text("清除所有数据")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("设置")
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
