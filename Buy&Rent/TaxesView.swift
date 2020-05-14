//
//  TaxesView.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 07/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI

struct TaxesView: View {
  
  // TODO: mirar el excel de Carlos Galán e implementar esta parte
  
  @Binding var appModel: AppModel
  @State private var test = 0
  @State private var message: AlertMessage? = nil
  
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
          self.message = TaxMessages.irpfMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $message) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        TextField("0", text: defaultInsuranceProxy, onEditingChanged: {
          if $0 {
            self.defaultInsuranceProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.leading, 149)
        Text("%")
      }
      HStack {
        Text("Vivienda habitual del inquilino")
          .fixedSize()
        Button(action: {
          self.message = TaxMessages.mainResidenceMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $message) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        Picker(selection: $test, label: Text("")) {
          Text("Sí")
            .fixedSize()
            .tag(0)
          Text("No")
            .fixedSize()
            .tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      HStack {
        Text("Valor de la construcción")
          .fixedSize()
        Button(action: {
          self.message = TaxMessages.landRegistryMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $message) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        TextField("0", text: defaultInsuranceProxy, onEditingChanged: {
          if $0 {
            self.defaultInsuranceProxy.wrappedValue = "0"
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
          self.message = TaxMessages.landRegistryMessage
        }) {
          Image(systemName: "info.circle")
        }.alert(item: $message) { message in
          Alert(
            title: Text(message.title),
            message: Text(message.message),
            dismissButton: .default(Text("Ok"))
          )
        }
        TextField("0", text: defaultInsuranceProxy, onEditingChanged: {
          if $0 {
            self.defaultInsuranceProxy.wrappedValue = "0"
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
            self.message = TaxMessages.annualDepreciationMessage
          }) {
            Image(systemName: "info.circle")
          }.alert(item: $message) { message in
            Alert(
              title: Text(message.title),
              message: Text(message.message),
              dismissButton: .default(Text("Ok"))
            )
          }
          Spacer()
          Text("0 €/año")
            .fixedSize()
        }
        HStack {
          Text("Intereses de la hipoteca")
            .fixedSize()
          Button(action: {
            self.message = TaxMessages.mortageInterestMessage
          }) {
            Image(systemName: "info.circle")
          }.alert(item: $message) { message in
            Alert(
              title: Text(message.title),
              message: Text(message.message),
              dismissButton: .default(Text("Ok"))
            )
          }
          Spacer()
          Text("0 €/año")
            .fixedSize()
        }
        HStack {
          Text("Impuestos")
            .fixedSize()
          Button(action: {
            self.message = TaxMessages.taxesMessage
          }) {
            Image(systemName: "info.circle")
          }.alert(item: $message) { message in
            Alert(
              title: Text(message.title),
              message: Text(message.message),
              dismissButton: .default(Text("Ok"))
            )
          }
          Spacer()
          Text("0 €/año")
            .fixedSize()
        }
      }
    }
    .navigationBarTitle(Text("Impuestos"), displayMode: .inline)
  }
  
  struct TaxesView_Previews: PreviewProvider {
    static var previews: some View {
      TaxesView(appModel: .constant(AppModel()))
    }
  }
}

extension TaxesView {
  
  var defaultInsuranceProxy: Binding<String> {
    Binding<String>(
      get: {
        if self.appModel.defaultInsurance.isZero {
          return String()
        } else {
          return CoreUtils.textFieldFormattedValue(for: self.appModel.defaultInsurance, truncateDecimals: false)
        }
    },
      set: {
        if let value = CoreUtils.numberFormatter.number(from: $0) {
          self.appModel.defaultInsurance = value.doubleValue < 0.0 ? 0.0 : value.doubleValue
        }
    })
  }
}
