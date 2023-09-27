//
//  ViewController.swift
//  judoScoreboard
//
//  Created by Min Hu on 2023/9/26.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // 創建播放器實例
    let player = AVPlayer()
    // 創建儲存按鍵聲音的 playerItem
    let playerItem1 = AVPlayerItem(url: Bundle.main.url(forResource: "beep-sound", withExtension: "mp3")!)
    // 創建儲存時間到聲音的 playerItem
    let playerItem2 = AVPlayerItem(url: Bundle.main.url(forResource: "bell", withExtension: "mp3")!)
    // 倒數計時器面板
    @IBOutlet weak var countdownLabel: UILabel!
    // 觸控以開始或暫停倒數計時
    @IBOutlet weak var startPauseCountdownButton: UIButton!
    // 宣告倒數計時器實例
    var countdownTimer: Timer?
    // 記錄計時器的狀態，true表示計時中，false表示計時暫停或停止
    var isCounting = false
    // 初始化倒數計時時間（秒）
    var remainingTime = 240
    
    // 宣告壓制計時器實例
    var timer1: Timer?
    var timer2: Timer?
    
    // 壓制計時器初始秒數
    var timer1Seconds = 0
    var timer2Seconds = 0
    
    // 壓制計時器顯示介面
    @IBOutlet weak var timer1Label: UILabel!
    @IBOutlet weak var timer2Label: UILabel!
    // 壓制計時開始按鍵
    @IBOutlet weak var OsaekomiButton1: UIButton!
    @IBOutlet weak var OsaekomiButton2: UIButton!
    // 壓制計時結束按鍵
    @IBOutlet weak var toketaButton1: UIButton!
    @IBOutlet weak var toketaButton2: UIButton!
    
    @IBOutlet weak var player1Label: UILabel!
    
    @IBOutlet weak var player2Label: UILabel!
    
    // 指導次數選擇按鍵 1
    @IBOutlet weak var firstSButton: UIButton!
    
    @IBOutlet weak var firstS1Label: UILabel!
    
    @IBOutlet weak var firstS2Label: UILabel!
    
    @IBOutlet weak var firstHLabel: UILabel!
    
    // 指導次數選擇按鍵 2
    @IBOutlet weak var secondSButton: UIButton!
    
    @IBOutlet weak var secondS1Label: UILabel!
    
    @IBOutlet weak var secondS2Label: UILabel!
    
    @IBOutlet weak var secondHLabel: UILabel!
    
    // Player1 1勝分數牌
    @IBOutlet weak var ippon1Label: UILabel!
    // Player1 半勝分數牌
    @IBOutlet weak var wazaAri1Label: UILabel!
    // Player2 1勝分數牌
    @IBOutlet weak var ippon2Label: UILabel!
    // Player2 半勝分數牌
    @IBOutlet weak var wazaAri2Label: UILabel!
    // 時間設定 button 白色
    @IBOutlet weak var timeSetting1Button: UIButton!
    // 時間設定 button 黃色
    @IBOutlet weak var timeSetting2Button: UIButton!
    // 裝著調整分鐘的 stepper 的 view
    @IBOutlet var stepperView1: UIView!
    // 裝著調整秒數的 stepper 的 view
    @IBOutlet var stepperView2: UIView!
    // 調整分鐘的 stepper
    @IBOutlet weak var stepper1: UIStepper!
    // 調整秒數的 stepper
    @IBOutlet weak var stepper2: UIStepper!
    // 設定 View
    @IBOutlet weak var settingView: UIView!
    // 為了點任意處收起 Setting View 而生的 View，放置 Tap Gesture 用
    @IBOutlet weak var viewForHideSettingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定 button 外框寬度 2
        OsaekomiButton1.layer.borderWidth = 2
        // 設定 button 外框顏色為白色
        OsaekomiButton1.layer.borderColor = UIColor.white.cgColor
        // 下方同上
        OsaekomiButton2.layer.borderWidth = 2
        OsaekomiButton2.layer.borderColor = UIColor.white.cgColor
        toketaButton1.layer.borderWidth = 2
        toketaButton1.layer.borderColor = UIColor.white.cgColor
        toketaButton2.layer.borderWidth = 2
        toketaButton2.layer.borderColor = UIColor.white.cgColor
        firstSButton.layer.borderWidth = 3
        // 設定外框顏色為黃色
        firstSButton.layer.borderColor = UIColor.yellow.cgColor
        secondSButton.layer.borderWidth = 3
        secondSButton.layer.borderColor = UIColor.yellow.cgColor
        // 隱藏兩個 toketaButton
        toketaButton1.isHidden = true
        toketaButton2.isHidden = true
        // 隱藏兩個 OsaekomiButton
        OsaekomiButton1.isHidden = true
        OsaekomiButton2.isHidden = true
        // 更新倒數計時 label
        updateCountdownLabel()
        // 指導 label 全部隱藏
        firstS1Label.isHidden = true
        firstS2Label.isHidden = true
        firstHLabel.isHidden = true
        secondS1Label.isHidden = true
        secondS2Label.isHidden = true
        secondHLabel.isHidden = true
        // 時間設定黃色按鍵先隱藏
        timeSetting2Button.isHidden = true
        // 將承載著 stepper 的 view 們轉向 270 度並隱藏
        stepperView1.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 270)
        stepperView1.isHidden = true
        stepperView2.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 270)
        stepperView2.isHidden = true
        // 設定 stepper 們的極大極小值與初始值
        stepper1.minimumValue = -1
        stepper1.maximumValue = 1
        stepper1.value = 0
        stepper2.minimumValue = -1
        stepper2.maximumValue = 1
        stepper2.value = 0
        // Setting View 與用來 tap 其他地方隱藏 SettingView 的 View 都預設隱藏
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
        
    }
    // 更新倒數計時 label
    func updateCountdownLabel(){
        // 將剩餘時間轉換為分和秒的格式
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        // 將分鐘與秒數設定好格式放到倒數計時 label 中
        countdownLabel.text = String(format: "%d:%02d", arguments: [minutes, seconds])
    }
    // 停止計時
    func stopCountdownTimer(){
        // 停止計時器
        countdownTimer?.invalidate()
        // 釋放 timer
        countdownTimer = nil
    }
    
    // 開始倒數計時
    func startCountdownTimer(){
        // 設定計時器，每 1 秒執行一次，計時完畢後執行 closure 內的程式碼
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ [weak self] _ in
            guard let self = self else { return }
            // 減少剩餘時間
            self.remainingTime -= 1
            // 更新倒數計時 label
            self.updateCountdownLabel()
            // 如果剩餘時間為 0，倒數計時任務結束
            if self.remainingTime == 0{
                // 將目前播放內容置換為時間到聲音
                player.replaceCurrentItem(with: playerItem2)
                // 播放聲音
                player.play()
                // 則停止計時
                stopCountdownTimer()
            }
        }
    }
    // 點擊倒數計時上的 button 以開始倒數計時或暫停倒數計時
    @IBAction func startPauseButtonTapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果計時器計時中
        if isCounting{
            stopCountdownTimer() // 停止計時
            // 如果壓制計時器 1 在運作
            if timer1?.isValid == true{
                // 則計時器停止
                timer1?.invalidate()
            }
            // 如果壓制計時器 1 在運作
            if timer2?.isValid == true{
                // 則計時器停止
                timer2?.invalidate()
            }
            OsaekomiButton1.isHidden = true
            OsaekomiButton2.isHidden = true
            // 若非計時中
        }else{
            startCountdownTimer() // 開始計時
            // 如果 Player1 壓制時間板上的數字不為0
            if timer1Label.text != "0"{
                // 則繼續計時
                startTimer1()
                // 如果 Player2 壓制時間板上的數字不為0
            }else if timer2Label.text != "0"{
                // 則繼續計時
                startTimer2()
            }
            OsaekomiButton1.isHidden = false
            OsaekomiButton2.isHidden = false
        }
            // 切換 isCounting 的真偽狀態
            isCounting.toggle()
    }
        // 設定 Player1 的開始壓制計時
        func startTimer1(){
            // 如果 timer1 已在運作，先停止它
            if timer1?.isValid == true{
                timer1?.invalidate()
            }
            // 設定計時器，每 1 秒執行一次，計時完畢後執行 closure 內的程式碼
            timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){[weak self] _ in
                guard let self = self else { return }
                // 增加一秒時間
                self.timer1Seconds += 1
                // 更新倒數計時 label
                self.timer1Label.text = String(self.timer1Seconds)
                // 如果時間大於等於 20
                if self.timer1Seconds >= 20 {
                    // 則停止中央倒數計時器
                    self.stopCountdownTimer()
                    // Player1 一勝顯示1
                    self.ippon1Label.text = "1"
                    // Player1 如果原先半勝為 0
                    if wazaAri1Label.text == "0"{
                        // 則半勝 +1
                        self.wazaAri1Label.text = "1"
                        // Player1 如果原先半勝為 1
                    }else if wazaAri1Label.text == "1"{
                        // 則半勝 +1
                        self.wazaAri1Label.text = "2"
                    }
                    // 停止 Player1 的壓制計時
                    timer1?.invalidate()
                }
            }
        }
        
        @IBAction func Osaekomi1Tapped(_ sender: UIButton) {
            // 發出按鍵嗶聲
            beepSoundPlay()
            //  雙方的 OsaekomiButton 都隱藏
            OsaekomiButton1.isHidden = true
            OsaekomiButton2.isHidden = true
            // Player1 的 Toketa Button 出現
            toketaButton1.isHidden = false
            // 開始計時
            startTimer1()
        }
        
        @IBAction func toketaButton1Tapped(_ sender: UIButton) {
            // 發出按鍵嗶聲
            beepSoundPlay()
            // Player1 的 Toketa Button 隱藏
            toketaButton1.isHidden = true
            //  雙方的 OsaekomiButton 都出現
            OsaekomiButton1.isHidden = false
            OsaekomiButton2.isHidden = false
            // 計時器停止計時
            timer1?.invalidate()
            // 秒數歸 0
            timer1Seconds = 0
            // 計時 label 顯示為 0
            timer1Label.text = "0"
        }
        
        func startTimer2(){
            // 如果 timer2 已在運作，先停止它
            if timer2?.isValid == true{
                timer2?.invalidate()
            }
            timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){[weak self] _ in
                guard let self = self else { return }
                self.timer2Seconds += 1
                self.timer2Label.text = String(self.timer2Seconds)
                if self.timer2Seconds >= 20{
                    self.stopCountdownTimer()
                    self.ippon2Label.text = "1"
                    if wazaAri2Label.text == "0"{
                        self.wazaAri2Label.text = "1"
                    }else if wazaAri2Label.text == "1"{
                        self.wazaAri2Label.text = "2"
                    }
                    timer2?.invalidate()
                }
            }
        }
        
        @IBAction func osaekomi2Tapped(_ sender: UIButton) {
            // 發出按鍵嗶聲
            beepSoundPlay()
            OsaekomiButton2.isHidden = true
            OsaekomiButton1.isHidden = true
            toketaButton2.isHidden = false
            startTimer2()
        }
        
        @IBAction func toketaButton2Tapped(_ sender: UIButton) {
            // 發出按鍵嗶聲
            beepSoundPlay()
            toketaButton2.isHidden = true
            OsaekomiButton2.isHidden = false
            OsaekomiButton1.isHidden = false
            timer2?.invalidate()
            timer2Seconds = 0
            timer2Label.text = "0"
        }
    // 按下 Player1 一勝上方的透明 button
    @IBAction func ippon1Tapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果 Player1 一勝原本為 0
        if ippon1Label.text == "0"{
            // Player1 一勝的 label 改為 1
            ippon1Label.text = "1"
            // 如果 Player1 一勝原本為 1
        }else if ippon1Label.text == "1"{
            // 改為 0 重新開始
            ippon1Label.text = "0"
        }
        // 停止所有計時器
        countdownTimer?.invalidate()
        timer1?.invalidate()
        timer2?.invalidate()
    }
    // 按下 Player2 一勝上方的透明 button
    @IBAction func ippon2Tapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果 Player2 一勝原本為 0
        if ippon2Label.text == "0"{
            // Player2 一勝的 label 改為 1
            ippon2Label.text = "1"
            // 如果 Player2 一勝原本為 1
        }else if ippon2Label.text == "1"{
            // 改為 0 重新開始
            ippon2Label.text = "0"
        }
        // 停止所有計時器
        countdownTimer?.invalidate()
        timer1?.invalidate()
        timer2?.invalidate()
    }
    // 發出按鍵嗶聲
    fileprivate func beepSoundPlay() {
        // 將目前播放內容置換為按鍵聲音
        player.replaceCurrentItem(with: playerItem1)
        // 將播放器調到最開頭(0秒)
        player.seek(to: .zero)
        // 播放聲音
        player.play()
    }
    // 按下 Player1 半勝上方的透明 button
    @IBAction func wazaAri1Tapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果原本沒有半勝
        if wazaAri1Label.text == "0"{
            // 增加一個半勝
            wazaAri1Label.text = "1"
            // 如果已經有一個半勝
        }else if wazaAri1Label.text == "1"{
            // 增加一個半勝
            wazaAri1Label.text = "2"
            // 停止所有計時器
            countdownTimer?.invalidate()
            timer1?.invalidate()
            timer2?.invalidate()
        }else if wazaAri1Label.text == "2"{
            wazaAri1Label.text = "0"
        }
    }
        
    // 按下 Player2 半勝上方的透明 button
    @IBAction func wazaAri2Tapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果原本沒有半勝
        if wazaAri2Label.text == "0"{
            // 增加一個半勝
            wazaAri2Label.text = "1"
            // 如果已經有一個半勝
        }else if wazaAri2Label.text == "1"{
            // 增加一個半勝
            wazaAri2Label.text = "2"
            // 停止所有計時器
            countdownTimer?.invalidate()
            timer1?.invalidate()
            timer2?.invalidate()
        }else if wazaAri2Label.text == "2"{
            wazaAri2Label.text = "0"
        }
    }
    // 點按 Player1 指導 button
    @IBAction func firstSButtonTapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果原本 S1 隱藏
        if firstS1Label.isHidden == true{
            // S1 顯示
            firstS1Label.isHidden = false
            // 如果原本 H 顯示
        }else if firstHLabel.isHidden == false{
            // 全部隱藏
            firstHLabel.isHidden = true
            firstS2Label.isHidden = true
            firstS1Label.isHidden = true
            // 如果原本 S2 顯示
        }else if firstS2Label.isHidden == false{
            // H 顯示
            firstHLabel.isHidden = false
            // 如果原本 S1 顯示
        }else if firstS1Label.isHidden == false{
            // S2 顯示
            firstS2Label.isHidden = false
        }
    }
    
    // 點按 Player2 指導 button
    @IBAction func secondSButtonTapped(_ sender: UIButton) {
        // 發出按鍵嗶聲
        beepSoundPlay()
        // 如果原本 S1 隱藏
        if secondS1Label.isHidden == true{
            // S1 顯示
            secondS1Label.isHidden = false
            // 如果原本 H 顯示
        }else if secondHLabel.isHidden == false{
            // 全部隱藏
            secondHLabel.isHidden = true
            secondS2Label.isHidden = true
            secondS1Label.isHidden = true
            // 如果原本 S2 顯示
        }else if secondS2Label.isHidden == false{
            // H 顯示
            secondHLabel.isHidden = false
            // 如果原本 S1 顯示
        }else if secondS1Label.isHidden == false{
            // S2 顯示
            secondS2Label.isHidden = false
        }
    }
    
    @IBAction func timeSetting1Tapped(_ sender: UIButton) {
        beepSoundPlay()
        timeSetting1Button.isHidden = true
        timeSetting2Button.isHidden = false
        stepperView1.isHidden = false
        stepperView2.isHidden = false
    }
    
    @IBAction func timeSetting2Tapped(_ sender: UIButton) {
        beepSoundPlay()
        timeSetting1Button.isHidden = false
        timeSetting2Button.isHidden = true
        stepperView1.isHidden = true
        stepperView2.isHidden = true
    }
    
    
    @IBAction func stepper1Tapped(_ sender: UIStepper) {
        beepSoundPlay()
        // time 只會等於 0, 60, -60
        var time = Int(sender.value) * 60
        // 如果剩餘時間大於等於一分鐘
        if remainingTime >= 60{
            // 如果 stepper 按 +
            if time >= 60{
                remainingTime += time
            // 如果 stepper 按 -
            }else if time < 60{
                remainingTime += time
            }
            // 如果剩餘時間小於一分鐘但大於 0
        }else if remainingTime < 60 && remainingTime > 0 {
            // 如果 stepper 按 +
            if time >= 60{
                remainingTime += time
            }
        } else if remainingTime == 0 {
            // 如果 stepper 按 +
            if time >= 60{
                remainingTime += time
            }
        }
        sender.value = 0
        time = 0
        updateCountdownLabel()
        
        if remainingTime >= 600{
            countdownLabel.font = UIFont(name: "Typo Digit Demo", size: 130)
        }
        if remainingTime < 600{
            countdownLabel.font = UIFont(name: "Typo Digit Demo", size: 172)
        }
        
    }
    
    @IBAction func stepper2Tapped(_ sender: UIStepper) {
        beepSoundPlay()
        // 宣告接收 stepper 並轉換為整數的變數 time
        var time = Int(sender.value)
        // 如果剩餘時間大於等於一秒
        if remainingTime >= 1{
            // 如果stepper 點 +
            if time > 0{
                remainingTime += time // 剩餘時間+1
                // 如果stepper 點 -
            }else if time < 0{
                remainingTime += time // 剩餘時間-1
            }
        // 如果剩餘時間等於 0 秒
        }else if remainingTime == 0 {
            // 如果stepper 點 +
            if time > 0{
                remainingTime += time // 剩餘時間+1
                // 如果stepper 點 -
            }else if time < 0{
                remainingTime = 0 // 不做任何事，剩餘時間一樣為 0
            }
        }
        // stepper 數值清空
        sender.value = 0
        // time 歸 0
        time = 0
        // 更新倒數計時 label
        updateCountdownLabel()
        // 如果剩餘時間超過 10 分鐘
        if remainingTime >= 600{
            // 字體縮小
            countdownLabel.font = UIFont(name: "Typo Digit Demo", size: 130)
        }
        // 如果剩餘時間小於 10 分鐘
        if remainingTime < 600{
            // 字體保持初始大小
            countdownLabel.font = UIFont(name: "Typo Digit Demo", size: 172)
        }
    }
    // 打開設定 View
    @IBAction func settingOpen(_ sender: UIButton) {
        beepSoundPlay()
        // 顯示設定 View
        settingView.isHidden = false
        viewForHideSettingView.isHidden = false
    }
    
    
    // 全部重設
    @IBAction func resetAllTapped(_ sender: UIButton) {
        beepSoundPlay()
        ippon1Label.text = "0"
        ippon2Label.text = "0"
        wazaAri1Label.text = "0"
        wazaAri2Label.text = "0"
        firstHLabel.isHidden = true
        secondHLabel.isHidden = true
        firstS1Label.isHidden = true
        secondS1Label.isHidden = true
        firstS2Label.isHidden = true
        secondS2Label.isHidden = true
        remainingTime = 240
        updateCountdownLabel()
        if isCounting == true{
            stopCountdownTimer()
            isCounting.toggle()
        }
        timer1Seconds = 0
        timer1Label.text = "\(timer1Seconds)"
        timer2Seconds = 0
        timer2Label.text = "\(timer2Seconds)"
        if timer1?.isValid == true{
            timer1?.invalidate()
        }
        if timer2?.isValid == true{
            timer2?.invalidate()
        }
        toketaButton1.isHidden = true
        toketaButton2.isHidden = true
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    
    // 重設分數
    @IBAction func resetScoreTapped(_ sender: UIButton) {
        beepSoundPlay()
        ippon1Label.text = "0"
        ippon2Label.text = "0"
        wazaAri1Label.text = "0"
        wazaAri2Label.text = "0"
        firstHLabel.isHidden = true
        secondHLabel.isHidden = true
        firstS1Label.isHidden = true
        secondS1Label.isHidden = true
        firstS2Label.isHidden = true
        secondS2Label.isHidden = true
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    // 重設時間
    @IBAction func resetTimeTapped(_ sender: UIButton) {
        beepSoundPlay()
        remainingTime = 240
        updateCountdownLabel()
        if isCounting == true{
            stopCountdownTimer()
            isCounting.toggle()
        }
        timer1Seconds = 0
        timer1Label.text = "\(timer1Seconds)"
        timer2Seconds = 0
        timer2Label.text = "\(timer2Seconds)"
        if timer1?.isValid == true{
            timer1?.invalidate()
        }
        if timer2?.isValid == true{
            timer2?.invalidate()
        }
        toketaButton1.isHidden = true
        toketaButton2.isHidden = true
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    
    @IBAction func enterPlayer1Name(_ sender: UITextField) {
        player1Label.text = sender.text
        
    }
    
    @IBAction func enterPlayer2Name(_ sender: UITextField) {
        player2Label.text = sender.text
    }
    
    @IBAction func changeCourt(_ sender: UIButton) {
        beepSoundPlay()
        let text1 = player1Label.text
        let text2 = player2Label.text
        player1Label.text = text2
        player2Label.text = text1
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    
    @IBAction func tapToHideSettingView(_ sender: UITapGestureRecognizer) {
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    // 設定背景色為黑色
    @IBAction func changeToBlack(_ sender: UIButton) {
        beepSoundPlay()
        view.backgroundColor = UIColor.black
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    // 設定背景色為青色
    @IBAction func changetoCyan(_ sender: UIButton) {
        beepSoundPlay()
        view.backgroundColor = UIColor.cyan
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }
    // 設定背景色為橘色
    @IBAction func changeToOrange(_ sender: UIButton) {
        beepSoundPlay()
        view.backgroundColor = UIColor.orange
        settingView.isHidden = true
        viewForHideSettingView.isHidden = true
    }

    }
