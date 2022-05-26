//
//  ContentView.swift
//  EloTrack
//
//  Created by Hellman Zhao on 5/15/22.
//

import SwiftUI

struct StandingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var isNavigationBarHidden: Bool = true
    @State var showSheet=false
    
    @State private var playerList: [Player] = [Player]()

    let group: Group

    var body: some View {
            
            VStack {
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                            .frame(width: 30.0, height: 30.0)
                    }
                    .padding(.top, 30.0)
                    .padding(.leading, 15.0)
                    
                    Text("STANDINGS")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.top, 30.0)
                        .padding(.leading, 10.0)

                    Spacer()
                    
                    Button {
                        playerList=[Player]()
                        for i in 0..<group.playerArray.count{
                            playerList.append(group.playerArray[i])
                        }
                        if group.rankByWins==0{
                            playerList.sort {$0.wins!.intValue > $1.wins!.intValue }
                        }
                        else{
                            playerList.sort {$0.points!.intValue > $1.points!.intValue }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                            .frame(width: 25.0, height: 25.0)
                    }
                    .padding(.top, 26.0)
                    .padding(.leading, 80.0)
                    
                    Spacer()
                    
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                            .frame(width: 20.0, height: 20.0)
                    }
                    .sheet(isPresented: $showSheet) {
                        ConfigurationView(group: group, playerList: $playerList)
                    }
                    .padding(.top, 30.0)
                    .padding(.trailing, 30)
                }
                
                List {
                  Section {
                      ForEach(0..<playerList.count, id: \.self) { index in
                          NavigationLink(
                            destination: PlayerStatsView(player: playerList[index], group: group)) {
                                Label {
                                    Text(playerList[index].playerName ?? "")
                                } icon: {
                                    Image(systemName: "\(index+1).circle.fill")
                                        .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                                }
                            }
                    }
                  } header: {
                    Text("Players Ranked")
                  }
                }
                
            }
            .navigationBarTitle("Hidden Title")
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = true
                
                playerList=[Player]()
                for i in 0..<group.playerArray.count{
                    playerList.append(group.playerArray[i])
                }
                if group.rankByWins==0{
                    playerList.sort {$0.wins!.intValue > $1.wins!.intValue }
                }
                else{
                    playerList.sort {$0.points!.intValue > $1.points!.intValue }
                }
            }

    }
    
}

struct HomeView: View {
    
    @State private var groups: [Group] = [Group]()
    @State private var initial_message="No Groups Yet"
    @State private var showSheet=false
    @State var isNavigationBarHidden: Bool = true
    
    @available(iOS 15.0, *)
    @available(iOS 15.0, *)
    @available(iOS 15.0, *)
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                HStack {
                    Text("GROUPS")
                        .font(.system(size: 35))
                        .fontWeight(.heavy)
                        .padding(.top, 30.0)
                        .padding(.leading, 25.0)

                    Spacer()
                }
                
                ZStack {
                    List{
                        ForEach(groups,id:\.self){ group in
                            Text(group.groupName ?? "")
                                .background( NavigationLink("", destination: StandingsView(group: group)).opacity(0) )
                                .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach{ index in
                                let group=groups[index]
                                PersistenceController.shared.deleteGroup(group: group)
                                groups=PersistenceController.shared.getallGroups()
                            }
                        })
                    }
//                    .padding(.trailing)
                    .navigationTitle("Hidden Navigation Bar")
                    .navigationBarHidden(self.isNavigationBarHidden)
                    .listStyle(.inset)
                    
                    if(groups.count == 0){
                        Text(initial_message)
                            .font(.footnote)
                            .italic()
                    }
                }
                .onAppear(perform: {
                    self.isNavigationBarHidden = true
                    groups=PersistenceController.shared.getallGroups()
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                    AppDelegate.orientationLock = .portrait // And making sure it stays that way
                })
                
                HStack {
                    Spacer()
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                            .padding(.trailing, 25.0)
                            .frame(width: 75.0, height: 75.0)
                    }
                    .padding(.trailing)
                    .fullScreenCover(isPresented: $showSheet) {
                        CreateGroupView(groups: $groups)
                    }
                }

            }
            
            
        }
    }
}
                        
struct CreateGroupView: View {
    
    @Binding var groups: [Group]
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    //Group fields
    @State var groupName=""
    @State var numPlayers=2
    @State var playerNames=["","","","","","","","","","",
                            "","","","","","","","","","",
                            "","","","","","","","","","",
                            "","","","","","","","","","",
                            "","","","","","","","","",""]
    @State var players:[Player]=[]
        
    var body: some View {
        
            VStack {
                
                HStack {
                    Text("CREATE GROUP")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.top, 30.0)
                        .padding(.leading, 25.0)

                    Spacer()
                }
                
                Form{
                    Section{
                        TextField("Tennis Club", text: $groupName)
                    }
                    Section(header:Text("Number of Players"),footer:Text("You need at least 2 players").italic()){
                        TextField("Number of Players", value: $numPlayers, format: .number)
                    }
                    Section(header:Text("Player Names"),footer:Text("No 2 players should be named exactly the same").italic()){
                        ForEach(1..<numPlayers+1, id: \.self) { index in
                            TextField("Player "+String(index)+" Name", text: $playerNames[index-1])
                        }
                    }
                }
                .accentColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .padding(.leading, 25.0)
                            .frame(width: 70.0, height: 70.0)
                    }
                    .padding(.leading)
                    Spacer()
                    Button {
                        var count=0
                        for i in 0..<numPlayers{ //checks if filled out textfields match number of players
                            if !playerNames[i].isEmpty{
                                count+=1
                            }
                        }
                        if(!groupName.isEmpty && numPlayers>=2 && count==numPlayers){
                            for i in 0..<playerNames.count {
                                if (playerNames[i] != "") { //create Player entities for non empty string names
                                    let player=Player(context: moc)
                                    player.playerName=playerNames[i]
                                    player.wins=(Int16(0)) as NSNumber //change i to 0
                                    player.losses=(Int16(0)) as NSNumber
                                    player.ties=(Int16(0)) as NSNumber
                                    player.points=(Int16(15)) as NSNumber //change i to 15
                                    player.id=(Int16(i+1)) as NSNumber
                                    players.append(player)
                                }
                            }
                            
                            PersistenceController.shared.saveGroup(groupName: groupName, numPlayers: Int16(numPlayers), players: players)
                            groups=PersistenceController.shared.getallGroups()
//                            print(groups[0].playerArray)
//                            print(groups[0].matchesArray)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                            .padding(.trailing, 25.0)
                            .frame(width: 90.0, height: 90.0)
                    }
                    .padding(.trailing)
                    }
            }

        }
        
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let group=Group()
        StandingsView(group: group)
        
        HomeView()
        
        CreateGroupView(groups: .constant([]))
        
    }
}
