## ADDED Requirements

### Requirement: Display statistics overview page

The system SHALL provide a statistics overview page accessible from the main screen.

#### Scenario: Open statistics from main screen
- **WHEN** user taps the chart bar icon in navigation bar
- **THEN** system displays statistics view as a modal sheet

#### Scenario: Dismiss statistics view
- **WHEN** user swipes down or taps close button
- **THEN** system dismisses statistics view and returns to main screen

### Requirement: Display core statistics metrics

The system SHALL display the following core statistics on the overview page: total check-ins, active habits, average completion rate, current longest streak.

#### Scenario: View core metrics with data
- **WHEN** user opens statistics view with existing check-in data
- **THEN** system displays all four core metrics in card format

#### Scenario: View core metrics without data
- **WHEN** user opens statistics view with no check-ins
- **THEN** system displays all metrics with zero values and helpful empty state

### Requirement: Support time range filtering

The system SHALL allow users to filter statistics by three time ranges: 全部 (all), 本月 (this month), 本周 (this week).

#### Scenario: Switch to "本月" filter
- **WHEN** user taps "本月" filter button
- **THEN** system updates all statistics to show only current month data

#### Scenario: Switch to "本周" filter
- **WHEN** user taps "本周" filter button
- **THEN** system updates all statistics to show only current week data

#### Scenario: Switch to "全部" filter
- **WHEN** user taps "全部" filter button
- **THEN** system updates all statistics to show all-time data

#### Scenario: Default time range
- **WHEN** user opens statistics view for the first time
- **THEN** system displays "全部" (all time) statistics by default

### Requirement: Display completion rate visualization

The system SHALL display average completion rate as a circular progress ring.

#### Scenario: View completion rate
- **WHEN** user has 70% average completion rate
- **THEN** system displays a progress ring showing 70% filled

#### Scenario: View 100% completion rate
- **WHEN** user has perfect 100% completion
- **THEN** system displays a fully filled progress ring with success indicator

### Requirement: Display check-in trend chart

The system SHALL display a trend chart showing check-in count over time.

#### Scenario: View weekly trend
- **WHEN** user selects "本周" filter
- **THEN** system displays line chart with 7 data points (Mon-Sun)

#### Scenario: View monthly trend
- **WHEN** user selects "本月" filter
- **THEN** system displays line chart with daily data points for current month

#### Scenario: View all-time trend
- **WHEN** user selects "全部" filter and has data spanning multiple months
- **THEN** system displays aggregated trend (e.g., weekly or monthly aggregation)

### Requirement: Display habit rankings

The system SHALL display a ranking list of habits sorted by selected metric.

#### Scenario: View habits ranked by completion rate
- **WHEN** user views ranking section with default sort
- **THEN** system displays habits sorted by completion rate (highest first)

#### Scenario: Switch ranking metric to streak
- **WHEN** user taps "连续天数" sort option
- **THEN** system re-sorts habits by current streak (longest first)

#### Scenario: Display top 5 habits
- **WHEN** user has more than 5 habits
- **THEN** system displays top 5 with option to expand for full list

#### Scenario: Display all habits when less than 5
- **WHEN** user has 3 habits
- **THEN** system displays all 3 without "view more" option

### Requirement: Display streak information

The system SHALL display current longest streak and historical longest streak.

#### Scenario: View current active streak
- **WHEN** user has an ongoing streak
- **THEN** system displays current longest streak with habit name

#### Scenario: View broken streak
- **WHEN** all streaks are broken
- **THEN** system displays "0 天" for current longest streak

#### Scenario: View historical best streak
- **WHEN** user had a 30-day streak in the past
- **THEN** system displays "30 天" as historical longest streak

### Requirement: Refresh statistics on data change

The system SHALL automatically update statistics when underlying habit data changes.

#### Scenario: Update statistics after check-in
- **WHEN** user dismisses statistics view, checks in a habit, and reopens statistics
- **THEN** system displays updated statistics reflecting the new check-in

#### Scenario: Update statistics after habit deletion
- **WHEN** user deletes a habit while statistics view is open
- **THEN** system immediately updates statistics to exclude deleted habit

### Requirement: Display loading state

The system SHALL show a loading indicator when calculating complex statistics.

#### Scenario: Calculate statistics for large dataset
- **WHEN** user has thousands of check-ins and opens statistics
- **THEN** system displays loading indicator until calculations complete

#### Scenario: Quick display for small dataset
- **WHEN** user has minimal data
- **THEN** system displays statistics immediately without loading indicator

### Requirement: Support pull-to-refresh

The system SHALL allow users to manually refresh statistics by pulling down.

#### Scenario: Pull to refresh statistics
- **WHEN** user pulls down on statistics view
- **THEN** system recalculates and refreshes all statistics

#### Scenario: Release to trigger refresh
- **WHEN** user pulls down beyond threshold and releases
- **THEN** system shows refresh animation and updates data

### Requirement: Display navigation and controls

The system SHALL provide clear navigation title and dismiss controls.

#### Scenario: View statistics title
- **WHEN** user opens statistics view
- **THEN** system displays "统计" as navigation title

#### Scenario: Dismiss via close button
- **WHEN** user taps "×" or "完成" button
- **THEN** system dismisses statistics view

#### Scenario: Dismiss via swipe
- **WHEN** user swipes down on statistics sheet
- **THEN** system dismisses statistics view with animation
