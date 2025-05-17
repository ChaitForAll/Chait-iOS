//
//  UIFont+PreferredFontWeight.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

extension UIFont {
    static func preferredFont(for textStyle: TextStyle, weight: Weight) -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let font = UIFont.systemFont(ofSize: fontDescriptor.pointSize, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        return metrics.scaledFont(for: font)
    }
}
