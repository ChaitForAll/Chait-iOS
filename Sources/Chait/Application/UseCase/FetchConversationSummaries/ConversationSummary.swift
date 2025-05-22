//
//  ConversationSummary.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation

struct ConversationSummary {
    let id: UUID
    let title: String
    let titleImage: String?
    let lastMessageText: String?
    let lastMessageSenderName: String?
    let lastMessageSenderImage: String?
}

extension ConversationSummary {
    init(
        conversationDetail: ConversationDetail,
        messageDetail: MessageDetail,
        userDetail: UserDetail
    ) {
        self.id = conversationDetail.id
        self.title = conversationDetail.title
        self.titleImage = conversationDetail.titleImage
        self.lastMessageText = messageDetail.text
        self.lastMessageSenderName = userDetail.userName
        self.lastMessageSenderImage = userDetail.profileImage
    }
}
