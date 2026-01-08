//
//  FootballSelectionSummaryView.swift
//  EDICC
//
//  Created by 노우영 on 12/22/25.
//

import SwiftUI

struct FootballSelectionSummaryView: View {
    let team: EPLTeam
    let season: Int
    let onResetTap: () -> Void // 초기화 버튼 클릭 시 실행될 클로저
    
    var body: some View {
        HStack(spacing: 12) {
            
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                
                // 실제 앱에서는 팀 로고 이미지로 교체
                Image(systemName: "soccerball")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundColor(team.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(team.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("\(String(season))/\(String(season + 1).suffix(2)) Season")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Button(action: onResetTap) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(team.color) 
                }
            }
            .buttonStyle(PlainButtonStyle()) // 버튼 기본 깜빡임 효과 제거
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        // 캡슐 모양 배경에 팀 컬러 적용
        .background(
            Capsule()
                .fill(team.color)
        )
        // 붕 떠있는 느낌의 그림자
        .shadow(color: team.color.opacity(0.4), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    FootballSelectionSummaryView(
        team: .liverpool,
        season: 2014
    ) {
        
    }
}
