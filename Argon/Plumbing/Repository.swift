//
//  Repository.swift
//  Argon
//
//  Created by Vincent Coetzee on 23/04/2023.
//

import Foundation

public class Repository
    {
    public class var initialSourceForNewSourceFile: String
        {
        let dateFormatter = DateFormatter()
        let format = "dd/MM/yyyy"
        dateFormatter.dateFormat = format
        let date = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.string(from: Date())
        let string = """
            //
            //
            // Argon File created by \(NSUserName()) on \(date) \(time)
            //
            IMPORT Argon
            
            MODULE Module
                {
                }
            """
        return(string)
        }
    }
