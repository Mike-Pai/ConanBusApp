//
//  BusData.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/6.
//

import Foundation
import CryptoKit 

func getTimeString() -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
    dateFormater.locale = Locale(identifier: "en_US")
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    let time = dateFormater.string(from: Date())
    return time
}

let appId = "98a71c951dd841f188e49fbf2e46a27d"
let appKey = "iKEEhYqKciGt6Su8WcdI8n5Xu30"
let xdate = getTimeString()
let signDate = "x-date: \(xdate)"
let key = SymmetricKey(data: Data(appKey.utf8))
let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
let base64HmacString = Data(hmac).base64EncodedString()
let authorization = """
hmac username="\(appId)", algorithm="hmac-sha256", headers="x-date", signature="\(base64HmacString)"
"""
let url = URL(string: "https://ptx.transportdata.tw/MOTC/v2/Bus/StopOfRoute/City/Keelung?$filter=Direction%20eq%200&$top=100&$format=JSON")!


var request = URLRequest(url: url)

struct BusPost: Codable {
    var RouteUID :String
    var RouteID : String
    var RouteName:RouteName
    var Direction : Int
    var Stops : [Stop]
}
struct RouteName: Codable{
    var Zh_tw: String
    var En: String
}
struct Stop: Codable {
    var StopID:String
    var StopName:StopName
    var StopBoarding: Int
}

struct StopName : Codable {
    var Zh_tw: String
    var En: String
}

struct BusTime: Codable{
    let StopUID, StopID: String
    let StopName: StopName
    let RouteUID: String
    let RouteID: String
    let RouteName: StopName
    let StopSequence: Int?
    let Direction, StopStatus: Int
    let SrcUpdateTime, UpdateTime: Date
    let EstimateTime: Int?
}

