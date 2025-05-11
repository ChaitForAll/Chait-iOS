//
//  UITextField+Bind.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

extension UITextField {
    
    func bind<Object: AnyObject>(
        to property: ReferenceWritableKeyPath<Object, String>,
        on object: Object?
    ) -> AnyCancellable {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .removeDuplicates()
            .sink { object?[keyPath: property] = $0 }
    }
}
