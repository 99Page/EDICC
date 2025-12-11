import UIKit

extension UIColor {

    /// Hex Code 문자열을 사용하여 UIColor를 생성합니다.
    ///
    /// 유효하지 않은 Hex 문자열이 주어질 경우 투명한 색상 (UIColor.clear)을 반환합니다.
    ///
    /// - Parameter hex: `#RRGGBB` 또는 `RRGGBB` 형식의 16진수 문자열.
    /// - Parameter alpha: 투명도 값 (0.0에서 1.0 사이). 기본값은 1.0 (불투명).
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        
        // 1. 문자열 정리 및 유효성 검사
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        hexSanitized = hexSanitized.replacingOccurrences(of: "0x", with: "")
        
        // Hex Code는 반드시 6자리여야 함 (RRGGBB)
        guard hexSanitized.count == 6 else {
            // 유효성 검사 실패 시 UIColor.clear로 초기화
            self.init(red: 0, green: 0, blue: 0, alpha: 0) // .clear와 동일
            return
        }
        
        // 2. R, G, B 구성 요소를 분리
        var rgbValue: UInt64 = 0
        
        // 16진수 문자열을 UInt64로 변환
        // 변환에 실패하면 (예: 유효하지 않은 문자 포함) 0이 됩니다.
        let success = Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        guard success else {
            // 16진수 변환 실패 시 투명한 색상으로 초기화
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        
        // Red (RRGGBB에서 앞 2자리)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        // Green (RRGGBB에서 중간 2자리)
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        // Blue (RRGGBB에서 끝 2자리)
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        // 3. UIColor 초기화
        self.init(red: red,
