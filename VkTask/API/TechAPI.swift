//
//  TechAPI.swift
//  VkTask
//
//  Created by Ilia Zakharov on 14.07.2022.
//

import Foundation

final class TechAPI {
    
    func getData(complition: @escaping([Service]) -> ()) {
        
        let sourceURL = "https://publicstorage.hb.bizmrg.com/sirius/result.json"
        let url = URL(string: sourceURL)
        
        guard let url = url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error)
            } else {
                if let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: []) {

                    let techResponse = try? JSONDecoder().decode(TechResponse.self, from: data)
                    let service = techResponse?.body.services
                    complition(service ?? [])
                }
            }
        }
        task.resume()
    }
}
