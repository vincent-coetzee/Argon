//
//  VisualDesignEditorView.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/10/2023.
//

import AppKit

fileprivate class VisualDesignView: NSView
    {
    }
    
public class VisualDesignEditorView: NSView,IDEEditorView
    {
    public var editorDelegate: IDEEditorViewDelegate?
    
    public func beginEditing(node: IDENode?)
        {
        }
    
    public func configure()
        {
        }
    
    public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        true
        }
        
    public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        false
        }
    
    public func endEditing(node: IDENode?)
        {
        
        }
    
    public func canEdit(node: IDENode?) -> Bool
        {
        if node.isNil
            {
            return(false)
            }
        return(node!.nodeType == .visualDesignNode)
        }
        
    private let scrollView: NSScrollView
    private let visualDesignView: VisualDesignView
    
    public override  init(frame: NSRect)
        {
        self.scrollView = NSScrollView(frame: frame)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasVerticalRuler = true
        self.scrollView.hasHorizontalScroller = true
        self.scrollView.hasHorizontalRuler = true
        self.visualDesignView = VisualDesignView(frame: frame)
        self.visualDesignView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.documentView = self.visualDesignView
        self.scrollView.borderType = .noBorder
        super.init(frame: frame)
        self.addSubview(self.scrollView)
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    
    public required init?(coder: NSCoder)
        {
        self.scrollView = coder.decodeObject(forKey: "scrollView") as! NSScrollView
        self.visualDesignView = coder.decodeObject(forKey: "visualDesignView") as! VisualDesignView
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.scrollView,forKey: "scrollView")
        coder.encode(self.visualDesignView,forKey: "visualDesignView")
        super.encode(with: coder)
        }
        
    public func handleMenuEvent(_ sender: Any?)
        {
        }
    }
