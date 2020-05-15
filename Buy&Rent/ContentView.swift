//
//  ContentView.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @State private var appModel: AppModel = AppModel()
  
  @State private var grossReturnMessage: AlertMessage? = nil
  @State private var netReturnMessage: AlertMessage? = nil
  @State private var cashflowMessage: AlertMessage? = nil
  @State private var roiMessage: AlertMessage? = nil
  @State private var perMessage: AlertMessage? = nil
  
  @State private var buyExpensesRefresh = false
  @State private var periodicExpensesRefresh = false
  @State private var taxesRefresh = false
  
  @State private var totalPropertyValue: String = String()
  @State private var moneyToSpend: String = String()
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
            }, onCommit: {
              self.appModel.annualDepreciation = self.appModel.computeAnnualDepreciation()
              self.appModel.taxes = self.appModel.computeTaxes()
              self.computeResults()
              if self.appModel.taxes.isEmpty {
                self.taxesRefresh.toggle()
              }
              if self.appModel.buyExpenses.isEmpty {
                self.buyExpensesRefresh.toggle()
              }
            })
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("€")
          }
          HStack {
            NavigationLink(destination: BuyExpenses(appModel: $appModel)) {
              Text("Gastos de la compra")
                .fixedSize()
              TextField("0" + (buyExpensesRefresh ? "" : " "), text: $appModel.buyExpenses)
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
            }, onCommit: {
              self.appModel.annualDepreciation = self.appModel.computeAnnualDepreciation()
              self.appModel.taxes = self.appModel.computeTaxes()
              self.computeResults()
              if self.appModel.taxes.isEmpty {
                self.taxesRefresh.toggle()
              }
            })
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("€")
          }
        }
        
        Section(header: Text("Hipoteca")) {
          HStack {
            NavigationLink(destination: MortgageExpenses(appModel: $appModel)) {
              Text("Importe del préstamo")
                .fixedSize()
              TextField("0", text: $appModel.mortgageValueString)
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
            TextField("0", text: $appModel.mortgageExpenses)
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
            }, onCommit: {
              self.appModel.taxes = self.appModel.computeTaxes()
              self.computeResults()
              if self.appModel.periodicExpenses.isEmpty {
                self.periodicExpensesRefresh.toggle()
              }
              if self.appModel.taxes.isEmpty {
                self.taxesRefresh.toggle()
              }
            })
              .multilineTextAlignment(.trailing)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding(.leading, 18)
            Text("€/mes")
          }
          HStack {
            NavigationLink(destination: PeriodicExpenses(appModel: $appModel)) {
              Text("Gastos periódicos")
                .fixedSize()
              TextField("0" + (periodicExpensesRefresh ? "" : " "), text: $appModel.periodicExpenses)
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
            NavigationLink(destination: TaxesView(appModel: $appModel)) {
              Text("Impuestos")
                .fixedSize()
              TextField("0" + (taxesRefresh ? "" : " "), text: $appModel.taxes)
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
            Text((!totalPropertyValue.isEmpty ? totalPropertyValue : "0") + " €")
              .fixedSize()
          }
          HStack {
            Text("Capital a aportar")
              .fixedSize()
            Spacer()
            Text((!moneyToSpend.isEmpty ? moneyToSpend : "0") + " €")
              .fixedSize()
          }
          HStack {
            Text("Letra hipotecaria")
              .fixedSize()
            Spacer()
            Text((!appModel.mortgageNote.isEmpty ? appModel.mortgageNote : "0") + " €/mes")
              .fixedSize()
          }
          HStack {
            Text("Beneficio antes de impuestos")
              .fixedSize()
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          HStack {
            Text("Beneficio después de impuestos")
              .fixedSize()
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          HStack {
            Text("Rentabilidad bruta")
              .fixedSize()
            Button(action: {
              self.grossReturnMessage = TaxMessages.grossReturnMessage
            }) {
              Image(systemName: "info.circle")
            }
            .alert(item: $grossReturnMessage) { message in
              Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("Ok"))
              )
            }
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          HStack {
            Text("Rentabilidad neta")
              .fixedSize()
            Button(action: {
              self.netReturnMessage = TaxMessages.netReturnMessage
            }) {
              Image(systemName: "info.circle")
            }
            .alert(item: $netReturnMessage) { message in
              Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("Ok"))
              )
            }
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          HStack {
            Text("Cashflow")
              .fixedSize()
            Button(action: {
              self.cashflowMessage = TaxMessages.cashflowMessage
            }) {
              Image(systemName: "info.circle")
            }
            .alert(item: $cashflowMessage) { message in
              Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("Ok"))
              )
            }
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          HStack {
            Text("ROI. Retorno de la inversión")
              .fixedSize()
            Button(action: {
              self.roiMessage = TaxMessages.roiMessage
            }) {
              Image(systemName: "info.circle")
            }
            .alert(item: $roiMessage) { message in
              Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("Ok"))
              )
            }
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
          HStack {
            Text("PER. Relación precio/beneficio")
              .fixedSize()
            Button(action: {
              self.perMessage = TaxMessages.perMessage
            }) {
              Image(systemName: "info.circle")
            }
            .alert(item: $perMessage) { message in
              Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("Ok"))
              )
            }
            Spacer()
            Text("\(moneyToPay) €")
              .fixedSize()
          }
        }
      }
      .navigationBarTitle(Text("Buy & Rent"), displayMode: .inline)
      .onAppear {
        self.appModel.annualDepreciation = self.appModel.computeAnnualDepreciation()
        self.appModel.taxes = self.appModel.computeTaxes()
        self.computeResults()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

extension ContentView {
  
  func computeResults() {
    let totalProperty = appModel.buyValue +
      (CoreUtils.numberFormatter.number(from: appModel.buyExpenses)?.doubleValue ?? 0.0) +
      appModel.workExpenses +
      (CoreUtils.numberFormatter.number(from: appModel.mortgageExpenses)?.doubleValue ?? 0.0)
    totalPropertyValue = CoreUtils.textFieldFormattedValue(for: totalProperty, truncateDecimals: true)
    let mortgageValue = appModel.mortgageValueString.isEmpty ? 0.0 : CoreUtils.numberFormatter.number(from: appModel.mortgageValueString)?.doubleValue ?? 0.0
    let moneyToSpendComputation = totalProperty - mortgageValue
    moneyToSpend = CoreUtils.textFieldFormattedValue(for: moneyToSpendComputation > 0.0 ? moneyToSpendComputation : 0.0, truncateDecimals: true)
    
    // TODO: seguir calculando el beneficio antes de impuestos...
  }
  
  var buyValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.buyValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.buyValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.buyValue = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          if self.appModel.selectedExpensesComputation == 0 {
            if self.appModel.buyValue > 0.0 {
              if self.appModel.buyExpensesPercentage > 0.0 {
                let conversion = NSNumber(value: (self.appModel.buyValue * self.appModel.buyExpensesPercentage / 100.0))
                if conversion.doubleValue > 0.0 {
                  self.appModel.buyExpenses = CoreUtils.textFieldFormattedValue(for: conversion.doubleValue, truncateDecimals: true)
                } else {
                  self.appModel.buyExpenses = String()
                }
              }
            } else {
              self.appModel.buyExpenses = String()
            }
          } else {
            let totalExpenses = self.appModel.computeBuyExpenses()
            if totalExpenses > 0.0 {
              self.appModel.buyExpenses = CoreUtils.textFieldFormattedValue(for: totalExpenses, truncateDecimals: true)
            } else {
              self.appModel.buyExpenses = String()
            }
          }
        }
        
        if self.appModel.mortgagePercentageToggle {
          let mortgageValue = self.appModel.buyValue * self.appModel.mortgageValue  / 100.0
          self.appModel.mortgageValueString = mortgageValue > 0.0 ? CoreUtils.textFieldFormattedValue(for: mortgageValue, truncateDecimals: true) : String()
        }
    })
  }
  
  var workExpensesProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.workExpenses.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.workExpenses, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.workExpenses = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
        }
    })
  }
  
  var rentValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.rentValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.rentValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.rentValue = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
          let totalPeriodicExpenses = self.appModel.computePeriodicExpenses()
          if totalPeriodicExpenses > 0.0 {
            self.appModel.periodicExpenses = CoreUtils.textFieldFormattedValue(for: totalPeriodicExpenses, truncateDecimals: true)
          } else {
            self.appModel.periodicExpenses = String()
          }
        }
    })
  }
}
