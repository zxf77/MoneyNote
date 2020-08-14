//
//  AccountListView.swift
//  Notepad
//
//  Created by snow on 2020/6/10.
//  Copyright © 2020 snow. All rights reserved.
//

import SwiftUI

struct AccountListView: View {
    @ObservedObject var account: AccountInfo = AccountInfo()
    var demotype = "收入"
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(self.account.account, id: \.objectId) { item in
                VStack {
                    if item.sortIndex == 0 || self.account.account[item.sortIndex].accountDay != self.account.account[item.sortIndex - 1].accountDay {
                        VStack {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(item.accountMonth)-\(item.accountDay)")
                                Spacer()
                            }.padding(.horizontal)
                            Text("————————————————————————")
                        }.foregroundColor(Color.gray)
                        
                    }
                    NavigationLink(destination: ShowAccountView(account: item)) {
                        HStack {
                            Image("\(item.accountName)")
                            Text("\(item.accountName)")
                            Spacer()
                            Text(item.type == self.demotype ? "" : "-")
                            Text(String(format: "%.1f", item.accountMoney))
                        }.padding(.horizontal)
                    }.buttonStyle(PlainButtonStyle())
                }
                
            }
        }
    }
}

