//
//  MainPageView.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/8.
//




import SwiftUI
import CryptoKit
let City =
    [ "基隆市",
      "台北市",
      "新北市"
    ]

let Weatherurl = URL(string: "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-54AA468C-A4C0-4A75-843C-0CDE8629933D&format=JSON")!


struct Weather : Codable {
    var records:records
}
struct records : Codable {
    var location:[location]
}
struct location : Codable{
    var locationName: String
    var weatherElement: [weatherElement]
}
struct weatherElement: Codable{
    var time:[time]
}
struct time :Codable{
    var parameter: parameter
}
struct parameter: Codable{
    var parameterName: String
}



struct MainPageView: View {
    
    @State private var Cityselect = 0
    func GetWeatherdata(){
        URLSession.shared.dataTask(with: Weatherurl) { (data,response , error) in
            let decoder = JSONDecoder()
            
            if let data = data {
                do {
                    let searchResponse = try decoder.decode(Weather.self, from: data)
                    for Index in searchResponse.records.location.indices {
                        self.WeatherCity.append(searchResponse.records.location[Index].locationName)
                        self.WeatherCondition.append(searchResponse.records.location[Index].weatherElement[3].time[0].parameter.parameterName)
                        self.tempetureMin.append(searchResponse.records.location[Index].weatherElement[2].time[0].parameter.parameterName)
                        self.tempetureMax.append(searchResponse.records.location[Index].weatherElement[4].time[0].parameter.parameterName)
                        self.WeatherFeel.append(searchResponse.records.location[Index].weatherElement[0].time[0].parameter.parameterName)
                        self.RainRate.append(searchResponse.records.location[Index].weatherElement[1].time[0].parameter.parameterName)
                        
                    }
                    
                    
                    print(RainRate)
                } catch {
                    print("error")
                }
            } else {
                print("error")
            }
        }.resume()
    }
    
    @State private var WeatherCity:[String] = []
    @State private var WeatherFeel:[String] = []
    @State private var tempetureMin:[String] = []
    @State private var RainRate:[String] = []
    @State private var tempetureMax:[String] = []
    @State private var WeatherCondition:[String] = []
    @State private var GetDataTime = true
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    VStack{
                        if WeatherCity.isEmpty {
                            Text("請選擇城市")
                        } else {
                            Text(WeatherCity[Cityselect]+tempetureMin[Cityselect]+"°C")
                        }
                        
                        Picker("更換城市", selection: $Cityselect){
                            ForEach(WeatherCity.indices, id: \.self){ (cityIndex) in
                                Text("\(WeatherCity[cityIndex])")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        
                    }
                    VStack{
                        if WeatherCondition.isEmpty || WeatherFeel.isEmpty || RainRate.isEmpty || tempetureMin.isEmpty {
                            Label("陰雨綿綿．．．", systemImage: "cloud.fill" )
                            Divider()
                            Label("體感．．．", systemImage: "figure.stand" )
                            Label("降雨機率．．．", systemImage: "cloud.heavyrain" )
                            Label("溫度的範圍．．．", systemImage: "thermometer" )
                        }else{
                            Label("\(WeatherFeel[Cityselect])", systemImage: "cloud.fill" )
                            Divider()
                            Label("\(WeatherCondition[Cityselect])", systemImage: "figure.stand" )
                            Label("\(RainRate[Cityselect])%", systemImage: "cloud.heavyrain" )
                            Label("\(tempetureMin[Cityselect])°C~\(tempetureMax[Cityselect])°C", systemImage: "thermometer" )
                        }
                    }
                    Spacer()
                }
                ContentView()
                   
                
            }
            .navigationTitle("偵探等公車！")
            .background(
                Image("學校")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.8)
                    .edgesIgnoringSafeArea(.all)

            )
        }
        .onAppear(){
            if GetDataTime {
                GetWeatherdata()
                GetDataTime = false
            }
        }
        
        
        
    }
    
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
