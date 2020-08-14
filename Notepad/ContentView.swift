//
//  ContentView.swift
//  Notepad
//
//  Created by snow on 2020/6/8.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var home = Home.home
    
    init() {
        home.loginFlag = home.getLoginFlag()
    }
 
    var body: some View {
        (home.loginFlag ? AnyView(FirstView()) : AnyView(LoginView()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
