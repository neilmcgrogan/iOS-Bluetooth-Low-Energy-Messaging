//
//  ViewController.swift
//  home app
//
//  Created by McGrogan, Neil on 10/26/21.
//

import SwiftUI

enum LoadView {
    case home, provisioned
}

struct ViewController: View {
    
    @State private var loadView = LoadView.home
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        Group {
            
            switch loadView {
            case .home:
                HomeView(loadView: self.$loadView, bleManager: bleManager)
                //HomeView(loadView: self.$loadView)
            case .provisioned:
                Provisioned(loadView: self.$loadView, bleManager: bleManager)
            }
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
    }
}
