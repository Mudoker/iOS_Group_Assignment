/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Apple Men
 Doan Huu Quoc (s3927776)
 Tran Vu Quang Anh (s3916566)
 Nguyen Dinh Viet (s3927291)
 Nguyen The Bao Ngoc (s3924436)
 
 Created  date: 11/09/2023
 Last modified: 15/09/2023
 Acknowledgement: None
 */

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    // Control state
    @Binding var currentUser:User
    @Binding var userSetting:UserSetting
    @ObservedObject var settingVM = SettingViewModel()
    @State var accountText: String = ""
    
    @State var isAdding = false
    @State var shouldPresentPickerSheet = false
    @State var shouldPresentCamera = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    // Title
                    Text("Profile Settings")
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                    
                    // Change avatar
                    VStack(alignment: .center) {
                        Button(action: { isAdding = true}) {
                            
                            VStack{
                                if let mediaURL = URL(string: settingVM.avatarSelectedMedia?.absoluteString ?? "") {
                                    
                                    KFImage(mediaURL)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        
                                    
                                } else {
                                    // Handle the case where the media URL is invalid or empty.
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        
                                }
                            }
                            .frame(width: proxy.size.width / 4, height: proxy.size.width / 4)
                            .clipShape(Circle())
                            .overlay{
                                if (settingVM.avatarSelectedMedia != NSURL(string: currentUser.profileImageURL ?? "")){
                                    
                                }else{
                                    ZStack {
                                        Circle()
                                            .fill(Color.black.opacity(0.6))
                                        
                                        Image(systemName: "camera")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: proxy.size.width / 12)
                                    }
                                }
                                
                            }
                            .actionSheet(isPresented: $isAdding) { () -> ActionSheet in
                                ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                    self.shouldPresentPickerSheet = false
                                    self.shouldPresentCamera = true
                                }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                    self.shouldPresentPickerSheet = true
                                    self.shouldPresentCamera = false
                                }), ActionSheet.Button.cancel()])
                            }
                        
                            
                            .sheet(isPresented: $shouldPresentPickerSheet) {
                                UIImagePickerView(isPresented: $shouldPresentPickerSheet , selectedMedia: $settingVM.avatarSelectedMedia, sourceType: .photoLibrary , allowVideos: false)
                                    .presentationDetents(shouldPresentCamera ? [.large] : [.medium])
                                
                            }
                            .fullScreenCover(isPresented: $shouldPresentCamera) {
                                UIImagePickerView(isPresented: $shouldPresentCamera , selectedMedia: $settingVM.avatarSelectedMedia, sourceType: .camera, allowVideos: false)
                                    .ignoresSafeArea()
                            }
                            
                            .onChange(of: settingVM.avatarSelectedMedia) { _ in
                                settingVM.hasProfileSettingChanged = true
                            }


                        }
                        Text("Change photo")
                    }
                    .padding()
                    
                    // Content
                    VStack(alignment: .leading) { // Align text to the left
                        Text("Update profile")
                            .padding(.vertical)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Profile")
                                .bold()
                            
                            HStack {
                                Text("Account")
                                
                                Spacer()
                                
                                Text(verbatim: "huuquoc7603@gmail.com")
                                    .foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3))
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Username")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileUsername, prompt: Text(verbatim: "qdoan7603").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileUsername) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Bio")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileBio, prompt: Text(verbatim: "bio").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileBio) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Text("Phone number")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfilePhoneNumber, prompt: Text(verbatim: "qdoan7603").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfilePhoneNumber) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                                
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                        // Connections
                        VStack(alignment: .leading) {
                            Text("Connections")
                                .bold()
                            
                            HStack {
                                Image("fb")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/15, height: proxy.size.width/15)
                                
                                Text("Facebook")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileFacebook, prompt: Text(verbatim: "example.com").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileFacebook) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Image("linkedin")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width/15, height: proxy.size.width/15)
                                
                                Text("LinkedIn")
                                
                                Spacer()
                                
                                TextField("", text: $settingVM.newProfileLinkedIn, prompt: Text(verbatim: "example.com").foregroundColor(userSetting.darkModeEnabled ? .white.opacity(0.5) : .black.opacity(0.3)))
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: settingVM.newProfileLinkedIn) { _ in
                                        if settingVM.isProfileSettingChange() {
                                            settingVM.hasProfileSettingChanged = true
                                        } else {
                                            settingVM.hasProfileSettingChanged = false
                                            
                                        }
                                    }
                            }
                            .padding(.vertical)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    //MARK: Update Profile
                                    Task{
                                        let user = await settingVM.updateProfile()!
                                        currentUser = user
                                        print(user)
                                        settingVM.hasProfileSettingChanged.toggle()
                                        settingVM.resetField()
                                        
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                    
                                    
                                }) {
                                    Text("Confirm")
                                        .foregroundColor(settingVM.isProfileSettingChange() ? .white : .gray)
                                        .padding()
                                        .frame(width: proxy.size.width/1.2) // Make the button as wide as the HStack
                                        .background(settingVM.hasProfileSettingChanged ? Color.blue : Color.gray.opacity(0.5))
                                        .cornerRadius(8)
                                }
                                .disabled(!settingVM.hasProfileSettingChanged) // Disable when no changes
                                .padding(.top)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                    }
                }
            }
            .padding(.top, 0.1)
        }
        .onAppear{
            settingVM.avatarSelectedMedia = NSURL(string: currentUser.profileImageURL ?? "")
        }
        .foregroundColor(userSetting.darkModeEnabled ? .white : .black)
        .background(!userSetting.darkModeEnabled ? .white : .black)
    }
}


