//
//  TitlebarView.swift
//  Argon
//
//  Created by Vincent Coetzee on 29/09/2023.
//

import AppKit

public class TitlebarView: NSView
    {
    public var selectedNodeModel: ValueModel?
        {
        willSet
            {
            self.pathControl.valueModel = nil
            }
        didSet
            {
            self.pathControl.valueModel = self.selectedNodeModel
            }
        }
        
    private var pathControl: PathControl!
    private var issueCountIconLabelView: IconLabelView!
    
    public init()
        {
        super.init(frame: .zero)
        self.initPathControl()
        self.initIssueControl()
        }
        
    private func initPathControl()
        {
        let control = PathControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.wantsLayer = true
        control.layer!.cornerRadius = StyleTheme.shared.metric(for: .metricControlCornerRadius)
        control.layer!.backgroundColor = StyleTheme.shared.color(for: .colorToolbarBackground).cgColor
        self.pathControl = control
        self.addSubview(control)
        control.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 200).isActive = true
        control.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200).isActive = true
        control.heightAnchor.constraint( equalToConstant: 20).isActive = true
        control.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.needsLayout = true
        }
        
    private func initIssueControl()
        {
        let control = IconLabelView(image: NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: "")!, imageEdge: .left, text: "0 issues",padding: NSSize(width:2,height: 2))
        control.translatesAutoresizingMaskIntoConstraints = false
        self.issueCountIconLabelView = control
        control.imageTintElement = .colorIssue
        control.textColorElement = .colorToolbarText
        self.addSubview(control)
        control.leadingAnchor.constraint(equalTo: self.pathControl.trailingAnchor, constant: 10).isActive = true
        control.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.needsLayout = true
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        }
    }
