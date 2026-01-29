---
name: test-verification
description: 结合代码和日志，验证功能测试是否正常执行，并生成详细的验证报告
license: MIT
compatibility: 适用于所有项目
metadata:
  author: qumeikai
  version: "1.0"
  created: "2026-01-29"
  requires: debug-logging-standard
---

# 测试验证 Skill

在手动测试或自动化测试完成后，通过分析测试日志和代码，自动验证功能是否正常执行，并生成详细的验证报告。

## 使用场景

当用户要求"验证测试结果"、"检查功能是否正常"、"分析测试日志"时使用此 skill。

## 核心原则

### 1. 验证的目的
- **流程验证**: 确认所有关键步骤都执行了
- **顺序验证**: 确认执行顺序符合预期
- **数据验证**: 确认数据处理结果正确
- **异常检测**: 发现潜在问题和错误

### 2. 验证依赖

**前置条件**:
- ✅ 代码中有符合 debug-logging-standard 规范的日志
- ✅ 测试执行生成了完整的日志输出
- ✅ 能够访问相关的源代码

## 验证流程

### 步骤 1: 收集测试信息

**需要收集**:

1. **功能信息**
   - 功能名称（如：统计功能）
   - 测试场景（如：查看全部时间统计）
   - 预期行为（如：显示正确的统计数据）

2. **测试日志**
   - 控制台输出（Xcode Console）
   - 日志文件
   - 或测试框架的输出

3. **相关代码**
   - 功能相关的源文件
   - 关键业务逻辑

**询问用户**:
```
请提供以下信息：
1. 测试的功能名称？
2. 测试场景描述？
3. 测试日志（粘贴或文件路径）？
4. 相关代码文件？（如果不指定，我将根据日志自动识别）
```

### 步骤 2: 分析测试日志

**日志分析要点**:

#### A. 提取日志条目

```swift
// 示例日志
[DEBUG] StatisticsView.onAppear - 进入统计页面
[DEBUG] HabitStatistics.init - 初始化: habitCount=5, range=全部
[DEBUG] HabitStatistics.totalCheckIns - 计算总打卡: result=150
[DEBUG] HabitStatistics.averageCompletionRate - 计算完成率: result=85.5%
[DEBUG] StatisticsView.body - 渲染完成
```

**提取信息**:
- 执行的类和方法
- 关键参数值
- 计算结果
- 执行顺序
- 时间戳（如果有）

#### B. 识别执行路径

根据日志重建执行流程：
```
1. 用户进入统计页面 (StatisticsView.onAppear)
2. 初始化统计数据 (HabitStatistics.init)
   - 输入: 5个习惯，全部时间范围
3. 计算总打卡次数 (totalCheckIns)
   - 输出: 150次
4. 计算平均完成率 (averageCompletionRate)
   - 输出: 85.5%
5. 页面渲染完成 (body)
```

#### C. 检测异常

查找日志中的：
- `[ERROR]` 级别的日志
- `[WARN]` 级别的日志
- 异常关键词（"失败"、"错误"、"异常"、"nil"）
- 意外的执行分支

### 步骤 3: 分析相关代码

**代码分析要点**:

#### A. 读取代码

根据日志中出现的类名和方法名，读取相关代码：
```
从日志 "[DEBUG] HabitStatistics.totalCheckIns" 
→ 读取 HabitStatistics.swift
→ 定位到 totalCheckIns 计算属性
```

#### B. 理解业务逻辑

分析代码的：
- 输入参数
- 处理逻辑
- 输出结果
- 可能的分支
- 边界条件

#### C. 建立预期行为

基于代码逻辑，确定：
- 应该执行哪些步骤
- 应该输出什么日志
- 数据应该如何变化

### 步骤 4: 对比验证

**验证检查点**:

#### 1. 流程完整性检查

**验证**:
- ✅ 所有必要的方法都执行了吗？
- ✅ 是否缺少关键步骤？
- ✅ 是否有未预期的步骤？

**示例**:
```
代码中定义的关键方法:
✅ init() - 日志已找到
✅ totalCheckIns - 日志已找到
✅ averageCompletionRate - 日志已找到
✅ topHabitsByCompletionRate - 日志已找到
❌ historicalLongestStreak - 日志未找到（可能未调用）
```

#### 2. 执行顺序检查

**验证**:
- ✅ 执行顺序是否符合逻辑？
- ✅ 是否有依赖关系错误？

**示例**:
```
预期顺序: init → 数据加载 → 计算 → 渲染
实际顺序: init → 数据加载 → 计算 → 渲染
结果: ✅ 顺序正确
```

#### 3. 数据正确性检查

