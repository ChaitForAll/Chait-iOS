//
//  AppContainer.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
  
import Supabase
import Foundation

final class AppContainer {
    
    // MARK: External(s)
    
    private let supabaseClient: SupabaseClient
    
    // MARK: Service(s)
    
    let authService: AuthenticationService
    
    // MARK: Repository(s)
    
    private let conversationRepository: ConversationRepository
    private let friendRepository: FriendRepository
    private let imageRepository: ImageRepository
    
    // MARK: DataSource(s)
    
    private let userRemoteDataSource: UserRemoteDataSource
    private let conversationMembershipDataSource: ConversationMembershipRemoteDataSource
    private let conversationDataSource: ConversationRemoteDataSource
    
    
    init() {
        let supabaseClient = SupabaseClient(
            supabaseURL: AppEnvironment.projectURL,
            supabaseKey: AppEnvironment.secretKey
        )
        
        self.authService = AuthenticationService(supabase: supabaseClient)
        
        self.userRemoteDataSource = DefaultUserRemoteDataSource(supabase: supabaseClient)
        self.conversationMembershipDataSource = DefaultConversationMembershipRemoteDataSource(supabase: supabaseClient)
        self.conversationDataSource = DefaultConversationRemoteDataSource(supabase: supabaseClient)
        
        self.conversationRepository = ConversationRepositoryImplementation(
            conversationRemote: conversationDataSource,
            conversationMembershipRemote: conversationMembershipDataSource,
            userRemote: userRemoteDataSource
        )
        self.friendRepository = FriendRepositoryImplementation(
            client: supabaseClient,
            usersRemote: userRemoteDataSource
        )
        self.imageRepository = ImageRepositoryImplementation(imageManager: ImageManager())

        self.supabaseClient = supabaseClient
    }
    
    
    // MARK: UseCase(s)
    
    private func fetchImageUseCase() -> FetchImageUseCase {
        return DefaultFetchImageUseCase(imageRepository: imageRepository)
    }
    
    private func conversationUseCase() -> ConversationUseCase {
        return DefaultConversationUseCase(
            conversationRepository: conversationRepository,
            userID: authService.userID ?? UUID() // TODO: try get rid of optional
        )
    }
    
    private func fetchFriendListUseCase() -> FetchFriendsListUseCase {
        return DefaultFetchFriendsListUseCase(repository: friendRepository)
    }
    
    // MARK: ViewModel(s)
    
    func conversationListViewModel() -> ConversationListViewModel {
        return ConversationListViewModel(conversationUseCase: conversationUseCase())
    }
    
    func friendListViewModel() -> FriendListViewModel {
        return FriendListViewModel(
            userID: authService.userID ?? UUID(),
            fetchFriendsListUseCase: fetchFriendListUseCase(),
            fetchImageUseCase: fetchImageUseCase()
        )
    }
    
    func personalChatViewModel(_ channelID: UUID) -> PersonalChatViewModel {
        return PersonalChatViewModel(
            userID: authService.userID ?? UUID(),
            channelID: channelID,
            conversationUseCase: conversationUseCase()
        )
    }
    
    func authViewModel() -> AuthViewModel {
        return AuthViewModel(authService: authService)
    }
}
