---
title: 공돌이의 MATLAB 정리노트
keywords: sample homepage
hide_sidebar: true
permalink: index.html
identifier: 20230515
comments: false
startnote: true
toc: false
ogimage: https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/images/ogimage.png
---

안녕하세요! **"공돌이의 MATLAB 정리노트"**에 오신 것을 환영합니다. 이 블로그는 기억력이 좋지 못한 공돌이가 고민했던 MATLAB, Simulink 내용을 정리한 곳입니다. 단순한 MATLAB 코딩에 관한 내용 뿐만 아니라, 파이썬과의 연동, 경로 계획법, 쿼드 콥터 모델링과 같은 의외로 깊은 내용들도 다루고 있습니다.

자매품(?)으로 공돌이의 수학정리노트도 있습니다.
* [공돌이의 수학정리노트](https://angeloyeo.github.io/)

---

## 📚 튜토리얼 목록

<style>
.tutorial-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
  margin: 32px 0;
}

.tutorial-card {
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
  background: #ffffff;
}

.tutorial-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  border-color: #0076A8;
  text-decoration: none;
  color: inherit;
}

.tutorial-card-image {
  width: 100%;
  height: 160px;
  object-fit: cover;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 56px;
}

.tutorial-card-image img {
  width: 100%;
  height: 160px;
  object-fit: cover;
}

.tutorial-card-image-emoji {
  width: 100%;
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 56px;
}

.tutorial-card-body {
  padding: 16px 18px 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.tutorial-card-tag {
  display: inline-block;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #0076A8;
  background: #e8f4fa;
  border-radius: 4px;
  padding: 2px 8px;
  margin-bottom: 2px;
  width: fit-content;
}

.tutorial-card-title {
  font-size: 17px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0;
  line-height: 1.3;
}

.tutorial-card-desc {
  font-size: 13.5px;
  color: #555;
  line-height: 1.55;
  margin: 0;
}
</style>

<div class="tutorial-grid">

  <a class="tutorial-card" href="https://matlabtutorial.github.io/1.%20matlab_basics_why_use_matlab.html">
    <div class="tutorial-card-image-emoji" style="background: linear-gradient(135deg, #0076A8 0%, #00a1e4 100%);">
      <span>🖥️</span>
    </div>
    <div class="tutorial-card-body">
      <span class="tutorial-card-tag">입문</span>
      <p class="tutorial-card-title">MATLAB Basics</p>
      <p class="tutorial-card-desc">MATLAB을 처음 시작하는 분들을 위한 기초 튜토리얼. 행렬 연산, 스크립트 작성, 시각화까지 핵심 개념을 단계별로 정리합니다.</p>
    </div>
  </a>

  <a class="tutorial-card" href="https://matlabtutorial.github.io/1.%20introduction_to_MATLAB_with_Python.html">
    <div class="tutorial-card-image-emoji" style="background: linear-gradient(135deg, #306998 0%, #FFD43B 100%);">
      <span>🐍</span>
    </div>
    <div class="tutorial-card-body">
      <span class="tutorial-card-tag">연동</span>
      <p class="tutorial-card-title">MATLAB with Python</p>
      <p class="tutorial-card-desc">MATLAB과 Python을 함께 사용하는 방법을 소개합니다. 두 언어의 장점을 결합해 더 강력한 엔지니어링 워크플로우를 구성하세요.</p>
    </div>
  </a>

  <a class="tutorial-card" href="https://matlabtutorial.github.io/1.%20what_is_path_planning.html">
    <div class="tutorial-card-image-emoji" style="background: linear-gradient(135deg, #2e7d32 0%, #81c784 100%);">
      <span>🤖</span>
    </div>
    <div class="tutorial-card-body">
      <span class="tutorial-card-tag">로봇</span>
      <p class="tutorial-card-title">Path Planning for Mobile Robot</p>
      <p class="tutorial-card-desc">MATLAB과 Simulink로 이동 로봇의 경로 계획 알고리즘을 구현합니다. A*, RRT 등 주요 알고리즘을 직접 시뮬레이션해봅니다.</p>
    </div>
  </a>

  <a class="tutorial-card" href="https://matlabtutorial.github.io/no00_IntroToUAV.html">
    <div class="tutorial-card-image-emoji" style="background: linear-gradient(135deg, #37474f 0%, #90a4ae 100%);">
      <span>🚁</span>
    </div>
    <div class="tutorial-card-body">
      <span class="tutorial-card-tag">Aerospace</span>
      <p class="tutorial-card-title">Aerospace Engineering</p>
      <p class="tutorial-card-desc">낙하산의 착륙 위치 계산, 쿼드콥터 드론의 동역학 모델링부터 제어 설계까지. Simulink를 활용해 우주항공 시뮬레이션을 처음부터 구성합니다.</p>
    </div>
  </a>

  <a class="tutorial-card" href="https://matlabtutorial.github.io/no00_IntroToSimscapeMultibody.html">
    <div class="tutorial-card-image-emoji" style="background: linear-gradient(135deg, #6a1b9a 0%, #ce93d8 100%);">
      <span>⚙️</span>
    </div>
    <div class="tutorial-card-body">
      <span class="tutorial-card-tag">Simulink</span>
      <p class="tutorial-card-title">Simscape Multibody 101</p>
      <p class="tutorial-card-desc">Simscape Multibody를 이용해 기계 시스템의 3D 물리 시뮬레이션을 구축합니다. 관절, 링크, 구속 조건을 시각적으로 모델링합니다.</p>
    </div>
  </a>

  <a class="tutorial-card" href="https://matlabtutorial.github.io/no01_WhatIsPIDControl.html">
    <div class="tutorial-card-image-emoji" style="background: linear-gradient(135deg, #b71c1c 0%, #ef9a9a 100%);">
      <span>📈</span>
    </div>
    <div class="tutorial-card-body">
      <span class="tutorial-card-tag">제어</span>
      <p class="tutorial-card-title">PID Control 101</p>
      <p class="tutorial-card-desc">PID 제어기의 개념부터 MATLAB/Simulink를 이용한 튜닝까지. 제어 이론의 핵심을 직관적으로 이해하고 실습합니다.</p>
    </div>
  </a>

</div>