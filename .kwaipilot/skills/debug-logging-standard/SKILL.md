---
name: debug-logging-standard
description: Debug 日志使用规范。在业务开发过程中，在关键位置写入 debug 日志，用于手动测试或自动化测试阶段进行功能验证。
license: MIT
compatibility: 适用于所有项目
metadata:
  author: qumeikai
  version: "1.0"
  created: "2026-01-29"
---

# Debug 日志使用规范

在业务开发过程中规范化使用 debug 日志，确保关键业务逻辑可追踪、可验证。

## 使用场景

当用户要求"添加 debug 日志"、"规范日志"、"在关键位置打日志"时使用此 skill。

## 核心原则

### 1. 日志的目的
- **可验证性**: 通过日志验证功能是否执行
- **可追踪性**: 通过日志追踪业务流程
- **可调试性**: 通过日志快速定位问题

### 2. 何时添加日志

**必须添加日志的位置**:
- ✅ **业务入口**: 函数/方法开始执行时
- ✅ **关键决策点**: if/switch 的分支选择
- ✅ **数据转换**: 重要的数据处理前后
- ✅ **外部调用**: API 请求、数据库操作、文件 I/O
- ✅ **异常处理**: catch 块、错误处理逻辑
- ✅ **业务出口**: 函数返回前（特别是多个返回点时）

**不建议添加日志的位置**:
- ❌ 简单的 getter/setter
- ❌ 纯 UI 渲染逻辑（除非是关键交互）
- ❌ 过于频繁执行的循环内部（可以记录循环总数）

## 日志格式规范

### Swift 项目日志格式

```swift
// 格式: [标签] 位置 - 动作: 关键信息
print("[DEBUG] ClassName.methodName - Action: key=value, key2=value2")
```

### 日志级别标签

- `[DEBUG]`: 调试信息，记录业务流程
- `[INFO]`: 一般信息，记录重要状态
- `[WARN]`: 警告信息，不影响功能但需要注意
- `[ERROR]`: 错误信息，功能执行失败

### 日志内容要求

**✅ 好的日志示例**:
```swift
// 入口日志 - 记录输入参数
print("[DEBUG] HabitStatistics.init - 初始化统计: habitCount=\(habits.count), timeRange=\(timeRange.rawValue)")

// 决策日志 - 记录分支选择
print("[DEBUG] Habit.getCompletionRate - 计算完成率: startDate=\(startDate), endDate=\(endDate), totalDays=\(totalDays)")

// 结果日志 - 记录输出结果
print("[DEBUG] HabitStatistics.averageCompletionRate - 计算完成: result=\(String(format: "%.2f", result * 100))%")

// 异常日志 - 记录错误信息
print("[ERROR] Habit.toggleCompletion - 切换失败: habitId=\(id), date=\(date), error=\(error.localizedDescription)")
```

**❌ 不好的日志示例**:
```swift
// ❌ 太简单，无法验证
print("开始")

// ❌ 没有上下文
print("count: \(count)")

// ❌ 信息过多，难以阅读
print("habit: \(habit)")  // 打印整个对象
```

## 实施步骤

当用户要求添加 debug 日志时，按以下步骤执行：

### 1. 识别关键路径

分析代码，识别需要添加日志的关键位置：
- 列出所有业务方法
- 标记决策分支
- 找出数据转换点

### 2. 添加入口日志

在每个关键方法开始处添加日志：
```swift
func calculateStatistics(habits: [Habit], timeRange: StatisticsTimeRange) {
    print("[DEBUG] calculateStatistics - 开始计算: habitCount=\(habits.count), range=\(timeRange.rawValue)")
    // ... 业务逻辑
}
```

### 3. 添加决策日志

在 if/switch/guard 等分支处添加日志：
```swift
if habits.isEmpty {
    print("[DEBUG] calculateStatistics - 检测到空数据: 返回默认值")
    return defaultValue
}

switch timeRange {
case .all:
    print("[DEBUG] calculateStatistics - 使用全部时间范围")
case .thisMonth:
    print("[DEBUG] calculateStatistics - 使用本月时间范围")
case .thisWeek:
    print("[DEBUG] calculateStatistics - 使用本周时间范围")
}
```

### 4. 添加结果日志

在方法返回前添加日志：
```swift
let result = calculate()
print("[DEBUG] calculateStatistics - 计算完成: result=\(result)")
return result
```

### 5. 验证日志有效性

添加日志后，进行验证：
- ✅ 每个日志是否有唯一标识（类名+方法名）？
- ✅ 日志是否包含关键信息（参数、结果）？
- ✅ 日志是否可以串联起完整的业务流程？
- ✅ 通过日志能否判断功能是否正确执行？

## 测试验证指南

### 手动测试验证

1. **执行功能**: 运行应用，触发业务逻辑
2. **查看日志**: 在 Xcode Console 或设备日志中查看
3. **验证流程**: 确认日志按预期顺序出现
4. **检查数据**: 确认日志中的数据正确

**示例验证清单**:
```
✅ [DEBUG] StatisticsView.onAppear - 进入统计页面
✅ [DEBUG] HabitStatistics.init - 初始化: habitCount=5, range=全部
✅ [DEBUG] HabitStatistics.totalCheckIns - 计算总打卡: result=150
✅ [DEBUG] HabitStatistics.averageCompletionRate - 计算完成率: result=85.5%
✅ [DEBUG] StatisticsView.body - 渲染完成
```

