//
//  SmetankaWidgetView.swift
//  SmetankaWidgetExtension
//
//  Created by Димон on 25.09.23.
//

import SwiftUI

struct SmetankaWidgetView: View {
    
    let displaySize: CGSize
    
    private let gradient = Gradient(colors: [.red, .orange, .yellow, .orange, .purple, .pink])
    private let defaultIconName = "person.circle"
    
    
    var body: some View {
        ZStack {
            ContainerRelativeShape().fill(AngularGradient(gradient: gradient, center: .bottomTrailing))
            Widget1()
        }
        .frame(width: displaySize.width, height: displaySize.height)
    }
    
    @ViewBuilder
    func Widget1() -> some View {
        VStack(alignment: .center) {
            HStack(alignment: .center,
                   spacing: 4) {
                Text("Название рецепта")
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(.black)
            }
            Text("Описание рецепта")
                .lineLimit(3)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.black)
                .padding(.bottom, 2)
        }
    }
}
