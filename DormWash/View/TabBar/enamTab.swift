import SwiftUI

enum Tab: Int, CaseIterable {
    case washer
    case star
    case gear

    var imageName: String {
        switch self {
        case .washer: "washer"
        case .star: "star"
        case .gear: "gear"
        }
    }
}
