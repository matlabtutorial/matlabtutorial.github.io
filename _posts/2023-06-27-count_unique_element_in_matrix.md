---
title: (번역) 행렬 안의 특정 원소가 몇 개인지 세는 방법
published: true
permalink: count_unique_element_in_matrix.html
summary: "내장 함수를 이용해 행렬 안의 원소의 개수를 더 빠르게 셀 수 있다."
tags: [번역, 행렬]
identifier: count_unique_element_in_matrix
sidebar: false
toc: true
---

본 포스트의 원문은 아래의 URL에서 확인하실 수 있습니다. 본 포스트는 원작자에게 동의를 구한 뒤 한국어로 번역하였습니다.

- [【MATLAB】配列内のユニークな要素、それぞれの数を数える方法](https://qiita.com/eigs/items/c6668d6a478369e7e525)

# 사용 환경

MATLAB R2017a

# 과제

예를 들어,

```matlab
v = [1,2,3,4,2,2,1];
```

라는 배열이 있다고 했을 때, 1이 두 개, 2가 세 개 등으로 세어나갈 수 있습니다. MATLAB에는 이 동작을 수행해주는 쉬운 이름의 함수가 없어서 어쩔 수 없이 for 루프로 프로그램을 작성해본다면 이런 느낌이겠습니다.

```matlab
v = [1,2,3,4,2,2,1];
vq = unique(v);
N = length(vq);

numvq = zeros(N,1);
tic
for ii=1:N
    numvq(ii) = sum(v==ii);
end
toc
```

하려고 하는 것은 실현했습니다만, 행렬의 차원이 커지면 시간이 더 걸릴테고, 무엇보다 아름다운 솔루션이 아닙니다. 그래서 for 문을 쓰지않고 구현할 수 있는 방법이 없나 조사하였고 세 가지 방법을 소개해드립니다.

이런저런 방법으로 계산했을 때 걸린 시간을 제 laptop 머신으로 tic/toc을 이용해 계측했을 때 아래와 같은 결과를 확인할 수 있습니다.

| 함수명      | 계산 시간  |
|------------|------------|
| arrayfun   | 0.16 초   |
| accumarray | 0.0013 초 |
| histcounts | 0.0016 초 |

for 문을 쓴 경우에는 0.18초 정도였으니 `accumarray` 함수는 좋은 편이네요.

실행시간 계측을 위해서 1부터 1000까지 랜덤 정수를 무작위로 갖는 10만 x 1 벡터 v를 만들고 각 정수가 몇 번 나타나는지 찾았습니다.

아래는 각각의 코드입니다.

# arrayfun 함수

```matlab
N = 1e5;
v = randi(1000,N,1);
numvq = arrayfun(@(x) sum(v == x), unique(v));
```

이 경우 for 문은 피할 수 있었습니다만, 속도는 크게 빠르지 않습니다.

# accumarray 함수

```matlab
N = 1e5;
v = randi(1000,N,1);
numvq = accumarray(v,1);
```

함수의 작동 방식을 이해하는 데에는 시간이 걸립니다만, 계산 속도는 가장 빨랐습니다.

# histcounts 함수

```matlab
N = 1e5;
v = randi(1000,N,1);
numvq = histcounts(v,'BinMethod','integers');
```

`histcounts` 함수는 R2014b에 도입되어 비교적 새로운 함수입니다만, 이 옵션은 의식하지 못했습니다.

# 참고

Q&A 사이트 MATLAB Answers

* [how can I count the number of elements on a vector?](https://kr.mathworks.com/matlabcentral/answers/282986-how-can-i-count-the-number-of-elements-on-a-vector?s_eid=PSM_29435)
* [Can I use UNIQUE to get a count of the number of times each element is repeated?](https://kr.mathworks.com/matlabcentral/answers/96776-can-i-use-unique-to-get-a-count-of-the-number-of-times-each-element-is-repeated?s_eid=PSM_29435&requestedDomain=)
* [How can I count the number of elements of a given value in a matrix?](https://jp.mathworks.com/matlabcentral/answers/181613-how-can-i-count-the-number-of-elements-of-a-given-value-in-a-matrix?s_eid=PSM_29435)

를 참고했습니다.