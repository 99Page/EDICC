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
            self?.setupSelectionVM(hexagon)
        }
        
        let manchester = FootballStatisticsResponse.manchersterUnited23
        let bruno = FootballPlayer(dto: manchester.response[0])
        let diogo = FootballPlayer(dto: manchester.response[1])
        let brunoHexagon = bruno.hexagonPoints(standard: FootballPlayer.self)
        let diogoHexagon = diogo.hexagonPoints(standard: FootballPlayer.self)
        
        hexagonVM.model.chart.update(target: \.primary, label: bruno.label, points: brunoHexagon)
        hexagonVM.model.chart.update(target: \.secondary, label: diogo.label, points: diogoHexagon)
    }
    
    func setupSelectionVM(_ hexagonDataSet: HexagonDataSet) {
        teamSelectVM = FootballTeamSelectViewModel(hexagonTarget: hexagonDataSet) { [weak self] in
            self?.hexagonVM.model.chart.updateDataSet(old: $0, new: $1)
        }
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
