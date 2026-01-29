# HabitKit 项目概览

## 📱 项目简介

HabitKit 是一个用 Swift 和 SwiftUI 构建的现代化习惯追踪 iOS 应用，提供直观的界面和强大的功能来帮助用户养成良好习惯。

## ✨ 核心功能

### 1. 习惯管理
- 创建、编辑、删除习惯
- 自定义习惯名称、图标和颜色
- 支持 12 种图标和 8 种颜色选择

### 2. 三种视图模式
- **网格视图**: 卡片式布局，快速浏览所有习惯
- **列表视图**: 显示最近 5 天的完成情况
- **详情视图**: 查看完整的习惯历史和统计

### 3. 打卡系统
- 一键打卡/取消打卡
- 支持点击任意历史日期进行补卡
- 实时保存到本地数据库

### 4. 可视化展示
- GitHub 风格的热力图
- 直观的完成状态标记
- 连续打卡天数统计

### 5. 数据统计 ✨ NEW
- **总体统计**: 总打卡次数、活跃习惯数、平均完成率
- **连续记录**: 当前最长连续、历史最长连续
- **趋势分析**: 打卡趋势图表（支持周/月/全部时间维度）
- **习惯排名**: 按完成率或连续天数排序
- **可视化**: 环形进度条、趋势图表、统计卡片

## 🏗️ 技术架构

### 技术栈
- **SwiftUI** - 声明式 UI 框架
- **SwiftData** - 数据持久化（iOS 17+）
- **Swift 5.9+** - 编程语言

### 架构设计
- **MVVM 模式** - Model-View-ViewModel
- **单向数据流** - SwiftUI 状态管理
- **组件化设计** - 可复用的视图组件

### SOLID 原则实践

#### 1. 单一职责原则 (Single Responsibility Principle)
```swift
// ✅ 每个组件只负责一个功能
HeatmapView.swift     // 只负责热力图显示
HabitCardView.swift   // 只负责卡片显示
AddHabitSheet.swift   // 只负责添加习惯
```

#### 2. 开闭原则 (Open/Closed Principle)
```swift
// ✅ 通过扩展添加新功能，无需修改原有代码
extension Color {
    static func from(string: String) -> Color { ... }
    static let habitColors: [String] = [...] // 易于扩展
}
```

#### 3. 里氏替换原则 (Liskov Substitution Principle)
```swift
// ✅ 所有视图都遵循 View 协议，可以互相替换
struct GridView: View { ... }
struct ListView: View { ... }
struct DetailView: View { ... }
```

#### 4. 接口隔离原则 (Interface Segregation Principle)
```swift
// ✅ 组件只依赖它需要的数据
struct HeatmapView: View {
    let habit: Habit        // 只需要 Habit 数据
    let columns: Int
    let dotSize: CGFloat
}
```

#### 5. 依赖倒置原则 (Dependency Inversion Principle)
```swift
// ✅ 通过环境注入依赖，而不是硬编码
@Environment(\.modelContext) private var modelContext
@Environment(\.dismiss) private var dismiss
```

## 📂 文件结构

```
habit_kit/
├── 📱 App 层
│   └── HabitKitApp.swift           # 应用入口，配置 SwiftData
│
├── 🎯 Model 层（数据模型）
│   ├── Habit.swift                 # 核心数据模型
│   │   - 属性：id, name, icon, color, createdAt, completionDates
│   │   - 方法：isCompleted(), toggleCompletion(), getCurrentStreak()
│   └── ViewMode.swift              # 视图模式枚举
│
├── 🎨 View 层（用户界面）
│   ├── ContentView.swift           # 主视图容器
│   ├── GridView.swift              # 网格视图（卡片布局）
│   ├── ListView.swift              # 列表视图（最近 N 天）
│   ├── DetailView.swift            # 详情视图（完整历史）
│   ├── SettingsView.swift          # 设置页面
│   │
│   ├── 📦 Components/（可复用组件）
│   │   ├── HeatmapView.swift       # 热力图组件
│   │   └── HabitCardView.swift     # 习惯卡片组件
│   │
│   └── 📋 Sheets/（弹窗视图）
│       ├── AddHabitSheet.swift     # 添加习惯弹窗
│       ├── EditHabitSheet.swift    # 编辑习惯弹窗
│       └── HabitDetailSheet.swift  # 习惯详情弹窗
│
├── 🛠️ Utils 层（工具类）
│   ├── DateExtensions.swift        # 日期处理扩展
│   │   - datesInMonth()
│   │   - datesToToday()
│   │   - lastNDays()
│   └── ColorExtensions.swift       # 颜色处理扩展
│       - from(string:)
│       - habitColors
│
├── 🎭 PreviewData/（预览数据）
│   └── PreviewData.swift           # 示例数据和预览容器
│
└── 📄 配置文件
    ├── Info.plist                  # 应用配置
    ├── README.md                   # 项目说明
    ├── QUICKSTART.md              # 快速开始指南
    └── .gitignore                 # Git 忽略规则
```

