//
//  TaxesView.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct TaxesView: View {
  
  @Binding var appModel: AppModel
  @State private var irpfMessage: AlertMessage? = nil
  @State private var mainResidenceMessage: AlertMessage? = nil
  @State private var landRegistryMessage: AlertMessage? = nil
  @State private var landRegistryMessage2: AlertMessage? = nil
  @State private var annualDepreciationMessage: AlertMessage? = nil
  @State private var mortgageInterestMessage: AlertMessage? = nil
  @State private var taxesMessage: AlertMessage? = nil
  
  init(appModel: Binding<AppModel>) {
    // Drop space between form sections
    UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    self._appModel = appModel
  }
  
  var body: some View {
    Form {
      HStack {
        Text("IRPF")
          .fixedSize()
        Button(action: {
          self.irpfMessage = TaxMessages.irpfMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $irpfMessage) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        Picker(selection: $appModel.irpfRange, label: Text("")) {
          Text("19%")
            .fixedSize()
            .tag(0)
          Text("24%")
            .fixedSize()
            .tag(1)
          Text("30%")
            .fixedSize()
            .tag(2)
          Text("37%")
            .fixedSize()
            .tag(3)
          Text("45%")
            .fixedSize()
            .tag(4)
        }
        .pickerStyle(SegmentedPickerStyle())
        .onReceive([appModel.irpfRange].publisher.first()) { _ in
          self.appModel.taxes = self.appModel.computeTaxes()
        }
      }
      HStack {
        Text("Vivienda habitual del inquilino")
          .fixedSize()
        Button(action: {
          self.mainResidenceMessage = TaxMessages.mainResidenceMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $mainResidenceMessage) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        Picker(selection: $appModel.mainResidence, label: Text("")) {
          Text("Sí")
            .fixedSize()
            .tag(0)
          Text("No")
            .fixedSize()
            .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .onReceive([appModel.mainResidence].publisher.first()) { _ in
          self.appModel.taxes = self.appModel.computeTaxes()
        }
      }
      HStack {
        Text("Valor de la construcción")
          .fixedSize()
        Button(action: {
          self.landRegistryMessage = TaxMessages.landRegistryMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $landRegistryMessage) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        TextField("0", text: landBuildingValueProxy, onEditingChanged: {
          if $0 {
            self.landBuildingValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Text("€")
      }
      HStack {
        Text("Valor del suelo")
          .fixedSize()
        Button(action: {
          self.landRegistryMessage2 = TaxMessages.landRegistryMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $landRegistryMessage2) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        TextField("0", text: landGroundValueProxy, onEditingChanged: {
          if $0 {
            self.landGroundValueProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 71)
        Text("€")
      }
      Section(header: Text("Resultados")) {
        HStack {
          Text("Amortización anual")
            .fixedSize()
          Button(action: {
            self.annualDepreciationMessage = TaxMessages.annualDepreciationMessage
          }) {
            Image(systemName: "info.circle")
          }.alert(item: $annualDepreciationMessage) { message in
            Alert(
              title: Text(message.title),
              message: Text(message.message),
              dismissButton: .default(Text("Ok"))
            )
          }
          Spacer()
          Text((!appModel.annualDepreciation.isEmpty ? appModel.annualDepreciation : "0") + " €/año")
            .fixedSize()
        }
        HStack {
          Text("Intereses de la hipoteca")
            .fixedSize()
          Button(action: {
            self.mortgageInterestMessage = TaxMessages.mortgageInterestMessage
          }) {
            Image(systemName: "info.circle")
          }.alert(item: $mortgageInterestMessage) { message in
            Alert(
              title: Text(message.title),
              message: Text(message.message),
              dismissButton: .default(Text("Ok"))
            )
          }
          Spacer()
          Text((!appModel.mortgageInterestString.isEmpty ? appModel.mortgageInterestString : "0") + " €/año")
            .fixedSize()
        }
        HStack {
          Text("Impuestos")
            .fixedSize()
          Button(action: {
            self.taxesMessage = TaxMessages.taxesMessage
          }) {
            Image(systemName: "info.circle")
          }.alert(item: $taxesMessage) { message in
            Alert(
              title: Text(message.title),
              message: Text(message.message),
              dismissButton: .default(Text("Ok"))
            )
          }
          Spacer()
          Text((!appModel.taxes.isEmpty ? appModel.taxes : "0") + " €/año")
            .fixedSize()
        }
      }
    }
    .navigationBarTitle(Text("Impuestos"), displayMode: .inline)
    .onAppear {
      self.appModel.annualDepreciation = self.appModel.computeAnnualDepreciation()
      self.appModel.taxes = self.appModel.computeTaxes()
    }
    .keyboardObserving()
  }
  
  struct TaxesView_Previews: PreviewProvider {
    static var previews: some View {
      TaxesView(appModel: .constant(AppModel()))
    }
  }
}

extension TaxesView {
  
  var landBuildingValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.landBuildingValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.landBuildingValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.landBuildingValue = value < 0.0 ? 0.0 : value
          self.appModel.annualDepreciation = self.appModel.computeAnnualDepreciation()
        }
    })
  }
  
  var landGroundValueProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.landGroundValue.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.landGroundValue, truncateDecimals: false)
        }
    },
      set: {
        if let value = Double($0) {
          self.appModel.landGroundValue = value < 0.0 ? 0.0 : value
          self.appModel.annualDepreciation = self.appModel.computeAnnualDepreciation()
        }
    })
  }
}
