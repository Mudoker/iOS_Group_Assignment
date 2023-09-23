//
//  BlockView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 22/09/2023.
//

import SwiftUI

struct RestrictedView: View {
    
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var settingVM: SettingViewModel
    
    @StateObject var restrictVM = RestrictViewModel()
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    settingVM.isRestrictedListSheetPresentedOniPhone = false
                } label: {
                    Text("Back")
                        .foregroundColor(.black)
                }
               
                Text("Restricted Account")
                    .bold()
                    .font(.body)
                    .padding(.horizontal)
                    .offset(x: 55)
                Spacer()
            }
            .frame(height: 60)
            .padding(.horizontal, 10)

            
            ScrollView{
                ForEach(restrictVM.userRestricList) { user in
                    VStack{
                        RestrictedListRow(user: user, restrictVM: restrictVM)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
            }
            
            Spacer()

        }
        .onAppear{
            Task {
                await restrictVM.fetchCurrentUserRestrictList()
                print("View")
                print(restrictVM.userRestricList)
            }
        }
        .refreshable {
            restrictVM.userRestricList.removeAll()
            await restrictVM.fetchCurrentUserRestrictList()
            print("View")
            print(restrictVM.userRestricList)
        
        }
    }
}

struct RestrictedView_Previews: PreviewProvider {
    static var previews: some View {
        RestrictedView(profileVM: ProfileViewModel(), settingVM: SettingViewModel())
    }
}
