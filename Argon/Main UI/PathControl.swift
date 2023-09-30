//
//  PathControl.swift
//  Argon
//
//  Created by Vincent Coetzee on 17/09/2023.
//

import AppKit

public class PathControl: NSPathControl,Dependent
    {
    public var dependentKey: Int = DependentSet.nextDependentKey

    public var valueModel: ValueModel?
        {
        willSet
            {
            self.valueModel?.removeDependent(self)
            }
        didSet
            {
            self.valueModel?.addDependent(self)
            self.valueModel?.shake(aspect: "value")
            }
        }
        
    private var _valueModel: ValueModel?
    
    public func update(aspect: String, with: Any?, from model: Model)
        {
        guard let key = self.valueModel?.dependentKey else
            {
            return
            }
        guard aspect == "value" && model.dependentKey == key else
            {
            return
            }
        guard let newValue = (model as! ValueModel).value as? SourceNode else
            {
            return
            }
        var items = Array<NSPathControlItem>()
        for anItem in newValue.pathToProject.reversed()
            {
            let pathControlItem = NSPathControlItem()
            pathControlItem.attributedTitle = NSAttributedString(string: anItem.name,attributes: [.font: StyleTheme.shared.font(for: .fontDefault),.foregroundColor: StyleTheme.shared.color(for: .colorDefault)])
            pathControlItem.image = anItem.projectViewImage.image(withTintColor: StyleTheme.shared.color(for: .colorDefault))
            items.append(pathControlItem)
            }
        self.pathItems = items
        }
    }
