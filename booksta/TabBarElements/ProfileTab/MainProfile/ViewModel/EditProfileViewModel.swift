//
//  EditProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 24.06.2022.
//

import Foundation
import Firebase
import Resolver

class EditProfileViewModel: ObservableObject {
    @Published var state = DataState<UserModel>.idle
    @Published var imageState = DataState<String>.idle
    @Published var newImageUrl: String?
    
    @Published var user: UserModel?
    @Published var areGenresSet = false
    
    @Published var oldImageUrl: String = ""
    @Published var oldGenres: [String] = []
    @Published var newGenres: [String] = []
    @Published var canGoBack = false
    @Published var canGoForth = false
    
    @Published var allGenres: [String] = [] {
        didSet {
            getAvailableGenres()
        }
    }
    @Published var availableGenres: [String] = []
    @Published var genreSearchText: String = "" {
        didSet {
            getAvailableGenres()
        }
    }

    
    func getUserInformation() {
        guard state == .idle else {
            return
        }
        state = .loading
        
        UserService.getCurrentUserInfo { [weak self] user,error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
            } else if let user = user {
                self.state = .loaded(user)
                self.imageState = .loaded(user.imageURL)
                
                self.user = user
                self.areGenresSet = true
                self.oldGenres = user.genres
                self.newGenres = user.genres
                self.oldImageUrl = user.imageURL
            }
        }
    }
    
    func discardChanges(newImageUrl: String) {
        if newImageUrl != oldImageUrl,
           let user = user {
            UserService.updateProfilePhoto(uid: user.uid, url: oldImageUrl) {[weak self] result in
                guard let `self` = self else { return }
                if result {
                    print("DEBUG: Photo succesfully updated")
                    self.setFlagToGoBack()
                } else {
                    print("DEBUG: Error updating photo")
                }
            }
        }
    }
    
    func setFlagToGoBack() {
        canGoBack = true
    }
    
    func canGoBackFunction() {
        if let url = newImageUrl {
            discardChanges(newImageUrl: url)
        } else if newImageUrl == nil {
            setFlagToGoBack()
        } else if let url = newImageUrl,
                  url == oldImageUrl {
            setFlagToGoBack()
        }
    }
    
    func saveChanges() {
        if newGenres != oldGenres {
            UserService.updateProfileGenres(genres: newGenres) { [weak self] result in
                guard let `self` = self else { return }
                if result {
                    print("DEBUG: Genres succesfully updated")
                    self.canGoForth = true
                } else {
                    print("DEBUG: Error updating genres")
                }
            }
        }
        else if newGenres == oldGenres {
            self.canGoForth = true
        }
    }
    
    func uploadPhoto(image: UIImage?) {
        guard imageState == .idle else {
            return
        }
        imageState = .loading
        
        if let image = image, let user = user {
            UserService.uploadPhotoToStorage(uid: user.uid, image: image, completion: { [weak self] urlImage in
                guard let `self` = self else { return }
                self.imageState = .loaded(urlImage)
                self.newImageUrl = urlImage
            })
        } else {
            self.state = .error("Unable to load image")
        }
    }
    
    func resetImageState() {
        self.imageState = .idle
    }
    
    func getAllGenres() {
        BookService.getBookGenres { [weak self] genres, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let genres = genres {
                self.allGenres = genres
            }
        }
    }
    
    func getAvailableGenres() {
        var returnValue: [String] = []
        for genre in allGenres {
            if !newGenres.contains(genre) {
                returnValue.append(genre)
            }
        }
        availableGenres = returnValue.filter({ genreSearchText.isEmpty ? true : $0.lowercased().contains(genreSearchText.lowercased()) })
            .sorted(by: < )
    }
    
    func onUnselect(index: Int) {
        newGenres.remove(at: index)
    }
    
    func updateProfileGenres(selectedGenres: [String]) {
        for genre in selectedGenres {
            if !newGenres.contains(genre) {
                newGenres.append(genre)
            }
        }
    }
}
