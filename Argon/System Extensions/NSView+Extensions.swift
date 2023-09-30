//
//  NSView.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/09/2023.
//

import AppKit

extension NSView
    {
    public func showBorder(color: NSColor)
        {
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.borderColor = color.cgColor
        }
        
    public func hideBorder()
        {
        self.layer?.borderWidth = 0
        self.layer?.borderColor = NSColor.clear.cgColor
        }
    }
