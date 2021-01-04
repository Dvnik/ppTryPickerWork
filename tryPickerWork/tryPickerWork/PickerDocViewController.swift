
import UIKit
//使用UTType需要import的套件
import UniformTypeIdentifiers

class PickerDocViewController: UIViewController
{
    //MARK:- Outlet
    @IBOutlet weak var fileUrl: UILabel!//顯示取到的檔案位置
    
    @IBOutlet weak var docSeg: UISegmentedControl!//顯示正要取的檔案類型
    
    @IBOutlet weak var picShow: UITextView!//結果顯示
    
    
    //MARK:- Values
    let tagLists:[String] = ["json", "txt"]//所有檔案類型
    
    //MARK:- Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK:- Target Actions
    //執行此頁的System Picker
    @IBAction func doSystemPicker(_ sender: Any)
    {
        // 決定的檔案類型由UISegmentedControl的Index對應到在tagLists陣列寫好的副檔名
        let tagString = tagLists[docSeg.selectedSegmentIndex]
        // 製作一個UTType陣列，決定要挑選的檔案類型，tag是篩檢字串，tagClass選filenameExtension則是「副檔名」的意思
        let types = UTType.types(tag: tagString, tagClass: .filenameExtension, conformingTo: nil)
        // 初始化檔案挑選控制器
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        // 設定檔案相關的代理事件實作在此類別
        docPicker.delegate = self
        // 開啟選取器
        self.show(docPicker, sender: nil)
    }
}
//MARK:-UIDocumentPickerDelegate
extension PickerDocViewController:UIDocumentPickerDelegate
{
    //使用UIDocumentPickerDelegate 內的函式承接回傳的檔案
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        print("檔案位置:\(urls)")
        //一般選取檔案的時候都只會取到一個檔案
        //會用陣列可能是要取整個資料夾的時候吧？
        if urls.count > 0
        {
            //取出選到的檔案(通常是第一筆)
            let selectUrl = urls[0]
            // 將得到的URL做其他處理
            // 此處只有弄json和txt檔案，所以都是針對文字內容做處理
            // 如果有其他的需求就要做別的處理
            fileUrl.text = selectUrl.absoluteString
            switch docSeg.selectedSegmentIndex
            {
            case 0:
                printJsonStr(selectUrl)
            case 1:
                printTxtStr(selectUrl)
            default:
                return
            }
        }
    }
    //MARK: 單純提供把檔案的內容印出來的功能
    func printJsonStr(_ jsonUrl:URL)
    {
        do {
            //用JSONSerialization解出Json字串
            let data = try Data(contentsOf: jsonUrl)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)//好讀模式
            let prettyJSONString = String(data:jsonData, encoding: .utf8)!
            picShow.text = prettyJSONString
        }
        catch
        {
            print(error)
        }
    }
    
    func printTxtStr(_ txtUrl:URL)
    {
        do {
            let showText = try String(contentsOf: txtUrl, encoding: .utf8)
            
            picShow.text = showText
        }
        catch
        {
            print(error)
        }
    }
}
