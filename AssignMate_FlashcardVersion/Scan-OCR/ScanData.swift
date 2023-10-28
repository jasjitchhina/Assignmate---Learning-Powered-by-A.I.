//
//  ScanData.swift
//  AssignMate_FlashcardVersion
//
//  Created by Peter Borozan on 10/27/23.
//

import Foundation


struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
