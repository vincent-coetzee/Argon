//
//  LLVMModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/04/2023.
//

import Foundation
import LLVMC

public class LLVMModule
    {
    public var moduleIdentifier: String
        {
        get
            {
            var length:size_t = 0
            let characters = LLVMGetModuleIdentifier(self.reference,&length)
            return(String(cString: characters!))
            }
        }
        
    public let reference: LLVMModuleRef
    
    init(name: String,context: LLVMContext)
        {
        self.reference = LLVMModuleCreateWithNameInContext(name,context.reference)
        }
        
    init(name: String)
        {
        self.reference = LLVMModuleCreateWithName(name)
        }
        
    deinit
        {
        LLVMDisposeModule(self.reference)
        }
    }
