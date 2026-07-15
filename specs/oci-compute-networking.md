# Spec: OCI 컴퓨트 + 네트워킹

> **상태**: 현행 반영 (as-built) · **대상 모듈**: [`oci/`](../oci) · **최종 갱신**: 2026-07-15
>
> 이 문서는 OCI 애플리케이션 인스턴스와 그 네트워크 구성의 **의도(source of truth)** 를 기술한다.
> 코드([`oci/oci.tf`](../oci/oci.tf), [`oci/networking/`](../oci/networking), [`oci/instance/`](../oci/instance))는 이 명세의 구현이며, 요구가 바뀌면 **이 문서를 먼저 고치고** 코드를 맞춘다.

## 1. 목적

개인 프로젝트의 모든 애플리케이션과 데이터베이스를 단일 OCI 인스턴스 한 대에서 호스팅한다.
OCI **Always Free(Ampere A1)** 한도 안에서 최대 스펙을 뽑아 비용 0원으로 운영하는 것이 목표다.

## 2. 요구사항

### 2.1 컴퓨트 (`oci/instance`)

| 항목 | 값 | 비고 |
|---|---|---|
| Shape | `VM.Standard.A1.Flex` | Ampere A1 (aarch64) |
| OCPU / 메모리 | **4 OCPU / 24 GB** | Always Free A1 최대치 |
| 부트 볼륨 | **200 GB** | 아래 3.1 제약 참고 |
| 이미지 | Ubuntu 24.04 (aarch64) | OCID는 코드에 고정, 리전 종속 |
| Availability Domain | `DUoH:AP-CHUNCHEON-1-AD-1` | 춘천 리전 AD-1 |
| 퍼블릭 IP | 할당함 (`assign_public_ip = true`) | Cloudflare DNS가 이 IP를 참조 |
| SSH | 공개키 주입 (`ssh_authorized_keys`) | 키는 변수로 주입, 코드에 없음 |
| 부트스트랩 | `scripts/oci_application_instance_userdata.sh` | `user_data`로 base64 주입, GHCR 토큰 전달 |

**불변 조건**
- 인스턴스는 `lifecycle { prevent_destroy = true }` 로 **실수 삭제를 차단**한다. 재생성이 필요하면 이 명세를 고쳐 의도를 명시한 뒤 진행한다.

### 2.2 네트워킹 (`oci/networking`)

| 리소스 | 값 |
|---|---|
| VCN | `APP_VPC`, CIDR `10.0.0.0/16` |
| 서브넷 | `10.0.1.0/24` (퍼블릭) |
| Internet Gateway | 활성, 라우트 `0.0.0.0/0 → IGW` |
| Egress | 전체 허용 (all protocol → `0.0.0.0/0`) |

**Ingress 허용 포트** (source `0.0.0.0/0`)

- **TCP**: `22`(SSH), `80`(HTTP), `443`(HTTPS), `5432`(PostgreSQL), `6379`(Redis)
- **UDP**: `27015`, `2456`, `2457`, `2458`, `8211` — 게임 서버 (발헤임 2456–2458 / 팰월드 8211 / 27015 등)

### 2.3 예산 알림 (`oci/budget`)

- 월간 **실사용(actual spend)** 예산, 한도 5 USD
- 알림 임계값 2단계: **1 USD 초과**, **5 USD 초과** → `BUDGETS_ALARM_TARGETS`(이메일)로 통지

## 3. 제약 / 주의 (non-obvious)

### 3.1 Always Free 스토리지 한도 — 부트 볼륨 200GB의 의미
OCI Always Free 블록 스토리지 총한도는 **200 GB이며, 부트 볼륨과 블록 볼륨이 합산**된다.
이 인스턴스가 부트 볼륨으로 200GB를 전부 쓰므로 **추가 블록 볼륨을 붙이면 과금**된다.
또한 인스턴스를 재생성/삭제할 때 **고아(orphan) 부트 볼륨이 남으면 그것도 한도를 차지해 과금**될 수 있으니 정리 필요.

### 3.2 보안 — Ingress가 전부 `0.0.0.0/0`
DB 포트(5432/6379)를 포함해 모든 ingress가 인터넷 전체에 열려 있다. 현재는 편의상 이렇게 두지만,
DB/캐시는 원칙적으로 공개 노출 대상이 아니다. 강화하려면 소스 CIDR 제한 또는 애플리케이션 서브넷 내부로 한정하는 것을 별도 과제로 검토한다. (본 명세는 현행을 기술할 뿐, 이 개방을 "권장"하지 않는다.)

### 3.3 리전 종속 값
`image_id`(OCID)와 `availability_domain`은 **춘천 리전에 고정**돼 있다. 리전을 옮기면 두 값 모두 교체해야 한다.

## 4. 인터페이스 (모듈 입출력)

- **입력**: `OCI_TENANCY_OCID`(=compartment), `OCI_SSH_PUBLIC_KEY`, `GHCR_TOKEN`, `BUDGETS_ALARM_TARGETS`
- **출력**: `app_server_public_ip` — 루트에서 `cloudflare` 모듈로 전달돼 DNS 레코드의 대상이 된다.

## 5. 인수 조건 (Acceptance)

- [ ] `terraform plan` 시 인스턴스가 4 OCPU / 24 GB / 부트 200 GB / A1.Flex로 뜬다.
- [ ] 보안 리스트에 TCP 22/80/443/5432/6379, UDP 27015/2456/2457/2458/8211 ingress가 존재한다.
- [ ] 인스턴스에 `prevent_destroy`가 걸려 있어 `destroy` 계획에서 오류로 막힌다.
- [ ] `app_server_public_ip` 출력이 Cloudflare 모듈 입력으로 연결된다.
- [ ] 예산 알림이 1 USD·5 USD 두 임계값으로 구성된다.
- [ ] 부트 볼륨 200GB 외 추가 블록 볼륨이 생성되지 않는다(Always Free 한도 준수).

## 6. 향후 과제 (out of scope)

- 3.2 DB 포트 공개 범위 축소
- 인스턴스 백업/스냅샷 전략 (현재 명세 없음)
- 다중 AD / 다중 인스턴스로의 확장 (현재는 단일 인스턴스 전제)
