//
//  Path+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/07/2023.
//

import Foundation
import Path

extension Path
    {
    public var lastPathComponentSansExtension: String
        {
        let string = NSString(string: self.string)
        let anExtension = "." + string.pathExtension
        let last = string.lastPathComponent
        return(last.replacingOccurrences(of: anExtension, with: ""))
        }
        
    public var polynomialRollingHash: Int
        {
        self.string.polynomialRollingHash
        }
    }
    
extension NSCoder
    {
    public func encode(_ path: Path?,forKey key: String)
        {
        if path.isNil
            {
            self.encode(true,forKey: "\(key)_nil")
            }
        else
            {
            self.encode(false,forKey: "\(key)_nil")
            self.encode(path!.string,forKey: "\(key)_path")
            }
        }
        
    public func decodePath(forKey key: String) -> Path?
        {
        let isNil = self.decodeBool(forKey: "\(key)_nil")
        if !isNil
            {
            return(Path(self.decodeObject(forKey: "\(key)_path") as! String)!)
            }
        return(nil)
        }
    }

public typealias Paths = Array<Path>

extension NSCoder
    {
    public func encode(_ paths: Paths,forKey key: String)
        {
        self.encode(paths.count,forKey: "\(key)_count")
        var index = 0
        for path in paths
            {
            self.encode(path,forKey: "\(key)_\(index)")
            index += 1
            }
        }
        
    public func decodePaths(forKey key: String) -> Paths
        {
        let count = self.decodeInteger(forKey: "\(key)_count")
        var paths = Paths()
        for index in 0..<count
            {
            if let path = self.decodePath(forKey: "\(key)_\(index)")
                {
                paths.append(path)
                }
            }
        return(paths)
        }
    }