### 自动化测试验证

1. **捕获日志**: 在测试中重定向 print 输出
2. **断言日志**: 验证特定日志是否出现
3. **验证顺序**: 确认日志出现顺序正确
4. **检查内容**: 使用正则表达式验证日志格式

**Swift 测试示例**:
```swift
func testStatisticsCalculation() {
    // 重定向日志输出
    let logCapture = LogCapture()
    
    // 执行业务逻辑
    let stats = HabitStatistics(habits: testHabits, timeRange: .all)
    _ = stats.totalCheckIns
    
    // 验证日志
    XCTAssertTrue(logCapture.contains("[DEBUG] HabitStatistics.init"))
    XCTAssertTrue(logCapture.contains("habitCount=5"))
    XCTAssertTrue(logCapture.contains("[DEBUG] HabitStatistics.totalCheckIns"))
}
```

## 日志清理规范

### 何时保留日志

- ✅ 核心业务逻辑的日志（长期保留）
- ✅ 复杂算法的关键步骤（长期保留）
- ✅ 用户交互的关键路径（长期保留）

### 何时移除日志

- ❌ 临时调试日志（问题解决后移除）
- ❌ 过于详细的中间步骤（精简为关键节点）
- ❌ 性能敏感路径的高频日志（移除或改为条件日志）

### 生产环境处理

**方案 1: 编译条件**
```swift
#if DEBUG
print("[DEBUG] 详细的调试信息")
#endif
```

**方案 2: 日志等级控制**
```swift
enum LogLevel {
    case debug, info, warn, error
}

func log(_ message: String, level: LogLevel = .debug) {
    #if DEBUG
    print("[\(level)] \(message)")
    #endif
}
```

## 项目实施建议

### 新功能开发

1. **开发阶段**: 添加详细的 debug 日志
2. **测试阶段**: 通过日志验证功能正确性
3. **优化阶段**: 保留关键日志，移除冗余日志
4. **发布阶段**: 使用编译条件控制日志输出

### 现有代码改进

1. **识别关键模块**: 优先为核心业务添加日志
2. **渐进式添加**: 每次添加一个模块的日志
3. **测试验证**: 每次添加后进行验证
4. **文档记录**: 在代码注释中说明日志用途

## 最佳实践

### ✅ DO（应该这样做）

- 使用统一的日志格式
- 记录输入参数和输出结果
- 在异常处理中添加详细日志
- 使用有意义的标识符（类名+方法名）
- 记录决策分支的选择原因

### ❌ DON'T（不要这样做）

- 不要打印敏感信息（密码、token）
- 不要在循环中打印大量日志
- 不要使用模糊的日志信息
- 不要忘记移除临时调试日志
- 不要在生产环境保留所有 debug 日志

## 示例：为统计功能添加日志

**原始代码**:
```swift
var totalCheckIns: Int {
    let range = timeRange.dateRange
    return habits.reduce(0) { total, habit in
        total + habit.getCheckInsInRange(range).count
    }
}
```

**添加日志后**:
```swift
var totalCheckIns: Int {
    print("[DEBUG] HabitStatistics.totalCheckIns - 开始计算: habitCount=\(habits.count), range=\(timeRange.rawValue)")
    
    let range = timeRange.dateRange
    let result = habits.reduce(0) { total, habit in
        let checkIns = habit.getCheckInsInRange(range).count
        print("[DEBUG] HabitStatistics.totalCheckIns - 累加习惯: habitName=\(habit.name), checkIns=\(checkIns)")
        return total + checkIns
    }
    
    print("[DEBUG] HabitStatistics.totalCheckIns - 计算完成: totalCheckIns=\(result)")
    return result
}
```

**验证测试**:
```
预期日志输出:
[DEBUG] HabitStatistics.totalCheckIns - 开始计算: habitCount=3, range=全部
[DEBUG] HabitStatistics.totalCheckIns - 累加习惯: habitName=跑步, checkIns=20
[DEBUG] HabitStatistics.totalCheckIns - 累加习惯: habitName=阅读, checkIns=15
[DEBUG] HabitStatistics.totalCheckIns - 累加习惯: habitName=冥想, checkIns=10
[DEBUG] HabitStatistics.totalCheckIns - 计算完成: totalCheckIns=45
```

## 工具和辅助

### 日志查看工具

- **Xcode Console**: 开发时实时查看
- **Console.app**: Mac 系统日志查看器
- **grep/ack**: 命令行日志搜索
- **日志分析脚本**: 自动化验证日志

### 日志搜索技巧

```bash
# 搜索特定功能的日志
grep "\[DEBUG\] HabitStatistics" console.log

# 统计日志出现次数
grep -c "\[DEBUG\] totalCheckIns" console.log

# 提取关键数据
grep -o "totalCheckIns=\[0-9\]*" console.log
```

## 总结

规范的 debug 日志是：
1. **有标识**: 明确标注类名和方法名
2. **有内容**: 包含关键参数和结果
3. **有格式**: 统一的日志格式
4. **有用途**: 可用于测试验证
5. **有节制**: 不过度、不遗漏

通过规范化的日志，我们可以：
- ✅ 快速定位问题
- ✅ 验证功能正确性
- ✅ 追踪业务流程
- ✅ 提高代码质量
