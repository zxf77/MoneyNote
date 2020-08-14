//
//  EditPasswordView.swift
//  Notepad
//
//  Created by snow on 2020/6/17.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct EditPasswordView: View {
    @State private var password = ""
    @State private var newPassword = ""
    @State private var newPasswordTwo = ""
    @State private var showNewPassword = false
    @State private var showOldPassword = true
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            if showOldPassword {
                Text("请输入旧密码")
                    .font(.title)
                SecureField("旧密码", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    self.checkOldPassword()
                }) {
                    Text("确定")
                        .foregroundColor(Color.white)
                }.disabled(password == "")
                    .frame(width: 120, height: 44)
                    .background(password == "" ? Color.gray : Color.blue)
            }
            if showNewPassword {
                Text("请输入新密码")
                    .font(.title)
                SecureField("新密码", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                SecureField("确认新密码", text: $newPasswordTwo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    self.revisePassword()
                }) {
                    Text("确定")
                        .foregroundColor(Color.white)
                }.disabled(newPassword == "" || newPasswordTwo == "")
                    .frame(width: 120, height: 44)
                    .background(newPassword == "" || newPasswordTwo == "" ? Color.gray : Color.blue)
            }
            
            Spacer()
            
        }
            
        .alert(isPresented: $showAlert) { () -> Alert in
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("确定"), action: {
                if self.showSuccessAlert {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }))
        }
            
        .navigationBarTitle("修改密码")
        
    }
    //检查密码是否正确
    func checkOldPassword() {
        let username = UserDefaults.standard.string(forKey: "UserName")!
        let url = URL(string: "https://api2.bmob.cn/1/login?username=\(username)&password=\(self.password)")!
        
        var request = URLRequest(url: url)
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if (try? JSONDecoder().decode(LoginResult.self, from: data)) != nil{
                    DispatchQueue.main.async {
                        self.showNewPassword = true
                        self.showOldPassword = false
                    }
                    return
                }
                self.showAlert = true
                self.alertTitle = "出错了"
                self.alertMessage = "密码错误请重新输入"
                self.password = ""
            }
        }.resume()
    }
    //更改密码
    func revisePassword() {
        if newPassword != newPasswordTwo {
            self.showAlert = true
            self.alertTitle = "出错了"
            self.alertMessage = "两次输入的密码不一致"
            self.newPassword = ""
            self.newPasswordTwo = ""
            return
        }
        if newPassword == password {
            self.showAlert = true
            self.alertTitle = "出错了"
            self.alertMessage = "新密码与旧密码相同"
            self.newPassword = ""
            self.newPasswordTwo = ""
            return
        }
        let body = Password(oldPassword: self.password, newPassword: self.newPassword)
        let encoder = JSONEncoder()
        guard let httpBody = try? encoder.encode(body) else {
            dump("压缩错误")
            return
        }
        let objectId = UserDefaults.standard.string(forKey: "objectId")!
        let url = URL(string: "https://api2.bmob.cn/1/updateUserPassword/\(objectId)")!
        
        var request = URLRequest(url: url)
        request.addValue("a64e097f890e4ea79594ed0e381bb335", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("fc0c4352b29eb4a6ff09fb0751878102", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        request.httpMethod = "PUT"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if (try? JSONDecoder().decode(PasswordResult.self, from: data)) != nil{
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertTitle = "成功"
                        self.alertMessage = "修改密码成功"
                        self.showSuccessAlert = true
                    }
                    return
                }
                self.showAlert = true
                self.alertTitle = "出错了"
                self.alertMessage = "发生了未知错误，请重试"
                self.newPassword = ""
                self.newPasswordTwo = ""
            }
        }.resume()
    }
}


struct EditPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EditPasswordView()
    }
}
