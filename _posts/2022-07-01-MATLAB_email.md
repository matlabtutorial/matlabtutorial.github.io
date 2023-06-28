---
title: MATLAB으로 email 보내기
published: true
permalink: email_with_MATLAB.html
summary: "MATLAB에서 Email을 보내는 방법과 실습"
tags: [웹]
identifier: email_with_MATLAB
sidebar: false
toc: true
---

MATLAB으로 메일을 보내는 게 특별히 필요할까 싶겠지만, 간혹 MATLAB으로 오랜 시간이 걸리는 연산을 수행할 때 유용할 수 있다. 어떤 경우 MATLAB 코드를 3-4일씩 돌리는 경우도 있다. 이 때, 개인이 사용하는 PC에서 코드를 돌리는 것이 아니라 공용 컴퓨터에서 이런 일을 수행하게 된다면, 전체 스크립트 가장 하단에 email을 송부해주는 코드를 삽입하면 코드가 모두 돌아갔을 때 mail 알림을 받을 수 있을 것이다. 그러면 코드가 완전히 다 돌아갔는지 알 수 있는 것이다.

본 내용에 대한 더 자세한 내용은 MathWorks 홈페이지를 참고하시기 바랍니다.

- [Send Email](https://www.mathworks.com/help/matlab/import_export/sending-email.html?s_tid=srchtitle_sending%20email_1)

참고로 Gmail로는 MATLAB을 통해 email을 보낼 수 없다.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-07-01-MATLAB_email/pic1.png">
  <br>
  그림 1. Gmail은 id/password만을 이용해 접속하여 동작하는 외부 접근을 허용하지 않음.
</p>

# 네이버 메일을 이용한 이메일 송부

MATLAB을 이용하여 네이버 메일을 발신자로하여 메일을 송부할 수 있다. 네이버에서 아래와 같이 세팅을 수행하도록 하자. 우선 네이버 메일에 들어가서 환경설정에 들어간다.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-07-01-MATLAB_email/pic2.png">
  <br>
  그림 2. 네이버 메일의 "환경설정"에 들어가보자
</p>

IMAP/SMTP를 사용하도록 설정하자.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-07-01-MATLAB_email/pic3.png">
  <br>
  그림 3. IMAP/SMTP를 사용하도록 설정해야 네이버에서 메일을 보낼 수 있다.
</p>

아래의 MATLAB 코드를 실행하여 메일을 보내도록 하자. 

여기서 주석이 달린 부분은 자신의 네이버 메일 주소, 비밀번호 그리고 받는 사람의 주소를 직접 입력하도록 하자.

```MATLAB
setpref('Internet','SMTP_Server','smtp.naver.com');
setpref('Internet','E_mail','sender@naver.com'); % 네이버 메일 주소
setpref('Internet','SMTP_Username','sender@naver.com'); % 네이버 메일 주소
setpref('Internet','SMTP_Password','YOUR PASSWORD'); % 네이버에서 사용하는 비밀번호
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail('receiver@gmail.com','Email Title','Email body contents') % 받는 사람의 주소와 메일 제목, 내용
```