**验证**:
- ✅ 输入数据是否合理？
- ✅ 输出结果是否正确？
- ✅ 数据转换是否准确？

**示例**:
```swift
// 代码逻辑
var totalCheckIns: Int {
    habits.reduce(0) { $0 + $1.getCheckInsInRange(range).count }
}

// 日志显示
[DEBUG] HabitStatistics.totalCheckIns - 计算总打卡: result=150

// 验证
✅ 输入: 5个习惯
✅ 输出: 150次
🔍 推算: 平均每个习惯 30次打卡（合理）
```

#### 4. 异常处理检查

**验证**:
- ✅ 是否有错误日志？
- ✅ 异常是否被正确处理？
- ✅ 是否有资源泄漏？

### 步骤 5: 生成验证报告

## 验证报告模板

```markdown
# 功能测试验证报告

**功能名称**: {功能名称}
**测试场景**: {测试场景描述}
**测试时间**: {测试时间}
**验证时间**: {验证时间}
**验证人**: AI (test-verification skill)

---

## 📊 验证总览

| 验证项 | 状态 | 通过/总数 | 备注 |
|--------|------|-----------|------|
| 流程完整性 | ✅/❌/⚠️ | X/Y | ... |
| 执行顺序 | ✅/❌/⚠️ | X/Y | ... |
| 数据正确性 | ✅/❌/⚠️ | X/Y | ... |
| 异常处理 | ✅/❌/⚠️ | X/Y | ... |
| **总体评估** | ✅/❌/⚠️ | X/Y | ... |

**结论**: ✅ 通过 / ❌ 失败 / ⚠️ 部分通过

---

## 1️⃣ 测试场景描述

### 功能说明
{功能的简要说明}

### 测试场景
{具体的测试场景，如：用户点击统计按钮，查看全部时间的统计数据}

### 预期行为
{期望看到的结果，如：显示总打卡次数、平均完成率、连续天数等统计信息}

---

## 2️⃣ 日志分析

### 日志摘要
```
总日志条数: 25
DEBUG 日志: 23
INFO 日志: 2
WARN 日志: 0
ERROR 日志: 0
```

### 执行流程

**根据日志重建的执行路径**:

```
1. [14:20:15] StatisticsView.onAppear - 进入统计页面
   ↓
2. [14:20:15] HabitStatistics.init - 初始化统计
   参数: habitCount=5, timeRange=全部
   ↓
3. [14:20:15] HabitStatistics.totalCheckIns - 计算总打卡
   结果: 150次
   ↓
4. [14:20:15] HabitStatistics.activeHabitsCount - 计算活跃习惯
   结果: 5个
   ↓
5. [14:20:15] HabitStatistics.averageCompletionRate - 计算平均完成率
   结果: 85.5%
   ↓
6. [14:20:15] HabitStatistics.currentLongestStreak - 计算当前最长连续
   结果: 15天
   ↓
