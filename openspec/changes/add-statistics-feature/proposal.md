## Why

HabitKit 目前缺少数据分析和统计功能，用户无法直观了解自己的习惯养成进展和整体表现。添加统计功能可以帮助用户：
- 量化自己的进步，增强成就感和持续动力
- 识别表现最好和需要改进的习惯
- 通过数据可视化发现习惯养成的规律和趋势
- 设定和追踪长期目标

## What Changes

- **新增统计概览页面**：展示全局统计数据和关键指标
- **新增统计数据模型**：计算和聚合各种统计指标
- **增强 Habit 模型**：添加统计相关的计算方法
- **添加统计可视化组件**：图表、进度条、成就徽章等
- **集成统计入口**：在主界面工具栏添加统计按钮（已有占位符）

## Capabilities

### New Capabilities

- `statistics-calculation`: 统计数据计算引擎，包括：
  - 总体统计：总打卡天数、活跃习惯数、平均完成率
  - 连续记录：当前最长连续、历史最长连续
  - 时间段统计：本周/本月/全部时间的完成情况
  - 习惯排名：按完成率、连续天数等维度排序

- `statistics-visualization`: 统计数据可视化组件，包括：
  - 统计卡片：展示单个指标的卡片组件
  - 进度环：环形进度条显示完成率
  - 趋势图表：周/月完成趋势曲线
  - 排行榜：习惯表现排名列表

- `statistics-view`: 统计页面视图，包括：
  - 概览页面：展示核心统计指标
  - 详细分析：可展开查看更多数据
  - 时间筛选：切换不同时间范围的统计

### Modified Capabilities

- `habit-model`: 扩展 Habit 模型以支持统计功能
  - 添加完成率计算方法
  - 添加最长连续天数计算
  - 添加指定时间范围内的统计查询

## Impact

### 代码影响
- **新增文件**：
  - `HabitKit/Models/HabitStatistics.swift` - 统计数据模型
  - `HabitKit/Views/StatisticsView.swift` - 统计主视图
  - `HabitKit/Views/Components/StatisticsCard.swift` - 统计卡片组件
  - `HabitKit/Views/Components/ProgressRing.swift` - 环形进度组件
  
- **修改文件**：
  - `HabitKit/Models/Habit.swift` - 添加统计相关方法
  - `HabitKit/App/ContentView.swift` - 连接统计按钮到统计视图

### 依赖
- 使用 SwiftUI Charts 框架（iOS 17+ 内置）
- 依赖现有的 SwiftData 持久化层
- 无需引入外部依赖

### 用户体验
- 提供数据洞察，提升用户参与度
- 通过可视化增强应用的专业性和吸引力
- 不影响现有的网格、列表、详情三种视图模式
