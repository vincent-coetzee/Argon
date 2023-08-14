//
//  ProjectViewCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/04/2023.
//

import Cocoa

public class ProjectViewCell: NSTableCellView
    {
    public var node: SourceNode?
        {
        didSet
            {
            if self.node.isNotNil
                {
                self.textField?.stringValue = self.node?.name ?? ""
                let image = self.node!.projectViewImage
                self.imageView?.image = image
                self.imageView?.image?.isTemplate = true
                self.imageView?.contentTintColor = SourceTheme.shared.color(for: .colorTint)
                }
            }
        }
        
    @objc public func textFieldChanged(_ sender: Any?)
        {
        
        }
        
    public override func layout()
        {
        super.layout()
        let theFrame = self.bounds
        self.imageView!.frame = NSRect(x: 4,y: 2,width: 20,height: theFrame.size.height - 2)
        self.textField!.frame = NSRect(x: 24,y: 2,width: theFrame.size.width - 24,height: theFrame.size.height - 4)
        self.textField?.font = SourceTheme.shared.font(for: .fontDefault)
        }
    }
