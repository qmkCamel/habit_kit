#!/bin/bash

# ============================================================
# iOS 构建安装通用脚本
# ============================================================
# 用法: ./build_and_install.sh [选项] [device_id]
#
# 选项:
#   -c, --config <file>   指定配置文件路径 (默认: ./build.config)
#   -s, --scheme <name>   覆盖 Scheme 名称
#   -r, --release         使用 Release 配置
#   -b, --build-only      仅构建，不安装
#   -h, --help            显示帮助信息
#
# 依赖: xcbeautify (可选，用于美化输出)
#   安装: brew install xcbeautify
# ============================================================

set -e

# ============================================================
# 默认配置
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/build.config"

# 可被配置文件覆盖的默认值
PROJECT_TYPE="xcodeproj"
PROJECT_NAME=""
SCHEME=""
BUNDLE_ID=""
CONFIGURATION="Debug"
PLATFORM="iOS"
BUILD_DIR="build"
AUTO_LAUNCH=true
EXTRA_BUILD_ARGS=""

# 运行时变量
PROJECT_DIR=""
BUILD_PATH=""
RAW_LOG=""
PRETTY_LOG=""
ERROR_LOG=""
APP_PATH=""
DEVICE_ID=""
BUILD_ONLY=false
USE_XCBEAUTIFY=false
XCBEAUTIFY_CMD=""

# ============================================================
# 颜色定义
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }
echo_debug() { echo -e "${BLUE}[DEBUG]${NC} $1"; }
echo_step()  { echo -e "${CYAN}[STEP]${NC} $1"; }

# ============================================================
# 帮助信息
# ============================================================
show_help() {
    cat << EOF
iOS 构建安装通用脚本

用法: $0 [选项] [device_id]

选项:
  -c, --config <file>   指定配置文件路径 (默认: ./build.config)
  -s, --scheme <name>   覆盖 Scheme 名称
  -r, --release         使用 Release 配置
  -b, --build-only      仅构建，不安装
  -h, --help            显示帮助信息

示例:
  $0                           # 使用默认配置构建并安装
  $0 -r                        # 使用 Release 配置
  $0 -b                        # 仅构建
  $0 -c ~/myapp/build.config   # 使用指定配置文件
  $0 <device_id>               # 安装到指定设备

配置文件格式 (build.config):
  PROJECT_TYPE="xcodeproj"     # 或 xcworkspace
  PROJECT_NAME="MyApp.xcodeproj"
  SCHEME="MyApp"
  BUNDLE_ID="com.example.myapp"
  CONFIGURATION="Debug"
  PLATFORM="iOS"
  BUILD_DIR="build"
  AUTO_LAUNCH=true

EOF
    exit 0
}

# ============================================================
# 解析命令行参数
# ============================================================
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -s|--scheme)
                SCHEME="$2"
                shift 2
                ;;
            -r|--release)
                CONFIGURATION="Release"
                shift
                ;;
            -b|--build-only)
                BUILD_ONLY=true
                shift
                ;;
            -h|--help)
                show_help
                ;;
            -*)
                echo_error "未知选项: $1"
                show_help
                ;;
            *)
                # 非选项参数作为设备 ID
                DEVICE_ID="$1"
                shift
                ;;
        esac
    done
}

# ============================================================
# 加载配置文件
# ============================================================
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo_error "配置文件不存在: $CONFIG_FILE"
        echo ""
        echo "请创建配置文件，示例:"
        echo "----------------------------------------"
        cat << 'EOF'
PROJECT_TYPE="xcodeproj"
PROJECT_NAME="MyApp.xcodeproj"
SCHEME="MyApp"
BUNDLE_ID="com.example.myapp"
CONFIGURATION="Debug"
EOF
        echo "----------------------------------------"
        echo ""
        echo "或使用 -c 指定配置文件路径"
        exit 1
    fi
    
    echo_info "加载配置: $CONFIG_FILE"
    
    # 安全地加载配置（只允许特定变量）
    while IFS='=' read -r key value; do
        # 跳过注释和空行
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # 去除空格
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs | sed 's/^["'\'']\|["'\'']$//g')
        
        case "$key" in
            PROJECT_TYPE)   PROJECT_TYPE="$value" ;;
            PROJECT_NAME)   PROJECT_NAME="$value" ;;
            SCHEME)         [ -z "$SCHEME" ] && SCHEME="$value" ;;  # 命令行优先
            BUNDLE_ID)      BUNDLE_ID="$value" ;;
            CONFIGURATION)  [ "$CONFIGURATION" = "Debug" ] && CONFIGURATION="$value" ;;  # 命令行优先
            PLATFORM)       PLATFORM="$value" ;;
            BUILD_DIR)      BUILD_DIR="$value" ;;
            AUTO_LAUNCH)    AUTO_LAUNCH="$value" ;;
            EXTRA_BUILD_ARGS) EXTRA_BUILD_ARGS="$value" ;;
        esac
    done < "$CONFIG_FILE"
    
    # 设置项目目录（配置文件所在目录）
    PROJECT_DIR="$(cd "$(dirname "$CONFIG_FILE")" && pwd)"
    
    # 验证必需配置
    if [ -z "$PROJECT_NAME" ]; then
        echo_error "配置缺少 PROJECT_NAME"
        exit 1
    fi
    
    if [ -z "$SCHEME" ]; then
        echo_error "配置缺少 SCHEME"
        exit 1
    fi
    
    # 设置路径
    BUILD_PATH="$PROJECT_DIR/$BUILD_DIR"
    RAW_LOG="$BUILD_PATH/build_raw.log"
    PRETTY_LOG="$BUILD_PATH/build_pretty.log"
    ERROR_LOG="$BUILD_PATH/build_errors.log"
    
    # 显示配置
    echo_debug "项目目录: $PROJECT_DIR"
    echo_debug "项目文件: $PROJECT_NAME"
    echo_debug "Scheme: $SCHEME"
    echo_debug "配置: $CONFIGURATION"
    echo_debug "Bundle ID: $BUNDLE_ID"
}

