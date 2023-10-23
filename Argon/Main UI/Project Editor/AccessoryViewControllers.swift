//
//  TitlebarPathControlAccessoryViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/08/2023.
//

import Cocoa

class LeftSidebarButtonController: NSTitlebarAccessoryViewController
    {
    public var selectedNodeModel: ValueModel?
        {
        get
            {
            (self.view as! TitlebarView).selectedNodeModel
            }
        set
            {
            (self.view as! TitlebarView).selectedNodeModel = newValue
            }
        }
        
    public var issueCountIconLabelView: IconLabelView
        {
        (self.view as! TitlebarView).issueCountIconLabelView
        }
        
    public func setViewSize(_ size: CGSize)
        {
        var frame = self.view.frame
        frame.size.width = size.width
        self.view.frame = frame
        }
        
    public var target: Any!
    
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        }
        
    public override func loadView()
        {
        self.layoutAttribute = .left
        self.view = TitlebarView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        var button = NSButton(image: NSImage(systemSymbolName: "sidebar.left", accessibilityDescription: nil)!, target: self.target, action: #selector(ProjectViewController.onToggleLeftSidebar))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        self.view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button = NSButton(image: NSImage(systemSymbolName: "sidebar.right", accessibilityDescription: nil)!, target: self.target, action: #selector(ProjectViewController.onToggleRightSidebar))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        self.view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.view.needsLayout = true
        }
    }
    
class LowerTitleController: NSTitlebarAccessoryViewController,Dependent
    {
    public let dependentKey = DependentSet.nextDependentKey
    
    public func setViewHeight(_ height: CGFloat)
        {
        var frame = self.view.frame
        frame.size.height = height
        self.view.frame = frame
        }
        
    public var selectedNodeModel: ValueModel?
        {
        willSet
            {
            self.selectedNodeModel?.removeDependent(self)
            }
        didSet
            {
            self.selectedNodeModel?.addDependent(self)
            self.selectedNodeModel?.shake(aspect: "value")
            }
        }
        
    public var target: Any!
    private let titleField = NSTextField(labelWithString: "")
    
    public override func viewDidLoad()
        {
        super.viewDidLoad()
        }
        
    public override func loadView()
        {
        self.layoutAttribute = .bottom
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.titleField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleField)
        self.titleField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.titleField.widthAnchor.constraint(equalToConstant: 400).isActive = true
        self.view.needsLayout = true
        self.titleField.textColor = StyleTheme.shared.color(for: .colorToolbarText)
        self.titleField.font = StyleTheme.shared.font(for: .fontDefault,size: 12)
        self.titleField.alignment = .center
        }
        
    public func update(aspect: String,with: Any?,from model: Model)
        {
        guard aspect == "value" && model.dependentKey == self.selectedNodeModel?.dependentKey else
            {
            return
            }
        guard let node = self.selectedNodeModel?.value as? IDESourceFileNode else
            {
            return
            }
        self.titleField.stringValue = node.title
        self.view.needsLayout = true
        }
    }
