//
//  ImageUploaderService.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import FirebaseStorage
import UIKit

struct ImageUploaderService {
    //when we upload a photo we get a dounload link
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        //make the file smaller with 0.75 quality
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
        
    }
}

