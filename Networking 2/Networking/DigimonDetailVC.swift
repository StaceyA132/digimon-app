//
//  ViewController.swift
//  Networking
//
//  
//

import UIKit

class DigimonDetailVC: UIViewController {
    
    @IBOutlet weak var digiName: UILabel!
    @IBOutlet weak var digiImage: UIImageView!
    @IBOutlet weak var digiLevel: UILabel!
    @IBOutlet weak var digiDescription: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    var digimon: Digimon?
    var id: Int = 0
    var downloadTask: URLSessionDownloadTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://digi-api.com/api/v1/digimon/\(id)")!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url){(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let digimon = self.parse(data: data!) {

                    //now that we have access to the Digimon instance, we force the UI to update on the main thread
                    DispatchQueue.main.async { [self] in
                        updateUI(digimon: digimon)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    //the String initializer performs the request synchronously
    func performRequest(with url: URL) -> String? {
        do {
            //the call to the String init makes the network request, and hopefully gives us a response
            return try String(contentsOf: url)
        } catch {
            print("Download error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func parse(data:Data) -> Digimon? {
        do {
            let decoder = JSONDecoder()
            let digimon = try decoder.decode(Digimon.self, from: data)
            return digimon
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
    func updateUI(digimon:Digimon){
        self.digiName.text = digimon.name
        self.digiLevel.text = digimon.levels[0].level
        self.digiDescription.text = digimon.descriptions[0].description
        if let url = URL(string: digimon.images[0].href){
            downloadTask = digiImage.loadImage(url: url)
        }
    }
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        guard let text = digiDescription.text else { return }
                
                // Call the translation API
                translateText(text: text, source: "ja", target: "en") { [weak self] translatedText in
                    DispatchQueue.main.async {
                        // Show the translation in a popup
                        self?.showTranslationPopup(translatedText: translatedText)
                    }
                }
            }


            
            func translateText(text: String, source: String, target: String, completion: @escaping (String) -> Void) {
                let url = URL(string: "https://libretranslate.com/translate")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let requestBody = [
                    "q": text,
                    "source": source,// ja for japanese
                    "target": target // en for english
                ]
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
                
                let session = URLSession.shared
                session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Translation error: \(error.localizedDescription)")
                        completion("Translation failed")
                        return
                    }
                    
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let translatedText = json?["translatedText"] as? String {
                                completion(translatedText)
                            } else {
                                completion("Translation failed")
                            }
                        } catch {
                            print("JSON parsing error: \(error)")
                            completion("Translation failed")
                        }
                    }
                }.resume()
            }
            
            func showTranslationPopup(translatedText: String) {
                let alert = UIAlertController(title: "Translation", message: translatedText, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(dismissAction)
                present(alert, animated: true, completion: nil)
            }
        }
