<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독서피드</title>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/book/bookFeed.css">
<link rel="stylesheet" href="/css/fontawesome/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#btn_search").on('click', function(){
		fn_selectList();
	});		
	// 사용할 그라데이션 클래스 리스트
    var gradients = ['gradient-1', 'gradient-2', 'gradient-3', 'gradient-4', 'gradient-5'];

    // 모든 .note-content 요소를 찾아서 랜덤으로 그라데이션 클래스 적용
    $('.note-content').each(function() {
        // 0부터 gradients 배열 길이 사이에서 랜덤 숫자 생성
        var randomIndex = Math.floor(Math.random() * gradients.length);
        
        // 선택된 랜덤 클래스 적용
        $(this).addClass(gradients[randomIndex]);
    });
    
    let currentIndex = 0;
    const feedItems = $(".note-item");
    
    // 모달 열기
    $(".note-item").click(function () {
        currentIndex = feedItems.index(this);
        showModal(currentIndex);
        $("#feedModal").fadeIn(300);  // 300ms 동안 서서히 나타나기
    });

    // 모달 닫기
    $(".close").click(function () {
        $("#feedModal").hide();
        $("#feedModal").fadeOut(300);  // 300ms 동안 서서히 사라지기
    });
 	// 모달 외부 클릭 시 닫기
    $(window).click(function(event) {
        if ($(event.target).is("#feedModal")) {
            $("#feedModal").hide();
        }
    });
    // 이전 버튼
    $("#prevButton").click(function () {
        if (currentIndex > 0) {
            currentIndex--;
            showModal(currentIndex);
        }
    });

    // 다음 버튼
    $("#nextButton").click(function () {
	        if (currentIndex < feedItems.length - 1) {
	            currentIndex++;
	            showModal(currentIndex);
	        }
	 });
	    
	//모달 내용 업데이트
	 function showModal(index) {
	     const selectedFeed = feedItems.eq(index);
	     const isbn = selectedFeed.find(".book_isbn").val(); // 히든 필드에서 ISBN 값 가져오기       
	  	// 모달에 데이터 추가
	     $("#modalBookTitle").text(selectedFeed.find(".book_title").val());
	     $("#modalBookAuthor").text(selectedFeed.find(".book_author").text());
	     $("#modalBookImage").attr("src", selectedFeed.find(".book-image").attr("src"));
	     $("#modalUserNickname").text(selectedFeed.find(".user-nickname").text());
	     $("#modalNoteTime").text(selectedFeed.find(".note-time").text());
	     const noteTagText = selectedFeed.find(".note_tag").val();
	     $("#modalNoteTag").text(noteTagText);
	     
	     // 히든 필드에서 전체 노트 내용 가져오기
	     $("#modalNoteContent").text(selectedFeed.find(".full-note-content").val());
	     
	  	 // 책 링크에 ISBN 값 설정
	     $("#bookLink").attr("href", "/bookDetail.do?isbn=" + isbn);
	
		 // 프로필 이미지 추가
		 const profileImageSrc = selectedFeed.find(".profileImgPreview").attr("src");
		 $("#modalProfileImage").attr("src", profileImageSrc);
	        
	     // 별점 표시
	     const rating = selectedFeed.find(".star-rating .selected").length;
	     $("#modalStarRating").html("");
	     for (let i = 1; i <= 5; i++) {
	        if (i <= rating) {
	                $("#modalStarRating").append('<i class="fas fa-star"></i>');
	         } else {
	                $("#modalStarRating").append('<i class="far fa-star"></i>');
	            }
	        }
	        
	        $("#feedModal").show();
	    }
});

function fn_selectList(){
    var frm = $("#searchFrm").serialize();
    $.ajax({
        url: '/bookFeed.do',
        method: 'post',
        data: frm,
        dataType: 'json',
        success: function (data) {
            // 결과 카운트를 업데이트
            //$("#total_counter").text('총 ' + data.totCnt + ' 건');

            // 받은 데이터를 모델로 업데이트
            window.location.reload();  // 페이지 리로딩을 통해 서버에서 필터링된 데이터 다시 로드
        },
        error: function (data, status, err) {
            console.log(err);
        }
    });
}

