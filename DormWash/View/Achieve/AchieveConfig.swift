import Foundation
import SwiftUI

enum AchieveConfig {
    static let washSelector: Bool = false
    static let currentValue: Int = 0
    static let stepValues: [Int] = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]
    static let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
}
