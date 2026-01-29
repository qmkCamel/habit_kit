---
name: verify-debug-logs
description: 验证代码中的 debug 日志是否符合规范，并生成详细的验证报告
license: MIT
compatibility: 适用于所有项目
metadata:
  author: qumeikai
  version: "1.0"
  created: "2026-01-29"
  requires: debug-logging-standard
---

# Debug 日志验证 Skill

自动验证代码中的 debug 日志是否符合 debug-logging-standard 规范，并生成详细的验证报告。

## 使用场景

当用户要求"验证日志"、"检查日志规范"、"生成日志报告"时使用此 skill。

## 验证步骤

### 1. 确定验证范围

**询问用户**：
- 验证哪些文件？（单个文件、目录、整个项目）
- 验证的重点是什么？（格式、覆盖率、内容质量）

**默认行为**：
- 如果用户没有指定，验证当前打开的文件
- 如果是新功能，验证新增/修改的文件

### 2. 读取并分析代码

**分析步骤**：

1. **识别关键代码位置**
   - 函数/方法定义
   - 决策分支（if/switch/guard）
   - 数据转换和计算
   - 异常处理
   - 返回语句

2. **查找现有日志**
   - 搜索 `print(`、`NSLog(`、`os_log(`、`logger.`等日志语句
   - 提取日志内容和位置
   - 分析日志格式

3. **对比规范要求**
   - 检查是否符合 `[标签] 位置 - 动作: 关键信息` 格式
   - 检查日志级别是否合理
   - 检查是否包含必要的上下文信息

### 3. 执行验证检查

#### 检查项列表

**A. 格式规范检查**

- ✅ **日志格式**: 是否符合 `[标签] 位置 - 动作: 信息` 格式
- ✅ **日志级别**: 是否使用正确的级别标签（DEBUG/INFO/WARN/ERROR）
- ✅ **位置标识**: 是否包含类名和方法名
- ✅ **内容完整**: 是否包含关键参数和结果

**B. 覆盖率检查**

- ✅ **入口日志**: 每个关键方法是否有入口日志
- ✅ **决策日志**: 重要的 if/switch 是否有分支日志
- ✅ **结果日志**: 计算结果是否有输出日志
- ✅ **异常日志**: catch 块是否有错误日志

**C. 内容质量检查**

- ✅ **参数记录**: 是否记录了关键输入参数
- ✅ **结果记录**: 是否记录了返回值或计算结果
- ✅ **上下文信息**: 是否提供了足够的上下文
- ✅ **可读性**: 日志信息是否清晰易懂

**D. 最佳实践检查**

- ✅ **无敏感信息**: 是否避免了打印敏感数据
- ✅ **性能考虑**: 是否避免了高频循环中的日志
- ✅ **一致性**: 同类型日志格式是否一致
- ✅ **编译条件**: 是否使用了 #if DEBUG

### 4. 生成验证报告

报告应包含以下部分：

#### 报告模板

