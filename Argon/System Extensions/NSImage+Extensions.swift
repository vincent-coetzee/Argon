//
//  NSImage+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/08/2023.
//

import Cocoa

extension NSImage
    {
   func image(withTintColor tintColor: NSColor) -> NSImage
        {
        guard isTemplate else
            {
            return self
            }
       guard let copiedImage = self.copy() as? NSImage else
            {
            return self
            }
       copiedImage.lockFocus()
       tintColor.set()
       let imageBounds = NSMakeRect(0, 0, copiedImage.size.width+2, copiedImage.size.height)
       imageBounds.fill(using: .sourceAtop)
       copiedImage.unlockFocus()
       copiedImage.isTemplate = false
       return copiedImage
       }
    }
