<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좋아요 한 도서 전체보기</title>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/book/likedbooks.css?after">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	fn_selectList();
});
function fn_selectList(){
	 var frm = $(this).serialize(); // 폼 데이터 직렬화
     $.ajax({
         url: '/likedBooksList.do', // 좋아요한 도서 전체 목록을 반환하는 URL
         method: 'POST',
         data: frm,
         dataType: 'json',
         success: function(data) {
             console.log("응답 데이터: ", data);            
         },
         error: function(xhr, status, error) {
             console.error('AJAX 요청 오류: ', error);
         }
     });
 
}
</script>
</head>
<body>
    <h2>좋아요 한 도서 전체보기</h2>
<div class="liked-books-container">
    
    <!-- 검색 옵션 -->
    <div id="search" class="search-container">
        <form id="searchFrm" name="searchFrm" method="post">
            <ul class="search-options">
                <li>
                    <select id="searchCondition" name="searchCondition" class="search-select">
                        <option value="book_title">책 이름</option>
                        <option value="book_author">저자</option>
                    </select>
                </li>
                <li>
                    <input type="text" id="searchKeyword" name="searchKeyword" class="search-input" placeholder="검색어를 입력하세요"/>
                </li>
                <li>
                    <select id="tagSelect" name="tagSelect" class="search-select">
                        <option value="">전체보기</option>
                        <option value="#소설">소설</option>
                        <option value="#자기계발">자기계발</option>
                        <option value="#외국어">외국어</option>
                        <option value="#여행">여행</option>
                        <option value="#에세이&시">에세이&시</option>
                        <option value="#경제">경제</option>
                        <option value="#인문">인문</option>
                        <option value="#과학">과학</option>
                        <option value="#만화">만화</option>
                    </select>
                </li>
                <li>
                    <input type="submit" id="btn_search" name="btn_search" value="검색" class="btn-search"/>
                </li>
            </ul>
        </form>
    </div>
    
    <!-- 좋아요한 도서 전체 개수 표시 -->
    <div class="total-like-count-container">
        <span>총 좋아요한 도서 수: <span class="total-like-count">${likedBookList.size()}권</span></span>
    </div>
    
    <!-- 좋아요한 도서 목록 출력 -->
    <div class="liked-book-list">
        <c:if test="${not empty likedBookList}">
                <c:forEach var="book" items="${likedBookList}">
                    <div class="note-item">
                        <div class="note-book-info">
                        	<a href="/bookDetail.do?isbn=${book.bookIsbn}" class="book-detail-link">
                            	<img src="${book.bookImage}" alt="${book.bookTitle}" class="book-image" /> <!-- 책 이미지 -->
                            </a>
                            <div class="book-text-info">
                                <h3>${book.bookTitle}</h3> <!-- 책 제목 -->
                                <p>${book.bookAuthor}</p> <!-- 책 저자 -->
                            </div>
                        </div>
                    </div>
                </c:forEach>
        </c:if>
        <c:if test="${empty likedBookList}">
            <p style="text-align: center;">좋아요한 도서가 없습니다.</p>
        </c:if>
    </div>
</div>

</body>
</html>

</html>