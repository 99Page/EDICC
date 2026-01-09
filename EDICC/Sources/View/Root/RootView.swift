//
//  RootView.swift
//  EDICC
//
//  Created by 노우영 on 1/8/26.
//

import SwiftUI

@Observable
final class RootViewModel {
    var model = RootModel()
    
    func tapFootball() {
        model.path.append(.football)
    }
}

@Observable
final class RootModel {
    var path: [RootPath] = []
}

enum RootPath: Hashable {
    case football
}

struct RootView: View {
    @State private var vm = RootViewModel()
    
    var body: some View {
        NavigationStack(path: $vm.model.path) {
            VStack {
                Button {
                    vm.tapFootball()
                } label: {
                    Text("Football")
                }

            }
            .navigationDestination(for: RootPath.self) { path in
                switch path {
                case .football:
                    let vm = FootballHexagonCardViewModel(chart: .init())
                    FootballHexagonCardView(vm: vm)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
