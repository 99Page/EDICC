//
//  FootballHexagonCardView.swift
//  EDICC
//
//  Created by 노우영 on 12/18/25.
//

import SwiftUI

@Observable
class FootballHexagonCardViewModel {
    var hexagonVM = HexagonCardViewModel(model: HexagonCardModel())
    var teamSelectVM: FootballTeamSelectViewModel?
    
    init() {
        hexagonVM.legendSelected = { [weak self] hexagon in
            self?.showLegendSelectView(hexagon)
        }
    }
    
    func showLegendSelectView(_ hexagondDataSet: HexagonDataSet) {
        teamSelectVM = FootballTeamSelectViewModel(hexagonTarget: hexagondDataSet)
    }
    
    func handle() {
        
    }
}

struct FootballHexagonCardView: View {
    
    @State private var vm = FootballHexagonCardViewModel()
    
    var body: some View {
        HexagonCardView(legendVM: $vm.teamSelectVM, vm: vm.hexagonVM) { vm in
            FootballTeamSelectView(vm: vm)
        }
    }
}

#Preview {
    FootballHexagonCardView()
}
