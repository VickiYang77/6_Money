//
//  HomeView.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import UIKit

class HomeView: UIView {
    private var viewModel: HomeViewModel! {
        didSet {
            print("vvv_viewModel")
            balanceLabel.text = balanceString
            drawPercentRing()
        }
    }
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var percentRingView: UIView!
    
    // 進度條寬度
    let lineWidth: Double = 40
    
    // 半徑
    lazy var radius: Double = (0.8 * percentRingView.bounds.size.width) / 2.0
    
    lazy var circleView: UIView = {
        let viewWidth = 2 * (radius + lineWidth)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth))
        view.center = CGPoint(x: percentRingView.bounds.width/2.0, y: percentRingView.bounds.height/2.0)
        return view
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel(frame: percentRingView.bounds)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.text = balanceString
        return label
    }()
    
    var balanceString: String {
        "剩餘 $ \(viewModel.budget - viewModel.expense)\n\n已支出 \(percentage) %"
    }
    
    var percentage: Int {
        (viewModel.expense * 100) / viewModel.budget
    }
    
    init(frame: CGRect, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        loadNibContent()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNibContent() {
        let view = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! UIView
        view.frame = self.frame
        addSubview(view)
    }
    
    func setupUI() {
        budgetLabel.text = "$ \(viewModel.budget)"
        expenseLabel.text = "$ \(viewModel.expense)"
    }
    
    func reloadView(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    override func layoutSubviews() {
        print("vvv_layoutSubviews")
        super.layoutSubviews()
        self.layoutIfNeeded()
        drawPercentRing()
    }
    
    func drawPercentRing() {
        print("vvv_drawPercentRing")
        // 一度
        let aDegree = Double.pi / 180
        
        // 起始角度 (正上方為270度)
        let startDegree: Double = 270
        
        // 預算圓環軌道
        let trackPath = UIBezierPath(ovalIn: CGRect(x: lineWidth, y: lineWidth, width: radius*2, height: radius*2)) // 在指定的矩形範圍內繪製橢圓形
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackPath.cgPath // 指定要繪製的形狀路徑
        trackLayer.strokeColor = UIColor.topicGreen.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor // 填充形狀的內部區域(中心圓形顏色)
        
        // 進度條圓環
        let endDegree = startDegree + 360 * Double(percentage) / 100 // 結束角度
        let runningPath = UIBezierPath(arcCenter: CGPoint(x: lineWidth + radius, y: lineWidth + radius), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true) // 在指定中心點和半徑範圍內繪製弧形或圓弧
        let runningLayer = CAShapeLayer()
        runningLayer.path = runningPath.cgPath
        runningLayer.strokeColor  = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1).cgColor
        runningLayer.lineWidth = lineWidth
        runningLayer.fillColor = UIColor.clear.cgColor
        
        circleView.layer.addSublayer(trackLayer)
        circleView.layer.addSublayer(runningLayer)
        percentRingView.addSubview(circleView)
        percentRingView.addSubview(balanceLabel)
    }
}
