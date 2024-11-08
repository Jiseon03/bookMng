<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/book/bookRecord.css?after">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
    $.ajax({
        url: '/bookRecord.do',
        method: 'POST',
        dataType: 'json',
        success: function(data) {
            if (data.result === 'success') {
              
                
                var listHtml = '';              
                var maxDisplayCount = 5;
                var likedBookList = data.likedBookList;
                $('.like-info .myInfo-sub').text(likedBookList.length + '개');
                if (likedBookList.length > 0) {
                    for (var i = 0; i < likedBookList.length && i < maxDisplayCount; i++) {
                        listHtml += '<a href="/bookDetail.do?isbn=' + likedBookList[i].bookIsbn + '" class="book-detail-link">';
                        listHtml += '<div class="book-item">';
                        listHtml += '<img src="' + likedBookList[i].bookImage + '" alt="' + likedBookList[i].bookTitle + '" class="book-image" />';
                        listHtml += '<div class="book-title">' + likedBookList[i].bookTitle + '</div>';
                        listHtml += '<div class="book-author">' + likedBookList[i].bookAuthor + '</div>';
                        listHtml += '</div>';
                        listHtml += '</a>';
                    }
                
                } else {
                    listHtml += '<p style="text-align: center;">좋아요한 도서가 없습니다.</p>';
                }
                $(".liked-book-list").html(listHtml);
            } else {
                alert(data.message);
            }
        },
        error: function(xhr, status, error) {
            console.error('AJAX 요청 오류: ', error);
        }
    });
  
    $.ajax({
        url: '/selectBookNoteList.do',
        method: 'POST',
        dataType: 'json',
        success: function(data) {          
                $('.note-info .myInfo-sub').text(data.list.length + '개');
                
                var listHtml = '';              
                var maxDisplayCount = 5;            

                if (data.list.length > 0) {
                    for (var i = data.list.length - 1; i >= 0 && i >= data.list.length - maxDisplayCount; i--) {
                    	listHtml += '<a href="/bookNoteDetail.do?noteIdx=' + data.list[i].noteIdx + '" class="book-detail-link">';
                        listHtml += '<div class="book-item">';
                        listHtml += '<img src="' + data.list[i].bookImage + '" alt="' + data.list[i].bookTitle + '" class="book-image" />';
                        listHtml += '<div class="book-title">' + data.list[i].bookTitle + '</div>';
                        listHtml += '<div class="book-author">' + data.list[i].bookAuthor + '</div>';
                        listHtml += '</div>';  
                        listHtml += '</a>';
                    }
                
                } else {
                    listHtml += '<p style="text-align: center;">작성한 도서 노트가 없습니다.</p>';
                }
                $(".book-note-list").html(listHtml);
             
        },
        error: function(xhr, status, error) {
            console.error('AJAX 요청 오류: ', error);
        }
    });
});

</script>
</head>
<body>
    <h1>독서 기록</h1>
    <div class="mypage-container">
	    <div class="book-like">
	        <!-- 좋아요한 도서 개수 및 '전체보기' 링크 표시 -->
	        <div class="like-info myInfo-header">
	        	<div class="myInfo-title">좋아요 한 도서목록</div>
	            <div class="myInfo-sub">0권</div> <!-- Ajax에서 동적으로 업데이트 -->
	            <a href="likedBooksList.do" class="view-all-link">전체보기</a> <!-- 오른쪽 정렬된 전체보기 링크 -->
	        </div>
	
	        <!-- 좋아요한 도서 목록 출력 -->
	        <div class="liked-book-list list-wrap">
	            <!-- 여기에 Ajax에서 받아온 도서 목록이 동적으로 추가됨 -->
	        </div>
	    </div>
	    <div class="book-note">
		    <div class="note-info myInfo-header">
		        <div class="myInfo-title">작성한 독서 노트</div>
		        <div class="myInfo-sub">0개</div> <!-- Ajax에서 동적으로 업데이트 -->
		        <a href="/bookNoteListPage.do" class="view-all-link">전체보기</a>
		    </div>
		    
		    <!-- 좋아요한 도서 목록 출력 -->
	        <div class="book-note-list list-wrap">
	            <!-- 여기에 Ajax에서 받아온 도서 목록이 동적으로 추가됨 -->
	        </div>
	    </div>
	</div>


</body>

</html>