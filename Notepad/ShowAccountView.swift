//
//  ShowAccountView.swift
//  Notepad
//
//  Created by snow on 2020/6/12.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct ShowAccountView: View {
    @State var account: Account = Account()
    @State private var showAlert = false
    @State private var showError = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        List {
            HStack {
                Text("类型 ")
                    .foregroundColor(Color.gray)
                Text(account.type)
            }
            HStack {
                Text("金额 ")
                    .foregroundColor(Color.gray)
                Text(String(format: "%.1f", account.accountMoney))
            }
            HStack {
                Text("日期 ")
                    .foregroundColor(Color.gray)
                Text("\(account.accountMonth)-\(account.accountDay)")
            }
            HStack {
                Text("备注 ")
                    .foregroundColor(Color.gray)
                Text(account.accountNote)
            }
        }.listStyle(GroupedListStyle())
            .navigationBarTitle("\(account.accountName)")
            .navigationBarItems(trailing: Button(action: {self.showAlert = true}) {Image(systemName: "trash")})
            .alert(isPresented: $showAlert) { () -> Alert in
                if showError {
                    return Alert(title: Text("出错了"), message: Text("发生了未知错我"), dismissButton: .default(Text("确定")))
                } else {
                    return Alert(title: Text("警告"), message: Text("删除后将无法恢复，确认删除？"), primaryButton: Alert.Button.cancel(Text("取消")), secondaryButton: Alert.Button.default(Text("确定"), action: {
                        self.deleteAccount()
                    }))
                }
        }
    }
    //删除数据库中此条记录
    func deleteAccount() {
        let objectId = self.account.objectId
        let url = URL(string: "https://api2.bmob.cn/1/classes/accounts/\(objectId)")!
        var request = URLRequest(url: url)
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let decodeResponse = try? JSONDecoder().decode(PasswordResult.self, from: data){
                    DispatchQueue.main.async {
                        if decodeResponse.msg == "ok" {
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.showAlert = true
                            self.showError = true
                        }
                        
                    }
                    return
                }
                self.showAlert = true
                self.showError = true
            }
        }.resume()
    }
}

struct ShowAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAccountView()
    }
}
