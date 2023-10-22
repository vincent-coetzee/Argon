//
//  GroupElement.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/04/2023.
//

import AppKit

public class IDEFolderNode: IDECompositeNode
    {
    public override var nodeType: IDENodeType
        {
        .folderNode
        }
        
    public override var projectViewImage: NSImage
        {
        NSImage(named: "IconGroup")!
        }
    }
