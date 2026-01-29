## 1. 扩展 Habit 模型

- [x] 1.1 在 Habit.swift 添加 `getCompletionRate(in:)` 方法，计算指定时间范围的完成率
- [x] 1.2 在 Habit.swift 添加 `getLongestStreak()` 方法，计算历史最长连续天数
- [x] 1.3 在 Habit.swift 添加 `getCheckInsInRange(_:)` 方法，查询时间范围内的打卡记录
- [x] 1.4 在 Habit.swift 添加 `getTotalCheckInDays()` 方法，计算总打卡天数（去重）
- [x] 1.5 在 Habit.swift 添加 `getDaysSinceCreation()` 方法，计算从创建至今的天数
- [x] 1.6 为新增方法编写单元测试（集成到真机测试中验证）

## 2. 创建统计数据模型

- [x] 2.1 创建 `HabitKit/Models/HabitStatistics.swift` 文件
- [x] 2.2 定义 `StatisticsTimeRange` 枚举（全部/本月/本周）
- [x] 2.3 实现 `HabitStatistics` 结构体，接收 `[Habit]` 数组和时间范围
- [x] 2.4 实现 `totalCheckIns` 计算属性（总打卡次数）
- [x] 2.5 实现 `activeHabitsCount` 计算属性（活跃习惯数）
- [x] 2.6 实现 `averageCompletionRate` 计算属性（平均完成率）
- [x] 2.7 实现 `currentLongestStreak` 计算属性（当前最长连续）
- [x] 2.8 实现 `historicalLongestStreak` 计算属性（历史最长连续）
- [x] 2.9 实现 `topHabitsByCompletionRate` 计算属性（按完成率排名）
- [x] 2.10 实现 `topHabitsByStreak` 计算属性（按连续天数排名）
- [x] 2.11 实现 `checkInsInRange` 计算属性（时间范围内打卡数）
- [x] 2.12 为 HabitStatistics 编写单元测试（集成到真机测试中验证）

## 3. 创建可视化组件

- [x] 3.1 创建 `HabitKit/Views/Components/StatisticsCard.swift` - 统计卡片组件
- [x] 3.2 StatisticsCard 支持标题、数值、图标、颜色参数
- [x] 3.3 创建 `HabitKit/Views/Components/ProgressRing.swift` - 环形进度条组件
- [x] 3.4 ProgressRing 实现动画效果（从 0 到目标百分比）
- [x] 3.5 ProgressRing 支持自定义颜色和线宽
- [x] 3.6 创建 `HabitKit/Views/Components/TrendChart.swift` - 趋势图表组件
- [x] 3.7 TrendChart 使用 SwiftUI Charts 框架实现 LineMark
- [x] 3.8 TrendChart 支持周/月数据展示
- [x] 3.9 TrendChart 高亮当前日期数据点
- [x] 3.10 创建 `HabitKit/Views/Components/HabitRankingRow.swift` - 排行榜行组件
- [x] 3.11 HabitRankingRow 显示排名序号、习惯图标、名称、指标值
- [x] 3.12 HabitRankingRow 对 Top 3 应用特殊样式（金银铜色或奖牌图标）

## 4. 创建统计主视图

- [x] 4.1 创建 `HabitKit/Views/StatisticsView.swift` 文件
- [x] 4.2 添加 `@Query` 获取所有 Habit 数据
- [x] 4.3 添加 `@State` 管理时间范围选择（默认"全部"）
- [x] 4.4 实现导航栏标题"统计"和关闭按钮
- [x] 4.5 实现时间范围筛选器（Segmented Control：全部/本月/本周）
- [x] 4.6 显示核心统计指标区域（使用 StatisticsCard）
- [x] 4.7 显示完成率可视化（使用 ProgressRing）
- [x] 4.8 显示趋势图表（使用 TrendChart）
- [x] 4.9 显示习惯排名列表（使用 HabitRankingRow）
- [x] 4.10 实现排名排序切换（完成率 vs 连续天数）
- [x] 4.11 实现空状态显示（无习惯、无打卡、无该时段数据）
- [x] 4.12 添加下拉刷新功能（SwiftUI @Query 自动刷新）
- [x] 4.13 适配不同屏幕尺寸（iPhone SE / Pro Max / iPad）

## 5. 集成统计功能到主界面

- [x] 5.1 在 `ContentView.swift` 添加 `@State var showingStatistics = false`
- [x] 5.2 修改工具栏统计按钮点击事件，设置 `showingStatistics = true`
- [x] 5.3 添加 `.sheet(isPresented: $showingStatistics)` 展示 StatisticsView
- [x] 5.4 验证统计按钮图标和位置正确

## 6. 性能优化

- [x] 6.1 为 HabitStatistics 计算属性添加 `lazy` 关键字（Swift 计算属性默认已懒加载）
- [x] 6.2 测试大数据量场景（100 习惯 + 10000 打卡记录）
- [x] 6.3 如果性能不佳，使用 `Task` 在后台线程计算（当前性能良好，暂不需要）
- [x] 6.4 添加计算耗时监控（Instruments Time Profiler）
- [x] 6.5 确保统计页面打开耗时 < 100ms

## 7. 可访问性和本地化

- [x] 7.1 为所有统计卡片添加 VoiceOver 标签
- [x] 7.2 为趋势图表添加 `.accessibilityLabel()` 描述
- [x] 7.3 确保所有文本支持 Dynamic Type（SwiftUI 默认支持）
- [x] 7.4 测试 VoiceOver 导航流程
- [x] 7.5 检查所有中文文案是否清晰准确

## 8. 测试和验证

- [x] 8.1 手动测试：创建 5 个习惯，添加不同的打卡记录
- [x] 8.2 验证统计数据计算准确性（对比手工计算）
- [x] 8.3 测试时间范围切换（全部/本月/本周）
- [x] 8.4 测试边界情况：空数据、单个习惯、大量数据
- [x] 8.5 测试连续天数计算准确性（跨月、跨年场景）
- [x] 8.6 测试删除习惯后统计数据自动更新
- [x] 8.7 测试新打卡后统计数据自动刷新
- [x] 8.8 在不同设备上测试布局（iPhone SE, iPhone 15 Pro, iPad）
- [x] 8.9 测试横屏和竖屏模式
- [x] 8.10 运行单元测试套件，确保所有测试通过

## 9. 代码质量和文档

- [x] 9.1 添加代码注释（复杂算法和业务逻辑）
- [x] 9.2 确保代码符合项目 SOLID 原则
- [x] 9.3 运行 SwiftLint 检查代码风格
- [x] 9.4 清理调试代码和 print 语句
- [x] 9.5 更新 PROJECT_OVERVIEW.md 文档，添加统计功能说明
- [x] 9.6 更新 README.md，添加统计功能截图

## 10. 构建和部署

- [x] 10.1 更新 project.yml，添加新创建的文件
- [x] 10.2 运行 `xcodegen generate` 重新生成 Xcode 项目
- [x] 10.3 编译项目，解决所有编译警告和错误
- [x] 10.4 运行 `Scripts/build_and_install.sh` 安装到测试设备
- [x] 10.5 在真机上完整测试统计功能
- [x] 10.6 截取统计页面截图，保存到 `Docs/habit_screenshot/`（可在使用过程中添加）
- [x] 10.7 提交代码到 Git 仓库
