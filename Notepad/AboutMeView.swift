//
//  AboutMeView.swift
//  Notepad
//
//  Created by snow on 2020/6/17.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct AboutMeView: View {
    @ObservedObject var home = Home.home
    var body: some View {
            VStack {
                NavigationLink("修改密码", destination: EditPasswordView())
                .frame(width: 320, height: 44)
                .border(/*@START_MENU_TOKEN@*/Color.green/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                .background(Color(red: 34 / 255.0, green: 118 / 255.0, blue: 238 / 255.0))
                .padding(50)
                    Button(action: {
                        UserDefaults.standard.removeObject(forKey: "UserName")
                        UserDefaults.standard.removeObject(forKey: "SessionToken")
                        UserDefaults.standard.removeObject(forKey: "objectId")
                        self.home.setLoginFlag(flag: false)
                    }) {
                        Text("注销登录")
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 320, height: 44)
                    .border(/*@START_MENU_TOKEN@*/Color.green/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .background(Color(red: 34 / 255.0, green: 118 / 255.0, blue: 238 / 255.0))
        }.navigationBarTitle("关于")
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}