```markdown
# Debug 日志验证报告

**文件**: {文件路径}
**验证时间**: {时间戳}
**总体评分**: {分数}/100

---

## 📊 验证总览

| 检查类型 | 通过 | 失败 | 跳过 | 通过率 |
|---------|------|------|------|--------|
| 格式规范 | X    | Y    | Z    | XX%    |
| 覆盖率   | X    | Y    | Z    | XX%    |
| 内容质量 | X    | Y    | Z    | XX%    |
| 最佳实践 | X    | Y    | Z    | XX%    |
| **总计** | X    | Y    | Z    | XX%    |

---

## ✅ 通过的检查项

### 格式规范
- ✅ 日志格式符合规范: 23/25 条日志
- ✅ 日志级别使用正确: 所有日志
- ✅ 包含位置标识: 23/25 条日志

### 覆盖率
- ✅ 所有公开方法都有入口日志
- ✅ 异常处理都有错误日志

---

## ❌ 未通过的检查项

### 格式规范

#### 1. 日志格式不规范 (2 处)

**位置**: `HabitStatistics.swift:45`
```swift
print("开始计算")  // ❌ 缺少标签和位置
```

**建议修改**:
```swift
print("[DEBUG] HabitStatistics.calculate - 开始计算: habitCount=\(habits.count)")
```

---

**位置**: `HabitStatistics.swift:67`
```swift
print("result: \(result)")  // ❌ 缺少上下文
```

**建议修改**:
```swift
print("[DEBUG] HabitStatistics.averageCompletionRate - 计算完成: result=\(String(format: "%.2f", result * 100))%")
```

---

### 覆盖率

#### 2. 缺少决策分支日志 (3 处)

**位置**: `HabitStatistics.swift:89-93`
```swift
if habits.isEmpty {
    return 0  // ❌ 缺少日志
}
```

**建议添加**:
```swift
if habits.isEmpty {
    print("[DEBUG] HabitStatistics.totalCheckIns - 检测到空数据: 返回默认值 0")
    return 0
}
```

---

#### 3. 缺少结果日志 (1 处)

**位置**: `HabitStatistics.swift:120`
```swift
return result  // ❌ 缺少返回值日志
```

**建议添加**:
```swift
print("[DEBUG] HabitStatistics.calculate - 计算完成: result=\(result)")
return result
```

---

### 内容质量

#### 4. 缺少关键参数记录 (2 处)

**位置**: `HabitStatistics.init:15`
```swift
print("[DEBUG] HabitStatistics.init - 初始化")  // ❌ 未记录参数
```

**建议修改**:
```swift
print("[DEBUG] HabitStatistics.init - 初始化: habitCount=\(habits.count), timeRange=\(timeRange.rawValue)")
```

---

## ⚠️ 警告

### 性能警告

**位置**: `HabitStatistics.swift:78-82`
```swift
for habit in habits {
    print("[DEBUG] 处理习惯: \(habit)")  // ⚠️ 循环中打印大对象
}
```

**建议**: 只记录关键字段，避免打印整个对象
```swift
for habit in habits {
    print("[DEBUG] 处理习惯: name=\(habit.name), checkIns=\(habit.completionDates.count)")
}
```

---

## 💡 改进建议

### 优先级 P1（必须修复）
1. ❌ 修复 2 处格式不规范的日志
2. ❌ 添加 3 处缺失的决策分支日志
3. ❌ 添加 1 处缺失的结果日志

### 优先级 P2（建议修复）
4. ⚠️ 优化 2 处参数记录，添加关键信息
5. ⚠️ 优化 1 处循环日志，避免性能问题

### 优先级 P3（可选优化）
6. 💡 考虑添加 #if DEBUG 编译条件
7. 💡 统一日志格式的参数顺序

---

## 📈 质量趋势

**本次验证**: 78/100 分
- 格式规范: 92% (23/25)
- 覆盖率: 80% (8/10)
- 内容质量: 70% (7/10)
- 最佳实践: 70% (7/10)

**改进后预期**: 95/100 分
- 修复所有 P1 问题后预期达到 85 分
- 修复所有 P2 问题后预期达到 95 分

---

## 🎯 下一步行动

1. [ ] 修复 2 处格式不规范的日志
2. [ ] 添加 3 处决策分支日志
3. [ ] 添加 1 处结果日志
4. [ ] 优化 2 处参数记录
5. [ ] 验证修改后重新生成报告

---

**报告生成工具**: verify-debug-logs skill v1.0
**参考规范**: debug-logging-standard
```

### 5. 评分系统

**评分标准**：

- **90-100 分**: 优秀 - 日志规范完善，覆盖全面
- **75-89 分**: 良好 - 大部分符合规范，少量需改进
- **60-74 分**: 及格 - 基本符合规范，有明显改进空间
- **60 分以下**: 不及格 - 需要大量改进

**计算方法**：

```
总分 = (格式规范得分 × 0.3) + (覆盖率得分 × 0.3) + (内容质量得分 × 0.2) + (最佳实践得分 × 0.2)

各项得分 = (通过检查项 / 总检查项) × 100
```

## 实施指南

### 对于单个文件验证

**步骤**：

1. **读取文件**
   ```
   read_file(path="HabitKit/Models/HabitStatistics.swift")
   ```

2. **分析代码结构**
   - 识别所有方法定义
   - 识别决策分支
   - 识别返回语句

3. **查找日志语句**
   ```
   grep_search(path="HabitKit/Models", regex="print\\(")
   ```

4. **执行验证检查**
   - 逐项对照检查清单
   - 记录通过和未通过的项

5. **生成报告**
   - 使用报告模板
   - 填充验证结果
   - 添加具体建议

### 对于目录验证

