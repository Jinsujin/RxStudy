# My Bicycle App</br>

## 1. 개요 및 목적
RxSwift + MVVM을 공부함과 동시에 건강을 챙기기 위해 나를 위한 자전거 앱 개발</br>
<mark>추가 작성 필요</mark></br>
</br>
## 2. 필요한 기능
### 1) 대략적인 View 구성
     1-1. UITabBarController를 이용하여 Play Tab과 Record Tab을 구현
     1-2. Play Tab에서 출발지/목적지 설정 후 별도의 Controller에서 시간 측정
</br>

### 2) 각 View 기능
     2-1. Play Tab
         i. 출발지/목적지 입력
             -> 목적지 입력 직후 Mapview에서 실시간으로 경로 표기
             -> 목적지 입력 직후 거리/소요시간이 계산됨
         ii. 하단의 OK Button 선택 시 시간 측정 View로(Record Tab) 전환
<img src = "https://github.com/chalie00/MyBicycle/blob/init/Image/playtab.png">
</br>

     2-2. Record Tab
         i.Tableview에 Date, Distance, Time(걸린시간)으로 Record Data 관리
             -> Date, Distance, Time을 선택 시 Sort 기능 추가
         ii. Search 시 실시간으로 결과가 출력
<img src = "https://github.com/chalie00/MyBicycle/blob/init/Image/recordtab.png">
</br>

     2-3. TimeVC
         i. StartTime, PauseTime로 실제 자전거 주행 시 Start/Stop 기능
            -> Pause가 선택되기 전까지 StartTime Button 비활성화 (Pause 동일)
         ii. 자전거 주행 시 Hour, Min, Minute 가 실시간으로 표기
         iii. complete 선택 시 dismiss되며, Play Tab으로 이동
            -> dismiss 후 Record Tab 선택 시 현재 Data 갱신
<img src = "https://github.com/chalie00/MyBicycle/blob/init/Image/timevc.png">

## 3. RxSwift 구현이 예상되는 부분
     3-1. Play Tab
          i. 출발지/목적지 입력에 따른 지도, 거리, 소요 시간 갱신
     3-2. Record Tab
          i. Search 시 typing된 input에 따른 TableView 갱신
     3-3. TimeVC
          i. TBD

 
## 5주차 현 진행 상태 2022.01.14(금)
  1. 구현된 Function</br>
     ### 1) StartTextField에서 지명 입력 후 Enter -> 해당하는 지명에 Annotation Pin 표시 (EndTextField 동일)</br>
     ### 2) Start/End에 대한 Annotation Pin 설정 후 하단의 Start Button 선택 시 Start/End Pin이 Mapview에 표기됨</br>
     #### <span style="color:lightgreen">[UserSession] maps short session requested but session sharing is not enabled 가 발생하며, 경로가 그려지지 않음</span>
     #### StackOverflow에 최근 동일 질문이 있으나 해결책 없음 https://stackoverflow.com/questions/70472607/ios-maps-issue-routes-not-showing
     #### <span style="color:red">아... Delegate가 Call되지 않아 확인하니 mapview Delegate를 설정하지 않았음</span>
     ### 3) 경로에 대한 설정 중 자전거에 대한 항목이 없음
     ```
     directionRequest.transportType = .walking
     ```
     ### 4) Start/End Textfield가 nil이 아닌 경우 재 입력 시 기존 Mapview에서 해당 하는 Testfield의 Annotation을 삭제함
 2. 미비한 Function
    ### 1) MVVM Pattern을 만족하지 못함
    ### 2) TextField Value 변화에 의한 Mapview 갱신
    ### <span style="color:lightgreen">Textfield에 대한 변화를 감지는 가능하나 Test 주소에서 위도, 경도를 취득하기 힘듬 (텍스트가 전부 입력되지 않는 상황이 있음)</span>
    향후 계획</br>
    i) Textfield가 FirstResponse가 아닌 경우에만 신규 Annotation 갱신</br>
    ii) 임의의 주소 Array를 설정 후 Textfield에서 text 입력 시 Dropdown Menu에서 Array를 불러와 주소 선택 시 Annotation 갱신</br>
    