# ============================================================
# 检查 xcbeautify
# ============================================================
check_xcbeautify() {
    if [ -x "/opt/homebrew/bin/xcbeautify" ]; then
        XCBEAUTIFY_CMD="/opt/homebrew/bin/xcbeautify"
        USE_XCBEAUTIFY=true
        echo_info "检测到 xcbeautify (Homebrew)"
    elif [ -x "/usr/local/bin/xcbeautify" ]; then
        XCBEAUTIFY_CMD="/usr/local/bin/xcbeautify"
        USE_XCBEAUTIFY=true
        echo_info "检测到 xcbeautify"
    elif command -v xcbeautify &> /dev/null; then
        XCBEAUTIFY_CMD="xcbeautify"
        USE_XCBEAUTIFY=true
        echo_info "检测到 xcbeautify"
    else
        echo_warn "未安装 xcbeautify，使用原始输出"
        echo "      安装命令: brew install xcbeautify"
    fi
}

# ============================================================
# 检查设备
# ============================================================
check_devices() {
    echo_step "检查已连接的设备..."
    
    DEVICES=$(xcrun devicectl list devices 2>/dev/null | grep -E "iPhone|iPad" || true)
    
    if [ -z "$DEVICES" ]; then
        echo_error "没有找到已连接的 iOS 设备"
        echo "请确保:"
        echo "  1. iPhone 已通过 USB 连接"
        echo "  2. 已信任此电脑"
        echo "  3. 设备已解锁"
        exit 1
    fi
    
    echo "$DEVICES"
}

