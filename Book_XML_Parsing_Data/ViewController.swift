import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    
    // 데이터 클래스 객체 배열
    var myBookData = [BookData]()
    
    var dTitle = ""
    var dAuthor = ""
    
    // 현재의 tag를 저장
    var currentElement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        // Fruit.xml 화일을 가져 오기
        // optional binding nil check
        if let path = Bundle.main.url(forResource: "book", withExtension: "xml") {
            // 파싱 시작
            if let myParser = XMLParser(contentsOf: path) {
                // delegate를 ViewController와 연결
                myParser.delegate = self
                
                if myParser.parse() {
                    print("파싱 성공")
                    //print(myBookData[0].title)
                    //                    print(myFruitData[0].color)
                    //                    print(myFruitData[0].cost)
                    
                    for i in 0 ..< myBookData.count {
                        print(myBookData[i].title)
                    }
                } else {
                    print("파싱 실패")
                }
                
            } else {
                print("파싱 오류 발생")
            }
            
        } else {
            print("xml file not found")
        }
    }
    
    // XML Parser delegate 메소드
    // 1. tag(element)를 만나면 실행
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    //2. tag 다음에 문자열을 만날때 실행
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 공백 등 제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            switch currentElement {
            case "title" : dTitle = data
            case "author" : dAuthor = data
            default : break
            }
        }
    }
    
    //3. tag가 끝날때 실행(/tag)
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "book" {
            let myItem = BookData()
            myItem.title = dTitle
            myItem.author = dAuthor
            myBookData.append(myItem)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBookData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        cell.textLabel?.text = myBookData[indexPath.row].title
        cell.detailTextLabel?.text = myBookData[indexPath.row].author
        return cell
    }
}
