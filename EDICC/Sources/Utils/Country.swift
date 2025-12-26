//
//  Country.swift
//  EDICC
//
//  Created by 노우영 on 12/26/25.
//

import Foundation

enum Country: String, CaseIterable {
    // MARK: - UK & Home Nations
    case england, wales, scotland, northernIreland
    
    // MARK: - Europe
    case france, germany, italy, spain, portugal
    case netherlands, belgium, switzerland, austria
    case sweden, norway, denmark, ireland
    case poland, czechia, hungary, ukraine, romania
    case serbia, croatia, greece, turkey
    
    // MARK: - Asia
    case korea, japan, china
    
    // MARK: - Americas
    case usa, brazil, argentina, uruguay
    case colombia, chile, mexico, ecuador
    
    // MARK: - Africa
    case algeria, morocco, egypt, nigeria, cameroon, ghana, ivoryCoast
    case senegal, mali, burkinaFaso
    
    // MARK: - Fallback
    case unknown
    
    // MARK: - Initializer
    init(from apiString: String?) {
        guard let name = apiString?.lowercased() else {
            self = .unknown
            return
        }
        
        switch name {
        // UK & Home Nations
        case "england", "united kingdom", "uk": self = .england // 영국은 보통 잉글랜드로 통합
        case "wales": self = .wales
        case "scotland": self = .scotland
        case "northern ireland": self = .northernIreland
            
        // Europe
        case "france": self = .france
        case "germany": self = .germany
        case "italy": self = .italy
        case "spain": self = .spain
        case "portugal": self = .portugal
        case "netherlands", "holland": self = .netherlands
        case "belgium": self = .belgium
        case "switzerland": self = .switzerland
        case "austria": self = .austria
        case "sweden": self = .sweden
        case "norway": self = .norway
        case "denmark": self = .denmark
        case "republic of ireland", "ireland": self = .ireland
        case "poland": self = .poland
        case "czech republic", "czechia": self = .czechia
        case "hungary": self = .hungary
        case "ukraine": self = .ukraine
        case "romania": self = .romania
        case "serbia": self = .serbia
        case "croatia": self = .croatia
        case "greece": self = .greece
        case "turkey", "türkiye": self = .turkey
            
        // Asia
        case "korea republic", "south korea", "korea": self = .korea
        case "japan": self = .japan
        case "china": self = .china
            
        // Americas
        case "usa", "united states", "america": self = .usa
        case "brazil": self = .brazil
        case "argentina": self = .argentina
        case "uruguay": self = .uruguay
        case "colombia": self = .colombia
        case "chile": self = .chile
        case "mexico": self = .mexico
        case "ecuador": self = .ecuador
            
        // Africa
        case "algeria": self = .algeria
        case "morocco": self = .morocco
        case "egypt": self = .egypt
        case "nigeria": self = .nigeria
        case "cameroon": self = .cameroon
        case "ghana": self = .ghana
        case "cote d'ivoire", "ivory coast": self = .ivoryCoast
        case "senegal": self = .senegal
        case "mali": self = .mali
        case "burkina faso": self = .burkinaFaso
            
        default: self = .unknown
        }
    }
    
    // MARK: - Flag Emoji
    var flag: String {
        switch self {
        // UK & Home Nations
        case .england: return "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
        case .wales: return "🏴󠁧󠁢󠁷󠁬󠁳󠁿"
        case .scotland: return "🏴󠁧󠁢󠁳󠁣󠁴󠁿"
        case .northernIreland: return "🇬🇧" // 이모지 없음 -> 영국 국기 대체
            
        // Europe
        case .france: return "🇫🇷"
        case .germany: return "🇩🇪"
        case .italy: return "🇮🇹"
        case .spain: return "🇪🇸"
        case .portugal: return "🇵🇹"
        case .netherlands: return "🇳🇱"
        case .belgium: return "🇧🇪"
        case .switzerland: return "🇨🇭"
        case .austria: return "🇦🇹"
        case .sweden: return "🇸🇪"
        case .norway: return "🇳🇴"
        case .denmark: return "🇩🇰"
        case .ireland: return "🇮🇪"
        case .poland: return "🇵🇱"
        case .czechia: return "🇨🇿"
        case .hungary: return "🇭🇺"
        case .ukraine: return "🇺🇦"
        case .romania: return "🇷🇴"
        case .serbia: return "🇷🇸"
        case .croatia: return "🇭🇷"
        case .greece: return "🇬🇷"
        case .turkey: return "🇹🇷"
            
        // Asia
        case .korea: return "🇰🇷"
        case .japan: return "🇯🇵"
        case .china: return "🇨🇳"
            
        // Americas
        case .usa: return "🇺🇸"
        case .brazil: return "🇧🇷"
        case .argentina: return "🇦🇷"
        case .uruguay: return "🇺🇾"
        case .colombia: return "🇨🇴"
        case .chile: return "🇨🇱"
        case .mexico: return "🇲🇽"
        case .ecuador: return "🇪🇨"
            
        // Africa
        case .algeria: return "🇩🇿"
        case .morocco: return "🇲🇦"
        case .egypt: return "🇪🇬"
        case .nigeria: return "🇳🇬"
        case .cameroon: return "🇨🇲"
        case .ghana: return "🇬🇭"
        case .ivoryCoast: return "🇨🇮"
        case .senegal: return "🇸🇳"
        case .mali: return "🇲🇱"
        case .burkinaFaso: return "🇧🇫"
            
        case .unknown: return "🏳️"
        }
    }
}
