//
//  Stack.swift
//  useGPS
//
//  Created by Daichi Yoshikawa on 2020/09/14.
//  Copyright © 2020 Daichi Yoshikawa. All rights reserved.
//

import Foundation
import MapKit

//MKPointAnnotationのためのスタッククラス
class Stack {
  var stackArray = [MKPointAnnotation]()
    //pushメソッド
    func push(pinPush: MKPointAnnotation){
      self.stackArray.append(pinPush)
    }
    
    
    //popメソッド
    func pop() -> MKPointAnnotation? {
      if self.stackArray.last != nil {
        var Return = self.stackArray.last
        self.stackArray.removeLast()
        return Return!
      } else {
        return nil
      }
    }
}