**步骤**：

1. **列出目录中的文件**
   ```
   list_files(path="HabitKit/Models", recursive=true)
   ```

2. **过滤相关文件**
   - 只验证源代码文件（.swift, .ts, .py 等）
   - 排除测试文件（可选）

3. **批量验证**
   - 对每个文件执行验证
   - 汇总结果

4. **生成综合报告**
   - 包含总体统计
   - 列出每个文件的得分
   - 突出需要改进的文件

### 对于新功能验证

**步骤**：

1. **识别新增/修改的文件**
   ```
   git diff --name-only HEAD~1
   ```

2. **读取变更内容**
   ```
   git diff HEAD~1 -- <file>
   ```

3. **只验证新增的代码**
   - 关注新增的函数
   - 关注修改的逻辑

4. **生成增量报告**
   - 只报告新代码的问题
   - 给出明确的修改建议

## 自动化验证脚本

可以提供一个辅助脚本来自动化验证：

**verify-logs.sh**:
```bash
#!/bin/bash

# 验证指定文件的日志
FILE=$1

echo "=== Debug 日志验证 ==="
echo "文件: $FILE"
echo ""

# 统计日志数量
LOG_COUNT=$(grep -c "print(" "$FILE" || echo 0)
echo "日志总数: $LOG_COUNT"

# 检查格式
FORMATTED_COUNT=$(grep -c "print(\"\[DEBUG\]" "$FILE" || echo 0)
echo "格式正确: $FORMATTED_COUNT"

# 检查方法覆盖
FUNC_COUNT=$(grep -c "func " "$FILE" || echo 0)
echo "方法总数: $FUNC_COUNT"

# 生成简单报告
SCORE=$(( (FORMATTED_COUNT * 100) / (LOG_COUNT + 1) ))
echo ""
echo "格式规范得分: $SCORE/100"

if [ $SCORE -ge 90 ]; then
    echo "评级: ✅ 优秀"
elif [ $SCORE -ge 75 ]; then
    echo "评级: ✅ 良好"
elif [ $SCORE -ge 60 ]; then
    echo "评级: ⚠️ 及格"
else
    echo "评级: ❌ 不及格"
fi
```

## 检查清单详细说明

### 格式规范检查

**1. 日志格式检查**

检查模式：
```regex
\[(?:DEBUG|INFO|WARN|ERROR)\] \w+\.\w+ - .+: .+
```

**通过**:
```swift
print("[DEBUG] HabitStatistics.totalCheckIns - 开始计算: habitCount=5")
```

**不通过**:
```swift
print("totalCheckIns: 5")  // ❌ 缺少标签
print("[DEBUG] 开始计算")   // ❌ 缺少位置
print("[DEBUG] HabitStatistics - count: 5")  // ❌ 缺少方法名
```

**2. 日志级别检查**

- `[DEBUG]`: 正常业务流程
- `[INFO]`: 重要状态变化
- `[WARN]`: 潜在问题
- `[ERROR]`: 错误情况

**通过**:
```swift
print("[DEBUG] 正常计算流程")
print("[ERROR] 计算失败: \(error)")
```

**不通过**:
```swift
print("[FATAL] 错误")  // ❌ 不存在的级别
print("[debug] 日志")  // ❌ 级别标签应大写
```

### 覆盖率检查

**1. 入口日志检查**

每个公开方法应该有入口日志：

**通过**:
```swift
func calculateTotal() -> Int {
    print("[DEBUG] HabitStatistics.calculateTotal - 开始计算")
    // ...
}
```

**不通过**:
```swift
func calculateTotal() -> Int {
    // ❌ 缺少入口日志
    let result = 0
    // ...
}
```

**2. 决策分支检查**

重要的 if/switch 应该有日志：

**通过**:
```swift
if habits.isEmpty {
    print("[DEBUG] HabitStatistics.calculate - 检测到空数据: 返回 0")
    return 0
}
```

**不通过**:
```swift
if habits.isEmpty {
    return 0  // ❌ 缺少分支日志
}
```

**3. 结果日志检查**

计算结果应该记录：

**通过**:
```swift
let result = calculate()
print("[DEBUG] HabitStatistics.calculate - 计算完成: result=\(result)")
return result
```

**不通过**:
```swift
return calculate()  // ❌ 直接返回，无日志
```

### 内容质量检查

