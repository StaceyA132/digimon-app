//
//  DigiListVC.swift
//  Networking
//

//

import UIKit

class DigiListVC: UITableViewController {
    
    var digimonListResponse: AllDigimonResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://digi-api.com/api/v1/digimon?pageSize=100")!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url){(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let digiList = self.parse(data: data!) {
                    self.digimonListResponse = digiList
                    //now that we have access to the Digimon instance, we force the UI to update on the main thread
                    DispatchQueue.main.async { [self] in
                        self.tableView.reloadData()
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func parse(data:Data) -> AllDigimonResponse? {
        do {
            let decoder = JSONDecoder()
            let digimonList = try decoder.decode(AllDigimonResponse.self, from: data)
            return digimonList
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return digimonListResponse?.content.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DigiCell", for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = digimonListResponse?.content[indexPath.row].name
        cell.contentConfiguration = cellContent
        return cell
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //we need communicate to the destination of the segue, the number or if of the Digimon
        //so that we can make an API call using that ID #
        let destination = segue.destination as! DigimonDetailVC
        let digimonIDtoSend = sender as! Int
        destination.id = digimonIDtoSend
    }
    
    //method is called as son as user taps on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedDigimon = digimonListResponse?.content[indexPath.row]
        performSegue(withIdentifier: "toDigimonDetail", sender: selectedDigimon?.id)
    }
    

}
