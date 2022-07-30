import UIKit



class GoTrainingVC: UIViewController {
    @IBOutlet weak var countOfPracticeLabel: UILabel!
    @IBOutlet weak var practiceNameLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var practiceInfoLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var buttonLabel = ""

    var practiceNumber: Int = 0
    
    var setsCount = 1
    
    var localCountDown = SettingsVC().countDown
    
    let actualTraining = trainingsArray[GoTrainingPreviewVC().elementCount].allPractice
    
    
    
    
    var timer = Timer()
    
    @objc func minusOne(){
        guard localCountDown > 0 else {
            timer.invalidate()
            nextStep()
            self.timerLabel.isHidden = true
            return
        }
        
        
    self.timerLabel.isHidden = false
    self.localCountDown -= 1
    self.timerLabel.text = self.localCountDown.timeToString()
        
    
     
    }
       
   
    
    override func viewDidLoad()
    {
        localCountDown = SettingsVC().countDown
        
        timerLabel.isHidden = true
        
        self.countOfPracticeLabel.text = "Упражнение: \(practiceNumber + 1)/\(actualTraining.count)"
        
        self.practiceNameLabel.text = actualTraining[0].name
        
        self.setsLabel.text = "Подход: 1/\(actualTraining[0].sets)"
        
        self.practiceInfoLabel.text = "\(actualTraining[0].repeats) повторений с весом \(actualTraining[0].weight)кг."
        
    }
    
    
    
      func chill(){
        self.timerLabel.text = self.localCountDown.timeToString()
        startButton.setTitle("Закончить отдых", for: .normal)//Даём возможность через кнопку закончить отдых
         
        self.setsLabel.isHidden = true
        self.practiceInfoLabel.isHidden = true
        self.countOfPracticeLabel.isHidden = true
        self.practiceNameLabel.isHidden = true //Скрываем ненужные лейбелы
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(minusOne), userInfo: nil, repeats: true)
          
      }
    
    func nextStep(){
       
        
        
        
        if setsCount < actualTraining[practiceNumber].sets{
            self.setsCount += 1
        } else if setsCount == actualTraining[practiceNumber].sets{
            
                    guard practiceNumber + 1 != actualTraining.count else {
                        self.practiceNameLabel.text = "Готово"
                        self.setsLabel.text = ""
                        self.practiceInfoLabel.text = ""
                       
                        startButton.setTitle("Завершить тренировку", for: .normal)
                        
                        trainingsArray.append(trainingsArray[GoTrainingPreviewVC().elementCount])
                        trainingsArray[trainingsArray.count - 1].date = Date().string(format: "yyyy.MM.dd - HH:mm")
                        
                        NewTrainingVC().saveTrainingsArray()
                        
                        return
                        
                            }
            practiceNumber += 1
            self.setsCount = 1
            
            }
        
        
        self.setsLabel.isHidden = false
        self.practiceInfoLabel.isHidden = false
        self.countOfPracticeLabel.isHidden = false
        self.practiceNameLabel.isHidden = false
        
        self.countOfPracticeLabel.text = "Упражнение: \(practiceNumber + 1)/\(actualTraining.count)"
        startButton.setTitle("Готово", for: .normal)
        
        self.practiceNameLabel.text = actualTraining[practiceNumber].name
        
        self.setsLabel.text = "Подход: \(setsCount)/\(actualTraining[practiceNumber].sets)"
        
        self.practiceInfoLabel.text = "\(actualTraining[practiceNumber].repeats) повторений с весом \(actualTraining[practiceNumber].weight)кг."
        
        
     }
    
    
    @IBAction func pressStartButton(_ sender: UIButton) {
        switch (sender.titleLabel?.text)!{
        case "Готово":
            
            self.localCountDown = SettingsVC().countDown//Обновляем текущее время отдыха для работы счетчика
            
            chill()

        case "Закончить отдых":
            timer.invalidate()
            timerLabel.isHidden = true
            nextStep()
        case "Завершить тренировку":
            
            _ = navigationController?.popViewController(animated: true)
        default:
            return
        }
    }
    
}

extension Int{
    
    func timeToString() -> String{
       let minutes = self / 60 % 60
       let seconds = self % 60
       return String(format: "%02i:%02i", minutes, seconds)
       }

}
