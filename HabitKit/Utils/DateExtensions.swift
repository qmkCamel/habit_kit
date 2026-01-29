import Foundation

extension Date {
    /// 获取该日期所在月份的所有日期
    func datesInMonth() -> [Date] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: self)!
        
        var dates: [Date] = []
        var currentDate = interval.start
        
        while currentDate < interval.end {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    /// 获取月份字符串（如 "Jan 2026"）
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
    
    /// 获取从某个日期到今天的所有日期
    func datesToToday() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.startOfDay(for: self)
        
        guard startDate <= today else { return [] }
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= today {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    /// 获取最近N天的日期
    static func lastNDays(n: Int) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<n).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }.reversed()
    }
}
