<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/common/main.css">
<link rel="stylesheet" href="/css/egovframework/main/login.css?after"/>
<title>Insert title here</title>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_login").on('click', function(){
			fn_login();
		});
	});

	function fn_createAccount(){
		var frm = $("#frm");
		frm.attr("method", "POST");
		frm.attr("action", "/join.do");
		frm.submit();
	}
	
	function fn_login(){
	    var frm = $("#frm").serialize();
	    $.ajax({
	        url: '/member/loginAction.do',
	        method: 'post',
	        data : frm,
	        dataType : 'json',
	        success: function (data, status, xhr) {
	            if(data.resultChk){
	                // 리다이렉트 URL이 있으면 해당 URL로 이동, 없으면 기본 페이지로 이동
	                var redirectURL = $("#redirectURL").val();
	                console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>Redirect URL:", redirectURL);  // 콘솔에 리다이렉트 URL 출력
	                if (redirectURL) {
	                    location.href = redirectURL;
	                } else {
	                    location.href="/mainPage.do";
	                }
	            } else {
	                alert("로그인에 실패하였습니다.");
	                return;
	            }
	        },
	        error: function (data, status, err) {
	            console.log(err);
	        }
	    });
	}

	
	function fn_findIdView(){
		var frm = $("#frm");
		frm.attr("method", "POST");
		frm.attr("action", "/findIdView.do");
		frm.submit();
	}
	
	function fn_findPwView(){
		var frm = $("#frm");
		frm.attr("method", "POST");
		frm.attr("action", "/findPwView.do");
		frm.submit();
	}
</script>
</head>
<body>
<form id="frm" name="frm">
	<table>
	    <tr>
	        <td><h1>로그인</h1></td>
	    </tr>
	    <tr>
	        <td><input type="text" placeholder="ID" id="userId" name="userId"></td>
	    </tr>
	    <tr>
	        <td><input type="password" placeholder=Password id="userPw" name="userPw"></td>
	    </tr>	    
	   <tr>
	        <td><input type="button" value="로그인" class="btn" id="btn_login" name="btn_login"></td>
	    </tr>
	    <tr>
	        <td class="join">
	        	<a href="javascript:fn_findIdView();">아이디찾기</a>| 
	        	<a href="javascript:fn_findPwView();">비밀번호 찾기</a>| 
	        	<a href="javascript:fn_createAccount();">회원가입</a>
	        </td>
	    </tr>
	</table>
	<!-- 리다이렉트 URL을 위한 숨김 필드 -->
	<input type="hidden" id="redirectURL" name="redirectURL" value="${param.redirectURL}">
</form>
</body>
</html>