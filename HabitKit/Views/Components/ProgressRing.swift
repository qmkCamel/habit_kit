import SwiftUI

/// 环形进度条组件
struct ProgressRing: View {
    let progress: Double // 0.0 - 1.0
    let lineWidth: CGFloat
    let color: Color
    
    @State private var animatedProgress: Double = 0
    
    init(progress: Double, lineWidth: CGFloat = 12, color: Color = .purple) {
        self.progress = min(max(progress, 0), 1) // 限制在 0-1 之间
        self.lineWidth = lineWidth
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            // 进度圆环
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animatedProgress)
            
            // 中间显示百分比
            VStack(spacing: 4) {
                Text("\(Int(progress * 100))")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("%")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { oldValue, newValue in
            animatedProgress = newValue
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ProgressRing(progress: 0.75, color: .purple)
            .frame(width: 120, height: 120)
        
        ProgressRing(progress: 0.5, color: .green)
            .frame(width: 100, height: 100)
        
        ProgressRing(progress: 1.0, color: .orange)
            .frame(width: 80, height: 80)
    }
    .padding()
}
