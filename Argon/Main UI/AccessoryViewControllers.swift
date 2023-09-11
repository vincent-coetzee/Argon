//
//  TitlebarPathControlAccessoryViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/08/2023.
//

import Cocoa

class LeftSidebarButtonController: NSTitlebarAccessoryViewController
    {
    public var rightOffset: CGFloat = 0
        {
        didSet
            {
            var frame = self.view.frame
//            let width = max(45,self.rightOffset - (15 * 6))
//            frame.size.width = width
            frame.size.width = 120
            self.view.frame = frame
            }
        }
        
    public var target: Any!
    
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        }
        
    public override func loadView()
        {
        self.layoutAttribute = .left
        self.automaticallyAdjustsSize = false
        let button = TitlebarButton(imageName: "sidebar.left",target: self.target!, action: #selector(ProjectViewController.onToggleLeftSidebar),layoutAttribute: .left)
        button.frame = NSRect(x: 0,y: 0,width: 40,height: 20)
        self.view = button
        self.view.needsLayout = true
        }
    }

//class SpaceController: NSTitlebarAccessoryViewController
//    {
//    public override func viewDidLoad()
//        {
//        super.viewDidLoad()
//        }
//        
//    public override func loadView()
//        {
//        self.automaticallyAdjustsSize = false
//        self.view = NSView(frame: .zero)
//        self.view.frame = NSRect(x: 0,y: 0,width: 40,height: 20)
//        }
//    }

class RightSidebarButtonController: NSTitlebarAccessoryViewController
    {
    public var target: Any!
    
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        }
        
    public override func loadView()
        {
        self.layoutAttribute = .right
        self.automaticallyAdjustsSize = false
        let button = TitlebarButton(imageName: "sidebar.right",target: self.target!, action: #selector(ProjectViewController.onToggleRightSidebar),layoutAttribute: .right)
        button.frame = NSRect(x: 0,y: 0,width: 60,height: 30)
        self.view = button
        self.view.needsLayout = true
        }
    }

fileprivate class TitlebarButton: NSView
    {
    private let button: NSButton
    private let attribute: NSLayoutConstraint.Attribute
    
    public init(imageName: String,target: Any,action: Selector,layoutAttribute: NSLayoutConstraint.Attribute)
        {
        self.attribute = layoutAttribute
        self.button = NSButton(image: NSImage(systemSymbolName: imageName, accessibilityDescription: "")!, target: target, action: action)
        super.init(frame: .zero)
        self.addSubview(button)
        self.button.isBordered = false
        }
        
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    public override func layout()
        {
        super.layout()
        let delta = (self.bounds.size.height - 20) / 2
        if self.attribute == .right
            {
            self.button.frame = NSRect(x: self.bounds.size.width - 15 - 20,y: delta,width: 20,height: 20)
            }
        else if self.attribute == .left
            {
            self.button.frame = NSRect(x: 15,y: delta,width: 20,height: 20)
            }
        }
    }
