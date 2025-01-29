//
//  ChannelEntity.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct Channel: Identifiable {
    let id: UUID
    let title: String
    let updatedAt: Date
    let createdAt: Date
}
