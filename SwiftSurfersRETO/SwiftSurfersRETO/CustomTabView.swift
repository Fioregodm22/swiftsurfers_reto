//
//  CustomTabView.swift
//  ElementosReutilizables
//
//  Created by Maria Cavada on 10/10/25.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String)] = [
        ("timer", "Home"),
        ("calendar","Search"),
        ("rectangle.portrait.and.arrow.right","Favorites"),
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 60)
                .foregroundColor(Color(red: 230/255, green: 229/255, blue: 229/255))
                .shadow(radius: 5)
            HStack {
                ForEach(0..<3) { index in
                    Spacer()
                    Button {
                        tabSelection = index + 1
                    }label: {
                        ZStack (){
                            Spacer()
                            
                            
                            
                         
                            Spacer()
                            
                            if index + 1 == tabSelection {
                                Capsule()
                                    .frame(width: 90, height: 50)
                                    .foregroundColor( Color(red: 239/255, green: 239/255, blue: 239/255))
                                    .matchedGeometryEffect(id: "SelectedTab", in : animationNamespace)
        
                            }else{
                                Capsule()
                                    .frame(width: 90, height: 5)
                                    .foregroundColor(.clear)
                                    .offset(y: -5)
                                
                            }
                            
                            Image(systemName: tabBarItems[index].image)
                                .resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 35)
                        }
                        .foregroundColor(index + 1 == tabSelection ? Color(red: 255/255, green: 153/255, blue: 0/255): .gray)
                    }
                    Spacer()
                }
            }
            .padding()
            .frame(height: 80)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
