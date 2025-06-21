//
//  FriendViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Combine
import Foundation

final class FriendViewModel: Identifiable {
    
    @Published var imageData: Data?
    
    let id: UUID
    let name: String
    let displayName: String
    let status: String
    let createdAt: Date
    let imageURL: URL
    
    private var cancelBag = Set<AnyCancellable>()
    private let profileImageDataService: UserImageService
    
    init(profileImageDataService: UserImageService, friend: Friend) {
        self.profileImageDataService = profileImageDataService
        self.id = friend.friendID
        self.name = friend.name
        self.displayName = friend.displayName.isEmpty ? friend.name : friend.displayName
        self.status = friend.status
        self.createdAt = friend.createdAt
        self.imageURL = friend.image
    }
    
    func prepareImageData() {
        let command = FetchUserImageCommand(userID: id, imageType: .profile)
        profileImageDataService.fetchImageData(command)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                  receiveValue: { userImage in
                      self.imageData = userImage.data
                  }
            ).store(in: &cancelBag)
    }
}

extension FriendViewModel: Equatable {
    static func == (lhs: FriendViewModel, rhs: FriendViewModel) -> Bool {
        return [
            lhs.id == rhs.id,
            lhs.name == rhs.name,
            lhs.displayName == rhs.displayName,
            lhs.status == rhs.status,
            lhs.createdAt == rhs.createdAt,
            lhs.imageData == rhs.imageData
        ].allSatisfy { $0 == true }
    }
}
