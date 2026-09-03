//
//  navHandler.swift
//  presentation
//
//  Created by user on 02/09/2026.
//

import Foundation
import Observation

@Observable
final class SlideDeck {
    private(set) var slides: [Slide]
    private(set) var currentIndex = 0

    init(slides: [Slide] = loadSlides()) {
        self.slides = slides
    }

    var currentSlide: Slide? {
        slides.indices.contains(currentIndex) ? slides[currentIndex] : nil
    }

    func next() {
        guard currentIndex < slides.count - 1 else { return }
        currentIndex += 1
    }

    func previous() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
}
