//
//  BusTimeRow.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/11.
//

import SwiftUI

struct BusTimeRow: View {
    var bus:BusTime
    var body: some View {
        HStack {
                if bus.EstimateTime != nil{
                    Text(bus.StopName.Zh_tw)
                    Spacer()
                    if bus.EstimateTime!/60 < 3{
                        Text("即將進站")
                            .foregroundColor(.red)
                    } else{
                        Text("\(bus.EstimateTime!/60) 分鐘")
                    }
                } else {
                    Text(bus.StopName.Zh_tw)
                    Spacer()
                    Text("未發車")
                }
           
        }
                .padding()
        
    }
}

