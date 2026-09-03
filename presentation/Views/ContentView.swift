//
//  ContentView.swift
//  presentation
//
//  Created by user on 31/08/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var deck = SlideDeck()
    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let slide = deck.currentSlide {
                    if let title = slide.title {
                        Text(title)
                            .font(.largeTitle)
                            .bold()
                    }
                    ForEach(slide.blocks) { block in
                        switch block.kind {
                        case .paragraph(let text):
                            Text(text)
                        case .bullets(let items):
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                                    HStack(alignment: .top, spacing: 6) {
                                        Text("•")
                                        Text(item)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("No slides found")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .focusable()
        .focused($isFocused)
        .onAppear { isFocused = true }
        .onKeyPress(.leftArrow) {
            deck.previous()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            deck.next()
            return .handled
        }
    }
}

#Preview {
    ContentView()
}
