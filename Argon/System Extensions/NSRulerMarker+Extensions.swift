//
//  NSRulerMarker+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/09/2023.
//

import AppKit

extension NSRulerMarker
    {
    public var color: NSColor
        {
        guard self.representedObject.isNotNil else
            {
            return(.clear)
            }
        if self.representedObject is CompilerIssue
            {
            return(StyleTheme.shared.color(for: .colorIssue))
            }
        if self.representedObject is Breakpoint
            {
            return(StyleTheme.shared.color(for: .colorBreakpoint))
            }
        return(.clear)
        }
    }