## 🔄 数据流

```
用户操作 → View → Environment (.modelContext) → SwiftData → 持久化存储
                     ↓
                  更新 UI
```

### 示例：打卡流程
1. 用户点击日期按钮
2. 调用 `habit.toggleCompletion(on: date)`
3. 更新 `completionDates` 数组
4. 通过 `modelContext.save()` 保存到数据库
5. SwiftUI 自动刷新相关视图

## 🎨 UI/UX 设计

### 颜色系统
- 主题色：紫色 (#Purple)
- 8 种习惯颜色：red, orange, yellow, green, blue, purple, pink, indigo
- 透明度变化表示完成/未完成状态

### 动画效果
- 视图切换：`easeInOut` 动画
- 打卡交互：`spring` 弹性动画
- 底部指示器：滑动动画

### 组件设计
- **圆角**: 10-16pt
- **阴影**: opacity 0.05, radius 4-8pt
- **间距**: 12-16pt 网格间距
- **字体**: 系统默认字体，不同权重区分层级

## 📊 数据模型详解

### Habit 模型
```swift
@Model
final class Habit {
    var id: UUID                    // 唯一标识
    var name: String                // 习惯名称
    var icon: String                // SF Symbol 图标名
    var color: String               // 颜色字符串
    var createdAt: Date            // 创建时间
    var completionDates: [Date]    // 完成日期数组
    var targetCount: Int?          // 目标次数（可选）
}
```

### 关键方法
- `isCompleted(on: Date)` - 检查指定日期是否完成
- `toggleCompletion(on: Date)` - 切换完成状态
- `getCurrentStreak()` - 计算当前连续天数
- `getCompletionCount(on: Date)` - 获取完成次数

## 🚀 性能优化

### 1. 懒加载
- 使用 `LazyVGrid` 和 `LazyHStack` 优化列表渲染
- 只渲染可见区域的视图

### 2. 状态管理
- 使用 `@State` 管理本地状态
- 使用 `@Query` 自动监听数据变化
- 避免不必要的视图重建

### 3. 数据库优化
- 使用 SwiftData 的索引功能
- 批量操作减少 I/O
- 内存缓存常用数据

## 🔮 扩展性设计

### 易于添加新功能
1. **新视图模式**: 在 `ViewMode` 枚举中添加即可
2. **新图标**: 在 icons 数组中添加 SF Symbol 名称
3. **新颜色**: 在 `habitColors` 数组中添加颜色名
4. **新统计指标**: 在 Habit 模型中添加计算方法

### 示例：添加周视图
```swift
// 1. 在 ViewMode.swift 中添加
enum ViewMode {
    case grid
    case list
    case detail
    case week    // 新增
}

// 2. 创建 WeekView.swift
struct WeekView: View {
    // 实现周视图
}

// 3. 在 ContentView.swift 中添加
switch selectedViewMode {
    case .week:
        WeekView()
}
```

## 📱 兼容性

- **最低版本**: iOS 17.0
- **推荐版本**: iOS 17.2+
- **支持设备**: iPhone、iPad
- **屏幕适配**: 所有 iPhone 尺寸

## 🧪 测试建议

### 功能测试
- [ ] 创建、编辑、删除习惯
- [ ] 打卡和取消打卡
- [ ] 视图切换动画
- [ ] 数据持久化
- [ ] 统计数据准确性

### 边界测试
- [ ] 创建大量习惯（100+）
- [ ] 长时间跨度的完成记录（1年+）
- [ ] 快速连续点击测试
- [ ] 数据库迁移测试

## 📚 学习资源

### SwiftUI
- [Apple SwiftUI 官方文档](https://developer.apple.com/documentation/swiftui/)
- [SwiftUI by Example](https://www.hackingwithswift.com/quick-start/swiftui)

### SwiftData
- [Apple SwiftData 官方文档](https://developer.apple.com/documentation/swiftdata/)
- [SwiftData 教程](https://www.hackingwithswift.com/quick-start/swiftdata)

### 设计灵感
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)

## 🤝 贡献指南

如果你想改进这个项目：

1. 遵循现有的代码风格
2. 保持 SOLID 原则
3. 添加必要的注释
4. 测试新功能
5. 更新文档

## 📝 版本历史

### v1.0.0 (当前版本)
- ✅ 基础习惯管理功能
- ✅ 三种视图模式
- ✅ 热力图可视化
- ✅ 数据持久化
- ✅ 统计功能

### 未来计划
- 🔜 通知提醒
- 🔜 数据导出
- 🔜 小组件支持
- 🔜 iCloud 同步

---

**开始使用**: 查看 [QUICKSTART.md](QUICKSTART.md)  
**项目说明**: 查看 [README.md](README.md)
