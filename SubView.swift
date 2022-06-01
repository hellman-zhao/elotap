//
//  SubView.swift
//  EloTrack
//
//  Created by Hellman Zhao on 5/21/22.
//

import SwiftUI

struct PlayerStatsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var isNavigationBarHidden: Bool = true
    @State var winPercentage: Float = 0.0
    
    let player: Player
    let group: Group

    var body: some View {
        
        VStack{
            
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
                
                Text("PLAYER STATISTICS")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30.0)
                    .padding(.leading, 10.0)

                Spacer()
            }
            
            List {
                
              Section {
                  Text("Name: "+(player.playerName ?? ""))
                      .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  Text("Matches Played: "+("\(player.wins!.intValue+player.losses!.intValue+player.ties!.intValue)"))
                      .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  Text("Points: "+("\(player.points ?? 0)"))
                      .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  Text("Wins: "+("\(player.wins ?? 0)"))
                      .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  Text("Losses: "+("\(player.losses ?? 0)"))
                      .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  Text("Draws: "+("\(player.ties ?? 0)"))
                  if player.wins!.intValue+player.losses!.intValue+player.ties!.intValue==0{
                      Text("Win Percentage: N/A")
                          .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  }
                  else{
                      Text("Win Percentage: "+(String(NSString(format: "%.2f", winPercentage))))
                          .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                  }
              } header: {
                Text("Player Info")
              }
                
                Section {
                    if player.wins!.intValue+player.losses!.intValue+player.ties!.intValue == 0{
                        Text("No Matches Yet")
                            .italic()
                            .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                    }
                    ForEach(0..<group.matchesArray.count, id: \.self) { index in
                        let match=group.matchesArray[index]

                        if (match.winnerName==player.playerName) || (match.loserName==player.playerName) {

                            if match.winnerScore==match.loserScore{
                                if match.winnerName==player.playerName{
                                    Text("DRAW Vs. "+(match.loserName ?? ""))
                                        .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                                }
                                else if match.loserName==player.playerName{
                                    Text("DRAW Vs. "+(match.winnerName ?? ""))
                                        .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                                }
                            }
                            
                            else{
                                if match.winnerName==player.playerName{
                                    Text("WIN Vs. "+(match.loserName ?? ""))
                                        .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                                }
                                else if match.loserName==player.playerName{
                                    Text("LOSE Vs. "+(match.winnerName ?? ""))
                                        .listRowSeparatorTint(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                                }
                            }

                        }
                    }
                } header: {
                  Text("Match History")
                }

            }

        }
        .navigationBarTitle("Another Hidden Title")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
            
            if player.wins?.intValue==0 && player.losses?.intValue==0 {
                winPercentage=0.0
            }
            else{
                winPercentage=(player.wins?.floatValue ?? 0.0) / ((player.wins?.floatValue ?? 0.0) + (player.losses?.floatValue ?? 0.0))
            }
        }
        
    }
    
}

