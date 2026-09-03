//
//  MDToSlide.swift
//  presentation
//
//  Created by user on 31/08/2026.
//

import Foundation
// match md file number (numerical) to display as text

// Find every bundled .md file, ordered by its numeric filename, and parse
// each into a Slide.

func loadSlides() -> [Slide] {
    let urls = Bundle.main.urls(forResourcesWithExtension: "md", subdirectory: nil) ?? []

    let sorted = urls.sorted { lhs, rhs in
        let lhsNumber = Int(lhs.deletingPathExtension().lastPathComponent) ?? .max
        let rhsNumber = Int(rhs.deletingPathExtension().lastPathComponent) ?? .max
        return lhsNumber < rhsNumber
    }

    return sorted.compactMap { url in
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return parseSlide(from: contents)
    }
}

// Parse a markdown file's contents into a Slide: leading "# " line becomes
// the title, and the remaining text is split into paragraph/bullet blocks
// on blank lines.

func parseSlide(from markdown: String) -> Slide {
    var lines = markdown.components(separatedBy: .newlines)

    var title: String?
    if let first = lines.first, first.trimmingCharacters(in: .whitespaces).hasPrefix("#") {
        title = first.trimmingCharacters(in: .whitespaces)
            .drop(while: { $0 == "#" })
            .trimmingCharacters(in: .whitespaces)
        lines.removeFirst()
    }

    var blocks: [Block] = []
    var currentGroup: [String] = []

    func flushGroup() {
        defer { currentGroup = [] }
        guard !currentGroup.isEmpty else { return }

        let isBulletGroup = currentGroup.allSatisfy {
            $0.trimmingCharacters(in: .whitespaces).hasPrefix("-") ||
            $0.trimmingCharacters(in: .whitespaces).hasPrefix("*")
        }

        if isBulletGroup {
            let items = currentGroup.map { line -> AttributedString in
                let stripped = line.trimmingCharacters(in: .whitespaces)
                    .dropFirst()
                    .trimmingCharacters(in: .whitespaces)
                return attributedString(from: stripped)
            }
            blocks.append(Block(kind: .bullets(items)))
        } else {
            let paragraph = currentGroup.joined(separator: " ")
            blocks.append(Block(kind: .paragraph(attributedString(from: paragraph))))
        }
    }

    for line in lines {
        if line.trimmingCharacters(in: .whitespaces).isEmpty {
            flushGroup()
        } else {
            currentGroup.append(line)
        }
    }
    flushGroup()

    return Slide(title: title, blocks: blocks)
}

private func attributedString(from text: String) -> AttributedString {
    (try? AttributedString(markdown: text)) ?? AttributedString(text)
}


