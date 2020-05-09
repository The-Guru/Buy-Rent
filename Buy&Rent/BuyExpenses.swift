//
//  BuyExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct BuyExpenses: View {
  
  let computationMode = ["🔣 Cálculo por porcentaje", "👨🏼‍💻 Cálculo individual"]
  
  @State private var selectedComputation = 0
  @State private var test = ""
  
  init() {
    // Drop space between form sections
    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
  }
  
  var body: some View {
    Form {
      Picker(selection: $selectedComputation, label: Text("Modo de cálculo")) {
        Text(computationMode[0]).tag(0)
        Text(computationMode[1]).tag(1)
      }.pickerStyle(SegmentedPickerStyle())
      
      if selectedComputation == 0 {
        HStack {
          Text("Porcentaje")
            .fixedSize()
          TextField("10", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Text("%")
        }
      } else {
        HStack {
          Text("Notario")
            .fixedSize()
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 108)
          Text("€")
        }
        HStack {
          Text("Registro")
            .fixedSize()
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 100)
          Text("€")
        }
        HStack {
          Text("Gestoría")
            .fixedSize()
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 100)
          Text("€")
        }
        HStack {
          Text("ITP")
            .fixedSize()
          TextField("6", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 138)
          Text("%")
        }
        HStack {
          Text("Comisión inmobiliaria")
            .fixedSize()
          TextField("0", text: $test)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Text("€")
        }
      }
    }
    .navigationBarTitle(Text("Gastos de la compra"), displayMode: .inline)
  }
  
  struct BuyExpenses_Previews: PreviewProvider {
    static var previews: some View {
       //Group {
            BuyExpenses()
               //.environment(\.colorScheme, .light)

            //BuyExpenses()
              // .environment(\.colorScheme, .dark)
         //}
    }
  }
}
