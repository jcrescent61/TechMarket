# TechMarket

<br>

## 📱 앱 미리보기

|**메인 화면** | **상세 화면** |
| -------- | -------- |
|![Simulator Screen Recording - iPhone 14 - 2023-02-14 at 21 08 31](https://user-images.githubusercontent.com/80380535/218734911-f93bde56-6fed-4b54-952d-d5a744c6e9d2.gif)|![Simulator Screen Recording - iPhone 14 - 2023-02-14 at 21 08 55](https://user-images.githubusercontent.com/80380535/218734635-6b2fd136-079f-45f3-867b-485018f41abf.gif)|

<br>

## 폴더 구조
- **Entry**: AppDelegate과 SceneDelegate이 있습니다.
- **Model**: 모델의 집합입니다.
- **Network**: API, REST을 포함합니다.
- **Domain**: 화면 별 구현사항을 포함합니다.
- **Extension**: 커스텀한 Extension의 집합입니다.
- **SupportFile**: Assets, plist파일 등이 있습니다.


<br>

## 구현 내용

### Testable한 MVVM 구조
Testable한 ViewModel을 구현하기 위해 POP 구조로 MVVM을 설계하였습니다.
또한 ViewModel이 소유하는 Network객체를 Interface화 하여 DI형태로 구현하였습니다.

### Network 객체 구현 및 확장성 있는 Server API 관리
RESTful API의 학습을 위해 Network 객체를 직접 구현했습니다.

