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
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 60)
                .foregroundColor(.blue.opacity(0.2))
                .shadow(radius: 25)
            HStack {
                ForEach(0..<3) { index in
                    Spacer()
                    Button {
                        tabSelection = index + 1
                    }label: {
                        VStack (){
                            Spacer()
                            
                            Image(systemName: tabBarItems[index].image)
                                .resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                            
                         
                            Spacer()
                            
                            if index + 1 == tabSelection {
                                Capsule()
                                    .frame(width: 50, height: 5)
                                    .foregroundColor( Color(red: 255/255, green: 153/255, blue: 0/255))
                                    .matchedGeometryEffect(id: "SelectedTab", in : animationNamespace)
                                    .offset(y: -5)
                            }else{
                                Capsule()
                                    .frame(width: 50, height: 5)
                                    .foregroundColor(.clear)
                                    .offset(y: -5)
                                
                            }
                        }
                        .foregroundColor(index + 1 == tabSelection ? Color(red: 255/255, green: 153/255, blue: 0/255): .gray)
                    }
                    Spacer()
                }
            }
            .padding(22)
            .frame(height: 80)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
