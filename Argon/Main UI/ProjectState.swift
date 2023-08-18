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
    
    public init(project: SourceProjectNode,outlinerWidth: CGFloat)
        {
        self.project = project
        self.outlinerWidth = outlinerWidth
        }
        
    public required init(coder: NSCoder)
        {
        self.project = coder.decodeObject(forKey: "project") as! SourceProjectNode
        self.outlinerWidth = coder.decodeDouble(forKey: "outlinerWidth")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.project,forKey: "project")
        coder.encode(self.outlinerWidth,forKey: "outlinerWidth")
        }
    }
    
