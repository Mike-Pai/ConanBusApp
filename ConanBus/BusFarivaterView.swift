//
//  BusFarivaterView.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/12.
//

import SwiftUI

struct BusFarivaterView: View {
    init(){
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
            //若不要row分隔线的话：
            //UITableView.appearance().separatorStyle = .none
    }
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BusFaveriate.routeUID, ascending: true)],
        animation: .default)
    private var busfaveruate: FetchedResults<BusFaveriate>
    @State private var isRefreshing = false
    @State private var array: [String] = []
    var body: some View {
        NavigationView{
            List{
                ForEach(busfaveruate,id:\.self) {busfaveruate in
                        NavigationLink(destination: BusStationListView(routeUID: busfaveruate.routeUID ?? "KEE101", routeID: busfaveruate.routeID ?? "", routeName: RouteName(Zh_tw: "中正路", En: "Chung Chen Road"))){
                            Text(busfaveruate.routeName ?? "")
                        }
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(
                    Color.orange
                )
               
                
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                }
            }
            .background(
                Image("學校")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                
            )
            
//            .navigationBarTitleDisplayMode(.inline)
            //        .onPullToRefresh(isRefreshing: $isRefreshing, perform: {
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //                self.isRefreshing = false
//                self.array.insert(busfaveruate[0].routeName ?? "", at: 0)
//                }
//               
//            }
//        )
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

struct BusFarivaterView_Previews: PreviewProvider {
    static var previews: some View {
        BusFarivaterView()
    }
}
