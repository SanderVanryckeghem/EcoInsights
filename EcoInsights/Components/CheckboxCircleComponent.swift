//
//  CheckboxCircleComponent.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 24/03/2023.
//

import SwiftUI

struct CheckboxCircleComponent: View {
    @Binding var checked : Bool
    
    var body: some View {
        Image(systemName: checked ? "checkmark.circle.fill" : "checkmark.circle")
            .foregroundColor(checked ? .green : .secondary)
            .onTapGesture {
                checked.toggle()
            }
    }
}

struct CheckboxCircleComponent_Previews: PreviewProvider {
    struct CheckboxCircleDemoWrapper : View {
        @State var checked = false
        
        var body: some View {
            CheckboxCircleComponent(checked: $checked)
        }
    }
    
    static var previews: some View {
        CheckboxCircleDemoWrapper()
    }
}
