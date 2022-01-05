# 언젠간 하겠지

* 예전에 기획했었던 TODO App
* D-Day가 다가올수록 흐릿해지며, D-Day가 넘어가면 목록에서 사라짐
  * ON/OFF 가능
  * OFF시 로컬 Noti
* 목록화면과, 상세화면, 쓰기화면, 설정화면 총 네가지의 뷰로 구성
* 예전에 작성해두었던 목업은 [링크 참조](https://ovenapp.io/view/Mw0yxJ1X58QgVfOvi3fn0XIbhQYSWysx/4Rn9r
)

## 기능
* 목록화면
  * 테이블뷰
  * 스와이프로 ON/OFF설정, 삭제 가능
  * 제목 노출
* 상세화면
  * 제목
  * 숨김 여부
    * 알림 여부
  * 날짜
  * 내용
  * 수정, 삭제 버튼
    * 상세화면과 쓰기화면은 따로 구분 됨
* 쓰기화면
  * 제목
  * 숨기지않기 체크박스
    * 숨기지 않는 경우, 알림 기능 추가
  * 날짜
  * 내용 입력 
  * 등록 버튼
* 설정
  * 목록에 D-Day 표시여부

## 구현 모델
* TODO 모델
  * Core Data 이용 예정
    * 여유가 된다면, [CloudKit](https://developer.apple.com/icloud/cloudkit/) 적용 예정

## 도입 예정 기술
* MVVM
* XCTest(유닛 테스트)
* Core Data
* SnapKit
* Toast
* (여유가 된다면)CloudKit