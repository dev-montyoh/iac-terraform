# 개발 가이드

## 사전 요구사항

- [Terraform](https://www.terraform.io/downloads.html) (1.0.0 이상)
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS 계정 및 Access Key/Secret Key 설정 (`aws configure`)

## 로컬 환경에서 실행

> **⚠️ 주의**
> 이 프로젝트는 Terraform Cloud를 통한 워크플로우를 권장합니다. 로컬 환경에서의 `apply`는 테스트 및 비상 상황에서만 신중하게 사용해야 합니다.

1.  **Terraform 초기화**
    ```bash
    terraform init
    ```

2.  **Terraform 유효성 검사**
    ```bash
    terraform validate
    ```

3.  **실행 계획 검토 (Dry-Run)**
    ```bash
    terraform plan
    ```

4.  **인프라 적용**
    ```bash
    terraform apply
    ```

5.  **인프라 삭제** *(주의: 모든 인프라가 삭제됩니다)*
    ```bash
    terraform destroy
    ```

## Git 브랜치 전략

- **`master`**: 최종 릴리즈 브랜치 (운영 환경)
- **`develop`**: 통합 개발 브랜치
- **`feature/*`**: 기능 개발 브랜치. `develop` 브랜치에서 분기 후 Pull Request를 통해 Merge합니다.

## 커밋 메시지 규칙

[Conventional Commits](https://www.conventionalcommits.org/) 규칙을 따릅니다.

```
<type>: <subject>
```

### Type

| type | 설명 |
|---|---|
| `feat` | 새로운 리소스 또는 기능 추가 |
| `fix` | 오류 수정 |
| `refactor` | 기능 변경 없이 코드 구조 개선 |
| `chore` | 변수 정리, 파일 이동 등 유지보수 |
| `docs` | README, CONTRIBUTING 등 문서 수정 |

### 예시

```
feat: Cloudflare R2 버킷 추가
fix: Lightsail 방화벽 포트 설정 오류 수정
refactor: EC2 모듈을 Lightsail로 전환
chore: 미사용 변수 VPC_ID 제거
docs: README 프로젝트 구조 업데이트
```
