import SwiftUI

@Observable
class HexagonCardViewModel {
    var model: HexagonCardModel
    
    var legendSelected: ((HexagonDataSet) -> Void)?
    
    init(model: HexagonCardModel) {
        self.model = model
    }
    
    func selectLegend(_ hexagon: HexagonDataSet) {
        legendSelected?(hexagon)
    }
}

struct HexagonCardView<SheetItem: HexagonMaker, SheetContent: View>: View {
    
    
    @Binding var legendVM: SheetItem?
    @Bindable var vm: HexagonCardViewModel
    
    let legendView: (SheetItem) -> SheetContent
    
    var body: some View {
        GeometryReader { proxy in
            let chartHeight = proxy.size.height / 2
            let chartWidth = proxy.size.width
            ScrollView {
                VStack(spacing: 0) {
                    HexagonChartView(data: vm.model.chart)
                        .frame(width: chartWidth, height: chartHeight, alignment: .top)
                    
                    ChartLegendView(
                        primary: $vm.model.chart.primary,
                        secondary: $vm.model.chart.secondary,
                        selectedItem: $legendVM,
                        onLegendSelected: vm.selectLegend,
                        sheetContent: legendView
                    )
                    
                    HexagonStatsTableView(model: vm.model)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}


#Preview {
    FootballHexagonCardView()
}
