# 快速开始指南

## 在 Xcode 中创建项目

### 方法一：创建新项目并导入文件

1. **打开 Xcode**，选择 `File > New > Project`

2. **选择模板**
   - 选择 `iOS` > `App`
   - 点击 `Next`

3. **配置项目**
   - Product Name: `HabitKit`
   - Team: 选择你的开发团队（或留空）
   - Organization Identifier: 输入你的标识符（如 `com.yourname`）
   - Interface: 选择 `SwiftUI`
   - Storage: 选择 `SwiftData`
   - Language: `Swift`
   - 取消勾选 `Include Tests`
   - 点击 `Next`

4. **选择保存位置**，点击 `Create`

5. **导入项目文件**
   - 将生成的所有 Swift 文件复制到 Xcode 项目中
   - 在 Xcode 中右键点击项目根目录，选择 `Add Files to "HabitKit"`
   - 选择所有文件，确保勾选 `Copy items if needed`
   - 点击 `Add`

### 方法二：使用命令行创建项目

如果你熟悉命令行，可以使用以下脚本快速创建项目结构：

```bash
# 创建项目目录结构
mkdir -p HabitKitProject/HabitKit
cd HabitKitProject

# 文件已经在当前目录中，只需要在 Xcode 中打开即可
```

## 文件组织结构

在 Xcode 中，建议按以下方式组织文件：

```
HabitKit/
├── App
│   └── HabitKitApp.swift
├── Models
│   ├── Habit.swift
│   └── ViewMode.swift
├── Views
│   ├── ContentView.swift
│   ├── GridView.swift
│   ├── ListView.swift
│   ├── DetailView.swift
│   ├── SettingsView.swift
│   ├── Components
│   │   ├── HeatmapView.swift
│   │   └── HabitCardView.swift
│   └── Sheets
│       ├── AddHabitSheet.swift
│       ├── EditHabitSheet.swift
│       └── HabitDetailSheet.swift
├── Utils
│   ├── DateExtensions.swift
│   └── ColorExtensions.swift
└── PreviewData
    └── PreviewData.swift
```

## 配置项目设置

### 1. 设置部署目标
- 选择项目根目录
- 在 `TARGETS` 下选择 `HabitKit`
- 在 `General` 标签页中，将 `Minimum Deployments` 设置为 `iOS 17.0`

### 2. 配置 Info.plist（可选）
- 在项目设置中找到 `Info` 标签页
- 可以自定义应用名称、版本号等信息

### 3. 添加应用图标（可选）
- 在 `Assets.xcassets` 中添加 `AppIcon`
- 可以使用在线工具生成各种尺寸的图标

## 运行项目

### 1. 选择模拟器
- 在 Xcode 顶部工具栏选择目标设备
- 推荐：`iPhone 15 Pro` 或 `iPhone 15 Pro Max`

### 2. 编译并运行
- 点击 `▶️` 按钮或按 `Cmd + R`
- 首次运行可能需要较长时间编译

### 3. 如果遇到编译错误
- 确保所有文件都正确导入
- 检查文件的 `Target Membership` 是否正确
- 清理构建：`Product > Clean Build Folder` (Cmd + Shift + K)

## 测试功能

### 添加测试数据
应用首次运行时数据库为空，你可以：

1. **手动添加习惯**
   - 点击右上角的 `+` 按钮
   - 输入习惯名称（如"跑步"、"阅读"）
   - 选择图标和颜色
   - 保存

2. **使用预览数据**（仅用于开发测试）
   - 可以修改 `HabitKitApp.swift` 临时使用内存数据库
   - 在应用启动时插入示例数据

### 测试各项功能

✅ **习惯管理**
- 添加新习惯
- 编辑习惯名称、图标、颜色
- 删除习惯

✅ **打卡功能**
- 在列表视图点击方块打卡
- 在详情视图点击热力图打卡
- 查看打卡效果

✅ **视图切换**
- 使用底部标签切换三种视图
- 观察切换动画效果

✅ **统计功能**
- 查看连续打卡天数
- 查看总完成次数

## 常见问题

### Q: 编译时提示 "Cannot find type 'Habit' in scope"
A: 确保 `Habit.swift` 文件已添加到项目中，并且 Target Membership 已勾选。

### Q: 运行时崩溃提示 SwiftData 相关错误
A: 确保项目创建时选择了 SwiftData 作为存储选项，或手动添加 SwiftData 框架。

### Q: 热力图不显示或显示不正确
A: 检查日期计算逻辑，确保 `DateExtensions.swift` 正确实现。

### Q: 如何在真机上测试？
A: 
1. 连接 iPhone 到电脑
2. 在 Xcode 中选择你的设备
3. 可能需要在 `Signing & Capabilities` 中配置开发团队
4. 运行项目

## 下一步

完成基础功能后，你可以：

1. **优化 UI**
   - 调整颜色和字体
   - 添加更多动画效果
   - 适配不同屏幕尺寸

2. **添加新功能**
   - 实现提醒通知
   - 添加数据统计图表
   - 支持习惯分类
   - 添加小组件

3. **完善用户体验**
   - 添加引导页
   - 实现数据备份
   - 支持主题切换

4. **发布应用**
   - 准备 App Store 资源
   - 配置应用图标和启动屏幕
   - 提交审核

## 需要帮助？

- 查看 `README.md` 了解项目架构
- 阅读代码注释理解实现细节
- 参考 Apple 官方文档学习 SwiftUI 和 SwiftData

祝你开发愉快！🎉
