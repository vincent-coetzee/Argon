//
//  ValueModel.swift
//  ArgonWorks
//
//  Created by Vincent Coetzee on 26/3/22.
//

import AppKit

public protocol ValueModel: Model
    {
    var value: Any? { get set }
    }
    
extension ValueModel
    {
    public var booleanValue: Bool?
        {
        self.value as? Bool
        }
        
    public var stringValue: String?
        {
        self.value as? String
        }
        
    public var imageValue: NSImage?
        {
        self.value as? NSImage
        }
        
    public var colorValue: NSColor?
        {
        self.value as? NSColor
        }
        
    public func shake(aspect: String)
        {
        self.changed(aspect: aspect,with: self.value,from: self)
        }
    }
