//
//  LoginView.swift
//  Notepad
//
//  Created by snow on 2020/6/13.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert = false
    @State private var showNullError = false
    @State var showLogin = true
    @ObservedObject var home = Home.home
    
    var body: some View {
        ZStack {
            if showLogin {
               NavigationView {
               VStack{
                   Spacer()
                       .frame(height: 100)
                   
                   Text("欢迎使用")
                       .bold()
                       .font(.largeTitle)
                       .foregroundColor(.white)
                   Spacer()
                       .frame(height: 30)
                   
                   HStack{
                       Image(systemName: "person.fill")
                           .foregroundColor(.white)
                       CustomTextField(placeholder: "账号", text: $username)
                   }
                   .padding(.horizontal, 60)
                   .padding(.vertical, 20)
                   .overlay(RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.white)
                   .padding(.horizontal, 40)
                   .padding(.vertical, 10))
                   HStack{
                       Image(systemName: "lock.fill")
                           .foregroundColor(.white)
                       CustomSecureField(placeholder: "密码", text: $password)
                   }
                   .padding(.horizontal, 60)
                   .padding(.vertical, 20)
                   .overlay(RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.white)
                   .padding(.horizontal, 40)
                   .padding(.vertical, 10))
                   HStack {
                       Button(action: {
                           self.username == "" || self.password == "" ? self.showNullError = true : self.Login()
                       }){
                           Text("登陆")
                               .foregroundColor(Color.white)
                       }
                           .frame(width: 120, height: 44)
                           .background(username == "" || password == "" ? Color.gray : Color(red: 34 / 255.0, green: 118 / 255.0, blue: 238 / 255.0))
                       Spacer()
                       NavigationLink("注册", destination: RegisterView())
                           .foregroundColor(Color.white)
                           .frame(width: 120, height: 44)
                           .background(Color.gray)
                   }
                   .padding(.vertical, 10)
                   .padding(.horizontal, 60)
                   Spacer()
                   .alert(isPresented: $showNullError) { () -> Alert in
                       return Alert(title: Text("出错了"), message: Text("请输入正确的用户民和密码"), dismissButton: .default(Text("确定"), action: {
                       }))
                   }
                .alert(isPresented: $showErrorAlert) { () -> Alert in
                    return Alert(title: Text("出错了"), message: Text("用户名或密码输入错误"), dismissButton: .default(Text("确定"), action: {
                    }))
                }
               }
               .frame(height: UIScreen.main.bounds.height)
               .background(
                   LinearGradient(gradient: Gradient(colors: [Color(red: 232 / 255, green: 74 / 255, blue: 243 / 255), Color(red: 182 / 255, green: 237 / 255, blue: 183 / 255)]),
                                  startPoint:UnitPoint(x: 0.5, y: 0),
                                  endPoint:UnitPoint(x: 0.5, y: 1))
                       .edgesIgnoringSafeArea(.all))
                }
            } else {
                FirstView()
            }
        }.onAppear(perform: self.checkTimeOut)
    }
    //登录
    func Login() {
        
        let url = URL(string: "https://api2.bmob.cn/1/login?username=\(self.username)&password=\(self.password)")!
        
        var request = URLRequest(url: url)
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let decodeResponse = try? JSONDecoder().decode(LoginResult.self, from: data){
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(decodeResponse.sessionToken, forKey: "SessionToken")
                        UserDefaults.standard.set(decodeResponse.username, forKey: "UserName")
                        UserDefaults.standard.set(decodeResponse.objectId, forKey: "objectId")
                        self.showLogin = false
                        self.home.setLoginFlag(flag: true)
                    }
                    return
                }
                self.showErrorAlert = true
            }
        }.resume()
    }
    //检查是否登录过期
    func checkTimeOut() {
        if UserDefaults.standard.string(forKey: "UserName") == nil {
            return
        }
        let objectID = UserDefaults.standard.string(forKey: "objectId")!
        let sessionToken = UserDefaults.standard.string(forKey: "SessionToken")!
        let url = URL(string: "https://api2.bmob.cn/1/checkSession/\(objectID)")!
        var request = URLRequest(url: url)
        request.addValue("a64e097f890e4ea79594ed0e381bb335", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("fc0c4352b29eb4a6ff09fb0751878102", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.addValue(sessionToken, forHTTPHeaderField: "X-Bmob-Session-Token")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let decodeResponse = try? JSONDecoder().decode(PasswordResult.self, from: data) {
                    DispatchQueue.main.async {
                        if decodeResponse.msg == "ok" {
                            self.showLogin = false
                        }
                    }
                    return
                }
            }
        }.resume()
    }
}

struct LonginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                Text(placeholder)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0.5))
            }
            TextField("", text: $text)
                .foregroundColor(.white)
                .accentColor(.purple)
            
            
        }
        .font(.system(size: 20))
        .frame(height: 30)
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                Text(placeholder)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0.5))
            }
            SecureField("", text: $text)
                .foregroundColor(.white)
                .accentColor(.purple)
        }
        .font(.system(size: 20))
        .frame(height: 30)
    }
}
