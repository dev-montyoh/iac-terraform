# backend-iac-terraform
개인 프로젝트에 쓰이는 클라우드 환경의 코드형 인프라(IaC) 리포지토리

## CICD 구성
![CICD](assets/cicd.drawio.png)

---
## 주의사항
1. 각 환경별로 pull_request 및 push 를 통해 관리하고, Terraform Cloud 를 통해 관리하도록 한다.  
   - Terraform Cloud URL: https://app.terraform.io/app/organizations
2. `Admin`그룹은 콘솔상에서 직접 관리한다.

---
## Getting Started
깃허브 URL: https://github.com/dev-montyoh/backend-iac-terraform  
HTTPS clone URL: https://github.com/dev-montyoh/backend-iac-terraform.git  
깃허브 프로젝트 URL: https://github.com/users/dev-montyoh/projects/4  

---
## Local 개발 환경 구성
주의! Terraform Cloud 를 통해 반영되게끔 할 것

### AWS 계정 구성  
`aws configure --profile 프로필명`

### Terraform 초기화
`terraform init`
    
### Terraform 검증
`terraform validate`

### Terraform 적용
   - aws 프로필이 default로 설정 시  
       `terraform apply`
   - aws 프로필을 직접 지정할 시  
       `AWS_PROFILE=프로필명 terraform apply`

### IaC 적용을 취소할 시 다음 명령어 실행
`terraform apply -destroy`  
모든 인프라 정보가 사라지므로 가급적 `terraform apply`를 통한 업데이트 권장


---
## Git Flow
### branch 구조
```
origin
    ㄴ master
    ㄴ develop
    ㄴ features
        ㄴ branch1...
        ㄴ branch2...
```
```
1. 각 브랜치들은 backend-api-server 리포지토리의 브랜치와 동일하게 환경 구성을 한다.

2. 개발 완료 루 develop 으로 Pull Request 생성, Merge 한다.
```
backend-api-server URL: https://github.com/Monty-Oh/backend-api-server
