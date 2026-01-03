//
//  HexagonStatsTableView.swift
//  EDICC
//
//  Created by 노우영 on 12/17/25.
//

import SwiftUI

struct HexagonStatsTableView: View {
    @Bindable var model: HexagonCardModel
    
    var body: some View {
        VStack(spacing: 0) {
            Grid(verticalSpacing: 12) {
                GridRow {
                    Text("지표")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .gridColumnAlignment(.leading)
                    
                    ForEach(model.chart.dataSets) { dataSet in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(dataSet.color.value)
                                .frame(width: 8, height: 8)
                            
                            Text(dataSet.label)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .gridColumnAlignment(.trailing)
                        .onTapGesture {
                            model.selectedDataSet = dataSet
                        }
                    }
                }
                .padding(.bottom, 8)
                
                Divider()
                
                ForEach(0..<model.chart.axisLabels.count, id: \.self) { index in
                    GridRow {
                        Text(model.chart.axisLabels[index])
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.8)) // 진한 회색
                        
                        ForEach(model.chart.dataSets) { dataSet in
                            if index < dataSet.points.count {
                                Text(String(format: "%.1f", dataSet.points[index].rawValue))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.5))
                            } else {
                                Text("-")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if index < model.chart.axisLabels.count - 1 {
                        Divider()
                            .gridCellUnsizedAxes(.horizontal) // 구분선이 가로로 꽉 차게
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    @Previewable @State var model = HexagonCardModel()
    
    HexagonStatsTableView(
        model: model
    )
    .padding(.horizontal)
}
