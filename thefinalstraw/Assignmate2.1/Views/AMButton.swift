//
//  AMButton.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/14/23.
//

import SwiftUI

struct AMButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    
    var body: some View {
        Button(
            action: {
                action()
            }
            , label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        . foregroundColor(background)
                
                    Text(title)
                        .foregroundStyle(Color.white)
                        . bold()
                    
                }
            })
    }
}

#Preview {
    AMButton(title: "Value",
             background: .blue) {
        //action
    }
}
