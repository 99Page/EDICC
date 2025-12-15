import SwiftUI

struct HexagonCardView: View {
    
    @State private var model = HexagonChartModel(
        axisLabels: ["ACK", "DMG", "C", "D", "E", "Z"],
        dataSets: [
            HexagonDataSet(
                label: "type1",
                color: IdentifiableColor(.creamyOrange),
                values: [1, 0.666, 0.7, 0.5, 0.7, 0.1]
            ),
            HexagonDataSet(
                label: "type2",
                color: IdentifiableColor(.lemonYellow),
                values: [0.2, 0.5, 0.65, 0.9, 0.8, 0.4]
            )
        ]
    )
    
    init() { }
    
    var body: some View {
        GeometryReader { proxy in
            let chartHeight = proxy.size.height / 2
            let chartWidth = proxy.size.width
            ScrollView {
                VStack(spacing: 0) {
                    HexagonChartView(data: model)
                    
                    ChartLegendView(
                        primaryColor: $model.dataSets[0].color,
                        primaryTitle: model.dataSets[0].label ?? "",
                        secondaryColor: $model.dataSets[1].color,
                        secondaryTitle: model.dataSets[1].label ?? ""
                    )
                }
                .frame(width: chartWidth, height: chartHeight, alignment: .top)
            }
            .background(
                Color.black.opacity(0.6)
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HexagonCardView()
    }
}
