//
//  BannerViewController.swift
//  Buy&Rent
//
//  Created by iMac Óscar on 20/05/2020.
//  Copyright © 2020 iMac Óscar. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct BannerViewController: UIViewControllerRepresentable {
  
  let bannerId = "ca-app-pub-3940256099942544/2934735716"
  
  func makeUIViewController(context: Context) -> UIViewController {
    let view = GADBannerView(adSize: kGADAdSizeBanner)
    let viewController = UIViewController()
    view.adUnitID = bannerId
    view.rootViewController = viewController
    view.delegate = viewController
    viewController.view.addSubview(view)
    viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
    view.load(GADRequest())
    
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    
  }
}

extension UIViewController: GADBannerViewDelegate {
  public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    bannerView.alpha = 0
    UIView.animate(withDuration: 1, animations: {
      bannerView.alpha = 1
    })
  }
}
