# HabitKit - 习惯追踪应用

一个用 SwiftUI 和 SwiftData 构建的现代化习惯追踪 iOS 应用。

## 功能特性

### 核心功能
- ✅ **习惯管理** - 创建、编辑和删除习惯
- ✅ **打卡系统** - 每日打卡记录习惯完成情况
- ✅ **热力图展示** - 类似 GitHub 贡献图的可视化展示
- ✅ **数据统计** ✨ NEW - 全面的数据统计和可视化分析
- ✅ **多视图模式** - 网格、列表、详情三种视图模式

### 数据统计功能 ✨
- **总体统计** - 总打卡次数、活跃习惯数、平均完成率
- **连续记录** - 当前最长连续、历史最长连续
- **趋势分析** - 可视化趋势图表（支持周/月/全部时间维度）
- **习惯排名** - 按完成率或连续天数排序查看
- **可视化组件** - 环形进度条、趋势图表、统计卡片

### 三种视图模式

1. **网格视图** - 概览所有习惯，快速查看每个习惯的完成情况
2. **列表视图** - 查看最近 5 天的完成情况，支持快速打卡
3. **详情视图** - 查看单个习惯的详细信息和完整历史记录

## 技术栈

- **SwiftUI** - 现代化的声明式 UI 框架
- **SwiftData** - iOS 17+ 的新数据持久化框架
- **SOLID 原则** - 遵循面向对象设计原则

## 项目结构

```
habit_kit/
├── HabitKitApp.swift          # 应用入口
├── ContentView.swift           # 主视图
├── Models/                     # 数据模型层
│   ├── Habit.swift            # 习惯模型
│   ├── HabitStatistics.swift  # 统计数据模型 ✨
│   └── ViewMode.swift         # 视图模式枚举
├── Views/                      # 视图层
│   ├── GridView.swift         # 网格视图
│   ├── ListView.swift         # 列表视图
│   ├── DetailView.swift       # 详情视图
│   ├── SettingsView.swift     # 设置视图
│   ├── StatisticsView.swift   # 统计视图 ✨
│   ├── Components/            # 可复用组件
│   │   ├── HeatmapView.swift  # 热力图组件
│   │   ├── HabitCardView.swift # 习惯卡片组件
│   │   ├── StatisticsCard.swift # 统计卡片 ✨
│   │   ├── ProgressRing.swift   # 环形进度条 ✨
│   │   ├── TrendChart.swift     # 趋势图表 ✨
│   │   └── HabitRankingRow.swift # 排行榜行 ✨
│   └── Sheets/                # 弹窗视图
│       ├── AddHabitSheet.swift      # 添加习惯
│       ├── EditHabitSheet.swift     # 编辑习惯
│       └── HabitDetailSheet.swift   # 习惯详情
├── Utils/                      # 工具类
│   ├── DateExtensions.swift   # 日期扩展
│   └── ColorExtensions.swift  # 颜色扩展
└── PreviewData/               # 预览数据
    └── PreviewData.swift      # 示例数据

```

## 代码设计原则

### SOLID 原则应用

1. **单一职责原则 (SRP)**
   - 每个视图组件只负责一个功能
   - 模型类只处理数据相关逻辑

2. **开闭原则 (OCP)**
   - 通过协议和扩展实现功能扩展
   - 颜色和图标系统易于扩展

3. **里氏替换原则 (LSP)**
   - 视图模式使用枚举，保证类型安全
   - 所有视图遵循 SwiftUI 的 View 协议

4. **接口隔离原则 (ISP)**
   - 每个组件只依赖它需要的数据
   - 通过参数传递实现松耦合

5. **依赖倒置原则 (DIP)**
   - 使用 SwiftUI 的环境系统注入依赖
   - 视图依赖协议而不是具体实现

## 核心特性实现

### 1. 数据模型 (`Habit.swift`)
- 使用 `@Model` 宏实现 SwiftData 持久化
- 包含习惯名称、图标、颜色、创建时间、完成记录等属性
- 实现了连续打卡计算、日期检查等业务逻辑方法

### 2. 热力图组件 (`HeatmapView.swift`)
- 可配置的行列数和点大小
- 根据完成状态动态渲染颜色
- 支持点击交互

### 3. 视图切换系统
- 流畅的视图切换动画
- 底部标签栏指示器动画
- 保持状态的视图管理

### 4. 打卡系统
- 支持点击任意日期进行打卡/取消打卡
- 实时更新并保存到数据库
- 带有弹性动画效果

## 使用方法

### 开发环境要求
- Xcode 15.0+
- iOS 17.0+
- macOS 14.0+

### 运行步骤

1. 打开 Xcode
2. 创建新的 iOS App 项目，选择 SwiftUI 界面和 SwiftData 存储
3. 将项目文件复制到对应目录
4. 选择模拟器或真机运行

### 添加习惯
1. 点击右上角的 `+` 按钮
2. 输入习惯名称
3. 选择图标和颜色
4. 点击"完成"保存

### 打卡记录
- **网格视图**: 点击卡片查看详情
- **列表视图**: 点击对应日期方块进行打卡
- **详情视图**: 点击热力图中的点进行打卡

## 自定义扩展

### 添加新图标
在 `AddHabitSheet.swift` 中的 `icons` 数组添加 SF Symbols 图标名称：

```swift
let icons = [
    "heart.fill",
    "figure.walk",
    // 添加你的图标
    "star.fill"
]
```

### 添加新颜色
在 `ColorExtensions.swift` 中的 `habitColors` 数组添加颜色：

```swift
static let habitColors: [String] = [
    "red", "orange", "yellow",
    // 添加你的颜色
    "brown", "mint"
]
```

## 未来计划

- [ ] 添加小组件支持
- [ ] 实现提醒通知功能
- [ ] 添加数据导出功能
- [ ] 支持习惯分类
- [ ] 添加成就系统
- [ ] 支持 iCloud 同步
- [ ] 支持深色模式优化
- [x] ~~添加数据分析图表~~ ✅ 已完成（v1.1）

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
