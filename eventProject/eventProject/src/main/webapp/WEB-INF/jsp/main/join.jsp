<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/main/join.css?ver=<%=System.currentTimeMillis()%>" />
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>회원가입</title>
<script type="text/javascript">
	$(document).ready(function(){
		$("#btn_idChk").on('click', function(){
			fn_idChk();
		});
		$("#userPw").on('input', function() {
	        var userPw = $(this).val();
	        var strengthDisplay = $("#passwordStrength");

	        if (userPw === "") {
	            // 입력 필드가 비어 있을 때 강도 표시 숨기기
	            strengthDisplay.text("").removeClass("weak medium strong");
	            return;
	        }
	        
	        // 비밀번호 강도 평가
	        var strength = 0;
	        if (userPw.length >= 8) strength++;
	        if (/[A-Z]/.test(userPw)) strength++;
	        if (/[a-z]/.test(userPw)) strength++;
	        if (/[0-9]/.test(userPw)) strength++;
	        if (/[^A-Za-z0-9]/.test(userPw)) strength++;

	        // 강도에 따른 텍스트와 스타일 업데이트
	        if (strength <= 2) {
	            strengthDisplay.text("취약함").removeClass("medium strong").addClass("weak");
	        } else if (strength === 3 || strength === 4) {
	            strengthDisplay.text("보통").removeClass("weak strong").addClass("medium");
	        } else if (strength === 5) {
	            strengthDisplay.text("안전함").removeClass("weak medium").addClass("strong");
	        }
	    });
	});
	function fn_join(){
		var userId = $("#userId").val();
		var userPw = $("#userPw").val();
		var userpwConfirm = $("#userPwConfirm").val();
		var userNickname = $("#userNickname").val();
		var userBirth = $("#userBirth").val();
		var userGender = $("#userGender").val();
		var Email = $("#email").val();
		var EmailAddr = $("#emailAddr").val();
		var idChkYn = $("#idChkYn").val();
		
		// 비밀번호 정규식 (최소 8자, 최소 하나의 대문자, 소문자, 숫자 및 특수 문자 포함)
	    var pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*])[A-Za-z\d!@#\$%\^&\*]{8,}$/;
		
		if(userId == ""){
			alert("ID를 입력하세요.");
			return;
		}else if(idChkYn == 'N'){
			alert("아이디 중복검사를 해주시기 바랍니다.");
			return;
		}else if(!pwRegex.test(userPw)) {
	        alert("비밀번호는 최소 8자 이상이며, 대문자, 소문자, 숫자, 특수 문자를 포함해야 합니다.");
	        return;
	    }else if(userPw != userpwConfirm){
			alert("비밀번호를 확인해주세요.");
			return;
		}else if(userBirth === ""){
			alert("생년월일을 입력하세요");
			return;
		}else if(userGender === ""){
			alert("성별을 선택해주세요");
			return;
		}else if(email === "" || emailAddr === ""){
			alert("이메일을 입력하세요.");
			return;
		}else{
			// 회원가입이 되는 부분
			var frm = $("#frm").serialize();
			$.ajax({
			    url: '/member/insertMember.do',
			    method: 'post',
			    data : frm,
			    dataType : 'json',
			    success: function (data, status, xhr) {
			        if(data.resultChk > 0){
			        	alert("회원이 되신걸 축하드립니다.");
			        	location.href="/login.do";
			        }else{
			        	alert("회원가입에 실패하였습니다.");
			        	return;
			        }
			    },
			    error: function (data, status, err) {
			    }
			});
			
		}
	}
	
	function fn_idChk(){
		var userId = $("#userId").val();
		if(userId ===""){
			alert("중복 검사할 아이디를 입력해주세요.");
		}else{
			$.ajax({
			    url: '/member/idChk.do',
			    method: 'post',
			    data : {
			    	'userId' : userId
			    },
			    dataType : 'json',
			    success: function (data, status, xhr) {
			        if(data.idChk > 0){
			        	alert("이미 등록된 아이디입니다.");
			        	return;
			        }else{
			        	alert("사용하실 수 있는 아이디입니다.");
			        	$("#idChkYn").val('Y');
			        }
			    },
			    error: function (data, status, err) {
			    }
			});
		}
	}	
</script>

</head>
<body>
	
	<form id="frm" name="frm" class="join-frm">
		<input type="hidden" id="idChkYn" name="idChkYn" value="N"/>
		<table>
			<tr>
				<td>
					<h1>회원가입</h1>
				</td>
			</tr>
			<tr>
				<td>
					<p>회원 정보를 입력해 주세요</p>
				</td>
			</tr>
			<tr>
				
				<td>아이디</td>
			</tr>
			<tr>
				<td>
					<input type="text" class="text" style="width:180px;" id="userId" name="userId"/>
					<input type="button" id="btn_idChk" name="btn_idChk" value="중복검사"/>
				</td>
			</tr>
			<tr>
			    <td>비밀번호<span class="warning-message">(비밀번호는 최소 8자 이상이며, 대문자, 소문자, 숫자, 특수 문자를 포함해야 합니다.)</span></td>		    
			</tr>			
			<tr>
			    <td>
			        <input type="password" class="text" id="userPw" name="userPw"/>
			        <span id="passwordStrength" class="strength-display"></span> <!-- 강도 표시 -->
			    </td>
			</tr>
			<tr>
				<td>비밀번호 확인</td>
			</tr>
			<tr>
				<td>
					<input type="password" class="text" id="userPwConfirm" name="userPwConfirm"/>
				</td>
			</tr>
			<tr>
				<td>생년월일</td>
			</tr>
			<tr>
				<td>
					<input type="date" class="text" id="userBirth" name="userBirth"/>
				</td>
			</tr>
			<tr>
				<td>이메일</td>
			</tr>
			<tr>
				<td>
					 <div class="email-container">
			            <input type="text" class="email" id="email" name="email" placeholder="이메일"/>@
			            <select id="emailAddr" name="emailAddr">
			                <option value="">--주소를 선택해주세요--</option>
			                <option value="naver.com">naver.com</option>
			                <option value="gmail.com">gmail.com</option>
			                <option value="daum.net">daum.net</option>
			                <option value="nate.com">nate.com</option>
			            </select>
        			</div>
				</td>
			</tr>
			<tr>
        <td>성별</td>
	    </tr>
	    <tr>
	        <td>
	            <input type="radio" id="genderM" name="userGender" value="M" />
	            <label for="genderM">남자</label>
	            <input type="radio" id="genderF" name="userGender" value="F" />
	            <label for="genderF">여자</label>
	        </td>
	    </tr>
			<tr>
				<td>
					<input type="button" value="가입하기" class="btn"
					onclick="fn_join();">
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>