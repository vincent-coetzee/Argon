//
//  NSMenuItem+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/10/2023.
//

import AppKit

extension NSMenuItem
    {
    public var identifierValue: String
        {
        self.identifier?.rawValue ?? ""
        }
    }
