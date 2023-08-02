//
//  LLVMContext.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/04/2023.
//

import Foundation
import LLVMC

public class LLVMContext
    {
    public let reference: LLVMContextRef
    
    init()
        {
        self.reference = LLVMContextCreate()
        }
        
    deinit
        {
        LLVMContextDispose(self.reference)
        }
    }
