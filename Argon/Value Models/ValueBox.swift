//
//  ValueBox.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/07/2023.
//

import Foundation

public enum ValueBox: Hashable
    {
    public var symbolType: ArgonType
        {
        switch(self)
            {
            case(.none):
                return(.voidType)
            case(.void):
                return(.voidType)
            case(.integer):
                return(.integerType)
            case(.uInteger):
                return(.uIntegerType)
            case(.string):
                return(.stringType)
            case(.boolean):
                return(.booleanType)
            case(.character):
                return(.characterType)
            case(.byte):
                return(.byteType)
            case(.atom):
                return(.atomType)
            case(.float):
                return(.floatType)
            case(.method(let method)):
                return(method)
            case(.function(let function)):
                return(function)
            case(.class(let someClass)):
                return(someClass)
            case(.enumeration(let enumeration)):
                return(enumeration)
            case(.enumerationCase(let aCase)):
                return(aCase.enumerationType)
            case(.identifier):
                return(.stringType)
            case(.variable(let variable)):
                return(variable.symbolType)
            case(.constant(let constant)):
                return(constant.symbolType)
            case(.date):
                return(.dateType)
            case(.time):
                return(.timeType)
            case(.dateTime):
                return(.dateTimeType)
            case(.tuple(let tuple)):
                return(tuple.symbolType)
            default:
                fatalError("This should never happen, if it does it's a huge bug.")
            }
        }
        
    public static func == (lhs: ValueBox, rhs: ValueBox) -> Bool
        {
        switch(lhs,rhs)
            {
            case(.none,.none):
                return(true)
            case(.void,.void):
                return(true)
            case(.integer(let integer1),.integer(let integer2)):
                return(integer1 == integer2)
            case(.uInteger(let integer1),.uInteger(let integer2)):
                return(integer1 == integer2)
            case(.string(let integer1),.string(let integer2)):
                return(integer1 == integer2)
            case(.path(let integer1),.path(let integer2)):
                return(integer1 == integer2)
            case(.boolean(let integer1),.boolean(let integer2)):
                return(integer1 == integer2)
            case(.character(let integer1),.character(let integer2)):
                return(integer1 == integer2)
            case(.byte(let integer1),.byte(let integer2)):
                return(integer1 == integer2)
            case(.atom(let integer1),.atom(let integer2)):
                return(integer1 == integer2)
            case(.float(let integer1),.float(let integer2)):
                return(integer1 == integer2)
            case(.method(let integer1),.method(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.function(let integer1),.method(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.class(let integer1),.class(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.enumeration(let integer1),.enumeration(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.enumerationCase(let integer1),.enumerationCase(let integer2)):
                return(integer1 == integer2)
            case(.identifier(let integer1),.identifier(let integer2)):
                return(integer1 == integer2)
            case(.variable(let integer1),.variable(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.constant(let integer1),.constant(let integer2)):
                return(integer1.identifier == integer2.identifier)
            case(.date(let integer1),.date(let integer2)):
                return(integer1 == integer2)
            case(.time(let integer1),.time(let integer2)):
                return(integer1 == integer2)
            case(.dateTime(let integer1),.dateTime(let integer2)):
                return(integer1 == integer2)
            case(.tuple(let tuple1),.tuple(let tuple2)):
                return(tuple1 == tuple2)
            default:
                return(false)
            }
        }
    
    case none
    case integer(Int64)
    case uInteger(UInt64)
    case string(String)
    case path(String)
//    case enumerationInstance(EnumerationType,EnumerationCase)
    case boolean(Bool)
    case void
    case character(UInt16)
    case byte(UInt8)
    case atom(String)
    case float(Argon.Float)
    case method(MethodType)
    case function(FunctionType)
    case `class`(ClassType)
    case enumeration(EnumerationType)
    case enumerationCase(EnumerationCase)
    case identifier(Identifier)
    case variable(Variable)
    case constant(Constant)
    case date(Argon.Date)
    case time(Argon.Time)
    case dateTime(Argon.DateTime)
    case text(String)
    case tuple(Argon.Tuple)
    
    public var isAtom: Bool
        {
        switch(self)
            {
            case .atom:
                return(true)
            default:
                return(false)
            }
        }
        
    public var atom: String
        {
        switch(self)
            {
            case .atom(let symbol):
                return(symbol)
            default:
                fatalError("atom called on ValueBox and it's not an atom.")
            }
        }
        
    public var isInteger: Bool
        {
        switch(self)
            {
            case .integer:
                return(true)
            case .uInteger:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isIdentifier: Bool
        {
        switch(self)
            {
            case .identifier:
                return(true)
            default:
                return(false)
            }
        }
        
    public func hash(into hasher:inout Hasher)
        {
        switch(self)
            {
            case(.none):
                hasher.combine("NONE")
            case(.void):
                hasher.combine("VOID")
            case(.integer(let integer1)):
                hasher.combine("INTEGER")
                hasher.combine(integer1)
            case(.uInteger(let integer1)):
                hasher.combine("UINTEGER")
                hasher.combine(integer1)
            case(.string(let integer1)):
                hasher.combine("STRING")
                hasher.combine(integer1)
            case(.path(let integer1)):
                hasher.combine("PATH")
                hasher.combine(integer1)
            case(.boolean(let integer1)):
                hasher.combine("BOOLEAN")
                hasher.combine(integer1)
            case(.character(let integer1)):
                hasher.combine("CHARACTER")
                hasher.combine(integer1)
            case(.byte(let integer1)):
                hasher.combine("BYTE")
                hasher.combine(integer1)
            case(.atom(let integer1)):
                hasher.combine("ATOM")
                hasher.combine(integer1)
            case(.float(let integer1)):
                hasher.combine("FLOAT")
                hasher.combine(integer1)
            case(.method(let integer1)):
                hasher.combine("METHOD")
                hasher.combine(integer1.typeHash)
            case(.class(let integer1)):
                hasher.combine("CLASS")
                hasher.combine(integer1.typeHash)
            case(.enumeration(let integer1)):
                hasher.combine("ENUMERATION")
                hasher.combine(integer1.typeHash)
            case(.enumerationCase(let integer1)):
                hasher.combine("ENUMERATIONCASE")
                hasher.combine(integer1)
            case(.identifier(let integer1)):
                hasher.combine("IDENTIFIER")
                hasher.combine(integer1)
            case(.variable(let integer1)):
                hasher.combine("VARIABLE")
                hasher.combine(integer1)
            case(.constant(let integer1)):
                hasher.combine("CONSTANT")
                hasher.combine(integer1)
            case(.date(let integer1)):
                hasher.combine("DATE")
                hasher.combine(integer1)
            case(.time(let integer1)):
                hasher.combine("DATE")
                hasher.combine(integer1)
            case(.dateTime(let integer1)):
                hasher.combine("DATETIME")
                hasher.combine(integer1)
            case(.function(let integer1)):
                hasher.combine("FUNCTION")
                hasher.combine(integer1.typeHash)
            case(.text(let integer1)):
                hasher.combine("TEXT")
                hasher.combine(integer1)
            case(.tuple(let tuple)):
                hasher.combine(tuple)
            }
        }
    }


extension NSCoder
    {
    public func encode(_ value: ValueBox,forKey key: String)
        {
        switch(value)
            {
            case(.none):
                self.encode(0,forKey: "\(key)_index")
            case(.integer(let integer)):
                self.encode(1,forKey: "\(key)_index")
                self.encode(integer,forKey: "\(key)_integer")
            case(.text(let text)):
                self.encode(2,forKey: "\(key)_index")
                self.encode(text,forKey: "\(key)_text")
            case(.path(let string)):
                self.encode(3,forKey: "\(key)_index")
                self.encode(string,forKey: "\(key)_path")
            case(.float(let float)):
                self.encode(4,forKey: "\(key)_index")
                self.encode(float,forKey: "\(key)_float")
            case(.atom(let string)):
                self.encode(5,forKey: "\(key)_index")
                self.encode(string,forKey: "\(key)_atom")
            case(.string(let string)):
                self.encode(6,forKey: "\(key)_index")
                self.encode(string,forKey: "\(key)_string")
            case(.uInteger(let integer)):
                self.encode(7,forKey: "\(key)_index")
                self.encode(integer,forKey: "\(key)_uinteger")
            case(.boolean(let boolean)):
                self.encode(8,forKey: "\(key)_index")
                self.encode(boolean,forKey: "\(key)_boolean")
            case(.void):
                self.encode(9,forKey: "\(key)_index")
            case(.character(let character)):
                self.encode(10,forKey: "\(key)_index")
                self.encode(character,forKey: "\(key)_character")
            case(.byte(let byte)):
                self.encode(11,forKey: "\(key)_index")
                self.encode(byte,forKey: "\(key)_byte")
            case(.class(let type)):
                self.encode(12,forKey: "\(key)_index")
                self.encode(type,forKey: "\(key)_class")
            case(.method(let method)):
                self.encode(13,forKey: "\(key)_index")
                self.encode(method,forKey: "\(key)_method")
            case(.enumeration(let enumeration)):
                self.encode(14,forKey: "\(key)_index")
                self.encode(enumeration,forKey: "\(key)_enumeration")
            case(.identifier(let identifier)):
                self.encode(15,forKey: "\(key)_index")
                self.encode(identifier,forKey: "\(key)_identifier")
            case(.variable(let variable)):
                self.encode(16,forKey: "\(key)_index")
                self.encode(variable,forKey: "\(key)_variable")
            case(.constant(let constant)):
                self.encode(17,forKey: "\(key)_index")
                self.encode(constant,forKey: "\(key)_constant")
            case(.date(let date)):
                self.encode(18,forKey: "\(key)_index")
                self.encode(date.day,forKey: "\(key)_date_day")
                self.encode(date.month,forKey: "\(key)_date_month")
                self.encode(date.year,forKey: "\(key)_date_year")
            case(.time(let time)):
                self.encode(19,forKey: "\(key)_index")
                self.encode(time.hour,forKey: "\(key)_time_hour")
                self.encode(time.minute,forKey: "\(key)_time_minute")
                self.encode(time.second,forKey: "\(key)_time_second")
                self.encode(time.millisecond,forKey: "\(key)_time_millisecond")
            case(.dateTime(let dateTime)):
                self.encode(20,forKey: "\(key)_index")
                self.encode(dateTime.date.day,forKey: "\(key)_dateTime_day")
                self.encode(dateTime.date.month,forKey: "\(key)_dateTime_month")
                self.encode(dateTime.date.year,forKey: "\(key)_dateTime_year")
                self.encode(dateTime.time.hour,forKey: "\(key)_dateTime_hour")
                self.encode(dateTime.time.minute,forKey: "\(key)_dateTime_minute")
                self.encode(dateTime.time.second,forKey: "\(key)_dateTime_second")
                self.encode(dateTime.time.millisecond,forKey: "\(key)_dateTime_millisecond")
            case(.enumerationCase(let aCase)):
                self.encode(21,forKey: "\(key)_index")
                self.encode(aCase,forKey: "\(key)_enumerationCase")
            case(.function(let method)):
                self.encode(22,forKey: "\(key)_index")
                self.encode(method,forKey: "\(key)_function")
            case(.tuple(let tuple)):
                self.encode(23,forKey: "\(key)_index")
                self.encode(tuple,forKey: "\(key)_tuple")
            }
        }

    public func decodeValueBox(forKey key: String) -> ValueBox
        {
        let index = self.decodeInteger(forKey: "\(key)_index")
        switch(index)
            {
            case(0):
                return(.none)
            case(1):
                return(.integer(self.decodeInt64(forKey: "\(key)_integer")))
            case(2):
                return(.text(self.decodeObject(forKey: "\(key)_text") as! String))
            case(3):
                return(.path(self.decodeObject(forKey: "\(key)_path") as! String))
            case(4):
                return(.float(self.decodeDouble(forKey: "\(key)_float")))
            case(5):
                return(.atom(self.decodeObject(forKey: "\(key)_atom") as! String))
            case(6):
                return(.string(self.decodeObject(forKey: "\(key)_string") as! String))
            case(7):
                let value = UInt64(bitPattern: self.decodeInt64(forKey: "\(key)_uinteger"))
                return(.uInteger(value))
            case(8):
                return(.boolean(self.decodeBool(forKey: "\(key)_boolean")))
            case(9):
                return(.void)
            case(10):
                return(.character(UInt16(self.decodeInteger(forKey: "\(key)_character"))))
            case(11):
                return(.byte(UInt8(self.decodeInteger(forKey: "\(key)_byte"))))
            case(12):
                return(.class(self.decodeObject(forKey: "\(key)_class") as! ClassType))
            case(13):
                return(.method(self.decodeObject(forKey: "\(key)_method") as! MethodType))
            case(14):
                return(.enumeration(self.decodeObject(forKey: "\(key)_enumeration") as! EnumerationType))
            case(15):
                return(.identifier(self.decodeObject(forKey: "\(key)_identifier") as! Identifier))
            case(16):
                return(.variable(self.decodeObject(forKey: "\(key)_variable") as! Variable))
            case(17):
                return(.constant(self.decodeObject(forKey: "\(key)_constant") as! Constant))
            case(18):
                let day = self.decodeInteger(forKey: "\(key)_date_day")
                let month = self.decodeInteger(forKey: "\(key)_date_month")
                let year = self.decodeInteger(forKey: "\(key)_date_year")
                return(.date(Argon.Date(day: day,month: month,year: year)))
            case(19):
                let hour = self.decodeInteger(forKey: "\(key)_time_hour")
                let minute = self.decodeInteger(forKey: "\(key)_time_minute")
                let second = self.decodeInteger(forKey: "\(key)_time_second")
                let millisecond = self.decodeInteger(forKey: "\(key)_time_millisecond")
                return(.time(Argon.Time(hour: hour,minute: minute,second: second,millisecond: millisecond)))
            case(20):
                let day = self.decodeInteger(forKey: "\(key)_dateTime_day")
                let month = self.decodeInteger(forKey: "\(key)_dateTime_month")
                let year = self.decodeInteger(forKey: "\(key)_dateTime_year")
                let hour = self.decodeInteger(forKey: "\(key)_dateTime_hour")
                let minute = self.decodeInteger(forKey: "\(key)_dateTime_minute")
                let second = self.decodeInteger(forKey: "\(key)_dateTime_second")
                let millisecond = self.decodeInteger(forKey: "\(key)_dateTime_millisecond")
                return(.dateTime(Argon.DateTime(date: Argon.Date(day: day,month: month,year: year),time: Argon.Time(hour: hour,minute: minute,second: second,millisecond: millisecond))))
            case(21):
                return(.enumerationCase(self.decodeObject(forKey: "_enumerationCase") as! EnumerationCase))
            case(22):
                return(.function(self.decodeObject(forKey: "\(key)_function") as! FunctionType))
            case(23):
                return(.tuple(self.decodeTuple(forKey: "\(key)_tuple")))
            default:
                fatalError()
            }
        }
    }
