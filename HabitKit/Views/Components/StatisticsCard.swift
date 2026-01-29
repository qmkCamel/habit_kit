import SwiftUI

/// 统计卡片组件
/// 用于展示单个统计指标的卡片
struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
        .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    VStack(spacing: 16) {
        StatisticsCard(
            title: "总打卡",
            value: "156",
            icon: "checkmark.circle.fill",
            color: .green
        )
        
        StatisticsCard(
            title: "完成率",
            value: "85.5%",
            icon: "chart.bar.fill",
            color: .purple
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
