//
//  ChannelUpdate.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


struct ChannelUpdate {
    
    enum UpdateState {
        case inserted
        case updated
        case deleted
    }
    
    let updatedChannel: Channel
    let channelUpdateState: UpdateState
}
