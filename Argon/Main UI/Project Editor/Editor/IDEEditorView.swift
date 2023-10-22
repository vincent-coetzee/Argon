//
//  SourceEditorView.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/10/2023.
//

import AppKit

public enum IDEEditorChange
    {
    case keysPressed(String)
    case location(Int,Int)
    case source(String,Tokens)
    }
    
public protocol IDEEditorViewDelegate
    {
    func editorView(_ editorView: IDEEditorView,changed: IDEEditorChange)
    }
    
public protocol IDEEditorView
    {
    var editorDelegate: IDEEditorViewDelegate? { get set }
    func beginEditing(node: IDENode?)
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
    func handleMenuItem(_ menuItem: NSMenuItem) -> Bool
    func endEditing()
    func canEdit(node: IDENode?) -> Bool
    }

public typealias ProjectIDEEditorView = IDEEditorView & NSView
