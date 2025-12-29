//
//  IdentifiableColor.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct IdentifiableColor: Identifiable, Hashable {
    var id: Int { value.hashValue }
    var value: Color
}

extension IdentifiableColor {
    init(_ resource: ColorResource) {
        self.value = Color(resource)
    }
}
