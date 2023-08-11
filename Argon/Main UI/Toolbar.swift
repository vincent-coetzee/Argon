//
//  Toolbar.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/08/2023.
//

import Cocoa


public class Toolbar: NSView
    {
    public var xSpacing: CGFloat = 2
        {
        didSet
            {
            self.needsLayout = true
            }
        }
        
    public var xPadding: CGFloat = 20
        {
        didSet
            {
            self.needsLayout = true
            }
        }
        
    public var yPadding: CGFloat = 10
        {
        didSet
            {
            self.needsLayout = true
            }
        }
        
    public var showLabels: Bool = true
        {
        didSet
            {
            self.needsLayout = true
            }
        }
        
    public enum Identifier
        {
        case build
        case parse
        case clean
        case read
        case write
        case run
        case debug
        }
        
    private var items = ToolbarItems()
        
    public func addItem(_ item: ToolbarItem)
        {
        self.items.append(item)
        self.needsLayout = true
        }

    public override func layout()
        {
        super.layout()
        let sizeWidth = self.bounds.size.width
        let sizeHeight = self.bounds.size.height
        let count = CGFloat(self.items.count == 0 ? 1 : self.items.count)
        let width = ( sizeWidth - 2 * self.xPadding - (( count - 1 ) * self.xSpacing )) / count
        let height = sizeHeight - 2 * self.yPadding
        var xOffset = self.xPadding
        var yOffset = self.yPadding
        for item in self.items
            {
            item.frame = NSRect(x: xOffset,y: yOffset,width: width,height: height)
            }
        }
        
    public override func draw(_ dirtyRect: NSRect)
        {
        for item in self.items
            {
            item.draw(showLabel: self.showLabels)
            }
        }
    }
    
public class ToolbarItem
    {
    public var frame: NSRect = .zero
    
    private let label: String
    private let image: NSImage
    private let tintedImage: NSImage!
    
    public init(label: String,imageName: String)
        {
        self.label = label
        self.image = NSImage(systemSymbolName: imageName, accessibilityDescription: "")!
        self.tintedImage = self.image.image(withTintColor: SourceTheme.default.color(for: .colorTint))
        }
        
    public func draw(showLabel: Bool)
        {
        if showLabel
            {
            self.drawWithLabel()
            }
        else
            {
            self.drawWithoutLabel()
            }
        }
        
    private func drawWithLabel()
        {
        let labelString = NSAttributedString(string: self.label,attributes: [.font: SourceTheme.default.font(for: .fontToolbarText),.foregroundColor: SourceTheme.default.color(for: .colorToolbarText)])
        let labelSize = labelString.size()
        let xPadding = (self.frame.size.width - labelSize.width) / 2.0
        let bottom = self.frame.size.height
        labelString.draw(at: NSPoint(x: xPadding,y: bottom))
        self.image.draw(in: NSRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height - labelSize.height))
        }
        
    private func drawWithoutLabel()
        {
        }
    }
    
public typealias ToolbarItems = Array<ToolbarItem>