7. [14:20:16] StatisticsView.body - 渲染完成
```

### 关键数据提取

| 数据项 | 值 | 来源 |
|--------|-------|------|
| 习惯总数 | 5 | HabitStatistics.init |
| 总打卡次数 | 150 | totalCheckIns |
| 活跃习惯数 | 5 | activeHabitsCount |
| 平均完成率 | 85.5% | averageCompletionRate |
| 最长连续 | 15天 | currentLongestStreak |

---

## 3️⃣ 代码对比验证

### 流程完整性验证

**代码中定义的关键方法**:

| 方法 | 是否执行 | 日志证据 |
|------|----------|----------|
| `init()` | ✅ 是 | `[DEBUG] HabitStatistics.init` |
| `totalCheckIns` | ✅ 是 | `[DEBUG] HabitStatistics.totalCheckIns` |
| `activeHabitsCount` | ✅ 是 | `[DEBUG] HabitStatistics.activeHabitsCount` |
| `averageCompletionRate` | ✅ 是 | `[DEBUG] HabitStatistics.averageCompletionRate` |
| `currentLongestStreak` | ✅ 是 | `[DEBUG] HabitStatistics.currentLongestStreak` |
| `historicalLongestStreak` | ⚠️ 否 | 未找到相关日志 |
| `topHabitsByCompletionRate` | ⚠️ 否 | 未找到相关日志 |

**分析**:
- ✅ 核心统计功能都已执行
- ⚠️ 部分排名功能可能未在此场景中调用（可能需要滚动或切换标签）

### 执行顺序验证

**代码逻辑分析**:
```swift
// StatisticsView 的渲染逻辑
var body: some View {
    // 1. 首先初始化统计数据
    let statistics = HabitStatistics(habits: habits, timeRange: selectedTimeRange)
    
    // 2. 然后访问各个计算属性
    ScrollView {
        // 显示总打卡
        Text("\(statistics.totalCheckIns)")
        // 显示完成率
        Text("\(statistics.averageCompletionRate)")
        // ...
    }
}
```

**日志顺序**:
```
1. ✅ 初始化 (init)
2. ✅ 计算统计数据 (totalCheckIns, averageCompletionRate, ...)
3. ✅ 渲染完成 (body)
```

**结论**: ✅ 执行顺序符合代码逻辑

### 数据正确性验证

#### 验证 1: 总打卡次数

**代码逻辑**:
```swift
var totalCheckIns: Int {
    let range = timeRange.dateRange
    return habits.reduce(0) { total, habit in
        total + habit.getCheckInsInRange(range).count
    }
}
```

**日志数据**:
```
输入: habitCount=5, timeRange=全部
输出: result=150
```

**验证**:
- ✅ 输入合理（5个习惯）
- ✅ 输出合理（平均每个习惯 30 次打卡）
- 🔍 无法从日志精确验证计算过程（建议增加中间步骤日志）

#### 验证 2: 平均完成率

**代码逻辑**:
```swift
var averageCompletionRate: Double {
    guard !habits.isEmpty else { return 0 }
    let totalRate = habits.reduce(0.0) { $0 + $1.getCompletionRate(in: range) }
    return totalRate / Double(habits.count)
}
```

**日志数据**:
```
输入: habitCount=5
输出: result=85.5%
```

**验证**:
- ✅ 输入合理（5个习惯）
- ✅ 输出合理（85.5% 是一个合理的完成率）
- 🔍 推算: 如果总完成率 85.5%，每个习惯平均约 85.5%（需要更多日志验证）

#### 验证 3: 边界条件

**代码中的边界处理**:
```swift
guard !habits.isEmpty else { return 0 }
```

**日志验证**:
- ⚠️ 未测试空数据场景
- 建议: 添加空数据测试用例

---

## 4️⃣ 异常检测

### 错误日志分析
```
ERROR 日志数: 0
WARN 日志数: 0
```
✅ 无错误或警告

### 潜在问题

#### 问题 1: 缺少某些功能的日志
**严重程度**: ⚠️ 低
**描述**: `historicalLongestStreak` 和 `topHabitsByCompletionRate` 未在日志中出现
**可能原因**: 这些功能可能需要用户滚动到页面底部或切换标签才会触发
**建议**: 
- 扩展测试场景，覆盖完整的用户交互
- 或确认这是预期行为（懒加载）

#### 问题 2: 缺少详细的计算步骤日志
**严重程度**: ⚠️ 低
**描述**: 某些复杂计算（如 reduce）缺少中间步骤的日志
**影响**: 难以精确验证计算过程
**建议**: 
- 在 reduce 循环中添加每次迭代的日志
- 或在计算完成后添加更详细的验证信息

---

## 5️⃣ 性能分析

### 执行时间
```
开始时间: 14:20:15.123
结束时间: 14:20:16.045
总耗时: 922ms
```

**分析**:
- ✅ 总耗时小于 1 秒，性能良好
- ✅ 符合性能要求（统计页面打开耗时 < 100ms 的目标需要重新评估）

### 性能建议
- 考虑对大数据量（100+ 习惯）进行性能测试
- 考虑添加缓存机制

---

## 6️⃣ 测试覆盖度评估

### 已测试场景
✅ 正常数据场景（5个习惯，150次打卡）
✅ 全部时间范围

### 未测试场景
❌ 边界条件
  - 空数据（0个习惯）
  - 单个习惯
  - 大量数据（100+ 习惯）
  
❌ 其他时间范围
  - 本月
  - 本周
  
❌ 异常场景
  - 数据损坏
  - 极端数值

### 覆盖度评分
**场景覆盖度**: 30% (3/10)
**代码覆盖度**: 70% (7/10 方法)

---

## 7️⃣ 改进建议

### 优先级 P1（必须改进）
1. ❌ 无 P1 问题

### 优先级 P2（建议改进）
1. ⚠️ 添加更详细的计算步骤日志
   - 位置: HabitStatistics.totalCheckIns, averageCompletionRate
   - 建议: 在 reduce 中记录每次迭代
   
2. ⚠️ 扩展测试场景
   - 添加边界条件测试（空数据、单个习惯）
   - 测试其他时间范围（本月、本周）

### 优先级 P3（可选优化）
1. 💡 添加性能监控日志
   - 记录关键操作的耗时
   - 便于性能分析和优化

2. 💡 添加数据验证日志
   - 在计算前后添加数据一致性检查
   - 便于发现数据异常

---

## 8️⃣ 验证结论

### 总体评估

**功能状态**: ✅ 正常

**评分**: 85/100

**详细评分**:
- 流程完整性: 90/100 (大部分关键流程已执行)
- 执行顺序: 100/100 (完全符合预期)
- 数据正确性: 80/100 (数据合理，但缺少详细验证)
- 异常处理: 100/100 (无错误)
- 性能表现: 90/100 (性能良好)
- 测试覆盖度: 50/100 (覆盖基本场景)

### 结论陈述

✅ **测试通过**

根据对测试日志和代码的综合分析，统计功能在当前测试场景下运行正常：

**优点**:
1. ✅ 所有核心统计功能正常执行
2. ✅ 执行顺序符合逻辑
3. ✅ 无错误或警告
4. ✅ 性能表现良好（< 1秒）
5. ✅ 数据输出合理

**不足**:
1. ⚠️ 测试场景覆盖度较低（仅测试了基本场景）
2. ⚠️ 部分功能未在当前场景中触发
3. ⚠️ 缺少详细的计算过程验证

**建议**:
1. 扩展测试用例，覆盖边界条件和异常场景
2. 添加更详细的日志，便于深度验证
3. 进行性能测试，验证大数据量下的表现

### 下一步行动

**立即行动** (P1):
- 无需立即行动，功能正常

**建议行动** (P2):
1. [ ] 添加边界条件测试用例
2. [ ] 测试本月、本周时间范围
3. [ ] 添加详细的计算步骤日志

**可选行动** (P3):
1. [ ] 进行大数据量性能测试
2. [ ] 添加自动化测试脚本
3. [ ] 完善异常场景测试

---

**报告生成**: test-verification skill v1.0
**参考规范**: debug-logging-standard
**验证方法**: 日志分析 + 代码对比
```

