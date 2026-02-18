# LUT 기반 왜곡 보정 전처리 + DPU 통합 실시간 차선 검출 Vision SoC 프로젝트

## 프로젝트 소개
Ultra96v2(Zynq UltraScale+ MPSoC) 기반 임베디드 비전 시스템에서,
fisheye 왜곡 보정 전처리와 DPU 기반 차선 검출 추론을 통합한 프로젝트입니다.

### 프로젝트 핵심:
- PL(Programmable Logic)에서 LUT 기반 스트리밍 왜곡 보정 수행
- Vitis AI DPU(B1600) 기반 Tiny-YOLOv3 추론 가속
- 단일 SoC에서 전처리 + 추론 통합으로 실시간 처리 달성

## 초록 (Abstract)
본 프로젝트는 시야각 약 180도의 fisheye 카메라를 사용하는 임베디드 비전 시스템에서,
비선형 왜곡으로 인한 정확도 저하와 전처리 연산 부담을 줄이기 위해 Zynq UltraScale+ MPSoC 기반
전처리-추론 통합 구조를 제안합니다. 일반 카메라(약 55도) 대비 fisheye 카메라는 넓은 시야로
사각지대를 줄이는 장점이 있지만, 왜곡 보정 연산 비용이 큽니다. 이를 해결하기 위해 PL 영역에서
사전 계산된 픽셀 매핑 테이블을 LUT로 사용해 remapping을 수행하여 복잡한 런타임 비선형 연산을
대체했고, 동시에 Vitis AI DPU(B1600)에서 Tiny-YOLOv3 추론을 가속했습니다.
구현 결과 end-to-end 처리량은 약 33.3 FPS였으며,
100 MHz 동작 주파수에서 타이밍 제약을 만족하여 안정적으로 동작함을 확인했습니다.

## 프로젝트 개요
- 플랫폼: Ultra96v2
- 기준 툴 버전: Vivado `2022.1`
- RTL 체인: `axis_resize_half -> bram_con -> bram -> fisheye_reader_stream`
- LUT 메모리: `map_x.mem`, `map_y.mem`
- 검증 방식: 1. Testbench (이미지 -> HEX -> RTL 시뮬레이션 -> HEX -> 이미지) 2. ILA

## 프로젝트 설명
프로젝트의 구체적인 구현 내용(RTL 상세, 검증 신호 파형 등)은 `2025_2학기_URP_최종 발표.pptx`를 참고해주세요.

## 저장소 구조

```text
Automation-Lab-URP-Automotive-Vision-SoC/
|- README.md
|- .gitignore
|- prj/                 # Vivado 프로젝트(.xpr/.runs/.gen)
|- .local/              # 로컬 캐시
|- hw/
|  |- rtl/              # 구현 RTL
|  |- bd/               # Block Design 원본
|  |- constraints/      # XDC
|  `- mem/              # map_x.mem, map_y.mem
|- ip_repo/             # 사용자 IP(PWM/module_ref 등)
|- board/               # Ultra96v2 board files
|- scripts/
|  `- open_project.tcl
|- testbench/
|  |- README.md
|  |- rtl/
|  |- scripts/
|  `- vectors/
`- 2025_2학기_URP_최종 발표.pptx
```

## scripts
- `open_project.tcl`: 이미 생성된 `prj/prj.xpr`를 바로 열어 현재 프로젝트 상태를 확인할 때 사용
- 이 저장소는 DPU IP 재설치 없이 확인 가능한 스냅샷 열기 흐름을 기본으로 사용

## 실행 방법
### Vivado 프로젝트 열기
1. Vivado `2022.1` 실행
2. `prj/prj.xpr` 열기

또는 Tcl 콘솔:

```tcl
source scripts/open_project.tcl
```

## RTL 검증(Testbench)
상세 문서: `testbench/README.md`

검증 흐름:
1. 왜곡 입력 이미지(`640x480`)를 HEX로 변환(img_to_hex.py 실행)
2. RTL 시뮬레이션으로 결과 HEX(`320x240`) 생성
3. 결과 HEX를 이미지로 복원(hex_to_img.py 실행)
4. 복원 결과를 시각적으로 확인
