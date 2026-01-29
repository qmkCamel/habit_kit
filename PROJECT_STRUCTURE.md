# HabitKit 项目结构

本文档描述了 HabitKit iOS 应用的目录结构。

```
habit_kit/
├── README.md                      # 项目说明文档
├── AGENTS.md                      # AI Agent 配置
├── project.yml                    # XcodeGen 项目配置文件
├── .gitignore                     # Git 忽略文件配置
│
├── HabitKit/                      # 主应用源代码目录
│   ├── App/                       # 应用入口
│   │   ├── HabitKitApp.swift      # SwiftUI App 入口
│   │   └── ContentView.swift      # 主视图
│   │
│   ├── Models/                    # 数据模型
│   │   ├── Habit.swift            # 习惯数据模型
│   │   └── ViewMode.swift         # 视图模式枚举
│   │
│   ├── Views/                     # 视图组件
│   │   ├── GridView.swift         # 网格视图
│   │   ├── ListView.swift         # 列表视图
│   │   ├── DetailView.swift       # 详情视图
│   │   ├── SettingsView.swift     # 设置视图
│   │   │
│   │   ├── Components/            # 可复用组件
│   │   │   ├── HabitCardView.swift    # 习惯卡片
│   │   │   └── HeatmapView.swift      # 热力图组件
│   │   │
│   │   └── Sheets/                # 弹窗视图
│   │       ├── AddHabitSheet.swift    # 添加习惯
│   │       ├── EditHabitSheet.swift   # 编辑习惯
│   │       └── HabitDetailSheet.swift # 习惯详情
│   │
│   ├── Utils/                     # 工具类和扩展
│   │   ├── DateExtensions.swift   # 日期处理扩展
│   │   └── ColorExtensions.swift  # 颜色处理扩展
│   │
│   ├── PreviewData/               # 预览数据
│   │   └── PreviewData.swift      # SwiftUI 预览用数据
│   │
│   ├── Assets.xcassets/           # 资源文件
│   │   ├── AppIcon.appiconset/    # 应用图标
│   │   └── AccentColor.colorset/  # 主题色
│   │
│   └── Info.plist                 # 应用配置文件
│
├── HabitKit.xcodeproj/            # Xcode 项目文件
│   └── project.pbxproj            # 项目配置
│
├── Scripts/                       # 构建和部署脚本
│   ├── build_and_install.sh       # 构建并安装到设备的脚本
│   └── build.config               # 构建配置文件
│
├── Docs/                          # 项目文档
│   ├── PROJECT_OVERVIEW.md        # 项目概览
│   ├── QUICKSTART.md              # 快速开始指南
│   ├── 开始使用.md                 # 中文使用指南
│   └── habit_screenshot/          # 应用截图
│       ├── habit_1.PNG
│       ├── habit_2.PNG
│       └── habit_3.PNG
│
├── build/                         # 构建产物（不提交到 Git）
│   └── ...
│
└── openspec/                      # OpenSpec 配置（可选）
    └── ...
```

## 目录说明

### HabitKit/ - 源代码目录
存放所有应用源代码，采用标准的 iOS 应用结构：
- **App/**: 应用入口和主视图
- **Models/**: SwiftData 数据模型
- **Views/**: 所有 SwiftUI 视图组件
- **Utils/**: 工具类和 Swift 扩展
- **PreviewData/**: Xcode Preview 所需的测试数据
- **Assets.xcassets/**: 图片、颜色等资源

### Scripts/ - 脚本目录
存放构建、部署相关的自动化脚本：
- `build_and_install.sh`: 自动构建并安装到 iOS 设备
- `build.config`: 构建配置（项目名、Bundle ID 等）

### Docs/ - 文档目录
存放项目文档和截图：
- 项目概览和使用指南
- 应用功能截图
- 其他技术文档

### 其他文件
- `project.yml`: XcodeGen 配置，用于生成 Xcode 项目
- `HabitKit.xcodeproj/`: Xcode 项目文件
- `build/`: 构建产物临时目录（已在 .gitignore 中忽略）

## 架构设计

本项目采用 **MVVM** (Model-View-ViewModel) 架构：

- **Model** (`Models/`): 使用 SwiftData 定义数据结构
- **View** (`Views/`): SwiftUI 视图组件，负责 UI 展示
- **ViewModel**: 通过 SwiftUI 的 `@Query` 和 `@Environment` 实现数据绑定

## 开发工作流

1. **修改代码**: 在 `HabitKit/` 目录下修改源文件
2. **构建测试**: 使用 Xcode 或运行 `Scripts/build_and_install.sh`
3. **文档更新**: 在 `Docs/` 目录中更新相关文档

## 注意事项

- 所有源代码必须放在 `HabitKit/` 目录下
- 构建产物会输出到 `build/` 目录（不提交到 Git）
- 使用 `project.yml` 管理项目配置，通过 XcodeGen 生成 `.xcodeproj`
