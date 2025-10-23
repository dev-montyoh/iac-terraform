1# Terraform으로 관리하는 클라우드 인프라 (AWS & Cloudflare)

개인 프로젝트에 필요한 클라우드 인프라를 Terraform을 사용하여 코드형 인프라(Infrastructure as Code, IaC)로 관리하는 리포지토리입니다. AWS와 Cloudflare 리소스를 코드로 정의하고, CI/CD 파이프라인을 통해 배포를 자동화하여 일관성 있고 반복 가능한 인프라 환경 구축을 목표로 합니다.

## 주요 특징

- **Infrastructure as Code**: Terraform을 사용하여 모든 인프라를 코드로 명확하게 정의하고 버전 관리합니다.
- **Multi-Provider**: AWS의 핵심 서비스와 Cloudflare의 DNS, 보안 기능을 통합 관리합니다.
- **모듈식 설계**: EC2, IAM, SSM 등 서비스별 모듈화를 통해 코드의 재사용성과 유지보수성을 극대화했습니다.
- **CI/CD 자동화**: GitHub Actions를 활용하여 Pull Request 생성 시 코드 유효성을 자동으로 검사하고, 배포 프로세스를 표준화합니다.
- **형상 관리**: 변수 파일을 기능(`users`, `policies` 등)에 따라 분리하여 관리의 편의성을 높였습니다.

## 프로젝트 구조

```
/
├── main.tf                     # Terraform 실행의 시작점, 전체 모듈 구성
├── variable.tf                 # 루트 모듈에서 사용하는 변수 선언
├── *.auto.tfvars               # 사용자, 정책 등 환경별 변수 값 자동 주입
│
├── aws/                        # AWS 관련 리소스 모음
│   ├── aws.tf                  # Provider 및 공통 리소스 정의
│   ├── ec2/                    # EC2, 보안 그룹 등
│   ├── iam/                    # IAM 사용자, 그룹, 정책, 역할
│   ├── ssm/                    # Systems Manager (문서, 유지보수 창)
│   ├── billing/                # 비용 및 예산 관리
│   └── ...
│
├── cloudflare/                 # Cloudflare 관련 리소스 모음
│   ├── cloudflare.tf           # Provider 및 리소스 정의
│   └── variable.tf
│
├── scripts/                    # EC2 User Data 등 셸 스크립트
├── .github/workflows/          # GitHub Actions 워크플로우
│   └── pull-request-develop.yaml
└── README.md
```

## 관리 대상 리소스

- **AWS**
  - **컴퓨팅**: EC2 인스턴스, Key Pair
  - **네트워킹**: 보안 그룹(Security Group), Elastic IP
  - **보안 및 자격 증명**: IAM 사용자, 그룹, 역할, 정책
  - **운영 관리**: SSM 문서, 유지보수 창, 대상 및 작업
  - **비용 관리**: AWS 예산(Budget) 및 결제 알림
- **Cloudflare**
  - DNS 레코드, 보안 설정 등 (필요시 확장)

## CI/CD 파이프라인

![CICD](assets/cicd.drawio.png)

이 프로젝트는 GitHub Actions를 사용하여 CI/CD 파이프라인을 구축했습니다.

- **Trigger**: `develop` 브랜치에 Pull Request가 생성될 때 워크플로우가 실행됩니다.
- **Jobs**:
  1. **Code Checkout**: 리포지토리의 코드를 가져옵니다.
  2. **Terraform Setup**: Terraform 실행 환경을 설정합니다.
  3. **Terraform Init**: 백엔드 설정을 제외하고 Terraform 작업 디렉터리를 초기화합니다.
  4. **Terraform Validate**: Terraform 코드의 문법이 유효한지 검사합니다.

이 파이프라인을 통해 `develop` 브랜치에 병합될 코드의 정합성을 사전에 보장합니다.

## 시작하기

### 사전 요구사항

- [Terraform](https://www.terraform.io/downloads.html) (1.0.0 이상)
- [AWS CLI](https://aws.amazon.com/cli/)
- AWS 계정 및 Access Key/Secret Key 설정 (`aws configure`)

### 로컬 환경에서 실행

> **⚠️ 주의**
> 이 프로젝트는 Terraform Cloud 또는 CI/CD를 통한 워크플로우를 권장합니다. 로컬 환경에서의 `apply`는 테스트 및 비상 상황에서만 신중하게 사용해야 합니다.

1.  **Terraform 초기화**
    Terraform이 필요한 플러그인(Provider)을 다운로드하고 초기 설정을 진행합니다.
    ```bash
    terraform init
    ```

2.  **Terraform 유효성 검사**
    Terraform 코드의 문법이 유효한지 검사합니다.
    ```bash
    terraform validate
    ```

3.  **실행 계획 검토 (Dry-Run)**
    인프라에 적용될 변경 사항을 미리 확인합니다.
    ```bash
    terraform plan
    ```

4.  **인프라 적용**
    계획된 변경 사항을 실제 인프라에 적용합니다.
    ```bash
    terraform apply
    ```

5.  **인프라 삭제**
    Terraform으로 생성한 모든 리소스를 삭제합니다. **(주의: 모든 인프라가 사라지므로 절대적으로 신중하게 사용해야 합니다)**
    ```bash
    terraform destroy
    ```

## Git 브랜치 전략

- **`master`**: 최종 릴리즈 버전이 저장되는 브랜치 (운영 환경)
- **`feature/*`**: 기능 개발을 위한 브랜치. `master` 브랜치에서 분기 후 Pull Request 및 Merge를 합니다.
