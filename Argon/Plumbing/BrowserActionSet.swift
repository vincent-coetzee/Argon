//
//  BrowserActionSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/04/2023.
//

import Foundation
import Cocoa

public enum InterfaceAction: Int
    {
    case leftSidebarAction = 1
    case rightSidebarAction = 2
    case loadAction = 4
    case saveAction = 8
    case buildAction = 16
    case hideIssuesAction = 32
    case showIssuesAction = 64
    case importAction = 128
    case cleanAction = 256
    case runAction = 512
    case debugAction = 1024
    case exportAction = 4096
    }
    
public struct InterfaceActionSet
    {
    private var rawValue: Int = 0
    
    public init()
        {
        }
        
    public init(_ values: Array<InterfaceAction>)
        {
        for action in values
            {
            self.insert(action)
            }
        }
        
    public mutating func insert(_ action: InterfaceAction)
        {
        self.rawValue |= action.rawValue
        }
        
    public func contains(_ action: InterfaceAction) -> Bool
        {
        (self.rawValue & action.rawValue) == action.rawValue
        }
        
    public mutating func remove(_ action: InterfaceAction)
        {
        self.rawValue = self.rawValue & ~action.rawValue
        }
    }
    
public struct BrowserActionSet: OptionSet
    {
    public var hierarchyActionMenu: NSMenu
        {
        let menu = NSMenu()
        var wasFileAction = false
        if self.contains(.newFolderAction)
            {
            menu.addItem(withTitle: "New Folder", action: #selector(ProjectHierarchyViewController.onNewFolder), keyEquivalent: "").isEnabled = true
            wasFileAction = true
            }
        if self.contains(.newFileAction)
            {
            menu.addItem(withTitle: "New Argon File", action: #selector(ProjectHierarchyViewController.onNewArgonFile), keyEquivalent: "").isEnabled = true
            wasFileAction = true
            }
        if wasFileAction
            {
            menu.addItem(NSMenuItem.separator())
            }
        var wasImportAction = false
        if self.contains(.importAction)
            {
            menu.addItem(withTitle: "Import File...", action: #selector(ProjectHierarchyViewController.onImportFile), keyEquivalent: "").isEnabled = true
        menu.addItem(NSMenuItem.separator())
            }
        if self.contains(.deleteAction)
            {
            menu.addItem(withTitle: "Delete", action: #selector(ProjectHierarchyViewController.onDeleteNode), keyEquivalent: "").isEnabled = true
            }
        return(menu)
        }
        
    public static let none = BrowserActionSet([])
    public static let leftSidebarAction = BrowserActionSet(rawValue: 1 )
    public static let rightSidebarAction  = BrowserActionSet(rawValue: 1 << 2)
    public static let loadAction = BrowserActionSet(rawValue: 1 << 3)
    public static let saveAction  = BrowserActionSet(rawValue: 1 << 4)
    public static let buildAction = BrowserActionSet(rawValue: 1 << 5)
    public static let importAction = BrowserActionSet(rawValue: 1 << 6)
    public static let deleteAction = BrowserActionSet(rawValue: 1 << 7)
    public static let searchAction = BrowserActionSet(rawValue: 1 << 8)
    public static let settingsAction = BrowserActionSet(rawValue: 1 << 9)
    public static let runAction = BrowserActionSet(rawValue: 1 << 10)
    public static let debugAction = BrowserActionSet(rawValue: 1 << 11)
    public static let hideIssuesAction = BrowserActionSet(rawValue: 1 << 12)
    public static let showIssuesAction = BrowserActionSet(rawValue: 1 << 13)
    public static let cleanAction = BrowserActionSet(rawValue: 1 << 14)
    public static let newFileAction = BrowserActionSet(rawValue: 1 << 15)
    public static let newFolderAction = BrowserActionSet(rawValue: 1 << 16)
    
    public static let `default` = BrowserActionSet(withEnabled: .loadAction,.leftSidebarAction,.rightSidebarAction,.buildAction,.cleanAction,.runAction,.debugAction)
    
    public let rawValue: Int
    
    public init(rawValue: Int)
        {
        self.rawValue = rawValue
        }
        
    public init(withEnabled actions: BrowserActionSet...)
        {
        self.rawValue = 0
        for action in actions
            {
            self.insert(action)
            }
        }
        
    internal func enabling(_ actions: BrowserActionSet...) -> Self
        {
        var newActions = self
        for action in actions
            {
            newActions.insert(action)
            }
        return(newActions)
        }
        
    @discardableResult
    internal func disabling(_ actions: BrowserActionSet...) -> Self
        {
        var newActions = self
        for action in actions
            {
            newActions.remove(action)
            }
        return(newActions)
        }
        
    internal func isActionEnabled(label: String) -> Bool
        {
        switch(label)
            {
            case("LeftSidebar"):
                return(self.contains(.leftSidebarAction))
            case("RightSidebar"):
                return(self.contains(.rightSidebarAction))
            case("Load"):
                return(self.contains(.loadAction))
            case("Save"):
                return(self.contains(.saveAction))
            case("Import"):
                return(self.contains(.importAction))
            case("Build"):
                return(self.contains(.buildAction))
            case("Clean"):
                return(self.contains(.cleanAction))
            case("Run"):
                return(self.contains(.runAction))
            case("Debug"):
                return(self.contains(.debugAction))
            case("Hide"):
                return(self.contains(.hideIssuesAction))
            case("Show"):
                return(self.contains(.showIssuesAction))
            case("Delete"):
                return(self.contains(.deleteAction))
            case("NewFile"):
                return(self.contains(.newFileAction))
            case("NewFolder"):
                return(self.contains(.newFolderAction))
            default:
                return(false)
            }
        }
        
    internal func update(windowController controller: ProjectWindowController)
        {
        controller.setLeftSidebarAction(enabled: self.contains(.leftSidebarAction))
        controller.setRightSidebarAction(enabled: self.contains(.leftSidebarAction))
        if let toolbar = controller.window?.toolbar
            {
            toolbar.setItem(at: "Load",enabled: self.contains(.loadAction))
            toolbar.setItem(at: "Save",enabled: self.contains(.saveAction))
            toolbar.setItem(at: "Build",enabled: self.contains(.buildAction))
            toolbar.setItem(at: "Import",enabled: self.contains(.importAction))
            toolbar.setItem(at: "Delete",enabled: self.contains(.deleteAction))
            toolbar.setItem(at: "Run",enabled: self.contains(.runAction))
            toolbar.setItem(at: "Debug",enabled: self.contains(.debugAction))
            toolbar.setItem(at: "Show",enabled: self.contains(.showIssuesAction))
            toolbar.setItem(at: "Hide",enabled: self.contains(.hideIssuesAction))
            toolbar.setItem(at: "Clean",enabled: self.contains(.cleanAction))
            }
        }
        
    public func adjustBrowserActionMenu(_ menu: NSMenu)
        {
//        var toggleCount = 0
//        if self.contains(.leftSidebarAction)
//            {
//            toggleCount += 1
//            menu.addItem(withTitle: "Toggle left sidebar", action: #selector(ArgonBrowserViewController.onToggleLeftSidebar),keyEquivalent: "")
//            }
//        if self.contains(.rightSidebarAction)
//            {
//            toggleCount += 1
//            menu.addItem(withTitle: "Toggle right sidebar", action: #selector(ArgonBrowserViewController.onToggleRightSidebar),keyEquivalent: "")
//            }
//        if toggleCount > 0
//            {
//            menu.addItem(NSMenuItem.separator())
//            }
//        var diskCount = 0
//        if self.contains(.loadAction)
//            {
//            diskCount += 1
//            menu.addItem(withTitle: "Open project...", action: #selector(ArgonBrowserViewController.onOpen),keyEquivalent: "")
//            }
//        if self.contains(.saveAction)
//            {
//            diskCount += 1
//            menu.addItem(withTitle: "Save project...", action: #selector(ArgonBrowserViewController.onSave),keyEquivalent: "")
//            }
//        if diskCount > 0
//            {
//            menu.addItem(NSMenuItem.separator())
//            }
//        if self.contains(.buildAction)
//            {
//            menu.addItem(NSMenuItem.separator())
//            menu.addItem(withTitle: "Build project...", action: #selector(ArgonBrowserViewController.onBuild),keyEquivalent: "")
//            }
//        if self.contains(.newSymbolAction) || self.contains(.newGroupAction) || self.contains(.newModuleAction) || self.contains(.newCommentAction)
//            {
//            menu.addItem(NSMenuItem.separator())
//            }
//        if self.contains(.newSymbolAction)
//            {
//            menu.addItem(withTitle: "New Symbol", action: #selector(ArgonBrowserViewController.onNewSymbol),keyEquivalent: "")
//            }
//        if self.contains(.newModuleAction)
//            {
//            menu.addItem(withTitle: "New Module", action: #selector(ArgonBrowserViewController.onNewModule),keyEquivalent: "")
//            }
//        if self.contains(.newCommentAction)
//            {
//            menu.addItem(withTitle: "New Comment", action: #selector(ArgonBrowserViewController.onNewComment),keyEquivalent: "")
//            }
//        if self.contains(.newImportAction)
//            {
//            menu.addItem(withTitle: "New Import", action: #selector(ArgonBrowserViewController.onNewImport),keyEquivalent: "")
//            }
//        if self.contains(.newGroupAction)
//            {
//            menu.addItem(withTitle: "New Group", action: #selector(ArgonBrowserViewController.onNewGroup),keyEquivalent: "")
//            }
//        if self.contains(.deleteItemAction)
//            {
//            menu.addItem(NSMenuItem.separator())
//            menu.addItem(withTitle: "Delete", action: #selector(ArgonBrowserViewController.onDeleteItem),keyEquivalent: "")
//            }
//        if self.contains(.searchAction) || self.contains(.settingsAction)
//            {
//            menu.addItem(NSMenuItem.separator())
//            }
//        if self.contains(.searchAction)
//            {
//            menu.addItem(withTitle: "Search...", action: #selector(ArgonBrowserViewController.onSearch),keyEquivalent: "")
//            }
//        if self.contains(.settingsAction)
//            {
//            menu.addItem(withTitle: "Settings...", action: #selector(ArgonBrowserViewController.onSettings),keyEquivalent: "")
//            }
        }
    }
