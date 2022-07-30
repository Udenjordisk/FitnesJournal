import UIKit


protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

let userDefaults = UserDefaults.standard

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

var trainingsArray: [Training] = []
   
struct Practice: Codable {
    var name: String
    var sets: Int
    var weight: Int
    var repeats: Int
}

struct Training: Codable {
    
    var date = Date().string(format: "yyyy.MM.dd - HH:mm")
    var allPractice: [Practice] = []
    
    
}




class NewTrainingVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    @IBOutlet weak var activityNameField: UITextField!
    @IBOutlet weak var setsCountField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var repeatCountField: UITextField!
    

    var training = Training()
    
    
    func saveTrainingsArray(){
        do {
            try userDefaults.setObject(trainingsArray, forKey: "trainingsArray")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getTrainingsArray(){
        do {
            trainingsArray = try userDefaults.getObject(forKey: "trainingsArray", castTo: [Training].self)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    @IBAction func saveExercise(_ sender: Any) {
        let practice = Practice(name: activityNameField.text ?? "Без названия", sets: Int(setsCountField.text!) ?? 0, weight: Int(weightField.text!) ?? 0, repeats: Int(repeatCountField.text!) ?? 0)
        
        self.training.allPractice.append(practice)

        tableView.reloadData()
        
        clearField()
    }
    
    @IBAction func saveTraining(_ sender: Any){
        
        
        trainingsArray.append(training)
        
        saveTrainingsArray()
        
        training.allPractice.removeAll()
                
        clearField()
                
        tableView.reloadData()
    }
    
    func clearField(){
        activityNameField.text = ""
        setsCountField.text = ""
        weightField.text = ""
        repeatCountField.text = ""
    }
    
}






extension NewTrainingVC: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return training.allPractice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"exCell", for: indexPath)
        
        cell.textLabel?.text = " \(training.allPractice[indexPath.row].name)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        func showAlert(){
            var messageForAlert = """
"""
            
                if String(training.allPractice[indexPath.row].weight) != "0"{
                    messageForAlert += """
Вес - \(training.allPractice[indexPath.row].weight)

"""
            }
                if String(training.allPractice[indexPath.row].sets) != "0"{
                    messageForAlert += """
Подходы - \(training.allPractice[indexPath.row].sets)

"""
                }
                if String(training.allPractice[indexPath.row].repeats) != "0"{
                    messageForAlert += """
Повторения - \(training.allPractice[indexPath.row].repeats)

"""
                }
     
            
            let alert = UIAlertController(title:"Упражнение - \(training.allPractice[indexPath.row].name)", message: messageForAlert, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.training.allPractice.remove(at: indexPath.row)
                tableView.reloadData()
            }
            
            alert.addAction(action)
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion: nil)
            }
        
        showAlert()
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
