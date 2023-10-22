//
//  NSMenu+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/10/2023.
//

import AppKit

extension NSMenu
    {
    public var target: AnyObject?
        {
        get
            {
            nil
            }
        set
            {
            for item in self.items
                {
                item.target = newValue
                }
            }
        }
    }
