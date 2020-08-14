//
//  RegisterView.swift
//  Notepad
//
//  Created by snow on 2020/6/13.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showErrorAlert = false
    @State private var showAlert = false
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 100)
            
            Text("欢迎注册")
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
                    self.RegisterUser()
                }){
                    Text("注册")
                        .foregroundColor(Color.white)
                    }.disabled(username == "" || password == "")
                .frame(width: 120, height: 44)
                    .background(username == "" || password == "" ? Color.gray : Color.blue)
            }
            .padding(.vertical, 10)
            Spacer()
            .alert(isPresented: $showAlert) { () -> Alert in
                if showErrorAlert { //用户民已存在
                    return Alert(title: Text("出错了"), message: Text("用户名已存在"), dismissButton: .default(Text("确定"), action: {
                        self.username = ""
                        self.password = ""
                    }))
                } else {
                    return Alert(title: Text("用户注册"), message: Text("注册成功"), primaryButton: Alert.Button.cancel(Text("取消")), secondaryButton: .default(Text("去登录"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }))
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 232 / 255, green: 74 / 255, blue: 243 / 255), Color(red: 182 / 255, green: 237 / 255, blue: 183 / 255)]),
                    startPoint:UnitPoint(x: 0.5, y: 0),
                    endPoint:UnitPoint(x: 0.5, y: 1))
            .edgesIgnoringSafeArea(.all))
    }
    //注册用户
    func RegisterUser() {
        let user: User = User(username: self.username, password: self.password)
        let encoder = JSONEncoder()
        guard let httpBody = try? encoder.encode(user) else {
            dump("压缩错误")
            return
        }
        let url = URL(string: "https://api2.bmob.cn/1/users")!
        
        var request = URLRequest(url: url)
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if (try? JSONDecoder().decode(RegistResult.self, from: data)) != nil{
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.showErrorAlert = false
                    }
                    return
                } else {
                    self.showAlert = true
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
