//
//  SelectionInListModel.swift
//  ArgonWorks
//
//  Created by Vincent Coetzee on 19/4/22.
//

import Foundation

public class SelectionInListModel: AspectModel,Dependent
    {
    public let dependentKey = DependentSet.nextDependentKey
    
    public var selectionValueModel: ValueModel = ValueHolder(value: nil)
        {
        willSet
            {
            self.selectionValueModel.removeDependent(self)
            }
        didSet
            {
            self.selectionValueModel.addDependent(self)
            self.changed(aspect: "selection",with: self.selectionValueModel.value,from: self)
            }
        }
        
    public var listValueModel: ValueModel = ValueHolder(value: Array<String>())
        {
        willSet
            {
            self.listValueModel.removeDependent(self)
            }
        didSet
            {
            self.listValueModel.addDependent(self)
            self.changed(aspect: "list",with: self.listValueModel.value,from: self)
            }
        }
        
    public var list: Array<Any> = []
        {
        didSet
            {
            self.listValueModel.value = self.list
            }
        }
        
    public var selection: Any? = nil
        {
        didSet
            {
            self.selectionValueModel.value = self.selection
            }
        }
    
    public func value(forAspect: String) -> Any?
        {
        if forAspect == "selection"
            {
            return(self.selectionValueModel.value)
            }
        if forAspect == "list"
            {
            return(self.listValueModel.value)
            }
        return(nil)
        }
    
    public func setValue(_ value: Any?,forAspect: String)
        {
        if forAspect == "selection"
            {
            self.selectionValueModel.value = value
            }
        else if forAspect == "list"
            {
            self.listValueModel.value = value
            }
        }
    
    public var dependents = DependentSet()
    
    public func update(aspect: String,with: Any?,from: Model)
        {
        if aspect == "value" && from.dependentKey == self.listValueModel.dependentKey
            {
            self.changed(aspect: "list",with: self.listValueModel.value,from: self)
            return
            }
        if aspect == "value" && from.dependentKey == self.selectionValueModel.dependentKey
            {
            self.changed(aspect: "selection",with: self.selectionValueModel.value,from: self)
            }
        }
    }
