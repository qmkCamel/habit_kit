## ADDED Requirements

### Requirement: Calculate total check-ins across all habits

The system SHALL calculate the total number of check-ins across all habits.

#### Scenario: User has multiple habits with check-ins
- **WHEN** user opens statistics view with 3 habits having 5, 10, and 15 check-ins respectively
- **THEN** system displays total check-ins as 30

#### Scenario: User has no check-ins
- **WHEN** user opens statistics view with habits but no check-ins
- **THEN** system displays total check-ins as 0

### Requirement: Calculate active habits count

The system SHALL calculate the number of habits that have at least one check-in.

#### Scenario: User has habits with and without check-ins
- **WHEN** user has 5 total habits, 3 with check-ins and 2 without
- **THEN** system displays active habits count as 3

#### Scenario: All habits are inactive
- **WHEN** user has habits but none have check-ins
- **THEN** system displays active habits count as 0

### Requirement: Calculate average completion rate

The system SHALL calculate the average completion rate across all habits for a given time range.

#### Scenario: Calculate average for current month
- **WHEN** user views statistics for "本月" (this month)
- **THEN** system calculates average completion rate based on days in current month

#### Scenario: Multiple habits with different completion rates
- **WHEN** Habit A has 80% completion and Habit B has 60% completion in selected range
- **THEN** system displays average completion rate as 70.0%

#### Scenario: No habits or no time range data
- **WHEN** no habits exist or no check-ins in selected time range
- **THEN** system displays average completion rate as 0.0%

### Requirement: Calculate current longest streak across all habits

The system SHALL identify the habit with the longest current streak and return that streak value.

#### Scenario: Multiple habits with different streaks
- **WHEN** Habit A has current streak of 5 days, Habit B has 10 days, Habit C has 3 days
- **THEN** system displays current longest streak as 10

#### Scenario: No active streaks
- **WHEN** all habits have broken streaks (last check-in more than 1 day ago)
- **THEN** system displays current longest streak as 0

### Requirement: Calculate historical longest streak

The system SHALL calculate the longest streak ever achieved across all habits.

#### Scenario: Historical streak longer than current
- **WHEN** Habit A had a 30-day streak in the past but current streak is 5 days
- **THEN** system displays historical longest streak as 30

#### Scenario: No historical data
- **WHEN** user has no check-ins or very few check-ins
- **THEN** system displays historical longest streak as 0

### Requirement: Calculate time-range specific statistics

The system SHALL support calculating statistics for three time ranges: all time, this month, this week.

#### Scenario: User selects "本周" (this week)
- **WHEN** user selects "本周" filter
- **THEN** system calculates statistics based on Monday to Sunday of current week

#### Scenario: User selects "本月" (this month)
- **WHEN** user selects "本月" filter
- **THEN** system calculates statistics from day 1 to last day of current month

#### Scenario: User selects "全部" (all time)
- **WHEN** user selects "全部" filter
- **THEN** system calculates statistics from earliest check-in date to today

### Requirement: Rank habits by completion rate

The system SHALL rank habits by their completion rate in descending order.

#### Scenario: Multiple habits with different completion rates
- **WHEN** Habit A has 90%, Habit B has 75%, Habit C has 60% completion rate
- **THEN** system returns ranking as [Habit A, Habit B, Habit C]

#### Scenario: Habits with equal completion rates
- **WHEN** multiple habits have the same completion rate
- **THEN** system maintains stable sort order (by name or creation date)

### Requirement: Rank habits by current streak

The system SHALL rank habits by their current streak in descending order.

#### Scenario: Multiple habits with different streaks
- **WHEN** Habit A has 10-day streak, Habit B has 5-day streak, Habit C has 0-day streak
- **THEN** system returns ranking as [Habit A, Habit B, Habit C]

#### Scenario: Multiple habits with broken streaks
- **WHEN** all habits have 0-day current streak
- **THEN** system returns all habits with streak value 0

### Requirement: Calculate check-in count for time range

The system SHALL calculate the total number of check-ins within a specified time range.

#### Scenario: Count check-ins in current month
- **WHEN** user views "本月" statistics and has 15 check-ins this month, 20 check-ins previously
- **THEN** system displays 15 check-ins for the selected range

#### Scenario: No check-ins in time range
- **WHEN** user has check-ins but none in the selected time range
- **THEN** system displays 0 check-ins for that range
