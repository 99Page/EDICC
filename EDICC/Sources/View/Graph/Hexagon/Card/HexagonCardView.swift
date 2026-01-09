import SwiftUI

@Observable
class HexagonCardViewModel {
    var model: HexagonCardModel
    var legendSelected: ((HexagonDataSet) -> Void)?
    
    init(model: HexagonCardModel) {
        self.model = model
    }
    
    func selectLegend(_ hexagon: HexagonDataSet) {
        model.selectedDataSet = hexagon
        legendSelected?(hexagon)
    }
}

struct HexagonCardView<SheetItem: HexagonUpdatable, SheetContent: View>: View {
    
    
    @Binding var legendVM: SheetItem?
    @Bindable var vm: HexagonCardViewModel
    
    @ViewBuilder let legendView: (SheetItem) -> SheetContent
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HexagonChartView(data: vm.model.chart)
                    .aspectRatio(1.2, contentMode: .fit)
                
                ChartLegendView(
                    primary: $vm.model.chart.primary,
                    secondary: $vm.model.chart.secondary,
                    onLegendSelected: vm.selectLegend,
                )
                .padding(.horizontal, 40)
                
                HexagonStatsTableView(
                    model: vm.model,
                    onLegendSelected: vm.selectLegend
                )
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
            }
        }
        .sheet(item: $legendVM) { item in
            legendSheet(sheetVM: item)
        }
    }
    
    /// 시트 내부 컨텐츠 생성 로직
    @ViewBuilder
    func legendSheet(sheetVM: SheetItem) -> some View {
        // 복잡한 삼항 연산자를 변수로 분리
        let targetColor = vm.model.isPrimarySelected ? $vm.model.chart.primary.color.value : $vm.model.chart.secondary.color.value
        
        LegendSelectionView(
            color: targetColor,
            bannedColor: vm.model.bannedColors
        ) {
            legendView(sheetVM)
        }
        .presentationDragIndicator(.visible)
    }
}


#Preview {
    FootballHexagonCardView(vm: FootballHexagonCardViewModel(chart: .init()))
}
