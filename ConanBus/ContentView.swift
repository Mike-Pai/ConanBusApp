//
//  ContentView.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/4.
//

import SwiftUI
import CoreData
import CryptoKit



struct ContentView: View {
    
    @State private var query = ""
    
    var filteredBus: [BusPost] {
             BusRoute.filter { query.isEmpty ? true : $0.RouteUID.lowercased().contains(query.lowercased()) }
        }
    
        
     func Getdata(){
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(xdate, forHTTPHeaderField: "")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let decoder = JSONDecoder()
            
            if let data = data {
                do {
                    let searchResponse = try decoder.decode([BusPost].self, from: data)
                        BusRoute = searchResponse
                    print(BusRoute)
                } catch {
                    print("error")
                }
            }
        }.resume()
    }
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BusFaveriate.id, ascending: true)],
        animation: .default)
    private var busfaveruate: FetchedResults<BusFaveriate>
    @State private var BusRoute = [BusPost]()
    @State private var GetDataTime = true
    var body: some View {
        
        VStack{
            SearchBar(text: $query, placeholder: NSLocalizedString("busSelect", comment: ""))
            
            List {
                ForEach(filteredBus,id:\.RouteID){(bus) in
                    HStack{
                        NavigationLink(destination: BusStationListView(routeUID: bus.RouteUID, routeID: bus.RouteID, routeName: bus.RouteName)){
                                                   Text(bus.RouteName.Zh_tw)
                                               }
                        Spacer()
                        Label("加到最愛", systemImage: "heart.circle")
                            .onTapGesture {
                                let busfarivate = BusFaveriate(context: viewContext)
                                busfarivate.routeID = bus.RouteID
                                busfarivate.routeUID = bus.RouteUID
                                busfarivate.routeName = bus.RouteName.Zh_tw
                                addItem()
                            }
                   
                    }
                    
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
               
                
                
            }
          
            .onAppear(){
                if GetDataTime {
                    Getdata()
                    GetDataTime = false
                }
               
            }
            
           
        }
       
       
    }
    
    private func addItem() {
        withAnimation {
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { busfaveruate[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
