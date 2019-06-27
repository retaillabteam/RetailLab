//
//  FakeApiCalling.swift
//  BluetoothDetection
//
//  Created by Alvaro IDJOUBAR on 20/05/2019.
//  Copyright © 2019 Alvaro IDJOUBAR. All rights reserved.
//

import Foundation

enum UserApiError: Error {
    case error
}

class FakeApiCalling {
    func getModel<T : Decodable >(ofType: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let path = Bundle(for: type(of: self) as AnyClass).path(forResource: "UserJsonResponse", ofType: "json") else { return }
        guard let data = NSData(contentsOfFile: path) as Data? else { return }
        
        do {
            let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let apiResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.success(apiResponse))
        } catch {
            print(error)
            completion(.failure(UserApiError.error))
        }
    }
}