## 实施指南

### 对于手动测试验证

**场景**: 用户在真机上手动测试了统计功能

**步骤**:

1. **收集测试日志**
   ```
   用户: "我测试了统计功能，这是 Xcode Console 的日志（粘贴日志）"
   ```

2. **AI 执行验证**
   - 分析日志，提取执行流程
   - 读取相关代码（StatisticsView.swift, HabitStatistics.swift）
   - 对比验证
   - 生成报告

3. **输出报告**
   - Markdown 格式的完整验证报告
   - 指出问题和改进建议

### 对于自动化测试验证

**场景**: 运行了 XCTest 测试套件

**步骤**:

1. **收集测试输出**
   ```bash
   xcodebuild test -scheme HabitKit 2>&1 | tee test_output.log
   ```

2. **AI 执行验证**
   - 解析测试输出
   - 提取每个测试用例的日志
   - 验证每个用例的执行情况
   - 汇总报告

3. **输出综合报告**
   - 包含所有测试用例的验证结果
   - 汇总统计信息

### 对于 CI/CD 集成

**在 CI 流程中使用**:

```yaml
# .github/workflows/test.yml
- name: Run Tests
  run: xcodebuild test -scheme HabitKit | tee test_output.log

- name: Verify Test Results
  run: |
    # 调用 AI 验证（需要 API 集成）
    ./scripts/verify-test-results.sh test_output.log
```

## 验证算法

### 流程完整性评分

```
流程完整性 = (已执行的关键方法数 / 预期执行的关键方法数) × 100
```

**关键方法识别**:
- 代码中定义的所有 public 方法
- 标记为 @MainActor 的方法
- 计算属性（var xxx: Type { ... }）

### 数据正确性评分

```
数据正确性 = Σ(单项验证得分) / 验证项数
```

**单项验证**:
- ✅ 100分: 数据精确匹配预期
- ⚠️ 70分: 数据在合理范围内，但无法精确验证
- ❌ 0分: 数据明显错误

### 总体评分

```
总分 = 流程完整性 × 0.3 + 执行顺序 × 0.2 + 数据正确性 × 0.3 + 异常处理 × 0.1 + 性能 × 0.1
```

**评级**:
- **90-100**: ✅ 优秀 - 测试通过，质量高
- **75-89**: ✅ 良好 - 测试通过，有小瑕疵
- **60-74**: ⚠️ 及格 - 部分通过，需要改进
- **60以下**: ❌ 不及格 - 测试失败

## 日志要求

为了获得最佳验证效果，日志应该：

1. **符合 debug-logging-standard 规范**
   ```swift
   print("[DEBUG] ClassName.methodName - 动作: key=value")
   ```

