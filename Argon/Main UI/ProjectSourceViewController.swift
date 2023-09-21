//
//  ProjectSourceViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import Cocoa

class ProjectSourceViewController: NSViewController,Dependent
    {
    public let dependentKey = DependentSet.nextDependentKey
    
    public var projectModel: ValueHolder!
        {
        didSet
            {
            self.projectModel.addDependent(self)
            }
        }
        
    public var selectedNodeModel: ValueHolder!
        {
        didSet
            {
            self.selectedNodeModel.addDependent(self)
            }
        }
    
    @IBOutlet weak var sourceView: SourceCodeEditingView!
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.sourceView.sourceEditorDelegate = self
        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
        if from.dependentKey == self.selectedNodeModel.dependentKey
            {
            if let node = self.selectedNodeModel.value as? SourceFileNode
                {
                self.sourceView.string = node.expandedSource
                node.tokens = ArgonScanner(source: node.expandedSource).allTokens()
                self.sourceView.tokens = node.tokens
                return
                }
            }
        }
        
    public func showAllCompilerIssues()
        {
        self.sourceView.showAllCompilerIssues()
        }
        
    public func hideAllCompilerIssues()
        {
        self.sourceView.hideAllCompilerIssues()
        }
        
    public func resetCompilerIssues(newIssues: CompilerIssues)
        {
        self.sourceView.resetCompilerIssues(newIssues: newIssues)
        }
    }

extension ProjectSourceViewController: SourceEditorDelegate
    {
    func sourceEditorKeyPressed(_ editor: NSTextView)
        {
        }
    
    func sourceEditor(_ editor: NSTextView, changedLine: Int, offset: Int)
        {
        }
    
    func sourceEditor(_ editor: NSTextView, changedSource: String, tokens: Tokens)
        {
        if let node = self.selectedNodeModel.value as? SourceFileNode
            {
            node.setSource(changedSource)
            node.expandedSource = changedSource
            node.setTokens(tokens)
            }
        }
    }
