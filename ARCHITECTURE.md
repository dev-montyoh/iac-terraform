# 아키텍처 · 프로젝트 구조

[← README로 돌아가기](README.md)

## 프로젝트 구조

```
/
├── main.tf                  # 루트: 프로바이더 + aws/oci/cloudflare 모듈 구성
├── variable.tf              # 루트 변수 선언
├── *.auto.tfvars            # users / policies / groups 변수 값 자동 주입
│
├── oci/                     # Oracle Cloud (OCI)
│   ├── oci.tf               # 모듈 호출 (networking, instance, budget)
│   ├── networking/          # VCN, 서브넷, 보안 그룹, IGW
│   ├── instance/            # Ampere A1 인스턴스 (앱 + DB)
│   └── budget/              # 예산 알림
│
├── aws/                     # AWS (IAM · 예산)
│   ├── aws.tf               # 모듈 호출 (iam, billing)
│   ├── iam/                 # 사용자·그룹·정책·역할
│   ├── billing/             # 예산 알림
│   └── ec2/ lightsail/ ssm/ elastic_ip/ key_pair/   # 코드 유지, 현재 미사용
│
├── cloudflare/              # Cloudflare
│   ├── cloudflare.tf        # DNS 레코드 + 모듈 호출 + Workers
│   ├── r2/                  # R2 오브젝트 스토리지 (static.montyoh.dev)
│   ├── workers/             # 점검(maintenance) 페이지 Worker
│   └── d1/                  # D1 서버리스 DB (코드 유지)
│
├── scripts/                 # 인스턴스 User Data 셸 스크립트
├── docs/                    # 문서
└── README.md
```

## CI/CD 파이프라인

![CICD](https://static.montyoh.dev/cicd.drawio.png)

**Terraform Cloud**의 VCS 연동을 통해 파이프라인을 구성합니다.

- **Trigger**: GitHub 레포지토리에 push되면 Terraform Cloud에서 워크플로우가 자동 실행됩니다.
- **Flow**:
  1. **Plan** — 변경 사항을 분석하여 적용될 내용을 미리 확인
  2. **Apply** — Plan 검토 후 승인 시 실제 인프라에 반영
- **State**: Terraform Cloud에서 중앙 관리
