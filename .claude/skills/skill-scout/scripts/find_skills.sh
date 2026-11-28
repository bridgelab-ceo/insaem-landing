#!/usr/bin/env bash
# 사용법: find_skills.sh "키워드1" "키워드2" ...
#
# GitHub 공개 저장소에서 SKILL.md(=Claude 스킬 설명서)를 키워드로 검색하고,
# 저장소마다 신뢰 지표(스타·최근 업데이트·라이선스)를 붙여 TSV로 출력한다.
# 검색과 메타데이터 조회만 하며, 후보의 코드는 내려받지도 실행하지도 않는다.
#
# 출력 열: hits(적중 키워드 수) stars pushed license flags repo skill_paths
# 환경변수: PER_PAGE(키워드당 결과 수, 기본 20), MAX_REPOS(조회할 저장소 수, 기본 60)
set -uo pipefail

[ $# -ge 1 ] || { echo "사용법: $0 \"키워드\" [\"키워드\" ...]" >&2; exit 1; }
command -v gh >/dev/null || { echo "gh CLI가 필요합니다" >&2; exit 1; }
command -v jq >/dev/null || { echo "jq가 필요합니다" >&2; exit 1; }

PER_PAGE="${PER_PAGE:-20}"
MAX_REPOS="${MAX_REPOS:-60}"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
: > "$tmp/hits.tsv"

# 1) 키워드별 SKILL.md 검색 (GitHub 코드 검색은 분당 10회 제한 → 7초 간격)
n=0
for kw in "$@"; do
  [ "$n" -gt 0 ] && sleep 7
  n=$((n + 1))
  out=""
  for attempt in 1 2; do
    if out=$(gh api -X GET search/code -f q="filename:SKILL.md $kw" -f per_page="$PER_PAGE" 2>"$tmp/err"); then
      break
    fi
    out=""
    [ "$attempt" -eq 1 ] && { echo "  (검색 한도 도달, 60초 후 재시도: $kw)" >&2; sleep 60; }
  done
  if [ -z "$out" ]; then
    echo "  검색 실패: $kw — $(head -c 200 "$tmp/err")" >&2
    continue
  fi
  # 4번째 열 = GitHub 관련도 순위(0이 가장 관련 높음)
  echo "$out" | jq -r --arg kw "$kw" '.items | to_entries[] | [.value.repository.full_name, .value.path, $kw, (.key | tostring)] | @tsv' >> "$tmp/hits.tsv"
  echo "  검색 완료: $kw ($(echo "$out" | jq '.items | length')건)" >&2
done

[ -s "$tmp/hits.tsv" ] || { echo "결과 없음" >&2; exit 0; }

# 2) 저장소 목록: 적중 키워드 수 많은 순 → 같으면 키워드 안 관련도 순위가 높은 순, 상위 MAX_REPOS개
#    (키워드마다 상위 결과가 고르게 살아남도록)
awk -F'\t' '
  !seen[$1 FS $3]++ {c[$1]++}
  !($1 in best) || $4 + 0 < best[$1] {best[$1] = $4 + 0}
  END {for (r in c) print c[r] "\t" best[r] "\t" r}' "$tmp/hits.tsv" \
  | sort -t$'\t' -k1,1nr -k2,2n | head -n "$MAX_REPOS" | cut -f3 > "$tmp/repos"

# 3) 저장소 신뢰 지표: search/repositories에 repo: 조건을 5개씩 묶어 조회 (분당 30회 제한)
: > "$tmp/meta.tsv"
split -l 5 "$tmp/repos" "$tmp/batch_"
for b in "$tmp"/batch_*; do
  q=$(sed 's/^/repo:/' "$b" | paste -sd' ' -)
  gh api -X GET search/repositories -f q="$q" -f per_page=10 2>/dev/null \
    | jq -r '.items[] | [
        .full_name,
        (.stargazers_count | tostring),
        (.pushed_at[:10]),
        (.license.spdx_id // "none"),
        ([ (if .archived then "archived" else empty end), (if .fork then "fork" else empty end) ] | join(",") | if . == "" then "-" else . end)
      ] | @tsv' >> "$tmp/meta.tsv"
  sleep 2.5
done

# 4) 합치기 + 모음집(남의 스킬을 대량 복사한 저장소) 표시
printf "hits\tstars\tpushed\tlicense\tflags\trepo\tskill_paths\n"
while IFS= read -r repo; do
  hits=$(awk -F'\t' -v r="$repo" '$1 == r {print $3}' "$tmp/hits.tsv" | sort -u | wc -l | tr -d ' ')
  paths=$(awk -F'\t' -v r="$repo" '$1 == r {print $2}' "$tmp/hits.tsv" | sort -u | head -5 | paste -sd',' -)
  meta=$(awk -F'\t' -v r="$repo" 'tolower($1) == tolower(r) {print $2 "\t" $3 "\t" $4 "\t" $5; exit}' "$tmp/meta.tsv")
  [ -n "$meta" ] || meta=$'?\t?\t?\tmeta-missing'
  stars=$(cut -f1 <<<"$meta"); pushed=$(cut -f2 <<<"$meta"); lic=$(cut -f3 <<<"$meta"); flags=$(cut -f4 <<<"$meta")
  shopt -s nocasematch
  if [[ "$repo" =~ (registry|library|mirror|collection|awesome|hub|marketplace|all-skills) ]]; then
    flags="${flags/#-/}"; flags="${flags:+$flags,}aggregator?"
  fi
  shopt -u nocasematch
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$hits" "$stars" "$pushed" "$lic" "$flags" "$repo" "$paths"
done < "$tmp/repos" | sort -t$'\t' -k1,1nr -k2,2nr
