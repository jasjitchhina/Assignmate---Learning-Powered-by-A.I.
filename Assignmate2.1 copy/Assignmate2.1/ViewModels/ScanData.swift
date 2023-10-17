//
//  ScanData.swift
//  Assignmate2.1
//
//  Created by Jesse Chhina on 10/16/23.
//

import Foundation


struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
