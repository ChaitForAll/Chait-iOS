//
//  CreateNewChannelUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

enum CreateNewChannelError: Error {
    case invalidInput(String)
    case unknown
}

protocol CreateNewChannelUseCase {
    func create(newChannel: NewChannel ) -> AnyPublisher<Void, CreateNewChannelError>
} 
