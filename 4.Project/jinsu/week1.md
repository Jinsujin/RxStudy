# 1주차 진행

> 기능을 구현을 우선 작업했습니다.
> 앞으로 리펙토링 해나가며 구조를 변경하고 Rx 를 도입할 예정입니다.

<br/>

### ViewModel

- 화면에 보여줄 데이터를 ViewModel 에서 처리합니다.
- ViewModel 은 생성자에서 Repository 를 주입받아 사용합니다.

### Repository

- Repository 는 DB 를 바꿔끼울 수 있도록 하기위한 레이어 입니다.
- 현재는 Array 로 데이터를 저장하고 있습니다
- 다음 작업에서 CoreData 로 변경할 예정입니다.

### 2주차 할 일

- [ ] UnitTest
- [ ] 할일 수정
- [ ] 디비를 바꿔끼우기 위한 설계변경
- [ ] CoreData 적용

<br/>
<br/>

## 🧩 Project Check List

### 기능

- [x] 할일 추가
- [ ] 할일 수정
  - 수정 화면(view controller) 를 띄워 에서 수정
- [x] 할일 삭제
- [x] 할일 체크

<br/>

### 목표

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
