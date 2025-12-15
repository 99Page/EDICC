//
//  IdentifiableColor.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct IdentifiableColor: Identifiable {
    let id = UUID()
    var color: Color
}

extension IdentifiableColor {
    init(_ resource: ColorResource) {
        self.color = Color(resource)
    }
}
