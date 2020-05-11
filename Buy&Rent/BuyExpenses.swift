//
//  BuyExpenses.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct BuyExpenses: View {
  
  let computationMode = ["🔣 Por porcentaje", "👨🏼‍💻 Individual"]
  @Binding var appModel: AppModel
  
  init(appModel: Binding<AppModel>) {
    // Drop space between form sections
    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    self._appModel = appModel
  }
  
  func updateBuyExpenses(percentage: Bool) {
    if percentage {
      if self.appModel.buyExpensesPercentage > 0.0 {
        let conversion = NSNumber(value: (self.appModel.buyValue * self.appModel.buyExpensesPercentage / 100.0))
        if conversion.doubleValue > 0.0 {
          self.appModel.buyExpenses = CoreUtils.textFieldFormattedValue(for: conversion.doubleValue, truncateDecimals: true)
        } else {
          self.appModel.buyExpenses = String()
        }
      } else {
        self.appModel.buyExpenses = String()
      }
    } else {
      let totalExpenses = self.appModel.computeAllExpenses()
      if totalExpenses > 0.0 {
        self.appModel.buyExpenses = CoreUtils.textFieldFormattedValue(for: totalExpenses, truncateDecimals: true)
      } else {
        self.appModel.buyExpenses = String()
      }
    }
  }
  
  var body: some View {
    Form {
      Picker(selection: $appModel.selectedExpensesComputation, label: Text("Modo de cálculo").fixedSize()) {
        Text(computationMode[0])
          .fixedSize()
          .tag(0)
        Text(computationMode[1])
          .fixedSize()
          .tag(1)
      }
      .onReceive([appModel.selectedExpensesComputation].publisher.first()) {
        if $0 == 0 {
          // Computation by percentage
          self.updateBuyExpenses(percentage: true)
        } else {
          // Individual computation
          self.updateBuyExpenses(percentage: false)
        }
      }
      
      if appModel.selectedExpensesComputation == 0 {
        HStack {
          Text("Porcentaje")
            .fixedSize()
          TextField("10", text: percentageProxy, onEditingChanged: {
            if $0 {
              self.percentageProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Text("%")
        }
      } else {
        HStack {
          Text("Notario")
            .fixedSize()
          TextField("0", text: notaryExpensesProxy, onEditingChanged: {
            if $0 {
              self.notaryExpensesProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 108)
          Text("€")
        }
        HStack {
          Text("Registro")
            .fixedSize()
          TextField("0", text: registryExpensesProxy, onEditingChanged: {
            if $0 {
              self.registryExpensesProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 100)
          Text("€")
        }
        HStack {
          Text("Gestoría")
            .fixedSize()
          TextField("0", text: managementExpensesProxy, onEditingChanged: {
            if $0 {
              self.managementExpensesProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 100)
          Text("€")
        }
        HStack {
          Text("ITP")
            .fixedSize()
          TextField("6", text: itpPercentageProxy, onEditingChanged: {
            if $0 {
              self.itpPercentageProxy.wrappedValue = "0"
            }
          })
            .multilineTextAlignment(.trailing)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 138)
          Text("%")
        }
        HStack {
          Text("Comisión inmobiliaria")
            .fixedSize()
          TextField("0", text: realStateCommissionProxy, onEditingChanged: {
            if $0 {
              self.realStateCommissionProxy.wrappedValue = "0"
            }
          })
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
      BuyExpenses(appModel: .constant(AppModel()))
      //.environment(\.colorScheme, .light)
      
      //BuyExpenses()
      // .environment(\.colorScheme, .dark)
      //}
    }
  }
}

extension BuyExpenses {
  
  var percentageProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.buyExpensesPercentage.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.buyExpensesPercentage, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.buyExpensesPercentage = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          // Compute property expenses using the property value
          self.updateBuyExpenses(percentage: true)
        }
    })
  }
  
  var notaryExpensesProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.notaryExpenses.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.notaryExpenses, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.notaryExpenses = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateBuyExpenses(percentage: false)
        }
    })
  }
  
  var registryExpensesProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.registryExpenses.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.registryExpenses, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.registryExpenses = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateBuyExpenses(percentage: false)
        }
    })
  }
  
  var managementExpensesProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.managementExpenses.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.managementExpenses, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.managementExpenses = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateBuyExpenses(percentage: false)
        }
    })
  }
  
  var itpPercentageProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.itpPercentage.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.itpPercentage, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.itpPercentage = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateBuyExpenses(percentage: false)
        }
    })
  }
  
  var realStateCommissionProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.realStateCommission.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.realStateCommission, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.realStateCommission = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          self.updateBuyExpenses(percentage: false)
        }
    })
  }
}
