//
//  BusStationListView.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/10.
//

import SwiftUI
import UIKit
import CryptoKit
import SwiftUIPullToRefresh
import RefreshableList
import Foundation

struct BusStationListView: View {
    var routeUID: String
    var routeID: String
    @State private var stopUID: String = ""
    @State private var busTime = [BusTime]()
    @State private var selectDirection = NSLocalizedString("去程", comment: "")
    @State var showRefreshView = false
    var direction = [NSLocalizedString("去程", comment: ""), NSLocalizedString("返程", comment: "")]
    @State var routeName: RouteName
    @State private var isRefreshing = false
    func GetTimeArrivedata(routeUID: String, busDirection: String){
        
        let urlTime = "https://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/Keelung?$filter=RouteUID eq \'" + routeUID + "\' and Direction eq " + busDirection + "&$orderby= StopSequence asc&$top=100&$format=JSON"
        let rulTemp = urlTime.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlTimeQuery = URL(string: rulTemp)!
        var requestTime = URLRequest(url: urlTimeQuery)
        
        requestTime.setValue(xdate, forHTTPHeaderField: "x-date")
        requestTime.setValue(xdate, forHTTPHeaderField: "")
        requestTime.setValue(authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: requestTime) { (data, response, error) in
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let data = data {
                do {
                    let searchResponse = try decoder.decode([BusTime].self, from: data)
                    self.busTime = searchResponse
                    print(busTime)
                } catch {
                    print("error")
                }
            }
        }.resume()
    }
    
    
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: self.$selectDirection, label: Text("請選擇旅程方向：")) {
                    ForEach(self.direction, id: \.self) {
                        (text) in Text(text)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
            }
            if selectDirection == NSLocalizedString("去程", comment: ""){
                
                VStack {
                    List{
                        ForEach(self.busTime.indices, id: \.self) { (index)  in
                            BusTimeRow(bus: self.busTime[index])
                                .onLongPressGesture(minimumDuration: 2){
                                    self.stopUID = self.busTime[index].StopUID
                                }
                        }
                    }
                }
                .onAppear {
                    //self.bus.removeAll()
                    self.GetTimeArrivedata(routeUID: self.routeUID, busDirection: "0")
                }
                .onPullToRefresh(isRefreshing: $isRefreshing, perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isRefreshing = false
                        self.GetTimeArrivedata(routeUID: self.routeUID, busDirection: "0")
                    }
                })
            } else {
                VStack {
                    List{
                        ForEach(self.busTime.indices, id: \.self) { (index)  in
                            BusTimeRow(bus: self.busTime[index])
                                .onLongPressGesture(minimumDuration: 2){
                                    self.stopUID = self.busTime[index].StopUID
                                }
                        }
                    }
                }
                .onAppear {
                    //self.bus.removeAll()
                    self.GetTimeArrivedata(routeUID: self.routeUID, busDirection: "1")
                }
                .onPullToRefresh(isRefreshing: $isRefreshing, perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isRefreshing = false
                        self.GetTimeArrivedata(routeUID: self.routeUID, busDirection: "1")
                    }
                })
            }
            
        }
        
    }
}


struct BusStationListView_Previews: PreviewProvider {
    static var previews: some View {
        BusStationListView(routeUID: "KEE1031", routeID: "1031", routeName: RouteName(Zh_tw: "中正路", En: "Chung Chen Road"))
    }
}
