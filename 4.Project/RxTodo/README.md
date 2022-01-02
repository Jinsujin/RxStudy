# 📱 TODO App

## 기능

- [ ] 할일 추가
  1. `+` 버튼 클릭
  2. 추가 화면(view controller) 를 띄우기
  3. `Title` 을 키보드로 입력한다
  4. `확인` 버튼 클릭
  5. 추가화면(view controller) 가 사라지고 ListViewController 에 추가된 데이터 반영
- [ ] 할일 수정
  - 수정 화면(view controller) 를 띄워 에서 수정
- [ ] 할일 삭제
  1. 셀의 `삭제 버튼` 을 터치한다
  2. 삭제 여부를 묻는 경고창을 띄운다
  3. 확인 버튼을 눌러 저장된 데이터를 삭제
  4. 뷰 화면에 반영

<br/>

## 목표

- [ ] **아키텍쳐 레이어 나누기**
  - Massive View Controller 탈피
- [ ] **테스트 코드 작성(TDD)**
- [ ] **리펙토링을 통한 점진적인 개선**
- [ ] **DB**
      <br/>
      역활과 구현을 나눠 느슨한 결합을 만들어 본다. (DB를 바꿔 끼워보자)
  1. Array 로 로컬에 저장
  2. Core Data
  3. Firebase Database
- [ ] **ReactiveX 맛보기**

<br/>

## 참고 자료

- [RxSwift Document](https://github.com/ReactiveX/RxSwift/tree/main/Documentation)
- [Coordinator Pattern(MVVM)](https://benoitpasquier.com/data-between-views-using-coordinator-pattern-swift/#)
- [MVVM 패턴을 적용한 통화 앱](https://github.com/popei69/TemplateProject)
- [클린아키텍쳐를 적용한 예제(RxSwift)](https://github.com/sergdort/CleanArchitectureRxSwift)
