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

struct HexagonCardView<VM: Identifiable, LegendView: View>: View {
    
    
    @Binding var legendVM: VM?
    @Bindable var vm: HexagonCardViewModel
    
    let legendView: (VM) -> LegendView
    
    var body: some View {
        GeometryReader { proxy in
            let chartHeight = proxy.size.height / 2
            let chartWidth = proxy.size.width
            ScrollView {
                VStack(spacing: 0) {
                    HexagonChartView(data: vm.model.chart)
                        .frame(width: chartWidth, height: chartHeight, alignment: .top)
                    
                    ChartLegendView(
                        legendVM: $legendVM,
                        primary: $vm.model.chart.dataSets[0],
                        secondary: $vm.model.chart.dataSets[1]
                    ) { vm in
                        legendView(vm)
                    } legendSelected: { legend in
                        vm.selectLegend(legend)
                    }
                    
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
