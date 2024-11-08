<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 검색 결과</title>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/book/bookDetail.css">
<link rel="stylesheet" href="/css/fontawesome/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    // 책 이미지의 src 속성을 가져옴.
    var imgSrc = $('.book-image').attr('src');
    
    // img-box에 ::before에 배경 이미지로 설정하는 동적 스타일을 추가
    var style = '<style>.img-box::before { content: ""; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: url(' + imgSrc + '); background-size: cover; background-position: center; filter: blur(16px); opacity: 0.5; z-index: 0; }</style>';
    
    // 동적으로 생성한 스타일을 head에 추가.
    $('head').append(style);
    
 	// "전체보기" 클릭 시
    $('.show-more').click(function() {
        $(this).parent('.short-text').hide(); 						// 짧은 텍스트 숨김
        $(this).closest('.book-content').find('.full-text').show(); // 전체 텍스트 보임
    });

    // "접기" 클릭 시
    $('.show-less').click(function() {
        $(this).parent('.full-text').hide(); // 전체 텍스트 숨김
        $(this).closest('.book-content').find('.short-text').show(); // 짧은 텍스트 보임
    });
    
 	// 좋아요 버튼 클릭 이벤트
    $(".like-btn").on("click", function() {
        var isbn = $(this).data("isbn"); // ISBN 가져오기
        var likeBtn = $(this); // 클릭한 좋아요 버튼 참조
        var heartIcon = likeBtn.find("i"); // 하트 아이콘 참조
        
        // Ajax로 좋아요 데이터를 서버로 전송
        $.ajax({
            url: '/likeBook.do', // 좋아요 처리할 서버 API
            method: 'POST',
            data: { isbn: isbn },
            dataType: 'json',
            success: function(data) {
                if (data.result === 'success') {
                    // 좋아요 개수 업데이트
                    likeBtn.find(".like-count").text(data.likeCount);
                    // 하트 아이콘을 채워진 하트로 변경
                    heartIcon.removeClass("far").addClass("fas");
                } else if (data.result === 'unliked') {
                    // 좋아요 개수 업데이트
                    likeBtn.find(".like-count").text(data.likeCount);
                    // 하트 아이콘을 빈 하트로 변경
                    heartIcon.removeClass("fas").addClass("far");
                }else if (data.result === 'fail') {
                    // 실패 메시지 표시 (로그인 필요 등)
                    alert(data.message);
                } else {
                    alert("좋아요 처리에 실패하였습니다.");
                }

                // 애니메이션 클래스 추가 및 일정 시간 후 제거
                heartIcon.addClass("animate-like");
                setTimeout(function() {
                    heartIcon.removeClass("animate-like");
                }, 300); // 애니메이션 지속 시간 (0.3초)
            },
            error: function(xhr, status, error) {
                console.error("좋아요 처리 중 오류 발생: " + error);
            }
        });
    });

});


</script>
</head>
<body>
		     
	 <c:if test="${not empty bookList}">
        <c:forEach var="book" items="${bookList}">
	      <div class="book-detail">
	        <div class="book-info">
	            <div class="img-box">
	                <img src="${book.image}" alt="${book.title}" width="100" class="book-image" />
	            </div>
	            <div class="title-box">
	                <h2 class="book-title">${book.title}</h2>
	                <div class="book-author"> ${book.author}</div>
	                 <div class="public-box">
		                <p class="book-publisher"> ${book.publisher}</p>
		                <p class="book-pubdate"> ${book.pubdate}</p>
	                </div>
                    <!-- 평균 별점 표시 -->
                    <div class="star-rating">
					    <c:choose>
					        <c:when test="${empty avgRating || avgRating == 0}">
					            <p class="no-rating-message">아직 등록된 별점이 없습니다</p>
					        </c:when>
					        <c:otherwise>
					            <c:forEach begin="1" end="5" var="i">
					                <div class="star">
					                    <div class="star-filled" style="width: ${avgRating >= i ? '100' : (avgRating >= i - 1 ? (avgRating % 1) * 100 : '0')}%; ">
					                        <i class="fas fa-star"></i>
					                    </div>
					                    <div class="star-empty">
					                        <i class="far fa-star"></i>
					                    </div>
					                </div>
					            </c:forEach>
					            <div class="star-score">
					                ${avgRating}점
					            </div>
					        </c:otherwise>
					    </c:choose>
					</div>
	                <div class="button-container">
			            <a href="/bookNote.do?isbn=${book.isbn}">
    						<div class="note-btn">독서 노트 작성하기</div>
						</a>
						<!-- 좋아요 버튼 -->	
						<div class="like-btn" data-isbn="${book.isbn}">
						    <i class="${userLiked ? 'fas' : 'far'} fa-heart"></i> <!-- userLiked 값에 따라 하트 아이콘 변경 -->
						    <span class="like-count">${likeCount}</span> <!-- 좋아요 개수 표시 -->
						</div>
            		</div> 
	            </div>
		      </div>
	       </div>
	       <div class="book-detail-wrap">
		        <div class="book-content-title">책 소개</div>
		        <p class="book-content">
	                <span class="short-text">
	                    ${fn:substring(book.description, 0, 250)}... 
	                    <a href="javascript:void(0);" class="show-more">전체보기</a>
	                </span>
	                <span class="full-text" style="display:none;">
	                    ${book.description} 
	                    <a href="javascript:void(0);" class="show-less">접기</a>
	                </span>
            	</p>
            	<div class="book-info-title">책 정보</div>
            	<div class="book-info-wrap">
	            	<div class="book-discount">
	            		<div class="title">가격 </div> 
	            		<div class="sub">${book.discount}원 </div> 
	            	</div>
	            	<div class="book-isbn">
	            		<div class="title">ISBN</div> 
	            		<div>${book.isbn}</div> 
	            	</div>
	            	<div class="book-link">
	    				<a href="${book.link}">
   							링크로 이동하기
						</a>
					</div>
				</div>
	        </div>
	     </div>
        </c:forEach>
    </c:if>
    	
    
    <a class="note-btn" href="/mainPage.do">검색으로 돌아가기</a>
</body>
</html>