//
//  ViewController.swift
//  SQLTest
//
//  Created by 김종권 on 2020/05/09.
//  Copyright © 2020 imustang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 필수로 필요한 객체 : 각각 DB와 연결할 객체와, 컴파일 된 SQL문을 담을 객체
        var db: OpaquePointer? = nil /// SQLite 연결 정보를 담을 객체
        var stmt: OpaquePointer? = nil /// 컴파일 된 SQL
        
        /// 파일매니저객체 -> 앱 내의 디렉토리 탐색 -> "db.sqlite"파일의 디렉토리 획득
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        /// 꼭 문서 디렉토리에 저장하는 이유 : iCloud를 사용할 경우에도 백업 대상이 되는 디렉토리가 문서디렉토리
        /*위와 동일한 구문
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let dbPath = path.strings(byAppendingPaths: ["db.sqlite"])[0]
         */
        
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        
        /// 5가지 기본
        /*
        sqlite3_open(dbPath, &db) /// DB connection
        sqlite3_prepare(db, sql, -1, &stmt, nil) /// get SQL be compiled - stmt
        sqlite3_step(stmt) /// excute SQL
        sqlite3_finalize(stmt) /// unlock stmt in DB
        sqlite3_close(db) /// close DB connection
        */
        
        /// 5가지 응용
        if sqlite3_open(dbPath, &db) == SQLITE_OK { /// DB is connected?
            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK { /// comliling SQL is successed?
            
                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("Create Table Success")
                }
                sqlite3_finalize(stmt)
                
            } else {
                print("Prepare Statement is Failed")
            }
            
            sqlite3_close(db)
            
        } else {
            print("DB connection is failed")
            return
        }
        
        /// db확인 :  terminal열어서 open [밑주소]
        print("dir = \n\(dbPath)")
    }


}

