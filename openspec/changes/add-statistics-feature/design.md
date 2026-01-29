## Context

HabitKit 是一个基于 SwiftUI + SwiftData 的习惯追踪应用（iOS 17+），采用 MVVM 架构。当前应用已实现：
- **数据层**：Habit 模型使用 SwiftData 持久化
- **视图层**：网格、列表、详情三种视图模式
- **核心功能**：习惯创建、编辑、删除、打卡
- **可视化**：热力图展示打卡历史

当前缺失的是数据分析和统计功能，工具栏已预留统计按钮（图标 `chart.bar.fill`）但未实现。

### 技术栈约束
- 必须使用 SwiftUI（iOS 17+）
- 数据持久化使用 SwiftData
- 不引入第三方依赖
- 可使用 SwiftUI Charts 框架（系统内置）

### 现有架构
```
HabitKit/
├── Models/
│   ├── Habit.swift (已有 getCurrentStreak() 等方法)
│   └── ViewMode.swift
├── Views/
│   ├── ContentView.swift (主容器，已有统计按钮占位符)
│   ├── GridView/ListView/DetailView.swift
│   └── Components/ (可复用组件)
└── Utils/ (日期、颜色扩展)
```

## Goals / Non-Goals

**Goals:**
1. 提供全局统计概览，展示用户的整体表现
2. 支持多时间维度的统计（全部、本月、本周）
3. 可视化呈现统计数据（卡片、环形图、趋势图）
4. 计算性能优化，大数据量下保持流畅
5. 与现有架构无缝集成，遵循现有代码风格

**Non-Goals:**
1. 不实现跨设备数据同步（iCloud 同步）
2. 不实现数据导出功能
3. 不添加社交分享功能
4. 不实现习惯分组或分类统计
5. 不提供通知提醒功能

## Decisions

### 1. 统计数据架构：计算式 vs 缓存式

**决策**：采用**实时计算**策略，不缓存统计结果

**理由**：
- ✅ **数据一致性**：统计数据始终反映最新状态，无需处理缓存失效
- ✅ **简化实现**：无需维护额外的缓存层和更新逻辑
- ✅ **内存高效**：不占用额外内存存储缓存数据
- ✅ **数据量可控**：单用户的习惯数量和打卡记录有限（预计 < 100 习惯，< 10000 打卡记录）

**替代方案**：缓存统计结果
- ❌ 需要监听 Habit 变化并失效缓存
- ❌ 增加代码复杂度
- ⚠️ 对当前数据规模收益不明显

**实现**：创建 `HabitStatistics` 值类型，接收 `[Habit]` 数组，按需计算统计指标

### 2. 统计计算位置：Model vs ViewModel vs View

**决策**：采用**混合方案**
- **Habit 模型**：单个习惯的统计方法（如完成率、最长连续）
- **HabitStatistics 值类型**：全局聚合统计（如总打卡数、平均完成率）
- **StatisticsView**：使用 `@Query` 获取数据，传递给 HabitStatistics

**理由**：
- ✅ **职责清晰**：模型负责自身统计，聚合逻辑独立
- ✅ **可测试性**：HabitStatistics 为纯函数，易于单元测试
- ✅ **SwiftUI 友好**：利用 `@Query` 自动刷新机制

**代码结构**：
```swift
// Model 层
extension Habit {
    func getCompletionRate(in range: DateRange) -> Double { ... }
    func getLongestStreak() -> Int { ... }
}

// 统计聚合层
struct HabitStatistics {
    let habits: [Habit]
    
    var totalCheckIns: Int { ... }
    var averageCompletionRate: Double { ... }
    var topHabits: [Habit] { ... }
}

// View 层
struct StatisticsView: View {
    @Query var habits: [Habit]
    
    var body: some View {
        let stats = HabitStatistics(habits: habits)
        // 渲染统计数据
    }
}
```

### 3. 时间范围筛选：枚举 vs 自定义日期

**决策**：第一版使用**预设枚举**（全部、本月、本周），后续可扩展自定义

**理由**：
- ✅ **简化 UI**：预设选项降低用户认知负担
- ✅ **快速实现**：避免复杂的日期选择器逻辑
- ✅ **满足主要需求**：覆盖 80% 的使用场景

**实现**：
```swift
enum StatisticsTimeRange: String, CaseIterable {
    case all = "全部"
    case thisMonth = "本月"
    case thisWeek = "本周"
}
```

### 4. 图表库选择：SwiftUI Charts vs 自定义绘制

**决策**：使用 **SwiftUI Charts 框架**

**理由**：
- ✅ **系统内置**：iOS 17+ 原生支持，无需引入依赖
- ✅ **声明式 API**：与 SwiftUI 风格一致
- ✅ **性能优化**：Apple 官方优化，支持动画和交互
- ✅ **可访问性**：自动支持 VoiceOver

