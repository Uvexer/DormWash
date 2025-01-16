import Foundation
import SwiftUI

enum AchieveConfig {
    static let washSelector: Bool = false
    static let currentValue: Int = 0
    static let stepValues: [Int] = (5 ... 80).filter { $0 % 5 == 0 }
    static let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
}
