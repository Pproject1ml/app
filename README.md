<section>
  <h1>TT - Travel Talk</h1>
  <ul>
    <li>
      여행기 위치 기반 채팅 서비스
    </li>
    <li>
      미래내일 일경험 프로젝트형 장려상 수상
    </li>
  </ul>
</section>
<section>
  <h1>핵심기술 소개</h1>
  <ul>
    <h3>채팅 local 저장 동기화</h3>
    <p>채팅에서 서버 부담을 줄이고 보다 빠르게 로드하기 위해 이전 데이터를 휴대폰에 저장하도록 하였다. 해당 과정에서 어려웠던점은 실시간 채팅이 들어오는 동안에 휴대폰에서 데이터를 받아와야 하는 점이었다.(실시간 채팅이 들어오면서 로컬의 데이터를 가져올 때 메시지 손실이 발생할 것 같았다.) 이를 해결하고자 socket에 연결되는 순간 메모리에 실시간 채팅을 계속 추가하도록 하였다. 이후 핸드폰에서 데이터를 가져오는 부분을 비동기로 처리하여 메시지 손실을 없애려고 하였다.</p>
    <br/>
    <p>아쉬웠던점: local에 채팅을 저장하고 가져오는 부분은 isolate(background thread) 에서 작업하도록 했으면 보다 main thread에서 빠른 반응속도를 구현할 수 있었을 것 같다.(시도는 했었지만 사용에 어려움이 있었다. 사전에 특정 메시지에 대한 행동을 정의해야 함)</p>
  </ul>
  <ul>
    <h3>단체 채팅방 구현</h3>
      <p>단체 채팅방 구현에서 가장 고민되었던 점은 "언제 채팅방을 구독하며 관리하는가"였다. 결론적으로 로그인 완료 후 메인 페이지에 들어오면 소켓에 연결하고 모든 채팅방을 구독하였다.(이부분은 실수였다)
      이렇게 하여 채팅이 들어오면 단체 채팅방 목록에서 최신 메시지 등을 수정해줄 수 있었다.
      </p>
    <br/>
    <p>아쉬웠던점: 처음에 생각하였던 userId 별로 socket 구독 신청하기 방법을 사용하면 서버에서의 처리는 늘어날 수 있지만 어플리케이션 내의 메모리사용량이 많이 줄었을 것 같다. 현재는 모든 채팅방을 항상 구독하고 있어서 메모리에 항상 데이터를 들고 있지만 위의 방법으로 user 별로 구독을 한다면 유저에게만 필요한 socket action을 보다 효율적으로 할 수 있었을 것 같다.(물론 서버에서의 처리는 늘어난다)</p>
  </ul>
  
</section>
<section>
<h1> 프로젝트 소개</h1>
<ul>
 <h3> 랜드마크 기반 채팅 서비스</h3>
