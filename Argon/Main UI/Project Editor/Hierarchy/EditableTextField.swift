//
//  EditableTextField.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/10/2023.
//

import AppKit

public class EditableTextField: NSTextField,NSTextFieldDelegate
    {
    public func _commonInit()
        {
        self.drawsBackground = true
        self.delegate = self
        }
        
    public override func mouseDown(with event: NSEvent)
        {
        if event.clickCount == 2 && !self.isEditable
            {
            self.beginEditing()
            }
        else
            {
            super.mouseDown(with: event)
            }
        }
        
    private func beginEditing()
        {
        self.isEditable = true
        self.backgroundColor = .white
        self.isSelectable = true
        self.selectText(nil)
        self.needsDisplay = true
        }
        
    private func endEditing()
        {
        self.isEditable = false
        self.backgroundColor = .clear
        self.isSelectable = false
        self.needsDisplay = true
        }

    public func controlTextDidEndEditing(_ obj: Notification)
        {
        self.endEditing()
        }
    }

extension NSOutlineView
    {
    public override func validateProposedFirstResponder(_ responder: NSResponder,for event: NSEvent?) -> Bool
        {
        if responder.isKind(of: EditableTextField.self)
            {
            return(true)
            }
        return(super.validateProposedFirstResponder(responder, for: event))
        }
    }