**使用场景**：
- 周/月完成趋势曲线（LineMark）
- 习惯分布饼图（SectorMark，可选）

**替代方案**：自定义 Canvas 绘制
- ❌ 开发成本高
- ❌ 需要手动实现可访问性

### 5. 统计视图展示方式：Sheet vs 新 Tab

**决策**：使用 **Sheet（模态弹窗）**方式展示

**理由**：
- ✅ **符合现有设计**：应用已使用 Sheet 展示设置、添加习惯等
- ✅ **焦点体验**：统计页面作为临时查看场景，不需要常驻 Tab
- ✅ **保持底部栏简洁**：不干扰现有的三视图切换逻辑

**实现**：
```swift
// ContentView.swift
@State private var showingStatistics = false

Button("统计") { showingStatistics = true }
.sheet(isPresented: $showingStatistics) {
    StatisticsView()
}
```

### 6. 数据可视化组件设计：单一组件 vs 组合式

**决策**：采用**组合式设计**，拆分为独立的可复用组件

**理由**：
- ✅ **可复用性**：StatisticsCard、ProgressRing 可用于其他场景
- ✅ **易于测试**：小组件独立测试
- ✅ **遵循 SOLID**：单一职责原则

**组件划分**：
- `StatisticsCard`：展示单个指标（标题、数值、图标）
- `ProgressRing`：环形进度条
- `TrendChart`：趋势图（封装 SwiftUI Charts）
- `HabitRankingRow`：排行榜单项

## Risks / Trade-offs

### Risk 1: 性能问题 - 大量打卡记录导致计算延迟

**影响**：如果用户有数千条打卡记录，实时计算可能出现卡顿

**缓解方案**：
1. 使用 `lazy` 计算属性，按需计算
2. 在后台线程计算复杂统计（使用 `Task` 和 `@MainActor`）
3. 如果性能问题明显，V2 引入缓存机制

**监控指标**：统计页面打开耗时应 < 100ms

### Risk 2: 时间计算复杂度 - 跨时区和夏令时

**影响**：用户更换时区后，统计数据可能出现偏差

**缓解方案**：
1. 统一使用 `Calendar.current` 和 `startOfDay(for:)` 处理日期
2. 所有日期比较使用 `calendar.isDate(_:inSameDayAs:)`
3. 参考现有 `getCurrentStreak()` 的实现逻辑

### Risk 3: UI 复杂度 - 过多统计指标导致信息过载

**影响**：用户可能被大量数据淹没，无法聚焦关键信息

**缓解方案**：
1. 遵循"渐进式呈现"原则，首屏仅展示核心指标（3-5 个）
2. 详细数据可滚动查看或展开
3. 使用卡片分组，视觉层次分明

### Risk 4: 空状态处理 - 新用户或无数据场景

**影响**：无打卡记录时，统计页面可能显得空洞

**缓解方案**：
1. 设计友好的空状态提示（Empty State）
2. 展示引导文案，鼓励用户开始打卡
3. 即使无数据，也显示"已创建习惯数"等基础信息

### Trade-off: 精美度 vs 开发速度

**选择**：第一版优先功能完整性，使用简洁的系统组件

**理由**：
- 快速验证统计功能的价值
- 后续可根据用户反馈优化 UI

**后续优化方向**：
- 添加动画过渡效果
- 自定义图表颜色主题
- 引入成就徽章系统

## Migration Plan

**部署步骤**：

1. **代码合并**：
   - 新增文件不影响现有功能
   - Habit 模型扩展为向后兼容方法

2. **数据迁移**：
   - 无需数据库迁移（仅读取现有 completionDates）
   - SwiftData 自动处理模型变更

3. **功能开关**：
   - 无需 Feature Flag，统计按钮已预留，直接激活即可

4. **测试验证**：
   - 单元测试：HabitStatistics 计算逻辑
   - UI 测试：统计页面显示正确
   - 边界测试：空数据、大数据量场景

**回滚策略**：
- 如果统计功能有问题，仅需在 ContentView 中注释掉 `.sheet(isPresented: $showingStatistics)`
- 不影响核心打卡功能

## Open Questions

1. **是否需要导出统计报告？**
   - 当前 Non-Goal，但用户可能有此需求
   - 建议：V1 不做，观察用户反馈

2. **是否支持习惯对比（Habit A vs Habit B）？**
   - 有一定价值，但增加复杂度
   - 建议：V2 评估

3. **统计数据的精度要求？**
   - 完成率保留几位小数？
   - 建议：保留 1 位小数，如 "85.3%"

4. **是否需要统计数据持久化（历史快照）？**
   - 用于查看"上月统计"、"年度回顾"等
   - 建议：V2 功能，需要更复杂的数据模型