<li> 특정 여행지의 랜드마크를 중심으로 다양한 정보를 실시간으로 공유할 수 있는 여행자들간의 오픈 채팅 서비스를 제공합니다.</li>
<li>랜드마크 에서 3km 이내의 사용자만이 채팅방에 참여하여 소통을 할 수 있습니다.</li>
</ul>
<!--주요 기능 -->
<ul>
 <h3> 주요 기능</h3>
  <ul>
    <h4>로그인</h4>
         <img height='400'  src='https://private-user-images.githubusercontent.com/86870218/411835310-1cc73a89-4293-4e95-952e-9f0a2c31913d.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzkyNTAxNjMsIm5iZiI6MTczOTI0OTg2MywicGF0aCI6Ii84Njg3MDIxOC80MTE4MzUzMTAtMWNjNzNhODktNDI5My00ZTk1LTk1MmUtOWYwYTJjMzE5MTNkLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAyMTElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMjExVDA0NTc0M1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWY4OTQ2ZjBiNzJhOTY3NmQ2NzQ2YTdhZDc5M2FmNzRiNmUyNWZiMThiMGFiMzNmNDcxYzg0NDA5YWNkNTY2Y2YmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.FO8xpXVWy-FMuuRJEXZp7ZgzJW69G3s3_g-AeT9_UsM' /> 
    <li> Google, kakao Oauth 를 적용하여 로그인 구현</li>
    <li> 닉네임 중복확인 </li>
  </ul>
  <br/>
  <ul>
    <h4>메인 페이지</h4>
         <img height='400'  src='https://private-user-images.githubusercontent.com/86870218/411841019-916da502-a27f-4e42-a8a5-af4b38ee4d25.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzkyNTIyOTIsIm5iZiI6MTczOTI1MTk5MiwicGF0aCI6Ii84Njg3MDIxOC80MTE4NDEwMTktOTE2ZGE1MDItYTI3Zi00ZTQyLWE4YTUtYWY0YjM4ZWU0ZDI1LmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAyMTElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMjExVDA1MzMxMlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTE0N2Q0ZWQ1MjE0MTkyNDA0NWY1ZTJkYzQ1ODNkMjY4MDE4NDAyMDYyZWI1MzgxNTY2M2E1YzgxNjY4MWQ4YmEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.Z2s_l_ilaXbZ33RBDXXWzarqz392s6LN-dn6Sx7atx8' />   
     <li>Google maps api 를 통한 지도 표시</li>
    <li>지도위 랜드마크 데이터 표시</li>
    <li>현재 위치에 따른 실시간 입장 가능한 채팅방 메뉴</li>
  </ul>
    <br/>
    <ul>
    <h4>단체 채팅</h4>
         <img height='300'  src='https://private-user-images.githubusercontent.com/86870218/411859301-4852ded8-00a2-49b4-83a0-e2a7faca35cf.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzkyNTc0MDQsIm5iZiI6MTczOTI1NzEwNCwicGF0aCI6Ii84Njg3MDIxOC80MTE4NTkzMDEtNDg1MmRlZDgtMDBhMi00OWI0LTgzYTAtZTJhN2ZhY2EzNWNmLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAyMTElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMjExVDA2NTgyNFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTU1M2RhOGU2OTQ3N2MxMzU2ZDVjMmU1MGEyNTk5NzVlNWE3MzlmZjVhMGFkMWQ2NThkNTc0ZTRjNmI1NzA2MWImWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.cMo5yoF-vRnx5KUByviMDlYfx6ycEmVzcdk9Lc486YU' />   
    <li>Socket(Stomp) 통신을 이용한 단체 채팅 구현</li>
     <li>Firebase Cloud Message 이용하여 채팅 event에 대한 Notification 처리</li>
    <br/>
  </ul>
</ul>
<ul>
 <h3> 시스템 구조도</h3>
<img width='50%' src='https://private-user-images.githubusercontent.com/86870218/411831720-ae01771e-6c11-4212-94c3-47257018f8d0.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzkyNDg3NTQsIm5iZiI6MTczOTI0ODQ1NCwicGF0aCI6Ii84Njg3MDIxOC80MTE4MzE3MjAtYWUwMTc3MWUtNmMxMS00MjEyLTk0YzMtNDcyNTcwMThmOGQwLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAyMTElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMjExVDA0MzQxNFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWM1ODdkYWVkNTcyYWE2NjE0NmYwNDM3ZTQ1ZGJjOGMwNzFkN2FiNDAwMTI3ZGY5NzM1MWFjMTdjNzRjZTg5ZGQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.LtMnjs8iLvDzeKLEc2XPbPqH3yusB5Am9_JPGA9vHjQ'/>
</ul>
</section>

<section>
<h1> 배포 현황</h1>
  <ul>
<li> Google closed test</li>
<li>https://play.google.com/store/apps/details?id=com.travelTalk.chat_location</li>
  </ul>
</section>
<section>
  <h1>기타 문서</h1>
  <a href='https://emphasized-albacore-bb4.notion.site/15af54b9e4848088846af956e5ec5f2d'>개발일지</a>
</section>


