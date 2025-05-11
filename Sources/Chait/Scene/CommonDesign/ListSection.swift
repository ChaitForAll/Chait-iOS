//
//  BaseSection.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class ListSection<SectionType: CaseIterable, Item: Identifiable> {
    
    let id: UUID = UUID()
    let sectionType: SectionType
    var items: [Item.ID: Item] = [:]
    
    init(sectionType: SectionType) {
        self.sectionType = sectionType
    }
    
    func item(for identifier: Item.ID) -> Item? {
        return items[identifier]
    }
    
    func insertItems(_ insertingItems: [Item]) {
        insertingItems.forEach { item in
            items[item.id] = item
        }
    }
}