**1. 参数记录检查**

**通过**:
```swift
print("[DEBUG] init - 初始化: habitCount=\(habits.count), range=\(timeRange.rawValue)")
```

**不通过**:
```swift
print("[DEBUG] init - 初始化")  // ❌ 未记录参数
```

**2. 结果记录检查**

**通过**:
```swift
print("[DEBUG] calculate - 完成: result=\(result), duration=\(duration)ms")
```

**不通过**:
```swift
print("[DEBUG] calculate - 完成")  // ❌ 未记录结果
```

**3. 上下文信息检查**

**通过**:
```swift
print("[DEBUG] filter - 过滤后: before=\(beforeCount), after=\(afterCount), filtered=\(beforeCount-afterCount)")
```

**不通过**:
```swift
print("[DEBUG] filter - 过滤后: \(afterCount)")  // ❌ 上下文不足
```

### 最佳实践检查

**1. 敏感信息检查**

**不通过**:
```swift
print("[DEBUG] login - 用户: \(username), 密码: \(password)")  // ❌ 打印密码
print("[DEBUG] api - token: \(apiToken)")  // ❌ 打印 token
```

**2. 性能检查**

**不通过**:
```swift
for item in largeArray {
    print("[DEBUG] 处理: \(item)")  // ❌ 高频日志
}
```

**通过**:
```swift
print("[DEBUG] 开始批处理: count=\(largeArray.count)")
for item in largeArray {
    // 处理逻辑
}
print("[DEBUG] 批处理完成")
```

**3. 编译条件检查**

**通过**:
```swift
#if DEBUG
print("[DEBUG] 调试信息")
#endif
```

**建议**:
```swift
print("[DEBUG] 调试信息")  // ⚠️ 建议添加编译条件
```

## 报告输出格式

### Markdown 格式（默认）

适合：
- 保存为文档
- 代码审查
- 知识库

### JSON 格式（自动化）

适合：
- CI/CD 集成
- 自动化测试
- 数据分析

```json
{
  "file": "HabitKit/Models/HabitStatistics.swift",
  "timestamp": "2026-01-29T14:00:00Z",
  "score": 78,
  "checks": {
    "format": {
      "passed": 23,
      "failed": 2,
      "rate": 92
    },
    "coverage": {
      "passed": 8,
      "failed": 2,
      "rate": 80
    }
  },
  "issues": [
    {
      "type": "format",
      "severity": "error",
      "line": 45,
      "message": "日志格式不规范",
      "current": "print(\"开始计算\")",
      "expected": "print(\"[DEBUG] HabitStatistics.calculate - 开始计算: ...\")"
    }
  ]
}
```

### 控制台格式（快速查看）

```
=== Debug 日志验证报告 ===

文件: HabitKit/Models/HabitStatistics.swift
评分: 78/100 (良好)

✅ 通过: 38/50 (76%)
❌ 失败: 12/50 (24%)

主要问题:
  ❌ 格式不规范: 2 处
  ❌ 缺少分支日志: 3 处
  ❌ 缺少结果日志: 1 处

建议优先修复 P1 问题 (6 处)
```

## 使用示例

### 示例 1: 验证单个文件

**用户请求**:
> "验证 HabitStatistics.swift 的日志"

**AI 执行**:
1. 读取文件内容
2. 分析代码结构
3. 查找所有日志
4. 执行验证检查
5. 生成详细报告

**输出**: Markdown 格式的完整报告

### 示例 2: 验证新功能

**用户请求**:
> "验证统计功能的日志是否规范"

**AI 执行**:
1. 识别统计功能相关文件
2. 批量验证多个文件
3. 生成综合报告
4. 突出需要改进的地方

### 示例 3: 快速检查

**用户请求**:
> "快速检查当前文件的日志质量"

**AI 执行**:
1. 验证当前打开的文件
2. 给出简短的评分和建议
3. 列出 Top 3 需要修复的问题

## 总结

通过 verify-debug-logs skill，您可以：

1. ✅ **自动验证**日志是否符合规范
2. ✅ **详细报告**问题所在位置和修改建议
3. ✅ **量化评估**日志质量（评分系统）
4. ✅ **优先排序**需要修复的问题
5. ✅ **持续改进**代码质量

这个 skill 与 debug-logging-standard 配合使用，形成完整的"规范-验证-改进"闭环。
