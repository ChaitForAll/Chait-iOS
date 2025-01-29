//
//  SupaBaseService.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Supabase

struct SupaBasePlatform {
    
    // MARK: Property(s)
    
    let client: SupabaseClient
    
    init() {
        let mainBundle = Bundle.main
        guard let projectURL: URL = URL(string: "https://dndbtcgtwrpfmjycgwps.supabase.co") else {
            fatalError("URL Not Valid. Please check project URL.")
        }
        guard let supabaseKey = mainBundle.object(forInfoDictionaryKey: "SupaBaseSecretKey") as? String
        else {
            fatalError("Failed to read SupaBase statis information. Please check ApplicationSettings.xcconfig")
        }
        
        self.client = SupabaseClient(
            supabaseURL: projectURL,
            supabaseKey: supabaseKey
        )
    }
}
