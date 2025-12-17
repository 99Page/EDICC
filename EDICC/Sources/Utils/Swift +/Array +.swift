//
//  Array +.swift
//  EDICC
//
//  Created by 노우영 on 12/22/25.
//

import Foundation

extension Array {
    /// 배열을 지정된 크기만큼 쪼개서 이중 배열로 반환합니다.
    ///
    /// # Example
    ///   ```swift
    ///   let numbers = [1, 2, 3, 4, 5]
    ///   let chunks = numbers.chunked(into: 2)
    ///   // 결과: [[1, 2], [3, 4], [5]]
    ///   ```
    func chunked(into size: Int) -> [[Element]] {
        // 1. stride(from:to:by:): 0부터 배열의 끝(count)까지 'size'만큼 건너뛰며 인덱스를 생성합니다.
        //    예) count가 5이고 size가 2라면 -> 0, 2, 4 생성
        return stride(from: 0, to: count, by: size).map { startIndex in
            
            // 2. 종료 인덱스 계산
            //    기본적으로는 (시작점 + size)이지만,
            //    마지막 덩어리의 경우 배열의 총 개수(count)를 넘으면 안 되므로 Swift.min을 사용해 안전하게 자릅니다.
            let endIndex = Swift.min(startIndex + size, count)
            
            // 3. 배열 슬라이싱 (Array Slicing)
            //    self[startIndex ..< endIndex]는 원본 배열의 일부를 가리키는 'ArraySlice'를 반환합니다.
            //    이를 다시 Array(...)로 감싸서 독립적인 배열로 만듭니다.
            return Array(self[startIndex ..< endIndex])
        }
    }
}
