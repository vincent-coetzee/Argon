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
        
    public var node: SourceNode?
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
                }
            }
        }
        
    private let imagePane = NSImageView(frame: .zero)
    public let textPane = NSTextField(labelWithString: "")
    
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
        self.imagePane.translatesAutoresizingMaskIntoConstraints = false
        self.textPane.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imagePane)
        self.addSubview(self.textPane)
        self.imagePane.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        self.imagePane.heightAnchor.constraint(equalToConstant: StyleTheme.shared.metric(for: .metricOutlinerImageHeight)).isActive = true
        self.imagePane.widthAnchor.constraint(equalTo: self.imagePane.heightAnchor).isActive = true
        self.imagePane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.textPane.leadingAnchor.constraint(equalTo: self.imagePane.trailingAnchor, constant: 4).isActive = true
        self.textPane.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -4).isActive = true
        self.textPane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.textPane.font = StyleTheme.shared.font(for: .fontOutliner)
        self.textPane.textColor = StyleTheme.shared.color(for: .colorOutlinerText)
        self.textPane.isEditable = true
        }
    }
