//
//  SymbolNode.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/10/2023.
//

import Foundation
import AppKit

public class SymbolViewCell: NSTableCellView,NSTextFieldDelegate
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
        
    public var imageName: String?
        {
        didSet
            {
            if let name = self.imageName,let image = NSImage(named: name)
                {
                self.imagePane.image = image
                self.imagePane.image?.isTemplate = true
                self.imagePane.contentTintColor = .controlAccentColor
                }
            }
        }
        
    private let imagePane = NSImageView(frame: .zero)
    public let leftPane = EditableTextField(labelWithString: "")
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
        self.leftPane.delegate = self.leftPane
        self.imagePane.translatesAutoresizingMaskIntoConstraints = false
        self.leftPane.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imagePane)
        self.addSubview(self.leftPane)
        self.imagePane.image?.isTemplate = true
        self.imagePane.contentTintColor = .controlAccentColor
        self.imagePane.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        let width = StyleTheme.shared.metric(for: .metricOutlinerImageHeight)
        self.imagePane.heightAnchor.constraint(equalToConstant: width).isActive = true
        self.imagePane.widthAnchor.constraint(equalTo: self.imagePane.heightAnchor).isActive = true
        self.imagePane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.leftPane.leadingAnchor.constraint(equalTo: self.imagePane.trailingAnchor, constant: 4).isActive = true
        self.leftPane.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.leftPane.font = StyleTheme.shared.font(for: .fontOutliner)
        self.leftPane.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        self.leftPane.textColor = StyleTheme.shared.color(for: .colorOutlinerText)
        self.leftPane.isEditable = false
        }
    }
