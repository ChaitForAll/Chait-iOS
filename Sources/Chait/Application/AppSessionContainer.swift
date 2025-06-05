//
//  AppContainer.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
  
import Supabase
import Foundation

final class AppSessionContainer {
    
    // MARK: Repository(s)
    
    private let conversationRepository: ConversationRepository
    private let friendRepository: FriendRepository
    private let imageRepository: ImageRepository
    private let messageRepository: MessageRepository
    private let userRepository: UserRepository
    
    // MARK: DataSource(s)
    
    private let userRemoteDataSource: UserRemoteDataSource
    private let conversationMembershipDataSource: ConversationMembershipRemoteDataSource
    private let conversationDataSource: ConversationRemoteDataSource
    private let messageRemoteDataSource: RemoteMessagesDataSource
    
    
    init(client: SupabaseClient, authSession: AuthSession) {
        self.userRemoteDataSource = DefaultUserRemoteDataSource(supabase: client)
        self.conversationMembershipDataSource = DefaultConversationMembershipRemoteDataSource(
            supabase: client
        )
        self.conversationDataSource = DefaultConversationRemoteDataSource(supabase: client)
        self.messageRemoteDataSource = DefaultRemoteMessagesDataSource(client: client)
        
        self.conversationRepository = ConversationRepositoryImplementation(
            conversationRemote: conversationDataSource,
            conversationMembershipRemote: conversationMembershipDataSource,
            userRemote: userRemoteDataSource,
            authSession: authSession
        )
        self.friendRepository = FriendRepositoryImplementation(
            client: client,
            usersRemote: userRemoteDataSource,
            authSession: authSession
        )
        self.imageRepository = ImageRepositoryImplementation(imageManager: ImageManager())
        self.messageRepository = MessageRepositoryImplementation(
            messagesDataSource: messageRemoteDataSource,
            authSession: authSession
        )
        self.userRepository = UserRepositoryImplementation(
            userDataSource: userRemoteDataSource,
            authSession: authSession
        )
    }
    
    
    // MARK: UseCase(s)
    
    private func fetchImageUseCase() -> FetchImageUseCase {
        return DefaultFetchImageUseCase(imageRepository: imageRepository)
    }
    
    private func conversationUseCase() -> ConversationUseCase {
        return DefaultConversationUseCase(
            conversationRepository: conversationRepository // TODO: try get rid of optional
        )
    }
    
    private func sendMessageUseCase() -> SendMessageUseCase {
        return SendMessageUseCase(messageRepository: messageRepository)
    }
    
    private func fetchFriendListUseCase() -> FetchFriendsListUseCase {
        return DefaultFetchFriendsListUseCase(repository: friendRepository)
    }
     
    private func fetchConversationSummariesUseCase() -> FetchConversationSummariesUseCase {
        return FetchConversationSummariesUseCase(
            conversationRepository: conversationRepository,
            messageRepository: messageRepository,
            userRepository: userRepository
        )
    }
    
    private func fetchConversationHistoriesUseCase() -> FetchConversationHistoryUseCase {
        return DefaultFetchConversationHistory(repository: messageRepository)
    }
    
    private func streamMessageUpdatesUseCase() -> StreamMessageUpdatesUseCase {
        return DefaultStreamMessageUpdatesUseCase(
            userRepository: userRepository,
            conversationRepository: conversationRepository,
            messagesRepository: messageRepository
        )
    }
    
    // MARK: ViewModel(s)
    
    func conversationListViewModel() -> ConversationListViewModel {
        return ConversationListViewModel(
            fetchConversationSummaries: fetchConversationSummariesUseCase()
        )
    }
    
    func friendListViewModel() -> FriendListViewModel {
        return FriendListViewModel(
            fetchFriendsListUseCase: fetchFriendListUseCase(),
            fetchImageUseCase: fetchImageUseCase()
        )
    }
    
    func personalChatViewModel(_ channelID: UUID) -> ConversationViewModel {
        return ConversationViewModel(
            channelID: channelID,
            conversationUseCase: conversationUseCase(),
            sendMessageUseCase: sendMessageUseCase(),
            fetchConversationHistoryUseCase: fetchConversationHistoriesUseCase(),
            streamMessageUpdatesUseCase: streamMessageUpdatesUseCase()
        )
    }
}
