//
//  CustomView.swift
//  ArgonWorks
//
//  Created by Vincent Coetzee on 26/3/22.
//

import Cocoa

//
//
// NEW NEW NEW
//
//
public protocol Control: AnyObject
    {
    var key: String { get }
    var textFontIdentifier: StyleElement { get set }
    var valueModel: ValueModel { get set }
    }
    
public class CustomView: NSView
    {
    public enum ViewEdge
        {
        case left
        case right
        case top
        case bottom
        }
        
    public var textFontIdentifier: StyleElement = .fontDefault
        
    public var backgroundColorIdentifier: StyleElement = .colorBackground
        {
        didSet
            {
            self.wantsLayer = true
            self.layer!.backgroundColor = SourceTheme.shared.color(for: self.backgroundColorIdentifier).cgColor
            }
        }
        
    public var drawsHorizontalBorder: Bool = false
        {
        didSet
            {
            self.needsDisplay = true
            }
        }
        
    public var horizontalBorderColorIdentifier: StyleElement = .colorLine
        {
        didSet
            {
            self.needsDisplay = true
            }
        }
        
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.wantsLayer = true
        }
    
    required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        }
    
    public override func awakeFromNib()
        {
        super.awakeFromNib()
        self.wantsLayer = true
        }
    }

