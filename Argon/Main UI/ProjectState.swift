//
//  ProjectState.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/08/2023.
//

import Foundation

public class ProjectState: NSObject,NSCoding
    {
    public let project: SourceProjectNode
    public let outlinerWidth: CGFloat
    public var windowFrame: NSRect = .zero
    public let sourceEditorWidth: CGFloat
    
    public init(project: SourceProjectNode,outlinerWidth: CGFloat,sourceEditorWidth: CGFloat)
        {
        self.project = project
        self.outlinerWidth = outlinerWidth
        self.sourceEditorWidth = sourceEditorWidth
        }
        
    public required init(coder: NSCoder)
        {
        self.sourceEditorWidth = coder.decodeDouble(forKey: "sourceEditorWidth")
        self.windowFrame = coder.decodeRect(forKey: "windowFrame")
        self.project = coder.decodeObject(forKey: "project") as! SourceProjectNode
        self.outlinerWidth = coder.decodeDouble(forKey: "outlinerWidth")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.windowFrame,forKey: "windowFrame")
        coder.encode(self.sourceEditorWidth,forKey: "sourceEditorWidth")
        coder.encode(self.project,forKey: "project")
        coder.encode(self.outlinerWidth,forKey: "outlinerWidth")
        }
    }
    