</script>
</head>
<body>
    <h1>독서 피드</h1>
    
    <!-- 검색 옵션과 피드 영역을 나란히 배치하는 컨테이너 -->
    <div class="content-container">
        
        <!-- 검색 옵션 -->
        <div id="search" class="search-container">
            <form id="searchFrm" name="searchFrm" action="/bookFeed.do" method="post">
                <ul class="search-options">
		                <!-- 별점 필터 추가 -->
		            <li>
		                <label for="noteRating" class="star-select">별점 선택:</label>
		                <select id="noteRating" name="noteRating" class="search-select">
		                    <option value="">전체</option> <!-- 전체 별점 선택 -->
		                    <option value="5">5점</option>
		                    <option value="4">4점</option>
		                    <option value="3">3점</option>
		                    <option value="2">2점</option>
		                    <option value="1">1점</option>
		                </select>
		            </li>
                    <li>
                        <select id="searchCondition" name="searchCondition" class="search-select">
                            <option value="book_title">책 이름</option>
                            <option value="book_author">저자</option>
                        </select>
                    </li>
                    <li>
                        <input type="text" id="searchKeyword" name="searchKeyword" class="search-input"/>
                    </li>
                    <li>
                        <input type="submit" id="btn_search" name="btn_search" value="검색" class="btn-search"/>
                    </li>
                </ul>
            </form>
        </div>
        
        <!-- 작성된 독서 노트 목록 출력 -->
        <div class="feed-container">
		    <c:if test="${not empty bookNoteDetails}">
		        <div class="note-grid">
		            <c:forEach var="note" items="${bookNoteDetails}">
		                <div class="note-item">
		                    <!-- 첫 번째 div: 작성자 정보 -->
							<div class="note-author">
						        <div class="profile-image">
						            <img src="${note.profileImagePath}" alt="프로필 이미지" id="profileImgPreview" class="profileImgPreview">
						        </div>
						        <p class="user-nickname">${note.user_nickname}</p> <!-- 작성자 -->
						        <p class="note-time">${note.timeDifference}</p> <!-- 작성 시간 차이 표시 -->
						    </div>
		
		                    <!-- 두 번째 div: 노트 내용 -->
		                    <div class="note-content">
		                        <c:choose>
		                            <c:when test="${fn:length(note.note_content) > 50}">
		                               	  ${fn:substring(note.note_content, 0, 50)}...
		                            </c:when>
		                            <c:otherwise>
		                                   ${note.note_content}
		                            </c:otherwise>
		                        </c:choose>
		                    </div>
							<!-- 전체 노트 내용을 히든 필드에 저장 -->
							<input type="hidden" class="full-note-content" value="${note.note_content}" />
		                    <!-- 세 번째 div: 책 정보 (제목, 저자, 이미지) -->
		                    <div class="note-book-info">
							    <div class="book-text-info">
							        <h3 class="short_book_title">${note.short_book_title}</h3> 							        
									<input type="hidden" class="book_title" value="${note.book_title}" />
									<input type="hidden" class="book_isbn" value="${note.book_isbn}" />
									<input type="hidden" class="note_tag" value="${note.note_tag}" />
							        <p class="book_author">${note.book_author}</p> 
							        <!-- note.note_rating 값이 없을 때 기본값 설정 -->
									<c:set var="noteRating" value="${note.note_rating != null ? note.note_rating : 0}" />
									<!-- 별점 표시 -->
									<div class="star-rating">
									    <c:forEach begin="1" end="5" var="i">
									        <span class="star">
									            <c:if test="${i <= noteRating}">
									                <i class="fas fa-star selected"></i> <!-- 선택된 별 (꽉 찬 별) -->
									            </c:if>
									            <c:if test="${i > noteRating}">
									                <i class="far fa-star"></i> <!-- 선택되지 않은 별 (비어 있는 별) -->
									            </c:if>
									        </span>
									    </c:forEach>
									</div>

							        
							    </div>
							    <img src="${note.book_image}" alt="${note.book_title}" class="book-image" /> <!-- 책 이미지 -->
							</div>

		
		                </div>
		            </c:forEach>
		        </div>
		    </c:if>
	   </div>

    </div>
    
    <!-- 책 노트가 없을 때 -->
    <c:if test="${empty bookNoteDetails}">
        <p>작성된 독서 노트가 없습니다.</p>
    </c:if>
    
    <!-- 모달 -->
	<div id="feedModal" class="modal" style="display: none;">
	    <div class="feed-modal-content">
	        <span class="close">&times;</span>
	
	        <!-- 이전, 다음 버튼 -->
	        <button class="prev" id="prevButton"><i class="fas fa-chevron-left"></i></button>
	        <button class="next" id="nextButton"><i class="fas fa-chevron-right"></i></button>
	
	        <!-- 피드 상세 내용 -->
	        <div id="modalFeedContent">
	            <!-- 사용자 정보 -->
	            <div class="user-info">
	                <div class="profile-image">
	                    <img id="modalProfileImage" src="" alt="프로필 이미지" class="profileImgPreview" />
	                </div>
	                <p class="user-nickname" id="modalUserNickname"></p>
	                <p class="note-time" id="modalNoteTime"></p>
	            </div>
	
	            <!-- 노트 내용 -->
	            <div class="note-content-full" id="modalNoteContent"></div>
	
	            <!-- 책 정보 -->
	         <a id="bookLink" href="" class="book-detail-link">
	            <div class="book-info">
	                    <img id="modalBookImage" src="" alt="책 이미지" class="book-image" />
	               
	                <div class="book-details">
	                    <h3 id="modalBookTitle"></h3>
	                    <p id="modalBookAuthor"></p>
	                    <div class="star-wrap">
		                    <div id="modalStarRating" class="modal-star-rating"></div> <!-- 별점 표시 부분 -->
		                    <div id="modalNoteTag" class="modalNoteTag"></div> <!-- 태그 표시 부분 -->
	                    </div>
	                </div>
	            </div>
	         </a>
	        </div>
	    </div>
	</div>

</body>
</html>