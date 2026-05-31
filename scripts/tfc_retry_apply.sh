#!/bin/bash
# OCI 인스턴스 사양 업그레이드 재시도 스크립트
# 사용법: TFC_TOKEN=<token> ./scripts/tfc_retry_apply.sh

TFC_TOKEN="${TFC_TOKEN}"
TFC_ORG="dev-monty"
TFC_WORKSPACE="iac-terraform"
RETRY_INTERVAL=5  # 5초

if [[ -z "$TFC_TOKEN" ]]; then
  echo "Error: TFC_TOKEN 환경변수를 설정해주세요"
  echo "사용법: TFC_TOKEN=<token> ./scripts/tfc_retry_apply.sh"
  exit 1
fi

WORKSPACE_ID=$(curl -s \
  -H "Authorization: Bearer $TFC_TOKEN" \
  -H "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/organizations/$TFC_ORG/workspaces/$TFC_WORKSPACE" \
  | jq -r '.data.id')

if [[ -z "$WORKSPACE_ID" || "$WORKSPACE_ID" == "null" ]]; then
  echo "Error: 워크스페이스를 찾을 수 없습니다"
  exit 1
fi

echo "Workspace: $TFC_WORKSPACE ($WORKSPACE_ID)"
echo "5초 간격으로 재시도합니다. 종료하려면 Ctrl+C"
echo "---"

ATTEMPT=0
while true; do
  ATTEMPT=$((ATTEMPT + 1))
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 시도 #$ATTEMPT"

  RUN_ID=$(curl -s \
    -X POST \
    -H "Authorization: Bearer $TFC_TOKEN" \
    -H "Content-Type: application/vnd.api+json" \
    -d "{\"data\":{\"type\":\"runs\",\"attributes\":{\"message\":\"OCI upgrade retry #$ATTEMPT\"},\"relationships\":{\"workspace\":{\"data\":{\"type\":\"workspaces\",\"id\":\"$WORKSPACE_ID\"}}}}}" \
    "https://app.terraform.io/api/v2/runs" \
    | jq -r '.data.id')

  echo "  Run ID: $RUN_ID"

  # 상태 폴링
  while true; do
    STATUS=$(curl -s \
      -H "Authorization: Bearer $TFC_TOKEN" \
      "https://app.terraform.io/api/v2/runs/$RUN_ID" \
      | jq -r '.data.attributes.status')

    echo "  Status: $STATUS"

    if [[ "$STATUS" == "applied" ]]; then
      echo ""
      echo "✓ 업그레이드 성공!"
      exit 0
    elif [[ "$STATUS" == "planned_and_finished" ]]; then
      echo "  변경사항 없음 (이미 적용됨)"
      exit 0
    elif [[ "$STATUS" == "errored" ]]; then
      echo "  실패. ${RETRY_INTERVAL}초 후 재시도..."
      break
    fi

    sleep 10
  done

  sleep $RETRY_INTERVAL
done
