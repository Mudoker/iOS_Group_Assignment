//
//  DiscoverViewModel.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 24/09/2023.
//

import Foundation
import SwiftUI
import Firebase

class DiscoverViewModel : ObservableObject{
    @Published var isOpenFilterOnIphone = false
    
    
    
    @Published var isSelectedPostAllowComment = false
    
    @Published var activeTab : String = "All"
    
    @Published var searchTerm : String = ""
    @Published var searchState : Bool = true
    
    @Published var birthMonth: DropdownMenuOption? =  DropdownMenuOption(option: "Posts")
    
    @Published var allUser : [User] = []
    @Published var postList : [Post] = []
    
    @Published var defaultPost : [Post] = []
    @Published var defaultPeople : [User] = []
    @MainActor
    func fetchAllUser() async throws {
        allUser = try await APIService.fetchAllUsers()
    }
    
    @MainActor
    func fetchAllPosts() async throws{
        do {
            // Query Firestore to get all posts
            let querySnapshot = try await Firestore.firestore().collection("test_posts").getDocuments()
            
            if querySnapshot.isEmpty {
                print("No documents")
                return
            }
            
            var fetchedAllPosts = [Post]()
            
            // Iterate and convert to Post objects
            for queryDocumentSnapshot in querySnapshot.documents {
                if let post = try? queryDocumentSnapshot.data(as: Post.self) {
                    fetchedAllPosts.append(post)
                }
            }
            
            // Sort the fetched posts by time in descending order
            fetchedAllPosts = sortPostByTime(order: "desc", posts: fetchedAllPosts)
            
            // Fetch user for each post's owner
            for i in 0..<fetchedAllPosts.count {
                let post = fetchedAllPosts[i]
                let ownerID = post.ownerID
                
                do {
                    let user = try await APIService.fetchUser(withUserID: ownerID)
                    fetchedAllPosts[i].unwrappedOwner = user
                } catch {
                    print("Error fetching user: \(error)")
                }
            }
            
            // Update the fetched posts array
            self.postList = fetchedAllPosts
        } catch {
            print("Error fetching posts: \(error)")
            throw error
        }
    }
    
    
    func sortPostByTime(order: String, posts: [Post]) -> [Post] {
        var sortedPosts = posts
        
        switch order {
        case "asc":
            sortedPosts.sort { post1, post2 in
                return post1.creationDate.dateValue().compare(post2.creationDate.dateValue()) == ComparisonResult.orderedAscending
            }
        case "desc":
            sortedPosts.sort { post1, post2 in
                return post1.creationDate.dateValue().compare(post2.creationDate.dateValue()) == ComparisonResult.orderedDescending
            }
        default:
            break
        }
        
        return sortedPosts
    }
    @MainActor
    func getDefaultPostList() {
        for i in 0...5 {
            defaultPost.append(postList[i])
        }
    }
    
    @MainActor
    func getRandomPosts(){
        defaultPost.removeAll()
        var randomIndices: Set<Int> = []
        //        var randomPosts: [Post] = []
        if (postList.count > 0){
            while randomIndices.count < 5 {
                let randomIndex = Int.random(in: 0..<postList.count)
                randomIndices.insert(randomIndex)
            }
        }
        
        for index in randomIndices {
            defaultPost.append(postList[index])
            print(index)
        }
    }
    
    @MainActor
    func getDefaultPeopleList() {
        for i in 0...5 {
            defaultPeople.append(allUser[i])
        }
    }
    
    @MainActor
    func getRandomPeople(){
        defaultPeople.removeAll()
        var randomIndices: Set<Int> = []
        //        var randomPosts: [Post] = []
        if (postList.count > 0){
            while randomIndices.count < 3 {
                let randomIndex = Int.random(in: 0..<allUser.count)
                randomIndices.insert(randomIndex)
            }
        }
        
        for index in randomIndices {
            defaultPeople.append(allUser[index])
            print(index)
        }
    }
}
