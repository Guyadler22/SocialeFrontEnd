//
//  IntDate.swift
//  Sociale
//
//  Created by Guy Adler on 16/12/2023.
//

import Foundation


struct IntDate {
    private var value: Double
    
    init(value:Double) {
        self.value = value
    }
    
    static func now()  -> Self {
        return Self(value: NSDate().timeIntervalSince1970 * 1000)
    }
    
    func difference_min(other: Self) -> Int64 {
        Int64((self.value - other.value) / 1000 / 60)
    }
    
    func difference_sec(other: Self) -> Int64 {
        Int64 ((self.value - other.value) / 1000)
    }
 
    
    func difference(other: Self) -> Self {
        if self.value < other.value {
            return IntDate(value: 0)
        }
        
        return IntDate(value: self.value - other.value)
    }
}
