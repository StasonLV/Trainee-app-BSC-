//
//  NoteListWorker.swift
//  Trainee app
//
//  Created by Stanislav Lezovsky on 02.06.2022.
//
import Foundation
import UIKit

final class NoteListWorker: NoteListWorkerLogic {
    let session: URLSession
    
    init (session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    // MARK: - метод для получения и обработки данных по url
    func fetch(completion: @escaping([NoteListCleanModel.FetchData.Response]) -> Void) {
        guard let url = createURLComponents() else { return }
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }
            guard let data = data,
                  let notes = try? JSONDecoder().decode([NoteListCleanModel.FetchData.Response].self, from: data)
            else {
                return
            }
            completion(notes)
        }
        task.resume()
    }

    // MARK: - метод для удобной работы с url
    private func createURLComponents () -> URL? {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "firebasestorage.googleapis.com"
        url.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        url.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
        ]
        return url.url
    }
}
//private extension NoteListWorker {
//    func downloadImageFrom(urlString: String) -> UIImage {
//        var donloadedImage: UIImage
//        DispatchQueue.global().async {
//            guard let url = URL(string: urlString) else { return }
//            guard let data = try? Data(contentsOf: url),
//                  let image = UIImage(data: data)
//            else { return }
//            donloadedImage = image
//        }
//    }
//}
