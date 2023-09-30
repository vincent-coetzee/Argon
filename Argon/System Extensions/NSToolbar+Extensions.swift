//
//  NSToolbar+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/09/2023.
//

import AppKit

extension NSToolbar
    {
    public func setItem(at: String,enabled: Bool)
        {
        for item in self.items
            {
            if item.itemIdentifier == NSToolbarItem.Identifier(at)
                {
                item.isEnabled = enabled
                return
                }
            }
        }
    }