2. **记录关键数据**
   - 输入参数
   - 中间结果
   - 最终输出

3. **记录执行路径**
   - 入口日志
   - 分支选择
   - 出口日志

4. **包含时间戳**（如果可能）
   ```swift
   let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
   print("[\(timestamp)] [DEBUG] ...")
   ```

## 高级特性

### 1. 自动问题诊断

当检测到问题时，AI 可以：
- 分析可能的原因
- 提供修复建议
- 给出示例代码

**示例**:
```
检测到问题: totalCheckIns 未执行

可能原因:
1. 视图未渲染该部分（懒加载）
2. 条件分支导致跳过
3. 代码逻辑错误

建议:
- 检查 SwiftUI 视图层级
- 添加强制触发的测试用例
- 检查 if/guard 条件
```

### 2. 性能回归检测

对比历史测试数据：
```
本次测试: 922ms
上次测试: 450ms
差异: +104% ⚠️ 性能退化

可能原因:
- 数据量增加
- 算法效率下降
- 新增了额外的计算

建议: 进行性能分析
```

### 3. 数据一致性验证

验证数据在整个流程中的一致性：
```
init: habitCount=5
totalCheckIns: 输入 5个习惯
averageCompletionRate: 输入 5个习惯
✅ 数据一致

如果不一致:
❌ 数据不一致检测到:
init: habitCount=5
totalCheckIns: 处理 4个习惯
原因: 可能在中间过程中过滤了数据
```

## 使用示例

### 示例 1: 手动测试验证

**用户**:
```
我测试了统计功能，点击了统计按钮，看到了数据。
这是日志：
[DEBUG] StatisticsView.onAppear - 进入统计页面
[DEBUG] HabitStatistics.init - 初始化: habitCount=5, range=全部
[DEBUG] HabitStatistics.totalCheckIns - 计算总打卡: result=150
[DEBUG] StatisticsView.body - 渲染完成
```

**AI 响应**:
1. 分析日志，提取执行流程
2. 读取 StatisticsView.swift 和 HabitStatistics.swift
3. 对比验证
4. 生成完整报告

**输出**: Markdown 格式的验证报告

### 示例 2: 自动化测试验证

**用户**:
```
/verify-test 运行了 testStatisticsCalculation 测试
```

**AI 响应**:
1. 读取测试代码
2. 分析测试输出
3. 验证断言是否通过
4. 检查日志完整性
5. 生成报告

### 示例 3: 问题诊断

**用户**:
```
测试失败了，不知道哪里有问题。日志：
[ERROR] HabitStatistics.init - 初始化失败: habits is empty
```

**AI 响应**:
1. 检测到错误日志
2. 分析错误原因（习惯列表为空）
3. 检查代码中的边界处理
4. 给出诊断报告：
   - 问题: 空数据传入
   - 原因: 测试数据未正确准备
   - 建议: 在测试前添加数据初始化

## 报告格式选项

### 1. 详细报告（默认）
- 完整的分析过程
- 所有验证细节
- 适合代码审查和归档

### 2. 简洁报告
- 只包含总览和结论
- 适合快速查看

### 3. JSON 格式
- 结构化数据
- 适合工具集成

```json
{
  "feature": "统计功能",
  "status": "passed",
  "score": 85,
  "checks": {
    "completeness": { "score": 90, "status": "passed" },
    "order": { "score": 100, "status": "passed" },
    "data": { "score": 80, "status": "warning" }
  },
  "issues": [
    {
      "severity": "warning",
      "type": "coverage",
      "message": "部分方法未执行"
    }
  ]
}
```

## 最佳实践

### ✅ DO（应该这样做）

1. **提供完整的测试上下文**
   - 说明测试的功能
   - 描述测试场景
   - 提供完整日志

2. **使用规范的日志**
   - 遵循 debug-logging-standard
   - 包含关键数据
   - 记录执行路径

3. **多场景测试**
   - 正常场景
   - 边界条件
   - 异常场景

### ❌ DON'T（不要这样做）

1. **不要只提供部分日志**
   - 可能导致验证不准确

2. **不要忽略警告**
   - 警告可能预示潜在问题

3. **不要跳过边界测试**
   - 边界条件往往是 bug 的来源

## 总结

test-verification skill 帮助您：

1. ✅ **自动验证**功能测试是否正常
2. ✅ **深度分析**日志和代码
3. ✅ **发现问题**和潜在风险
4. ✅ **生成报告**详细且可追溯
5. ✅ **提供建议**具体且可执行

通过结合代码分析和日志验证，这个 skill 提供了比单纯看日志或代码更深入的洞察，帮助确保功能质量。
