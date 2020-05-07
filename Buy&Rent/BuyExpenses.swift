//
//  BuyExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct BuyExpenses: View {
  
  let computationMode = ["Cálculo por porcentaje", "Cálculo individual"]
  
  @State private var selectedComputation = 0
  @State private var test = ""
  
  var body: some View {
    Form {
      Picker(selection: $selectedComputation, label: Text("Modo de cálculo")) {
        ForEach(0 ..< computationMode.count) {
          Text(self.computationMode[$0])
        }
      }
      
      if selectedComputation == 0 {
        HStack {
          Text("Porcentaje")
          TextField("10", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Text("%")
        }
      } else {
        HStack {
          Text("Notario")
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 108)
          Text("€")
        }
        HStack {
          Text("Registro")
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 100)
          Text("€")
        }
        HStack {
          Text("Gestoría")
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 100)
          Text("€")
        }
        HStack {
          Text("ITP")
          TextField("6", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 138)
          Text("%")
        }
        HStack {
          Text("Comisión inmobiliaria")
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Text("€")
        }
      }
    }.navigationBarTitle(Text("Gastos de la compra"))
  }
  
  struct BuyExpenses_Previews: PreviewProvider {
    static var previews: some View {
      BuyExpenses()
    }
  }
}
