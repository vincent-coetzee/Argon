//
//  ProjectViewCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 19/04/2023.
//

import AppKit

public class ProjectViewCell: NSTableCellView,NSTextFieldDelegate
    {
    private static let fontStyleElement: StyleElement = .fontOutliner
    
    public var cellWidth: CGFloat
        {
        guard let field = self.textField else
            {
            return(0)
            }
        let text = field.attributedStringValue
        let textWidth = text.size().width
        return(20 + 8 + textWidth)
        }
        
    public var node: IDENode?
        {
        didSet
            {
            if let newNode = self.node
                {
                self.textPane.stringValue = newNode.name
                let image = newNode.projectViewImage
                self.imagePane.image = image
                self.imagePane.image?.isTemplate = true
                self.imagePane.contentTintColor = StyleTheme.shared.color(for: .colorTint)
                if let someNode = self.node
                    {
                    let state = someNode.sourceItemState
                    if state.contains(.kAdded)
                        {
                        self.sourceStateImagePane.image = NSImage(named: "IconAdded")
                        }
                    else if state.contains(.kModified)
                        {
                        self.sourceStateImagePane.image = NSImage(named: "IconModified")
                        }
                    self.sourceStateImagePane.image?.isTemplate = true
                    self.sourceStateImagePane.contentTintColor = NSColor.controlAccentColor
                    }
                }
            }
        }
        
    private let imagePane = NSImageView(frame: .zero)
    public let textPane = EditableTextField(labelWithString: "")
    public let sourceStateImagePane = NSImageView(frame: .zero)
    
    public override init(frame: NSRect)
        {
        super.init(frame: frame)
        self.initPanes()
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        self.initPanes()
        }
        
    private func initPanes()
        {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textField = nil
        self.imageView = nil
        self.textPane.delegate = self.textPane
        self.imagePane.translatesAutoresizingMaskIntoConstraints = false
        self.sourceStateImagePane.translatesAutoresizingMaskIntoConstraints = false
        self.textPane.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imagePane)
        self.addSubview(self.textPane)
        self.addSubview(self.sourceStateImagePane)
        self.imagePane.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        let width = StyleTheme.shared.metric(for: .metricOutlinerImageHeight)
        self.imagePane.heightAnchor.constraint(equalToConstant: width).isActive = true
        self.imagePane.widthAnchor.constraint(equalTo: self.imagePane.heightAnchor).isActive = true
        self.imagePane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.textPane.leadingAnchor.constraint(equalTo: self.imagePane.trailingAnchor, constant: 4).isActive = true
        self.textPane.trailingAnchor.constraint(equalTo: self.sourceStateImagePane.leadingAnchor,constant: -4).isActive = true
        self.textPane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.textPane.font = StyleTheme.shared.font(for: .fontOutliner)
        self.sourceStateImagePane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.sourceStateImagePane.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        self.sourceStateImagePane.heightAnchor.constraint(equalToConstant: width).isActive = true
        self.sourceStateImagePane.widthAnchor.constraint(equalTo: self.sourceStateImagePane.heightAnchor).isActive = true
        self.textPane.textColor = StyleTheme.shared.color(for: .colorOutlinerText)
        self.textPane.isEditable = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldContentsChanged), name: NSTextField.textDidChangeNotification, object: window)
        }
        
    @objc public func textFieldContentsChanged(_ notification: Notification)
        {
        self.node?.setName(self.textPane.stringValue)
        }
    }
