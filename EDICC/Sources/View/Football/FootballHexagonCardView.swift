//
//  FootballHexagonCardView.swift
//  EDICC
//
//  Created by 노우영 on 12/18/25.
//

import SwiftUI

@MainActor
class FootballHexagonCardViewModel {
    var model = HexagonCardModel()
    var teamSelectVM = FootballTeamSelectViewModel()
    
    func handle() {
        
    }
}

@Observable
class FootballHexagonCardModel {
    var hexagonCard = HexagonCardModel()
}

struct FootballHexagonCardView: View {
    
    @State private var model = FootballHexagonCardModel()
    
    var body: some View {
        HexagonCardView(model: model.hexagonCard) {
            FootballTeamSelectView(vm: FootballTeamSelectViewModel())
        }
    }
}

#Preview {
    FootballHexagonCardView()
}