# ============================================================
# 获取设备 ID
# ============================================================
get_device_id() {
    if [ -n "$DEVICE_ID" ]; then
        echo_info "使用指定设备: $DEVICE_ID"
        return
    fi
    
    # 获取设备列表
    xcrun devicectl list devices -j /tmp/devices.json >/dev/null 2>&1
    
    DEVICE_ID=$(python3 -c "
import json
d = json.load(open('/tmp/devices.json'))
devices = d.get('result', {}).get('devices', [])

# 优先找有线连接的设备
wired = [x for x in devices if x.get('connectionProperties', {}).get('transportType') == 'wired']
if wired:
    print(wired[0]['identifier'])
else:
    # 其次找任何可用的设备
    connected = [x for x in devices if x.get('deviceProperties', {}).get('bootState') == 'booted' 
                 or 'coredevice.local' in x.get('hostname', '')]
    if connected:
        print(connected[0]['identifier'])
" 2>/dev/null || true)
    
    if [ -z "$DEVICE_ID" ]; then
        echo_error "无法获取设备 ID"
        echo "请确保设备已解锁并信任此电脑"
        exit 1
    fi
    
    echo_info "目标设备: $DEVICE_ID"
}

# ============================================================
# 构建应用
# ============================================================
build_app() {
    echo_step "开始构建 $SCHEME ($CONFIGURATION)..."
    
    # 清理并创建构建目录
    rm -rf "$BUILD_PATH"
    mkdir -p "$BUILD_PATH"
    
    # 构建项目或工作空间参数
    if [ "$PROJECT_TYPE" = "xcworkspace" ]; then
        PROJECT_ARG="-workspace \"$PROJECT_DIR/$PROJECT_NAME\""
    else
        PROJECT_ARG="-project \"$PROJECT_DIR/$PROJECT_NAME\""
    fi
    
    # 构建命令
    BUILD_CMD="xcodebuild \
        $PROJECT_ARG \
        -scheme \"$SCHEME\" \
        -configuration \"$CONFIGURATION\" \
        -destination \"generic/platform=$PLATFORM\" \
        -derivedDataPath \"$BUILD_PATH/DerivedData\" \
        -allowProvisioningUpdates \
        $EXTRA_BUILD_ARGS \
        build"
    
    # 执行构建
    BUILD_EXIT_CODE=0
    
    if [ "$USE_XCBEAUTIFY" = true ]; then
        echo_info "使用 xcbeautify 美化输出..."
        set +e
        eval "$BUILD_CMD" 2>&1 | tee "$RAW_LOG" | "$XCBEAUTIFY_CMD" --report junit --report-path "$BUILD_PATH/report.xml" 2>&1 | tee "$PRETTY_LOG"
        BUILD_EXIT_CODE=${PIPESTATUS[0]}
        set -e
        extract_errors
    else
        set +e
        eval "$BUILD_CMD" 2>&1 | tee "$RAW_LOG"
        BUILD_EXIT_CODE=${PIPESTATUS[0]}
        set -e
    fi
    
    # 查找 .app
    APP_BUNDLE=$(find "$BUILD_PATH/DerivedData" -name "*.app" -type d | grep -v "\.dSYM" | head -1)
    
    if [ -z "$APP_BUNDLE" ] || [ ! -d "$APP_BUNDLE" ]; then
        echo_error "构建失败，未找到 .app 文件"
        echo ""
        echo "========== 错误摘要（可复制给 AI 分析）=========="
        if [ -f "$ERROR_LOG" ]; then
            cat "$ERROR_LOG"
        else
            echo "查看详细日志: $RAW_LOG"
            grep -E "(error:|fatal error:|Build failed)" "$RAW_LOG" | tail -20 || true
        fi
        echo "=================================================="
        exit 1
    fi
    
    echo_info "构建成功: $APP_BUNDLE"
    APP_PATH="$APP_BUNDLE"
}

# ============================================================
# 提取错误信息
# ============================================================
extract_errors() {
    {
        echo "# 构建错误摘要"
        echo "生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "项目: $SCHEME"
        echo "配置: $CONFIGURATION"
        echo ""
        
        if grep -q "error:" "$RAW_LOG"; then
            echo "## 编译错误"
            echo '```'
            grep -E "error:" "$RAW_LOG" | head -30
            echo '```'
            echo ""
        fi
        
        if grep -q "warning:" "$RAW_LOG"; then
            echo "## 警告 (前10条)"
            echo '```'
            grep -E "warning:" "$RAW_LOG" | head -10
            echo '```'
            echo ""
        fi
        
        if grep -q "ld:" "$RAW_LOG"; then
            echo "## 链接错误"
            echo '```'
            grep "ld:" "$RAW_LOG" | head -10
            echo '```'
            echo ""
        fi
        
        if grep -q "BUILD SUCCEEDED" "$RAW_LOG"; then
            echo "## 结果: ✅ 构建成功"
        elif grep -q "BUILD FAILED" "$RAW_LOG"; then
            echo "## 结果: ❌ 构建失败"
        fi
    } > "$ERROR_LOG"
    
    echo_info "错误摘要: $ERROR_LOG"
}

# ============================================================
# 安装到设备
# ============================================================
install_app() {
    echo_step "正在安装到设备..."
    
    xcrun devicectl device install app \
        --device "$DEVICE_ID" \
        "$APP_PATH" \
        2>&1
    
    if [ $? -eq 0 ]; then
        echo_info "✅ 安装成功!"
    else
        echo_error "安装失败"
        exit 1
    fi
}

# ============================================================
# 启动应用
# ============================================================
launch_app() {
    if [ "$AUTO_LAUNCH" != "true" ] || [ -z "$BUNDLE_ID" ]; then
        return
    fi
    
    echo_step "正在启动应用..."
    
    xcrun devicectl device process launch \
        --device "$DEVICE_ID" \
        "$BUNDLE_ID" \
        2>&1 || echo_warn "启动失败，请手动打开"
}

# ============================================================
# 显示日志位置
# ============================================================
show_logs() {
    echo ""
    echo "========== 日志文件 =========="
    [ -f "$RAW_LOG" ] && echo "  原始日志: $RAW_LOG"
    [ -f "$PRETTY_LOG" ] && echo "  美化日志: $PRETTY_LOG"
    [ -f "$ERROR_LOG" ] && echo "  错误摘要: $ERROR_LOG"
    [ -f "$BUILD_PATH/report.xml" ] && echo "  JUnit报告: $BUILD_PATH/report.xml"
    echo "==============================="
}

# ============================================================
# 主流程
# ============================================================
main() {
    echo "========================================"
    echo "  iOS 构建安装脚本"
    echo "========================================"
    echo ""
    
    parse_args "$@"
    load_config
    check_xcbeautify
    
    if [ "$BUILD_ONLY" = true ]; then
        echo_info "仅构建模式"
        build_app
    else
        check_devices
        get_device_id
        build_app
        install_app
        launch_app
    fi
    
    show_logs
    
    echo ""
    echo_info "🎉 完成!"
    
    if [ -f "$ERROR_LOG" ]; then
        echo ""
        echo_info "💡 AI 分析: cat $ERROR_LOG"
    fi
}

main "$@"
