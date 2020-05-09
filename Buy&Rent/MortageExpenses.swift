//
//  MortageExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct MortageExpenses: View {
  
  @State private var test: Double = 0.0
  
  @State private var text1: String = ""
  @State private var text1Placeholder: String = "0.00"
  
  static let currencyEditing: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  
  var body: some View {
    VStack {
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      TextField( self.$text1Placeholder.wrappedValue, text: $text1, onEditingChanged: { (editing) in
        if editing {
          self.$text1Placeholder.wrappedValue
            = self.$text1.wrappedValue
          self.$text1.wrappedValue = ""
        }
      }).textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }
}

struct MortageExpenses_Previews: PreviewProvider {
  static var previews: some View {
    MortageExpenses()
  }
}
