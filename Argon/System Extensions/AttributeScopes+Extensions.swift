//
//  AttributesScopes+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/06/2023.
//

import Foundation
import AppKit

public extension AttributeScopes
    {
    struct CustomAttributes: AttributeScope
        {
        let customStyle: CustomTextStyleAttributes
        let appKitAttributes: AttributeScopes.AppKitAttributes
        var customAttributes: CustomAttributes.Type { CustomAttributes.self }
        }
    }


public extension AttributeDynamicLookup
    {
    subscript<T: AttributedStringKey>
        (
        dynamicMember keyPath: KeyPath<AttributeScopes.CustomAttributes, T>
        ) -> T
        {
        self[T.self]
        }
    }
