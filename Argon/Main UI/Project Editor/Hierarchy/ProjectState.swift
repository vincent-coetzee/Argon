//
//  ProjectState.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/08/2023.
//

import Foundation

public class ProjectState: NSObject,NSCoding
    {
    public let project: IDEProjectNode
    public let leftViewFrame: NSRect
    public let centerViewFrame: NSRect
    public let rightViewFrame: NSRect
    public var windowFrame: NSRect = .zero
    public var stateWasRestored = false
    
    public init(project: IDEProjectNode,leftViewFrame: NSRect,centerViewFrame: NSRect,rightViewFrame: NSRect)
        {
        self.project = project
        self.leftViewFrame = leftViewFrame
        self.centerViewFrame = centerViewFrame
        self.rightViewFrame = rightViewFrame
        }
        
    public required init(coder: NSCoder)
        {
        self.windowFrame = coder.decodeRect(forKey: "windowFrame")
        self.project = coder.decodeObject(forKey: "project") as! IDEProjectNode
        self.leftViewFrame = coder.decodeRect(forKey: "leftViewFrame")
        self.centerViewFrame = coder.decodeRect(forKey: "centerViewFrame")
        self.rightViewFrame = coder.decodeRect(forKey: "rightViewFrame")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.windowFrame,forKey: "windowFrame")
        coder.encode(self.project,forKey: "project")
        coder.encode(self.leftViewFrame,forKey: "leftViewFrame")
        coder.encode(self.centerViewFrame,forKey: "centerViewFrame")
        coder.encode(self.rightViewFrame,forKey: "rightViewFrame")
        }
    }
    
