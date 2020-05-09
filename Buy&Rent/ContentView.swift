//
//  ContentView.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @State private var buyValue: Double = 0.0
  @State private var buyExpenses: String = ""
  @State private var workExpenses: Double = 0.0
  @State private var mortageValue: String = ""
  @State private var mortageExpenses: String = ""
  @State private var rentValue: Double = 0.0
  @State private var periodicExpenses: String = ""
  @State private var taxesValue: String = ""
  
  private var totalPropertyValue: Double = 0.0
  private var moneyToPay: Double = 0.0
  
  init() {
    // Set the size of the navigation bar tittles in order to
    // see the Buy & Rent navigation bar button
    UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(ofSize: 13)]
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Compra del inmueble")) {
          HStack {
            Text("Importe de la compra")
              .fixedSize()
            TextField("0", text: buyValueProxy, onEditingChanged: {
              if $0 {
                self.buyValueProxy.wrappedValue = "0"
              }
            })
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("€")
          }
          HStack {
            NavigationLink(destination: BuyExpenses()) {
              Text("Gastos de la compra")
                .fixedSize()
              TextField("0", text: $buyExpenses)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 7)
                .disabled(true)
              Text("€")
            }
          }
          HStack {
            Text("Reforma")
              .fixedSize()
              .padding(.trailing, 100)
            TextField("0", text: workExpensesProxy, onEditingChanged: {
              if $0 {
                self.workExpensesProxy.wrappedValue = "0"
              }
            })
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("€")
          }
        }
        
        Section(header: Text("Hipoteca")) {
          HStack {
            NavigationLink(destination: MortageExpenses()) {
              Text("Importe del préstamo")
                .fixedSize()
              TextField("0", text: $mortageValue)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 1)
                .disabled(true)
              Text("€")
            }
          }
          HStack {
            Text("Gastos de la hipoteca")
              .fixedSize()
            TextField("0", text: $mortageExpenses)
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .disabled(true)
            Text("€")
          }
        }
        
        Section(header: Text("Alquiler")) {
          HStack {
            Text("Importe del alquiler")
              .fixedSize()
            TextField("0", text: rentValueProxy, onEditingChanged: {
              if $0 {
                self.rentValueProxy.wrappedValue = "0"
              }
            })
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.leading, 18)
            Text("€/mes")
          }
          HStack {
            NavigationLink(destination: PeriodicExpenses()) {
              Text("Gastos periódicos")
                .fixedSize()
              TextField("0", text: $periodicExpenses)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 27)
                .disabled(true)
              Text("€/mes")
            }
          }
        }
        
        Section(header: Text("Impuestos")) {
          HStack {
            NavigationLink(destination: TaxesView()) {
              Text("Impuestos")
                .fixedSize()
              TextField("0", text: $taxesValue)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 84)
                .disabled(true)
              Text("€/año")
            }
          }
        }
        
        Section(header: Text("Resultados")) {
          HStack {
            Text("Importe total del inmueble")
              .fixedSize()
            Spacer()
            Text("\(totalPropertyValue) €")
              .fixedSize()
          }
          HStack {
            Text("Capital a aportar")
              .fixedSize()
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          
          // TODO: Añadir resto de resultados
        }
      }
      .navigationBarTitle(Text("Buy & Rent"), displayMode: .inline)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    //Group {
      ContentView()
        //.environment(\.colorScheme, .light)
      
      //ContentView()
        //.environment(\.colorScheme, .dark)
    //}
  }
}

extension ContentView {
  
  static let numberFormatter = NumberFormatter()
  
  func textFieldFormattedValue(for value: Double) -> String {
    let isInteger = floor(value) == value
    return isInteger ? String(format: "%.0f", value) : String(value)
  }
  
  var buyValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.buyValue.isZero {
          return String()
        } else {
          return self.textFieldFormattedValue(for: self.buyValue)
        }
    },
      set: {
        if let value = ContentView.numberFormatter.number(from: $0) {
          self.buyValue = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
        }
    })
  }
  
  var workExpensesProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.workExpenses.isZero {
          return String()
        } else {
          return self.textFieldFormattedValue(for: self.workExpenses)
        }
    },
      set: {
        if let value = ContentView.numberFormatter.number(from: $0) {
          self.workExpenses = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
        }
    })
  }
  
  var rentValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.rentValue.isZero {
          return String()
        } else {
          return self.textFieldFormattedValue(for: self.rentValue)
        }
    },
      set: {
        if let value = ContentView.numberFormatter.number(from: $0) {
          self.rentValue = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
        }
    })
  }
}
