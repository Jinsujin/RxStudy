DoItSomeday

## 2022-01-17

### Model
* CoreData를 이용한 TODO 모델 개발

### View
* 메인화면
  * 설정, 정렬 기능이 있는 상단 뷰
    * 정렬은 UIPickerView로 처리
  * TODO 목록이 보여지는 테이블뷰 
      * DataSource는 RxSwift를 활용, ViewModel의 TODO Subject로 바인딩
      * 왼쪽으로 스와이프하여 삭제, 오른쪽으로 스와이프하여 알림 ON/OFF, 수정 메뉴 추가
      * 남은 시간에 따라 글씨 색 변경
  * TODO 추가 버튼
    * RxSwift를 활용하여 테이블뷰 끝단에서 숨겨지도록 처리
      * 애니메이션이 왜 작동하지 않는지는...
      
### ViewModel
* RxSwift
  * todo 목록에 관한 Subject (테이블뷰 갱신용)
  * sort 타입에 관한 Subject (테이블뷰 갱신용)
* TODO 관리 (삭제, 수정)

### Service (ETC?)
* 깔끔한 코드를 위한 몇가지 Extension
* 더미데이터를 위한 TODO 작성 함수, 그 외 D-Day계산을 위한 몇가지 기능들
