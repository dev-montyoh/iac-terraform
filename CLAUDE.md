# iac-terraform

개인 프로젝트의 모든 클라우드 인프라를 Terraform으로 코드화한 멀티 클라우드 IaC 저장소.
**OCI**(메인 컴퓨트·네트워크), **AWS**(IAM·예산), **Cloudflare**(DNS·R2·Workers·D1)를 하나의 루트 모듈에서 관리한다.

전체 개요는 [README.md](README.md), 기여 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md) 참고. 이 문서는 이 저장소에서 작업할 때 알아야 할 규약·명령·함정만 정리한다.

## 기술 스택

- Terraform (>= 1.0.0). 프로바이더 버전은 [main.tf](main.tf)에 고정: `aws ~> 4.16`, `cloudflare 5.11.0`, `oci 8.15.0`
- 상태(state)와 apply는 **Terraform Cloud**가 VCS 연동으로 관리. GitHub push → Plan → 승인 → Apply
- 애플리케이션 서비스는 OCI 인스턴스 위에서 Docker(Compose + Swarm Stack)로 구동

## 프로젝트 구조

```
main.tf                # 루트: 프로바이더 + aws/oci/cloudflare 모듈 호출
variable.tf            # 루트 변수 선언
*.auto.tfvars          # users/policies/groups 값 (비밀 아님, 커밋됨)
oci/                   # OCI: networking(VCN·서브넷·보안리스트), instance(Ampere A1), budget
aws/                   # AWS: iam, billing (ec2/lightsail/ssm 등은 코드 유지·현재 미사용)
cloudflare/            # Cloudflare: DNS 레코드, r2/, workers/, d1/
scripts/               # 인스턴스 User Data 셸 스크립트
docker-compose.yml     # postgres·redis (Compose)
docker-compose.stack.yml  # 애플리케이션 서비스 (Docker Swarm Stack)
.github/workflows/     # manual-redeploy-* 수동 재배포 워크플로우
```

## 자주 쓰는 명령어

```bash
terraform init        # 초기화
terraform validate    # 문법·구성 검증
terraform fmt         # 포맷 (커밋 전 실행)
terraform plan        # 변경 미리보기 (dry-run)
```

- **`terraform apply` / `destroy`는 로컬에서 실행하지 말 것.** apply는 Terraform Cloud(VCS 파이프라인)를 통한다. 로컬 apply는 비상 상황에서만 신중히.

## Git·커밋 규약

- 브랜치: `master`(운영) 에서 `feature/*` 분기 → PR → merge. **`master`에 직접 커밋 금지**
- 커밋 메시지: [Conventional Commits](https://www.conventionalcommits.org/), subject는 한국어
  - `feat`(리소스/기능 추가) · `fix`(오류 수정) · `refactor`(구조 개선) · `chore`(유지보수) · `docs`(문서)
  - 예: `feat: OCI Ampere 인스턴스 모듈 추가`

## 배포 메커니즘 (중요)

- **postgres·redis**: `docker-compose.yml` (Docker Compose)
- **나머지 앱 서비스**: `docker-compose.stack.yml` (Docker Swarm Stack, 스택명 `application-services`)
- `.github/workflows/manual-redeploy-*.yml` 는 GitHub Actions `workflow_dispatch`로 실행되며, `ssh.montyoh.dev`(OCI 인스턴스)에 SSH로 접속해 배포한다.
- ⚠️ **재배포 워크플로우는 `docker-compose.stack.yml`을 `master`의 raw URL에서 내려받는다.** 즉 이 파일 변경은 **`master`에 merge된 뒤에야** 실제 배포에 반영된다. feature 브랜치 상태로는 적용 안 됨.
- `manual-redeploy-vikunja.yml`은 재배포 외에 Vikunja 전용 DB/유저 생성, R2 백업, 백업 cron 등록까지 수행한다.

## 하지 말 것 / 주의

- **비밀값(프로바이더 자격증명·토큰·비밀번호)을 코드나 tfvars에 하드코딩하지 말 것.** 실제 시크릿은 Terraform Cloud 변수와 별도 비공개 저장소(`dev-montyoh/secrets-store`)에서 주입된다. 커밋된 `*.auto.tfvars`에는 비밀이 아닌 IAM 유저/정책/그룹 값만 있다.
- OCI가 메인이다. `aws/`의 ec2·lightsail·ssm·elastic_ip·key_pair 모듈은 **의도적으로 미사용 상태로 유지**되는 것이니 "죽은 코드"로 오해해 삭제하지 말 것.
- 프로바이더 버전은 고정돼 있다. 업그레이드는 별도 논의 후 진행.
