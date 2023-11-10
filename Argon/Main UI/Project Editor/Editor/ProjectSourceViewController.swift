//
//  ProjectSourceViewController.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/09/2023.
//

import AppKit

public class ProjectSourceViewController: NSViewController,Dependent
    {
    public  let dependentKey = DependentSet.nextDependentKey
    public  var editorView: IDEEditorView?
        
    public  var projectModel: ValueHolder!
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
    
    public var editedNode: IDENode?
        {
        willSet
            {
            self.editorView?.endEditing()
            if self.editedNode.isNil
                {
                self.clearEditor()
                }
            }
        didSet
            {
            self.editedNode?.configureEditor(in: self)
            self.editorView?.beginEditing(node: self.editedNode)
            }
        }
        
    public func update(aspect: String,with: Any?,from: Model)
        {
//        if from.dependentKey == self.selectedNodeModel.dependentKey
//            {
//            if let node = self.selectedNodeModel.value as? SourceFileNode
//                {
//                self.sourceView.sourceString = node.expandedSource
//                return
//                }
//            }
        }
        
    private func clearEditor()
        {
        if let someView = self.editorView as? NSView
            {
            self.editorView?.endEditing()
            someView.removeFromSuperview()
            self.editorView = nil
            }
        }
        
    public func configureEditor(for node: IDESourceFileNode)
        {
        if let someView = self.editorView,someView.canEdit(node: node)
            {
            someView.beginEditing(node: node)
            return
            }
        self.editorView = SourceCodeEditingView(frame: .zero)
        let someView = self.editorView as! NSView
        someView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(someView)
        someView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        someView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        someView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        someView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.editedNode = node
        }
        
    public func configureEditor(for node: IDEVisualDesignNode)
        {
        if let someView = self.editorView,someView.canEdit(node: node)
            {
            someView.beginEditing(node: node)
            return
            }
        self.editorView = VisualDesignEditorView(frame: .zero)
        let someView = self.editorView as! NSView
        someView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(someView)
        someView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        someView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        someView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        someView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.editedNode = node
        }
        
        
//    public func toggleComments()
//        {
//        self.sourceView.toggleCommentsOfCurrentSelection()
//        }
//        
//    public func selectionIsEmpty() -> Bool
//        {
//        self.sourceView.selectionIsEmpty()
//        }
//        
//    @objc func onCommentSelection(_ sender: Any?)
//        {
//        }
//        
//    public func toggleInferredTypes(`on`: Bool)
//        {
//        if `on`
//            {
//            self.sourceView.showInferredTypes()
//            }
//        else
//            {
//            self.sourceView.hideInferredTypes()
//            }
//        }
//        
//    public func toggleCompilerIssues(`on`: Bool)
//        {
//        if `on`
//            {
//            self.sourceView.showAllCompilerIssues()
//            }
//        else
//            {
//            self.sourceView.hideAllCompilerIssues()
//            }
//        }
//        
//    public func resetCompilerIssues(newIssues: CompilerIssues)
//        {
//        self.sourceView.resetCompilerIssues(newIssues: newIssues)
//        }

    @objc public func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        return(self.editorView?.handleMenuItem(menuItem) ?? false)
        }
        
    @objc public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        {
        return(self.editorView?.validateMenuItem(menuItem) ?? false)
        }
    }

extension ProjectSourceViewController: IDEEditorViewDelegate
    {
    public func editorView(_ editor: IDEEditorView, changed: IDEEditorChange)
        {
        }
    }
