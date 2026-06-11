<br/>

<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg" alt="Terraform" width="72" />

# iac-terraform

[![Multi Cloud](https://img.shields.io/badge/Cloud-OCI%20·%20AWS%20·%20Cloudflare-F80000?logo=oracle&logoColor=white)](https://github.com/dev-montyoh/iac-terraform)

**개인 프로젝트의 모든 클라우드 인프라를 Terraform으로 코드화하여 한 곳에서 관리**

---

실무에서 Terraform으로 인프라를 관리했던 경험을 살려 토이 프로젝트로 시작했습니다. 인프라 레벨에서 코드로 관리하는 방식이 유용하다고 느껴, 지금은 개인적으로 사용하는 모든 인프라를 이 프로젝트에서 관리하게 되었습니다.

현재는 **OCI를 메인 클라우드**로 사용하며, VCN·서브넷·보안 리스트 등 네트워크 구성과 Ampere A1 기반 컴퓨트 인스턴스, 예산 알림까지 모듈화하여 관리합니다. **AWS**는 IAM·예산 알림에 사용하고, EC2·SSM·Lightsail 등 컴퓨트 모듈은 코드베이스에 유지하되 현재 비활성화 상태입니다. **Cloudflare**(DNS, R2, Workers, D1)는 계속 운영 중입니다.

Terraform Cloud와 GitHub를 연동하여 실제 인프라에 배포합니다.

---

## 사용 기술

- Terraform (Terraform Cloud)
- OCI, AWS, Cloudflare (DNS / R2 / Workers)
- GitHub Actions
- Docker

---

## 주요 특징

- **Infrastructure as Code** — 모든 인프라를 코드로 정의하고 버전 관리
- **멀티 클라우드** — OCI · AWS · Cloudflare를 하나의 레포에서 통합 관리
- **모듈식 설계** — 서비스별 모듈화로 재사용성·유지보수성 확보
- **CI/CD 자동화** — Terraform Cloud VCS 연동: push → Plan → 승인 → Apply
- **비용 관리** — OCI · AWS 예산 알림으로 과금 모니터링

---

## 관리 대상 리소스

### OCI
- **컴퓨트**: Ampere A1 인스턴스 (Ubuntu 24.04 aarch64, 4 OCPU / 24GB) — 애플리케이션 + 데이터베이스 호스팅
- **네트워킹**: VCN(`APP_VPC`, `10.0.0.0/16`), 서브넷, 보안 그룹(TCP 22/80/443/5432 + 게임 서버 UDP 포트), Internet Gateway
- **비용 관리**: 월간 실사용 예산 알림 ($1 / $5 임계값)

### AWS
- **IAM**: 사용자, 그룹, 정책(AWS 관리형 + 커스텀), 역할
- **비용 관리**: 예산 알림
- *EC2 / Lightsail / SSM / Elastic IP / Key Pair 모듈은 코드베이스에 유지하되 현재 미사용 (애플리케이션을 OCI로 이전)*

### Cloudflare
- **DNS** (`montyoh.dev`): `root`, `www`, `ssh`, `db`, `payment`, 게임 서버(`valheim`, `corekeeper`, `palworld`), `xcelerate` — 모두 OCI 인스턴스로 라우팅
- **R2**: `common-static` 버킷 → `static.montyoh.dev` 커스텀 도메인 연결
- **Workers**: 서버 다운 시 점검 페이지 (`*montyoh.dev/*` 라우트)

---

## CI/CD

GitHub에 push하면 **Terraform Cloud**가 자동으로 `plan`을 실행하고, 검토·승인 후 `apply`합니다. State 파일은 Terraform Cloud에서 중앙 관리됩니다.

---

## 문서

- **[아키텍처 · 프로젝트 구조 →](ARCHITECTURE.md)** — 전체 다이어그램과 폴더 구조
- **[개발 가이드 →](CONTRIBUTING.md)** — 로컬 실행 · 브랜치 전략 · 커밋 규칙
