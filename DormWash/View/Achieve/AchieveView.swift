import CoreData
import SwiftUI

struct AchieveView: View {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    var body: some View {
        VStack {
            Text("Награды")
                .font(.largeTitle)
                .foregroundStyle(Color.white)
            ScrollView {
                LazyVGrid(columns: AchieveConfig.columns, spacing: 20) {
                    ForEach(AchieveConfig.stepValues, id: \.self) { stepValue in
                        AchieveCardView(viewContext: viewContext, stepValue: stepValue)
                    }
                }
            }
        }
        .animatedGradientBackground()
    }
}
