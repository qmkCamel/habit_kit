#!/bin/bash

# Debug 日志验证脚本
# 用法: ./verify-logs.sh <文件路径>

FILE="$1"

if [ -z "$FILE" ]; then
    echo "用法: $0 <文件路径>"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "错误: 文件不存在: $FILE"
    exit 1
fi

echo "==================================="
echo "  Debug 日志验证"
echo "==================================="
echo "文件: $FILE"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 统计日志数量
LOG_COUNT=$(grep -c "print(" "$FILE" 2>/dev/null || echo "0")
LOG_COUNT=$(echo "$LOG_COUNT" | tr -d '\n\r ')
echo "📊 日志统计"
echo "  总日志数: $LOG_COUNT"

# 检查格式
FORMATTED_COUNT=$(grep -c 'print("\[DEBUG\]' "$FILE" 2>/dev/null || echo "0")
FORMATTED_COUNT=$(echo "$FORMATTED_COUNT" | tr -d '\n\r ')
INFO_COUNT=$(grep -c 'print("\[INFO\]' "$FILE" 2>/dev/null || echo "0")
INFO_COUNT=$(echo "$INFO_COUNT" | tr -d '\n\r ')
WARN_COUNT=$(grep -c 'print("\[WARN\]' "$FILE" 2>/dev/null || echo "0")
WARN_COUNT=$(echo "$WARN_COUNT" | tr -d '\n\r ')
ERROR_COUNT=$(grep -c 'print("\[ERROR\]' "$FILE" 2>/dev/null || echo "0")
ERROR_COUNT=$(echo "$ERROR_COUNT" | tr -d '\n\r ')

TOTAL_FORMATTED=$((FORMATTED_COUNT + INFO_COUNT + WARN_COUNT + ERROR_COUNT))

echo "  格式正确: $TOTAL_FORMATTED"
echo "    [DEBUG]: $FORMATTED_COUNT"
echo "    [INFO]:  $INFO_COUNT"
echo "    [WARN]:  $WARN_COUNT"
echo "    [ERROR]: $ERROR_COUNT"

# 检查方法和属性覆盖
FUNC_COUNT=$(grep -E "^\s*(func |var .+\{)" "$FILE" 2>/dev/null | wc -l | tr -d ' \n\r')
echo ""
echo "📈 覆盖率统计"
echo "  方法/属性总数: $FUNC_COUNT"

# 计算评分
if [ "$LOG_COUNT" -eq 0 ]; then
    FORMAT_SCORE=0
else
    FORMAT_SCORE=$(( (TOTAL_FORMATTED * 100) / LOG_COUNT ))
fi

# 简单的覆盖率估算（每个方法至少应该有1个日志）
if [ "$FUNC_COUNT" -eq 0 ]; then
    COVERAGE_SCORE=100
elif [ "$LOG_COUNT" -ge "$FUNC_COUNT" ]; then
    COVERAGE_SCORE=100
else
    COVERAGE_SCORE=$(( (LOG_COUNT * 100) / FUNC_COUNT ))
    if [ "$COVERAGE_SCORE" -gt 100 ]; then
        COVERAGE_SCORE=100
    fi
fi

# 计算总分
TOTAL_SCORE=$(( (FORMAT_SCORE * 40 + COVERAGE_SCORE * 60) / 100 ))

echo ""
echo "==================================="
echo "  验证结果"
echo "==================================="
echo "格式规范得分: $FORMAT_SCORE/100"
echo "覆盖率得分:   $COVERAGE_SCORE/100"
echo "总体得分:     $TOTAL_SCORE/100"
echo ""

# 评级
if [ "$TOTAL_SCORE" -ge 90 ]; then
    echo "评级: ✅ 优秀"
    exit 0
elif [ "$TOTAL_SCORE" -ge 75 ]; then
    echo "评级: ✅ 良好"
    exit 0
elif [ "$TOTAL_SCORE" -ge 60 ]; then
    echo "评级: ⚠️  及格"
    exit 0
else
    echo "评级: ❌ 不及格"
    echo ""
    echo "建议:"
    if [ "$FORMAT_SCORE" -lt 60 ]; then
        echo "  - 改进日志格式，使用 [DEBUG] ClassName.methodName - 动作: 信息"
    fi
    if [ "$COVERAGE_SCORE" -lt 60 ]; then
        echo "  - 增加日志覆盖率，确保关键方法都有日志"
    fi
    exit 1
fi