struct ConfigurationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let group: Group
    @Binding var playerList: [Player]
    @State private var showSheet0=false
    @State private var showSheet1=false
    @State private var showSheet2=false
    
    var body: some View {
        
        VStack{
            
            HStack {
                Text("CONFIGURATION")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30.0)
                    .padding(.leading, 25.0)

                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 20.0, height: 20.0)
                }
                .padding(.top, 30.0)
                .padding(.trailing, 30)
            }
            
            List {
                
              Section {
                  Button {
                      if group.rankByWins==1{
                          group.rankByWins=0
                          playerList.sort {$0.points!.intValue > $1.points!.intValue }
                      }
                      else if group.rankByWins==0{
                          group.rankByWins=1
                          playerList.sort {$0.wins!.intValue > $1.wins!.intValue }
                      }
                      PersistenceController.shared.updateGroup()
                      presentationMode.wrappedValue.dismiss()
                  } label: {
                      Label {
                          if group.rankByWins==1{
                              Text("Rank By Points")
                                  .foregroundColor(Color.black)
                          }
                          else if group.rankByWins==0{
                              Text("Rank By Wins")
                                  .foregroundColor(Color.black)
                          }
                      } icon: {
                          Image(systemName: "slider.vertical.3")
                              .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                      }
                  }
                  
              }
                
                Section {
                    Button {
                        showSheet0.toggle()
                    } label: {
                        Label {
                            Text("Edit Players")
                                .foregroundColor(Color.black)
                        } icon: {
                            Image(systemName: "pencil.slash")
                                .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                        }
                    }
                    .fullScreenCover(isPresented: $showSheet0) {
                        EditPlayersView(group: group, playerList: $playerList)
                    }
                    
                    Button {
                        showSheet1.toggle()
                    } label: {
                        Label {
                            Text("Add Match")
                                .foregroundColor(Color.black)
                        } icon: {
                            Image(systemName: "highlighter")
                                .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                        }
                    }
                    .fullScreenCover(isPresented: $showSheet1) {
                        AddMatchView(group: group, playerList: $playerList)
                    }
                    
                    Button {
                        showSheet2.toggle()
                    } label: {
                        Label {
                            Text("View Matches")
                                .foregroundColor(Color.black)
                        } icon: {
                            Image(systemName: "book.closed")
                                .foregroundColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))
                        }
                    }
                    .sheet(isPresented: $showSheet2) {
                        MatchesView(group: group)
                    }
                }
                
            }
            
        }
    
    }
    
}

