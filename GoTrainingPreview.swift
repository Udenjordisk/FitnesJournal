import UIKit

class GoTrainingPreviewVC: UIViewController{
    
    @IBOutlet weak var practiceForDayLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var elementCount = 0
    var practiceCount = 1
    var text = """
"""
    override func viewDidLoad() {
        
        NewTrainingVC().getTrainingsArray()
        
        guard trainingsArray.count != 0 else {
                    practiceForDayLabel.text = """
        На сегодня упражнений нет.
        Добавьте первую тренировку в дневник и мы сможем cоздать следующую на её основе.
        """
                startButton.isEnabled = false
                    return
                }

        
        switch trainingsArray.count {
            case 3... :
            self.elementCount = trainingsArray.count - 3
                
            case 1...2:
            self.elementCount = trainingsArray.count - 1
                
            default:
             break
            }
            //TODO: Поменять отображение на таблицу с возможностью менять параметры
            for pract in trainingsArray[elementCount].allPractice{
                    text += """
    \(String(practiceCount)). \(pract.name)

    """
                practiceCount += 1
            }
            
            practiceForDayLabel.text = text
            
          
    }
   
    
    
    @IBAction func startTrainingButton(_ sender: UIButton) {
    }
    


}
