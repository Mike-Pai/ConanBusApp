//
//  MainTabView.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/12.
//

import SwiftUI

struct MainTabView: View {
    init(){
            UITableView.appearance().backgroundColor = .clear
            //若不要row分隔线的话：
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        TabView{
            MainPageView()
                .tabItem {
                    Image(systemName: "bus")
                    Text("公車查詢")
                 }
               
            BusFarivaterView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("我的最愛")
                }
            SwiftUIView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("頭像選擇")
                }
        }
       
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