struct EditPlayersView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    let group: Group
    @Binding var playerList: [Player]
    
    @State var oldName=""
    @State var newName=""
    @State var newPlayerName=""
    @State var removePlayerName=""
    @State var count=0
    
    var body: some View {
        
        VStack{

            HStack {
                Text("EDIT PLAYERS")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30.0)
                    .padding(.leading, 25.0)

                Spacer()
            }

            Form{
                Section(header:Text("Change Player Name"),footer:Text("Old name must be the name of an existing player").italic()){
                    TextField("Old Name", text: $oldName)
                    TextField("New Name", text: $newName)
                }
                Section(header:Text("Add Player")){
                    TextField("Player Name", text: $newPlayerName)
                }
                Section(header:Text("Remove Player")){
                    TextField("Player Name", text: $removePlayerName)
                }
            }
            .accentColor(Color(hue: 0.722, saturation: 0.98, brightness: 0.593))

            HStack{

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
                    if(!oldName.isEmpty && !newName.isEmpty){
                        count+=1
                        for player in group.playerArray{
                            if player.playerName==oldName{
                                player.playerName=newName
                                PersistenceController.shared.updateGroup()
                                break
                            }
                        }
                    }
                    if(!newPlayerName.isEmpty){
                        count+=1
                        group.numPlayers=(group.numPlayers!.intValue+1) as NSNumber

                        let player=Player(context: moc)
                        player.playerName=newPlayerName
                        player.wins=(Int16(0)) as NSNumber
                        player.losses=(Int16(0)) as NSNumber
                        player.ties=(Int16(0)) as NSNumber
                        player.points=(Int16(1200)) as NSNumber
                        player.id=(group.numPlayers!.intValue+25) as NSNumber
                        group.addToPlayers(player)
                        PersistenceController.shared.updateGroup()
                        
                        playerList.append(player)
                        if group.rankByWins==1{
                            playerList.sort {$0.wins!.intValue > $1.wins!.intValue }
                        }
                        else{
                            playerList.sort {$0.points!.intValue > $1.points!.intValue }
                        }
                    }
                    if(!removePlayerName.isEmpty){
                        count+=1
                        group.numPlayers=(group.numPlayers!.intValue-1) as NSNumber
                        
                        for player in group.playerArray{
                            if player.playerName==removePlayerName{
                                group.removeFromPlayers(player)
                                PersistenceController.shared.updateGroup()
                                break
                            }
                        }
                        for i in 0..<playerList.count{
                            if playerList[i].playerName==removePlayerName{
                                playerList.remove(at: i)
                                break
                            }
                        }
                    }

                    if count != 0 {
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

struct AddMatchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    let group: Group
    @Binding var playerList: [Player]
    
    @State var player1Name=""
    @State var player2Name=""
    @State var player1Score=0
    @State var player2Score=0
    
    var body: some View {
        
        VStack{
            
            HStack {
                Text("ADD MATCH")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30.0)
                    .padding(.leading, 25.0)

                Spacer()
            }
            
            Form{
                Section(header:Text("Players")){
                    TextField("Player 1 Name", text: $player1Name)
                    TextField("Player 2 Name", text: $player2Name)
                }
                Section(header:Text("Scores"),footer:Text("Insert a single number for each player").italic()){
                    TextField("Player 1 Score", value: $player1Score, format: .number)
                    TextField("Player 2 Score", value: $player2Score, format: .number)
                }
                
                if(!player1Name.isEmpty && !player2Name.isEmpty){
                    HStack{
                        VStack{
                            Text(player1Name)
                            Spacer()
                            Text(player2Name)
                        }
                        Spacer()
                        VStack{
                            Text(String(player1Score))
                            Spacer()
                            Text(String(player2Score))
                        }
                        VStack{
                            if(player1Score > player2Score){
                                Text("WIN")
                                    .foregroundColor(Color.green)
                                Spacer()
                                Text("LOSE")
                                    .foregroundColor(Color.red)
                            }
                            else if(player2Score > player1Score){
                                Text("LOSE")
                                    .foregroundColor(Color.red)
                                Spacer()
                                Text("WIN")
                                    .foregroundColor(Color.green)
                            }
                            else if(player1Score == player2Score){
                                Text("DRAW")
                                    .foregroundColor(Color.blue)
                                Spacer()
                                Text("DRAW")
                                    .foregroundColor(Color.blue)
                            }
                        }
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
                    if(!player1Name.isEmpty && !player2Name.isEmpty){
                        
                        group.numMatches+=1
                        var player1Points=0
                        var player2Points=0
                        var increaseName=""
                        var decreaseName=""

                        if(player1Score > player2Score){ //player1 beats player2
                            let match=Match(context: moc)
                            match.winnerName=player1Name
                            match.loserName=player2Name
                            match.winnerScore=(player1Score) as NSNumber
                            match.loserScore=(player2Score) as NSNumber
                            match.identify=(group.numMatches) as NSNumber
                            group.addToMatches(match)
                            
                            for player in group.playerArray{ //updates win/losses/ties
                                if player.playerName==player1Name{
                                    player.wins=(player.wins!.intValue+1) as NSNumber
                                    player1Points=player.points as! Int
                                }
                                if player.playerName==player2Name{
                                    player.losses=(player.losses!.intValue+1) as NSNumber
                                    player2Points=player.points as! Int
                                }
                            }
                            if player1Points>=player2Points{ //non-upset
                                for player in group.playerArray{
                                    if player.playerName==player1Name{
                                        player.points=(player.points!.intValue+15) as NSNumber
                                    }
                                    if player.playerName==player2Name{
                                        player.points=(player.points!.intValue-15) as NSNumber
                                    }
                                }
                            }
                            else if player1Points<player2Points{ //upset
                                var loserPoints=abs(Int((player1Points-player2Points)/4)) //initialize adjustment
                                if loserPoints<15{
                                    loserPoints=15
                                }
                                for player in group.playerArray{
                                    if player.playerName==player1Name{
                                        player.points=(player.points!.intValue+loserPoints) as NSNumber
                                    }
                                    if player.playerName==player2Name{
                                        player.points=(player.points!.intValue-loserPoints) as NSNumber
                                    }
                                }
                            }
                        }
                        
                        else if(player2Score > player1Score){ //player 2 beats player 1
                            let match=Match(context: moc)
                            match.winnerName=player2Name
                            match.loserName=player1Name
                            match.winnerScore=(player2Score) as NSNumber
                            match.loserScore=(player1Score) as NSNumber
                            match.identify=(group.numMatches) as NSNumber
                            group.addToMatches(match)
                            
                            for player in group.playerArray{
                                if player.playerName==player2Name{
                                    player.wins=(player.wins!.intValue+1) as NSNumber
                                    player2Points=player.points as! Int
                                }
                                if player.playerName==player1Name{
                                    player.losses=(player.losses!.intValue+1) as NSNumber
                                    player1Points=player.points as! Int
                                }
                            }
                            if player2Points>=player1Points{ //non-upset
                                for player in group.playerArray{
                                    if player.playerName==player1Name{
                                        player.points=(player.points!.intValue-15) as NSNumber
                                    }
                                    if player.playerName==player2Name{
                                        player.points=(player.points!.intValue+15) as NSNumber
                                    }
                                }
                            }
                            else if player2Points<player1Points{ //upset
                                var loserPoints=abs(Int((player1Points-player2Points)/4)) //initialize adjustment
                                if loserPoints<15{
                                    loserPoints=15
                                }
                                for player in group.playerArray{
                                    if player.playerName==player1Name{
                                        player.points=(player.points!.intValue-loserPoints) as NSNumber
                                    }
                                    if player.playerName==player2Name{
                                        player.points=(player.points!.intValue+loserPoints) as NSNumber
                                    }
                                }
                            }
                        }
                        
                        else if(player1Score == player2Score){ //draw
                            let match=Match(context: moc)
                            match.winnerName=player1Name
                            match.loserName=player2Name
                            match.winnerScore=(player1Score) as NSNumber //does not matter who we put as winner/loser
                            match.loserScore=(player2Score) as NSNumber
                            match.identify=(group.numMatches) as NSNumber
                            group.addToMatches(match)
                            
                            for player in group.playerArray{ //updates win/losses/ties
                                if player.playerName==player1Name{
                                    player.ties=(player.ties!.intValue+1) as NSNumber
                                    player1Points=player.points as! Int
                                }
                                if player.playerName==player2Name{
                                    player.ties=(player.ties!.intValue+1) as NSNumber
                                    player2Points=player.points as! Int
                                }
                            }
                            if player1Points>player2Points{ //updates points
                                increaseName=player2Name
                                decreaseName=player1Name
                            }
                            else if player2Points>player1Points{
                                increaseName=player1Name
                                decreaseName=player2Name
                            }
                            for player in group.playerArray{
                                if player.playerName==increaseName{
                                    player.points=(player.points!.intValue+10) as NSNumber
                                }
                                if player.playerName==decreaseName{
                                    player.points=(player.points!.intValue-10) as NSNumber
                                }
                            }
                        }
                        
                        PersistenceController.shared.updateGroup()
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

struct MatchesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let group: Group
    
    var body: some View {
        
        VStack{
            
            HStack {
                Text("MATCH LOG")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .padding(.top, 30.0)
                    .padding(.leading, 25.0)

                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 20.0, height: 20.0)
                }
                .padding(.top, 30.0)
                .padding(.trailing, 30)
            }
            
            Spacer()
            
            List{
                ForEach(0..<group.matchesArray.count, id: \.self) { index in
                    let match=group.matchesArray[index]
                    let player1Name=match.winnerName
                    let player1Score=match.winnerScore!.intValue
                    let player2Name=match.loserName
                    let player2Score=match.loserScore!.intValue
                    
                    Section(header:Text("Match #"+String(index+1))){
                        HStack{
                            VStack{
                                Text(player1Name ?? "")
                                Spacer()
                                Text(player2Name ?? "")
                            }
                            Spacer()
                            VStack{
                                Text("\(player1Score)")
                                Spacer()
                                Text("\(player2Score)")
                            }
                            VStack{
                                if(player1Score > player2Score){
                                    Text("WIN")
                                        .foregroundColor(Color.green)
                                    Spacer()
                                    Text("LOSE")
                                        .foregroundColor(Color.red)
                                }
                                else if(player2Score > player1Score){
                                    Text("LOSE")
                                        .foregroundColor(Color.red)
                                    Spacer()
                                    Text("WIN")
                                        .foregroundColor(Color.green)
                                }
                                else if(player1Score == player2Score){
                                    Text("DRAW")
                                        .foregroundColor(Color.blue)
                                    Spacer()
                                    Text("DRAW")
                                        .foregroundColor(Color.blue)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        
        let player=Player()
        let group=Group()
        
        PlayerStatsView(player: player, group: group)
        
        ConfigurationView(group: group, playerList: .constant([]))
        
        EditPlayersView(group: group, playerList: .constant([]))
        
        AddMatchView(group: group, playerList: .constant([]))
    }
}
