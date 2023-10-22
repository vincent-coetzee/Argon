//
//  SourceCodeEditingView.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/04/2023.
//

import AppKit
    
public class SourceCodeEditingView: NSView,NSTextViewDelegate,Model,IDEEditorView
    {
    public var editorDelegate: IDEEditorViewDelegate?
        {
        get
            {
            self.sourceView.editorDelegate
            }
        set
            {
            self.sourceView.editorDelegate = newValue
            }
        }
    
    public func beginEditing(node: IDENode?)
        {
        self.sourceView.beginEditing(node: node)
        }

    
    public func endEditing()
        {
        self.sourceView.endEditing()
        }
    
    public var sourceString: String
        {
        get
            {
            fatalError()
            }
        set
            {
            self.sourceView.string = newValue
            self.sourceView.textStorage?.setAttributes([.foregroundColor: StyleTheme.shared.color(for: .colorEditorText)],range: NSRange(location: 0,length: newValue.count))
            }
        }
        
//    public var compilerIssues: CompilerIssues
//        {
//        get
//            {
//            self.textView.compilerIssues
//            }
//        set
//            {
//            self.textView.compilerIssues = newValue
//            }
//        }
    
    private var sourceView: SourceView!
    private var scrollView: NSScrollView!
    private var _textViewDelegate: NSTextViewDelegate?
    public var dependentKey = DependentSet.nextDependentKey
    public var dependents = DependentSet()
    private var _compilerIssues = CompilerIssues()
    
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.scrollView = SourceView.scrollableTextView()
        self.sourceView = self.scrollView.documentView as? SourceView
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.sourceView.configureScrollView()
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        }
        
    private func configureScrollView()
        {
        self.wantsLayer = true
        self.layer?.backgroundColor = StyleTheme.shared.color(for: .colorEditorBackground).cgColor
        self.scrollView = SourceView.scrollableTextView()
        self.sourceView = self.scrollView.documentView as? SourceView
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
    public func resetCompilerIssues(newIssues: CompilerIssues)
        {
//        self.textView.resetCompilerIssues(newIssues: newIssues)
        }
        
    public func showAllCompilerIssues()
        {
//        self.textView.showAllCompilerIssues()
        }
        
    public func hideAllCompilerIssues()
        {
//        self.textView.hideAllCompilerIssues()
        }
        
    public func shake(aspect: String)
        {
        }
        
    public func canEdit(node: IDENode?) -> Bool
        {
        if node.isNil
            {
            return(false)
            }
        return(node!.nodeType == .fileNode)
        }
        
    @objc public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("showIssues"):
                self.sourceView.showAllCompilerIssues()
                menuItem.title = "Hide Issues"
                menuItem.action = #selector(self.handleMenuItem)
                menuItem.target = self
                return(true)
            case("hideIssues"):
                self.sourceView.hideAllCompilerIssues()
                menuItem.title = "Show Issues"
                menuItem.action = #selector(self.handleMenuItem)
                menuItem.target = self
                return(true)
            case("showInferredTypes"):
                return(true)
            case("hideInferredTypes"):
                return(true)
            case("commentSelection"):
                self.sourceView.toggleCommentsOfCurrentSelection()
                return(true)
            default:
                return(false)
            }
        }
        
    public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        switch(menuItem.identifier!.rawValue)
            {
            case("showIssues"):
                return(true)
            case("hideIssues"):
                return(true)
            case("showInferredTypes"):
                return(true)
            case("hideInferredTypes"):
                return(true)
            case("commentSelection"):
                return(!self.sourceView.selectionIsEmpty())
            default:
                return(false)
            }
        }
    }

