import SwiftUI

struct HexagonCardView<LegendView: View>: View {
    
    
    @Bindable var model: HexagonCardModel
    
    let legendView: () -> LegendView
    
    var body: some View {
        GeometryReader { proxy in
            let chartHeight = proxy.size.height / 2
            let chartWidth = proxy.size.width
            ScrollView {
                VStack(spacing: 0) {
                    HexagonChartView(data: model.chart)
                        .frame(width: chartWidth, height: chartHeight, alignment: .top)
                    
                    ChartLegendView(
                        primaryColor: $model.chart.dataSets[0].color,
                        primaryTitle: model.chart.dataSets[0].label,
                        secondaryColor: $model.chart.dataSets[1].color,
                        secondaryTitle: model.chart.dataSets[1].label
                    ) {
                        legendView()
                    }
                    
                    HexagonStatsTableView(model: model)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}


#Preview {
    let model = FootballHexagonCardModel()
    
    HexagonCardView(model: model.hexagonCard) { EmptyView() }
}
