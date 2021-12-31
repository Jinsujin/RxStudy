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

 
