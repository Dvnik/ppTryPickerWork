import UIKit

class PickerImgViewController: UIViewController
{
    //MARK:- Outlet
    @IBOutlet weak var fileUrl: UILabel!//顯示取到的檔案位置
    
    @IBOutlet weak var picShow: UIImageView!//結果顯示
    

    //MARK:- Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK:- Target Actions
    //執行此頁的System Picker
    @IBAction func doSystemPicker(_ sender: Any)
    {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            print("此裝置沒有相簿")
            fileUrl.text = "此裝置沒有相簿"
            return  // 直接離開函式
        }
        // 初始化影像挑選控制器
        let imagePicker = UIImagePickerController()
        // 設定影像挑選控制器為相簿
        // 設定影像挑選控制器為相機(.camera)的話，需要到info.plist
        // 新增相機使用權限 > Privacy - Camera Usage Description
        // 目前測試不需要相簿權限也可以使用相簿
        // 如果不放心可以再加上 > Privacy - Photo Library Description
        imagePicker.sourceType = .photoLibrary
        //允許編輯相片
        imagePicker.allowsEditing = true
        // 設定相機相關的代理事件實作在此類別
        imagePicker.delegate = self
        // 開啟選取器
        self.show(imagePicker, sender: nil)
    }
}
//MARK:- UIImagePickerControllerDelegate
//UIImagePickerController的delegate需求，由extension與原本的程式碼分割起來好閱讀
extension PickerImgViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //使用UIImagePickerControllerDelegate 內的函式承接回傳的圖片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("影像資訊:\(info)")
        // 將檔案位置取出來印在畫面上
        // imageURL型態當然是URL，加上if let 上一個保險
        if let strUrl = info[.imageURL] as? URL
        {
            fileUrl.text = strUrl.absoluteString
        }
        //用originalImage和editedImage沒編輯的話都是一樣的內容
        //但如果用originalImage的話不管怎麼編輯會取不到編輯後的影像(即便是用縮放選取圖片)
        //這邊選擇就看APP的用途
        if let image = info[.editedImage] as? UIImage
        {
            // 將結果顯示
            picShow.image = image
            //因為不會自動退掉畫面，要用手動退出
            //退掉相機畫面
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
