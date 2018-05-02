//
//  PdfViewController.swift
//  MQF
//
//  Created by elmo on 4/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pdf = PDFView(frame: UIScreen.main.bounds)
        let url = Bundle.main.url(forResource: "1T-38A-1", withExtension: "pdf")
        pdf.document = PDFDocument(url: url!)
        view.addSubview(pdf)
        
        if let page10 = pdf.document?.page(at: 100) {
            pdf.go(to: page10)
        }

    }


}
