//
//  FirstView.swift
//  Notepad
//
//  Created by snow on 2020/6/8.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct FirstView: View {
    @ObservedObject var account: AccountInfo = AccountInfo()
    @State private var income = 0.0
    @State private var expense = 0.0
    @State private var time = Date()
    @State var yearNow = 0
    @State var monthNow = 0
    @State private var showDatePicker = false
    let demotype = "收入"
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Button (action: {
                        self.showDatePicker = true
                    }) {
                        VStack {
                            Text("\(yearNow)年")
                                .foregroundColor(.gray)
                            HStack {
                                Text("\(monthNow)月")
                                    .font(Font.system(size: 25))
                                Image(systemName: "arrowtriangle.down.fill")
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 40)
                    VStack {
                        Text("收入")
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f", income))
                            .font(Font.system(size: 25))
                    }
                    Spacer()
                        .frame(width: 50)
                    VStack {
                        Text("支出")
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f", expense))
                            .font(Font.system(size: 25))
                    }
                    Spacer()
                }.padding()
                    .background(Color.yellow)
                    .blur(radius: showDatePicker ? 10 : 0)
                    .disabled(showDatePicker)
                if self.showDatePicker {
                    DatePicker("", selection: $time, displayedComponents: .date).labelsHidden()
                        .padding()
                    HStack {
                        Button(action: {
                            self.showDatePicker = false
                            self.onLoad()
                        }) {
                            Text("确定")
                        }
                        Button(action: {
                            self.showDatePicker = false
                        }) {
                            Text("取消")
                        }
                    }.padding()
                }
                AccountListView(account: self.account)
                .blur(radius: showDatePicker ? 10 : 0)
                    .disabled(showDatePicker)
                Spacer()
           }.onAppear(perform: self.onLoad)
           .navigationBarTitle(showDatePicker ? "选择日期" : "记账本", displayMode: .inline)
            .navigationBarItems(leading: NavigationLink("我的", destination: AboutMeView()).blur(radius: showDatePicker ? 10 : 0), trailing: NavigationLink("添加", destination: AddAcountView()).blur(radius: showDatePicker ? 10 : 0))
        }
    }
    func timeNow(){
        let components = Calendar.current.dateComponents([.year, .month], from: time)
        self.yearNow = components.year ?? 0
        self.monthNow = components.month ?? 0
    }
    //查询数据库中的数据
    func onLoad() {
        self.timeNow()
        let username = UserDefaults.standard.string(forKey: "UserName")
        let month = "\(self.yearNow)-\(self.monthNow)"
        let urltest = "https://api2.bmob.cn/1/classes/accounts?where={\"$and\":[{\"accountUser\":\"\(username ?? "")\"},{\"accountMonth\":\"\(month)\"}]}"
        let urlreally = urltest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlreally)!
        
        var request = URLRequest(url: url)
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-Application-Id")
        request.addValue("test_test", forHTTPHeaderField: "X-Bmob-REST-API-Key")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let decodeResponse = try? JSONDecoder().decode(AccountInfo.self, from: data){
                    DispatchQueue.main.async {
                        
                        //将数据按照日期升序
                        decodeResponse.account.sort(by: {$0.accountDay > $1.accountDay})
                        self.account.account = decodeResponse.account
                        //排序后依次给每条账目的sortIndex赋值Int类型，归类用
                        for index in 0 ..< self.account.account.count {
                            self.account.account[index].sortIndex = index
                        }
                        var incomeMoney = 0.0
                        var expendsMonye = 0.0
                        self.account.account.forEach { (item) in
                            if item.type == self.demotype {
                                incomeMoney += item.accountMoney
                            } else {
                                expendsMonye += item.accountMoney
                            }
                        }
                        self.income = incomeMoney
                        self.expense = expendsMonye
                    }
                    return
                } else {
                    dump("出错了")
                }
            }
        }.resume()
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
