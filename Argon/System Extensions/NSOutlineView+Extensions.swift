//
//  NSOutlineView+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import AppKit

extension NSOutlineView
    {
    public var widthOfWidestVisibleRow: CGFloat
        {
        let scrollView = self.enclosingScrollView!
        let visibleRectangle = scrollView.contentView.visibleRect
        let range = self.rows(in: visibleRectangle)
        var maximumWidth:CGFloat = 0
        for row in stride(from: range.location, through: range.location + range.length - 1, by: 1)
            {
            let indent = self.indentationPerLevel
            let level = self.level(forRow: row)
            let inset = indent * CGFloat(level)
            if let view = self.view(atColumn: 0, row: row, makeIfNecessary: false) as? ProjectViewCell
                {
                maximumWidth = max(maximumWidth,view.cellWidth + inset)
                }
            }
        return(maximumWidth)
        }
    }
