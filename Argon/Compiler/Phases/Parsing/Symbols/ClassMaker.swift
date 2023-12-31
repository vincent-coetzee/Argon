//
//  ClassMaker.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/11/16.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ClassMaker:MethodInstance
    {
    init(shortName:String,parameters:Parameters,block:Block)
        {
        super.init(shortName:shortName)
        self._parameters = parameters
        self.block = block
        }
    
    internal required init()
        {
        fatalError("init() has not been implemented")
        }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }

typealias ClassMakers = Array<ClassMaker>
