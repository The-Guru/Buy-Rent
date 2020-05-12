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
        TextField("0", text: defaultInsuranceProxy, onEditingChanged: {
          if $0 {
            self.defaultInsuranceProxy.wrappedValue = "0"
          }
        })
          .multilineTextAlignment(.trailing)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        // TODO: Añadir botón de información para explicar los tramos
        Text("%")
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
