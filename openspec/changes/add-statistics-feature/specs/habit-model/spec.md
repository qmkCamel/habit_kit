## MODIFIED Requirements

### Requirement: Calculate completion rate for time range

The system SHALL calculate the completion rate of a habit within a specified time range.

**Original behavior**: Habit model only supports checking if a specific date is completed (`isCompleted(on:)`).

**New behavior**: Habit model must support calculating completion percentage over a date range.

#### Scenario: Calculate completion rate for current month
- **WHEN** user has 10 check-ins out of 30 days in current month for a habit
- **THEN** system returns completion rate as 33.3%

#### Scenario: Calculate completion rate for custom range
- **WHEN** calculating completion rate from June 1 to June 15 (15 days)
- **THEN** system counts check-ins within that range and calculates percentage

#### Scenario: Handle date range before habit creation
- **WHEN** calculating completion rate for range starting before habit was created
- **THEN** system only counts days from habit creation date onward

#### Scenario: Future dates in range
- **WHEN** date range includes future dates
- **THEN** system only counts up to today (excludes future dates)

### Requirement: Calculate longest historical streak

The system SHALL calculate the longest consecutive check-in streak ever achieved by a habit.

**Original behavior**: Habit model only calculates current active streak (`getCurrentStreak()`).

**New behavior**: Habit model must also calculate historical longest streak across all time.

#### Scenario: Historical streak longer than current
- **WHEN** habit had 20-day streak in past, current streak is 5 days
- **THEN** system returns 20 as longest historical streak

#### Scenario: Current streak is the longest
- **WHEN** habit's current 15-day streak is the longest ever
- **THEN** system returns 15 as longest historical streak

#### Scenario: Multiple past streaks
- **WHEN** habit had streaks of 10, 15, and 8 days in the past
- **THEN** system returns 15 as longest historical streak

#### Scenario: No historical data
- **WHEN** habit has only 1 or 0 check-ins
- **THEN** system returns 0 or 1 as appropriate

### Requirement: Query check-ins within time range

The system SHALL provide a method to retrieve check-in dates within a specified time range.

**Original behavior**: Habit model exposes all `completionDates` array directly.

**New behavior**: Habit model should provide a filtered query method.

#### Scenario: Get check-ins for current week
- **WHEN** querying check-ins for Monday to Sunday of current week
- **THEN** system returns only check-in dates within that week

#### Scenario: Get check-ins for current month
- **WHEN** querying check-ins for day 1 to last day of current month
- **THEN** system returns only check-in dates within that month

#### Scenario: Empty result for range with no check-ins
- **WHEN** querying a time range with no check-ins
- **THEN** system returns empty array

### Requirement: Calculate total check-in days

The system SHALL calculate the total number of unique days the habit was checked in.

**Original behavior**: Habit model's `completionDates` array may contain duplicate dates for same day (if multiple check-ins allowed).

**New behavior**: Provide method to count unique check-in days.

#### Scenario: Count unique days with multiple check-ins per day
- **WHEN** habit has 5 check-ins but only on 3 unique days
- **THEN** system returns 3 as total check-in days

#### Scenario: Count unique days with one check-in per day
- **WHEN** habit has 10 check-ins on 10 different days
- **THEN** system returns 10 as total check-in days

### Requirement: Calculate days since creation

The system SHALL calculate the number of days since the habit was created.

**Original behavior**: Habit model has `createdAt` property but no helper method.

**New behavior**: Provide method to calculate days since creation.

#### Scenario: Habit created 30 days ago
- **WHEN** habit was created 30 days ago
- **THEN** system returns 30 days

#### Scenario: Habit created today
- **WHEN** habit was created earlier today
- **THEN** system returns 0 days (same day)

#### Scenario: Habit created yesterday
- **WHEN** habit was created yesterday
- **THEN** system returns 1 day
