
//
//  PostgrestFilterBuilder+ApplyFilters.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Supabase

extension PostgrestFilterBuilder {
    
    func applying(filters: [RequestFilter]) -> PostgrestFilterBuilder {
        var base: PostgrestFilterBuilder = self
        for filter in filters {
            base = base.filter(
                filter.column,
                operator: filter.requestOperator,
                value: filter.value
            )
        }
        return base
    }
}
