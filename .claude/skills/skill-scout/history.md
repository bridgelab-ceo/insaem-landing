# 스킬 비서 기록

예전에 추천·설치·거절한 스킬. 거절한 것은 다시 추천하지 않고, 보류는 3개월 뒤 다시 본다.
(공개 저장소일 수 있으니 고객명·연락처·금액 등 민감 정보는 쓰지 않는다.)

## 2026-11-24
- 설치함: hyperframes, hyperframes-cli, hyperframes-registry, media-use, reverse-any-video, style-sampling (heygen-com/hyperframes) — 광고 영상 제작
- 분석 영역: 정책자금·지원사업 컨설팅 / 메타 광고 소재 / 상세페이지·상담 신청 전환 / 콘텐츠 검수
- 검색어: meta ads creative, ad creative testing, landing page conversion, 카드뉴스, instagram carousel, 정부지원사업, reels script hook, lead nurture follow-up
- 추천 (결정 대기):
  - consult-gov-grant (modu-ai/moai-cowork)
  - ad-creative (coreyhaines31/marketingskills)
  - commerce-ad-claim-compliance-kr (modu-ai/moai-cowork)
  - cro (coreyhaines31/marketingskills)
- 제외:
  - 릴스 대본·카드뉴스 스킬들 (Ootto-AI/claude-content-skills, sergebulaev/instagram-skills 등) — insaem-content-master와 겹침
  - marketing-meta-ads-analyzer (modu-ai/moai-cowork) — 내용이 얇고 소재 허브·Meta 광고 연결과 겹침
  - government-support-survey (NomaDamas/k-skill) — 실행 때마다 외부 패키지·외부 서버 경유, consult-gov-grant로 대체
  - doc-hwp (modu-ai/moai-cowork) — 보류: 한글 파일 사업계획서를 자주 만들면 재검토

## 2026-11-24 (관찰 기반 재평가)
- 방식 변경: 작업 세션 관찰 → 마찰 패턴 점수 → 기준 통과 시에만 추천
- 철회 (관찰된 마찰과 연결 안 됨):
  - ad-creative (coreyhaines31/marketingskills) — 소재 기획에서 반복 막힘이 관찰되지 않음
  - cro (coreyhaines31/marketingskills) — 상세페이지 전환 관련 마찰 관찰 안 됨
  - consult-gov-grant (modu-ai/moai-cowork) — 관찰된 마찰은 '공고 탐색'이 아니라 '기준 수치 원문 확인'이라 적합도 낮음
- 추천 (결정 대기):
  - legal-contract-review (modu-ai/moai-cowork) — 계약서 패턴, 점수 18
  - commerce-ad-claim-compliance-kr (modu-ai/moai-cowork) — 광고 문구 패턴, 점수 12
- 제안: 정책 기준 원문 확인 — 맞는 공개 스킬 없음, 전용 스킬 제작 제안

## 2026-11-24 (방식 변경: 프로젝트 감시)
- 대표님 요청: 지난 작업 이력이 아니라, 앞으로 진행하는 프로젝트를 지켜보다가 추천
- 과거 이력 기반 관찰 일지(observations.md) 삭제
- 철회 (과거 이력 기반이라): legal-contract-review, commerce-ad-claim-compliance-kr (modu-ai/moai-cowork)
- 추천 (결정 대기):
  - webapp-testing (anthropics/skills) — 회사 업무 플랫폼 / 테스트 단계, 중요도 3 × 적합도 2 = 6
- 2026-11-24 webapp-testing 설치 승인. 프로젝트 저장소(kbgc-agent-team)는 이 세션에서 접근 불가 → 프로젝트 세션에 설치 명령 전달 대기. 설치 명령은 빈 폴더에서 시험해 정상 동작 확인(파일 6개, 점검 때와 동일)
