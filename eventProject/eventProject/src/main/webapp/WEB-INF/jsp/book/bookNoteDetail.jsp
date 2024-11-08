<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<link rel="stylesheet" href="/css/egovframework/book/bookNoteDetail.css?after">
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<script type="text/javascript">
$(document).ready(function(){
	
		$("#btn_save").on('click', function(){
			fn_save();
		});	
		
		// 기존 별점 값으로 별 선택 상태 설정
	    var currentRating = parseInt($(".noteRating").val());

	    if (!isNaN(currentRating) && currentRating > 0) {
	        var stars = $(".star-rating .star");
	        for (var i = 0; i < stars.length; i++) {
	            if ((i + 1) <= currentRating) {  // i는 0부터 시작하므로 i+1
	                $(stars[i]).find("i").removeClass("far").addClass("fas"); // 선택된 별은 채워진 별
	            } else {
	                $(stars[i]).find("i").removeClass("fas").addClass("far"); // 선택되지 않은 별은 비어있는 별
	            }
	        }
	    }

	    // 별 클릭 이벤트
	    $(".star-rating .star").on("click", function() {
	        var onStar = parseInt($(this).data("value")); // 클릭한 별의 값을 가져옴

	        var stars = $(this).parent().children(".star");

	        // 선택된 별까지 선택 상태로 변경
	        for (var i = 0; i < stars.length; i++) {
	            if ((i + 1) <= onStar) {  // i는 0부터 시작하므로 i+1로 비교
	                $(stars[i]).find("i").removeClass("far").addClass("fas"); // 선택된 별은 채워진 별
	            } else {
	                $(stars[i]).find("i").removeClass("fas").addClass("far"); // 선택되지 않은 별은 비어있는 별
	            }
	        }

	        // 선택된 별의 값을 숨겨진 input에 저장
	        $(this).parent().find(".noteRating").val(onStar);
	        console.log("숨겨진 input에 저장된 별점 값: " + $(this).parent().find(".noteRating").val());
	    	});
	    
	 // 태그 선택 창 열기
	    $("#tagSelector").on("click", function() {
	        const tags = ["#소설", "#자기계발", "#외국어", "#여행", "#에세이&시", "#경제", "#인문", "#과학", "#만화"];
	        let tagOptions = '';

	        // for 문을 사용해 태그 버튼 HTML을 하나씩 추가
	        for (var i = 0; i < tags.length; i++) {
	            tagOptions += '<button class="tag-option" data-tag="' + tags[i] + '">' + tags[i] + '</button><br>';
	        }
	        
	        // 모달 HTML 추가
	        let modalHtml = '<div class="tag-modal">' +
	                            '<div class="tag-content">' +
	                                tagOptions +
	                            '</div>' +
	                        '</div>';
	        
	        // 모달 창 HTML 삽입
	        $("body").append(modalHtml);
	    });

	    // 태그 옵션 버튼 클릭 이벤트 (이벤트 위임 방식 사용)
	    $(document).on("click", ".tag-option", function() {
	    	let selectedTag = $(this).data("tag");
	        if (selectedTag) {
	            $("#tagSelector").text('#' + selectedTag); 
	            $("#selectedTag").val('#'+selectedTag);
	        }
	        $(".tag-modal").remove();
	    });

	    // 모달 창 외부를 클릭하면 모달 닫기
	    $(document).on("click", ".tag-modal", function(event) {
	        if (!$(event.target).closest(".tag-content").length) {
	            $(".tag-modal").remove();
	        }
	    });
		
	    
});

	function fn_save(){
		var frm = $("#frm").serialize();
		
		$.ajax({
		    url: '/updateBookNote.do',
		    method: 'post',
		    data : frm,
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("독서노트가 수정 되었습니다.");
		    		location.href="/bookNoteListPage.do";
		    	}else{
		    		alert("저장에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}	
</script>
</head>
<body>
 <div class="wrap">
	<div class="book-info">
       
        <!--독서 노트 작성 폼 -->
        <img src="${bookInfo.image}" alt="${bookInfo.title}" class="book-image" />

         <div class="book-details">
               <h2 class="book-title">${bookInfo.title}</h2>
               <p class="book-author">${bookInfo.author}</p>
         </div>
           
    </div>
	<form id="frm" name="frm" class="note-form">
          <table>
           <input type="hidden" id="noteIdx" name="noteIdx" value="${noteIdx}"/>
                    <tr>
                        <td>읽기 시작한 날짜</td>
                        <td><input type="date" id="noteStartDate" name="noteStartDate" class="input-text"  value="${noteInfo.noteStartDate}"/></td>
                    </tr>
                    <tr>
                        <td>마지막으로 읽은 날짜</td>
                        <td><input type="date" id="noteEndDate" name="noteEndDate" class="input-text"   value="${noteInfo.noteEndDate}"/></td>
                    </tr>
                    <tr>
                        <td>내용 요약</td>
                        <td><textarea id="noteContent" name="noteContent" class="input-text">${noteInfo.noteContent}</textarea></td>
                    </tr>                 
                    <tr>
					    <td>별점</td>
					    <td>
					        <div class="star-rating">
					            <c:forEach begin="1" end="5" var="i">
					                <c:choose>
					                    <c:when test="${i <= noteInfo.noteRating}">
					                        <span class="star" data-value="${i}">
					                            <i class="fas fa-star selected"></i> <!-- 선택된 별 -->
					                        </span>
					                    </c:when>
					                    <c:otherwise>
					                        <span class="star" data-value="${i}">
					                            <i class="fas fa-star"></i> <!-- 선택되지 않은 별 -->
					                        </span>
					                    </c:otherwise>
					                </c:choose>
					            </c:forEach>
								
					            <!-- 별점 값을 저장하는 숨겨진 input 필드 -->
					            <input type="hidden" name="noteRating" class="noteRating" value="${noteInfo.noteRating}" /> <!-- 기존 별점 값 -->
					        </div>
					    </td>
					</tr>
					<tr>
					    <td>태그</td>
					    <td>
					        <!-- 선택된 태그를 표시할 때만 #을 붙이고, hidden input 값에는 태그명만 저장 -->
					        <div id="tagSelector" class="tag-selector">
					            ${noteInfo.noteTag != null ? noteInfo.noteTag : '태그 선택하기'}
					        </div>
					        <input type="hidden" id="selectedTag" name="selectedTag" value="${noteInfo.noteTag != null ? noteInfo.noteTag : ''}" />
					    </td>
					</tr>
					<tr>
                        <td>공개 여부</td>
                        <td>
					        <input type="radio" id="noteShowYnY" name="noteShowYn" value="Y" 
					               <c:if test="${noteInfo.noteShowYn == 'Y'}">checked</c:if> />
					        <label for="noteShowYnY">공개</label>
					
					        <input type="radio" id="noteShowYnN" name="noteShowYn" value="N" 
					               <c:if test="${noteInfo.noteShowYn == 'N'}">checked</c:if> />
					        <label for="noteShowYnN">비공개</label>
					    </td>
                    </tr>   
                    <tr>
                        <td>독서노트 생성일자</td>
                        <td><input type="text" id="noteCreateDate" name="noteCreateDate" class="input-text" value="${noteInfo.noteCreateDate}"/></td>
                    </tr>
                    <tr>
                        <td>독서노트 수정일자</td>
                        <td><input type="text" id="noteUpdateDate" name="noteUpdateDate" class="input-text" value="${noteInfo.noteUpdateDate}"/></td>
                    </tr>                
          </table>
          <div class="btn-form"style="float:right;">
			<input type="button" id="btn_save" class="btn_save" name="btn_save" value="저장하기"/>
			<input type="button" id="btn_list" class="btn_list" name="btn_list" value="목록으로" onclick="location.href='/bookNoteListPage.do'"/>
		 </div>
      </form>
      
     </div>
      
</body>
</html>