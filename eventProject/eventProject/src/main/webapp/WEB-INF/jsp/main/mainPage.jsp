<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/main/mainPage.css?after"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Insert title here</title>
<script type="text/javascript">
$(document).ready(function() {
    // AJAX로 좋아요 많은 도서 목록 가져오기
    $.ajax({
        url: '/getTopLikedBooks.do',
        method: 'POST',
        dataType: 'json',
        success: function(data) {
            var listHtml = '';
            
            if (data.topLikedBooks.length > 0) {
                for (var i = 0; i < data.topLikedBooks.length; i++) {
                	listHtml += '<a href="/bookDetail.do?isbn=' + data.topLikedBooks[i].bookIsbn + '" class="book-detail-link">';
                	listHtml += '    <div class="book-item">';
                	listHtml += '        <img src="' + data.topLikedBooks[i].bookImage + '" alt="' + data.topLikedBooks[i].bookTitle + '" class="book-image" />';
                	listHtml += '        <div class="book-title">' + data.topLikedBooks[i].bookTitle + '</div>';
                	listHtml += '        <div class="book-author">' + data.topLikedBooks[i].bookAuthor + '</div>';
                	listHtml += '        <div class="book-likes">💖 ' + data.topLikedBooks[i].likeCount + '</div>';
                	listHtml += '    </div>';
                	listHtml += '</a>';
                }
            } else {
                listHtml += '<p style="text-align:center;">조회된 도서가 없습니다.</p>';
            }

            // HTML에 삽입 후 너비 재계산
            $('.book-list').html(listHtml);
            Slider();
        },
        error: function(error) {
            console.error("Error fetching liked books: ", error);
        }
    });
    
	const tags = ["소설", "자기계발", "외국어", "여행", "에세이&시", "경제", "인문", "과학", "만화"];
    
    // 태그 버튼 HTML을 누적하여 생성
    let tagButtonsHtml = '';
    for (var i = 0; i < tags.length; i++) {
        tagButtonsHtml += '<button class="tag-button" data-tag="' + tags[i] + '">#' + tags[i] + '</button>';
    }
    $('#tagButtons').html(tagButtonsHtml);

    // 랜덤으로 태그 선택하여 표시
    const randomTag = tags[Math.floor(Math.random() * tags.length)];
    $('#selectedCategoryText').text('현재 ' + randomTag + ' 분야 인기 책'); // 랜덤 태그로 텍스트 설정
    fetchBooksByTag(randomTag); // 랜덤 태그에 맞는 책 목록 가져오기

    // 태그 버튼 클릭 시 선택한 태그로 책 목록 가져오기
    $('.tag-button').on('click', function() {
        const tag = $(this).data('tag');
        $('#selectedCategoryText').text('현재 ' + tag + ' 분야 인기 책'); // 선택된 태그로 텍스트 설정
        fetchBooksByTag(tag); // 선택한 태그에 맞는 책 목록 가져오기
    });

    // 특정 태그의 도서 목록을 AJAX로 가져오는 함수
    function fetchBooksByTag(tag) {
        $.ajax({
            url: '/selectTopBooksByTag.do',
            method: 'post',
            data: { tag: tag },
            dataType: 'json',
            success: function(data) {
                let listHtml = '';
                if (data.BooksByTag && data.BooksByTag.length > 0) {
	                for (var i = 0; i < data.BooksByTag.length; i++) {
	                    listHtml += '<a href="/bookDetail.do?isbn=' + data.BooksByTag[i].bookIsbn + '" class="book-detail-link">';
	                    listHtml += '    <div class="category-book-item">';
	                    listHtml += '        <img src="' + data.BooksByTag[i].bookImage + '" alt="' + data.BooksByTag[i].bookTitle + '" class="category-book-image" />';
	                    listHtml += '        <div class="category-book-title">' + data.BooksByTag[i].bookTitle + '</div>';
	                    listHtml += '        <div class="category-book-author">' + data.BooksByTag[i].bookAuthor + '</div>';
	                    listHtml += '    </div>';
	                    listHtml += '</a>';
	                }
	            }else {
                    listHtml = '<p>해당 카테고리에 도서가 없습니다.</p>';
                }
                
                // bookList에 HTML 삽입
                $('#bookList').html(listHtml);
            },
            error: function(err) {
                console.error("AJAX 요청 실패:", err);
                $('#bookList').html('<p>도서를 불러오는 중 오류가 발생했습니다.</p>');
            }
        });
    }
});

    function Slider() {
        // moveAmount를 고정된 값으로 설정 (책 1권의 너비)
        var moveAmount = $('.book-item').outerWidth(true); // 초기화 시 한 번만 계산
        var currentPosition = 0;
        var maxPosition = -($('.book-item').length - 5) * moveAmount; // 왼쪽으로 최대 이동 가능한 위치
        
        // 오른쪽 화살표 클릭 이벤트
        $('#right-arrow').on('click', function() {
            // 오른쪽 이동 가능할 때만
            if (currentPosition > maxPosition) {
                currentPosition -= moveAmount; // 고정된 moveAmount 값으로 이동
                console.log(moveAmount)
                console.log(currentPosition);
                $('.book-list').css('transform', 'translateX(' + currentPosition + 'px)');
            }
        });

        // 왼쪽 화살표 클릭 이벤트
        $('#left-arrow').on('click', function() {
            // 왼쪽 이동 가능할 때만
            if (currentPosition < 0) {
                currentPosition += moveAmount; // 고정된 moveAmount 값으로 이동
                $('.book-list').css('transform', 'translateX(' + currentPosition + 'px)');
            }
        });
    }



</script>
</head>
<body>
	<div class="search-container">
	    <div class="search-container-title">지금 좋아하는 도서를 검색해 보세요</div>
	    <form action="/search.do" id="searchfrm" method="get" class="search-form">
	        <input type="text" id="query" name="query" placeholder="검색어를 입력하세요." required />	       	
	        <button type="submit">검색</button>
	    </form>
	</div>

	
	<!-- 좋아요가 많은 도서 목록 섹션 -->
	<div class="recommended-books-container">
	    <h2>인기 도서</h2>
	    <p>가장 많이 좋아요를 받은 도서 상위 10개를 추천드립니다.</p>
	    <!-- 왼쪽 화살표 -->
		<div class="carousel-arrow left-arrow" id="left-arrow">
	        	<i class="fas fa-chevron-left left-arrow"></i>
		</div>
		 <!-- 오른쪽 화살표 -->
	    <div class="carousel-arrow right-arrow" id="right-arrow">
	        	<i class="fas fa-chevron-right right-arrow"></i>
	    </div>
	    <!-- 슬라이드 컨테이너 -->
	    <div class="carousel-container">
	        <!-- 도서 목록 슬라이드 -->
	        <div class="book-list-wrapper">
	            <div class="book-list"></div> <!-- Ajax에서 도서 목록 동적으로 추가 -->
	        </div>
	    </div>  
	</div>
	
	<!-- 카테고리 -->
	<div class="category-container">
	    <h2>분야 별 책 추천</h2>
	    <p id="selectedCategoryText">현재 전체 분야 인기 책</p> 
	    
	    <!-- 태그 버튼을 표시할 영역 -->
        <div id="tagButtons" class="tag-buttons">
            <!-- JavaScript로 태그 버튼 추가 -->
        </div>

        <!-- 도서 목록 -->
        <div id="bookList" class="category-book-list">
            <!-- AJAX에서 도서 목록 동적 추가 -->
        </div>
	</div>


</body>
</html>