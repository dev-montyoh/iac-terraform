# 개발 가이드

## 사전 요구사항

- [Terraform](https://www.terraform.io/downloads.html) (1.0.0 이상)
- 각 프로바이더 자격 증명 (Terraform Cloud 변수로 관리하며, 로컬 실행 시 환경변수/tfvars 필요)
  - **OCI**: Tenancy/User OCID, API Key Fingerprint, Private Key, Region
  - **Cloudflare**: Email, API Token, Account/Zone ID
  - **AWS**: Access Key/Secret Key — IAM·예산 모듈에 사용 (`aws configure`)

## 로컬 환경에서 실행

> **주의**
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

## GitHub Actions 수동 배포

서비스별 수동 재배포 워크플로우가 있습니다. GitHub Actions → `Run workflow`로 실행합니다.

| 워크플로우 | 설명 |
|---|---|
| `manual-redeploy-plane.yml` | Plane 스택 전체 재배포 (DB 생성 포함) |
| `manual-redeploy-postgres.yml` | PostgreSQL 컨테이너 재시작 |
| `manual-redeploy-redis.yml` | Redis 컨테이너 재시작 |

---

## Git 브랜치 전략

- **`master`**: 최종 릴리즈 브랜치 (운영 환경)
- **`feature/*`**: 기능 개발 브랜치. `master` 브랜치에서 분기 후 Pull Request를 통해 Merge합니다.

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
feat: OCI Ampere 인스턴스 모듈 추가
fix: Cloudflare DNS 레코드 content 오류 수정
refactor: 애플리케이션 서버를 AWS EC2에서 OCI로 전환
chore: 미사용 변수 정리
docs: 아키텍처 문서 분리 및 README 개편
```
