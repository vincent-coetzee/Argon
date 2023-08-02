//
//  LineRecord.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/05/2023.
//

import Foundation
import Path

public struct LineRecord
    {
    public let file: Path
    public let line: Int
    public let lineStart: Int
    public let lineEnd: Int
    }
