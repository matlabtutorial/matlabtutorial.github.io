---
title: MATLAB의 TCP/IP 통신
published: true
permalink: tcpip_in_MATLAB.html
summary: "MATLAB에서 TCIP/IP 통신을 수행하기 위한 세팅과 실습"
tags: [통신]
identifier: tcpip_in_MATLAB
sidebar: false
toc: true
---

본 내용에 대한 더 자세한 내용은 MathWorks 홈페이지를 참고하시기 바랍니다.

- [TCP/IP Interface](https://www.mathworks.com/help/instrument/tcp-ip-interface.html?s_tid=CRUX_lftnav)

# MATLAB 서버 / MATLAB 클라이언트

- [Communicate Between a TCP/IP Client and Server in MATLAB](https://www.mathworks.com/help/instrument/communicate-between-a-tcpip-client-and-server-in-matlab.html)

TCP/IP 통신 기능을 이용하면 간단한 채팅 기능을 구현할 수 있다.

<p align = "center">
  <img src = "https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/master/images/blog_posts/2022-06-25-MATLAB_tcpip/pic1.png">
  <br>
  그림 1. TCP/IP 기능을 이용한 MATLAB 간의 채팅 구현
</p>

아래는 서버 단에서 사용한 스크립트이다.

```MATLAB
% Server
clear; close all; clc;

% Server
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
address = resolvehost(hostname,"address");

server = tcpserver(address,5000,"ConnectionChangedFcn",@connectionFcn);
configureCallback(server,"terminator",@readDataFcn);

function connectionFcn(src, ~)
if src.Connected
    disp("Client connection accepted by server.")
    writeline(src, "Hi, MATLAB!");
end
end

function readDataFcn(src, ~)
disp("Data was received from the client.")
src.UserData = read(src,src.NumBytesAvailable,"string");
disp(src.UserData);
end
```
또 아래는 클라이언트 단에서 사용한 스크립트이다.

```MATLAB
% Client
clear; close all; clc;

client = tcpclient('192.XXX.XX.XXX',5000,'Timeout',20) % 실제 IP 주소와 포트 번호를 입력하세요.
pause(1)
rawData = readline(client);
disp(rawData);

%%
pause(1)
writeline(client, "Hi Back!")
```

# MATLAB 서버 / Python 클라이언트

TCP/IP 기능은 MATLAB과 다른 환경 간의 통신도 가능하게 해준다. 어떤 경우 Python에서만 사용할 수 있는 함수로 계산을 완료하고 MATLAB으로 다시 불러들이고 싶은 경우 혹은 그 반대 경우에 활용할 수 있을 것이다. 여기서는 간단히 스트링을 보내는 정도의 예시만을 보여주고자 한다.

아래는 서버로 설정된 MATLAB 단의 스크립트이다.

```MATLAB
clear; close all; clc;

[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
address = resolvehost(hostname,"address");

server = tcpserver(address,5000,"ConnectionChangedFcn",@connectionFcn)

function connectionFcn(src, ~)
if src.Connected
    disp("Client connection accepted by server.")
    write(src, "Hi Python", "string");
end
end
```

아래는 클라이언트로 설정된 Python 단의 스크립트이다.

```Python
# -*- coding: utf-8 -*-

import socket

# 접속 정보 설정
SERVER_IP = '192.000.000.000' # 실제 아이피 주소는 가렸습니다.
SERVER_PORT = 5000
SIZE = 16
SERVER_ADDR = (SERVER_IP, SERVER_PORT)

# 클라이언트 소켓 설정
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client_socket:
    client_socket.connect(SERVER_ADDR)  # 서버에 접속
    client_socket.send('hi'.encode())  # 서버에 메시지 전송
    msg = client_socket.recv(SIZE)  # 서버로부터 응답받은 메시지 반환
    print("resp from server : {}".format(msg))  # 서버로부터 응답받은 메시지 출력
```