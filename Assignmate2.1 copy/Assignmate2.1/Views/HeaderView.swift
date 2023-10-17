//
//  HeaderView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/14/23.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(background)
                .rotationEffect(Angle(degrees: angle))
           
            VStack{
                
                Text(title)
                    .foregroundStyle(Color.white)
                    .offset(y:20)
                    .font(.system(size: 50))
                    .bold()
                Text(subtitle)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
                    .offset(y:20)

            }
        }
        
        .frame(width: UIScreen.main.bounds.width * 3, height:300)
        .offset(y: -100)
    }
}

#Preview {
    HeaderView(title: "Title",
               subtitle: "Subtitle",
               angle: 15,
               background: .blue
    )
}
