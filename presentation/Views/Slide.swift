//
//  Slide.swift
//  presentation
//
//  Created by user on 31/08/2026.
//

import Foundation

struct Slide: Identifiable {
    let id = UUID()
    let title: String?
    let blocks: [Block]
}

struct Block: Identifiable {
    let id = UUID()
    let kind: Kind

    enum Kind {
        case paragraph(AttributedString)
        case bullets([AttributedString])
    }
}
