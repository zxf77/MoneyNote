//
//  AddAcountView.swift
//  Notepad
//
//  Created by snow on 2020/6/10.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct AddAcountView: View {
    let types = ["支出", "收入"]
    let incomeTypes = ["工资", "兼职", "理财", "礼金", "其他"]
    let expendTypes = ["餐饮", "购物", "交通", "日用", "运动", "娱乐", "通讯", "服饰", "医疗", "旅行", "学习", "礼物", "办公", "宠物", "其他"]
    @State var typesIndex = 0
    @State var name = 0
    @State private var money = ""
    @State private var note = ""
    @State private var time = Date()
    @State var yearNow = 0
    @State var monthNow = 0
    @State var dayNow = 0
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form {
            Picker("Tip percentage", selection: $typesIndex) {
                ForEach(0 ..< types.count, id: \.self) {
                    Text("\(self.types[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Picker("\(self.typesIndex == 0 ? "支出" : "收入")原因", selection: $name) {
                ForEach(typesIndex == 0 ? 0 ..< expendTypes.count : 0 ..< incomeTypes.count, id: \.self) {
                    Text("\(self.typesIndex == 0 ? self.expendTypes[$0] : self.incomeTypes[$0])")
                }
            }
            TextField("金额", text: $money)
                .keyboardType(.decimalPad)
            TextField("备注", text: $note)
            DatePicker("", selection: $time, displayedComponents: .date).labelsHidden()
        }.navigationBarTitle("增加账目")
            .navigationBarItems(trailing: Button("完成") {
                self.AddAccount()
                self.presentationMode.wrappedValue.dismiss()
            }.disabled(money == ""))
    }
    func timeNow () {
        let components = Calendar.current.dateComponents([.year, .month], from: time)
        let componentss = Calendar.current.dateComponents([.day], from: time)
        self.yearNow = components.year ?? 0
        self.monthNow = components.month ?? 0
        self.dayNow = componentss.day ?? 0
    }
    func AddAccount() {
        self.timeNow()
        let month = "\(self.yearNow)-\(self.monthNow)"
        let username = UserDefaults.standard.string(forKey: "UserName")!
        let account: AccountAdd = AccountAdd(accountUser: username, accountName: self.typesIndex == 0 ? self.expendTypes[name] : self.incomeTypes[name], accountMoney: Double(self.money) ?? 0.0, accountDay: self.dayNow, accountMonth: month, accountNote: self.note, type: self.types[self.typesIndex])
        let encoder = JSONEncoder()
        guard let httpBody = try? encoder.encode(account) else {
            print("can't encode")
            return
        }
        let url = URL(string: "https://api2.bmob.cn/1/classes/accounts")!
        
        var request = URLRequest(url: url)
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request).resume()
    }
}

struct AddAcountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAcountView()
    }
}
