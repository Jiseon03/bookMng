<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/myPage/myPage.css?after">
<script src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
	// 이미지 미리보기 기능
    window.previewProfileImage = function(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                $('#profileImgPreview').attr('src', e.target.result); // 미리보기 이미지 변경
            }
            reader.readAsDataURL(input.files[0]); // 파일 읽기
        }
    }
	
    // 프로필 이미지 업로드 폼 제출
    $("#profileImageForm").on('submit', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        
        $.ajax({
            url: '/uploadProfileImage.do',
            type: 'POST',
            data: formData,
            dataType: 'json',  // JSON 데이터로 받음
            processData: false,
            contentType: false,
         	// AJAX 요청 성공 시
            success: function(response) {
                if (response.result === 'success') {
                    alert("프로필 이미지가 성공적으로 업데이트되었습니다.");
                    $('#profileImgPreview').attr('src', response.profileImagePath + '?' + new Date().getTime()); // 미리보기 이미지 업데이트 및 캐시 무효화
                } else {
                    alert(response.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX 오류: ", error);
            }
        });
    });
    
    
    $("#profile-image").on('click', function(e) {
    	$("#profileImageInput").click();
    });
    
});

function fn_updateProfile(){
		var frm = $("#frm").serialize();

		$.ajax({
		    url: '/updateProfile.do',
		    method: 'post',
		    data : frm,
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("저장되었습니다.");
		    	}else{
		    		alert("저장에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
}
	
function fn_deleteUser(){	
	if (confirm("탈퇴하시겠습니까?")) {
		$.ajax({
			url: '/deleteUser.do',
			method: 'post',
			dataType : 'json',
			 success: function (data, status, xhr) {
				   if(data.resultChk > 0){
				    	alert("회원 탈퇴 성공.");
				   }else{
				    	alert("회원 탈퇴 실패.");
				   }
			},
			 error: function (data, status, err) {
				    console.log(err);
				    }
			});	
	}
}
</script>
</head>
<body>

	<h1>MyPage</h1>
	<div class="mypage-container">
		<div class="profile-image-container">
			<!-- 동그란 프로필 이미지 -->
			<div class="profile-image" id="profile-image">
				<img
					src="${profileImagePath != null ? profileImagePath : '/images/egovframework/myPage/기본프로필2.png'}"
					alt="프로필 이미지" id="profileImgPreview"
					onerror="this.onerror=null; this.src='/images/egovframework/myPage/기본프로필2.png';">
			</div>
			<div class="profile-name">${loginInfo.userNickname}님</div>

			<!-- 프로필 이미지 업로드 폼 -->
			<form id="profileImageForm" action="/uploadProfileImage.do"
				method="post" enctype="multipart/form-data">
				<label for="profileImageInput" class="custom-file-upload"
					style="display: none;"> 프로필 사진 업로드 </label> <input type="file"
					id="profileImageInput" name="profileImage" accept="image/*"
					onchange="previewProfileImage(this)" style="display: none;" />
				<button type="submit" class="image-submit">적용하기</button>
			</form>
		</div>
		<form id="frm" name="frm">
			<input type="hidden" id="idChkYn" name="idChkYn" value="N" />
			<table>
				<tr>

					<td>닉네임</td>
				</tr>
				<tr>
					<td><input type="text" class="text" style="width: 180px;"
						id="userNickname" name="userNickname"
						value="${loginInfo.userNickname}" /></td>
				</tr>
				<tr>

					<td>아이디</td>
				</tr>
				<tr>
					<td><input type="text" class="text" style="width: 180px;"
						id="userId" name="userId" value="${loginInfo.userId}" /> <input
						type="button" id="btn_idChk" name="btn_idChk" value="중복검사" /></td>
				</tr>
				<tr>
					<td>생년월일</td>
				</tr>
				<tr>
					<td><input type="date" class="text" id="userBirth"
						name="userBirth" value="${loginInfo.userBirth}" /></td>
				</tr>
				<tr>
					<td>이메일</td>
				</tr>
				<tr>
					<td>
						<div class="email-container">
							<input type="text" class="email" id="email" name="email"
								value="${loginInfo.emailId}" />@ <select id="emailAddr"
								name="emailAddr">
								<option value="">--주소를 선택해주세요--</option>
								<option value="naver.com"
									<c:if test="${loginInfo.emailAddr eq 'naver.com'}">selected</c:if>>naver.com</option>
								<option value="gmail.com"
									<c:if test="${loginInfo.emailAddr eq 'gmail.com'}">selected</c:if>>gmail.com</option>
								<option value="daum.net"
									<c:if test="${loginInfo.emailAddr eq 'daum.net'}">selected</c:if>>daum.net</option>
								<option value="nate.com"
									<c:if test="${loginInfo.emailAddr eq 'nate.com'}">selected</c:if>>nate.com</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
				<tr>
					<td class="button-wrap"><input type="button" value="프로필 수정"
						class="btn" onclick="fn_updateProfile();"></td>
				</tr>
				<tr>
					<td>
						<div class="delete_user" onclick="fn_deleteUser();">회원탈퇴</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>

</html>