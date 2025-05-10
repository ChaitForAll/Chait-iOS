//
//  BaseSection.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class ListSection<SectionType: CaseIterable, Item: Identifiable> {
    
    let id: UUID = UUID()
    let sectionType: SectionType
    var items: [Item] = []
    
    init(sectionType: SectionType) {
        self.sectionType = sectionType
    }
}
