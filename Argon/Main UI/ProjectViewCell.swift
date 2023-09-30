//
//  ProjectViewCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/04/2023.
//

import AppKit

public class ProjectViewCell: NSTableCellView
    {
    private static let fontStyleElement: StyleElement = .fontProjectCell
    
    public var cellWidth: CGFloat
        {
        guard let field = self.textField else
            {
            return(0)
            }
        let text = field.attributedStringValue
        let textWidth = text.size().width
        return(20 + 8 + textWidth)
        }
        
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
                self.imageView?.contentTintColor = StyleTheme.shared.color(for: .colorTint)
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
        let cellFont = StyleTheme.shared.font(for: Self.fontStyleElement)
        let rowHeight = cellFont.lineHeight + 4 + 4
        let imageWidth = rowHeight - 4
        self.imageView!.frame = NSRect(x: 0,y: 2,width: imageWidth,height: imageWidth)
        let inset = (theFrame.size.height - cellFont.lineHeight) / 2
        self.textField!.frame = NSRect(x: imageWidth + 4,y: inset,width: theFrame.size.width - imageWidth - 4,height: cellFont.lineHeight)
        self.textField?.font = cellFont
        }
    }
