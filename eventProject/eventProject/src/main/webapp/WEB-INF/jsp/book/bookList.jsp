<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 검색 결과</title>
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="/css/egovframework/book/bookList.css?after">
<link rel="stylesheet" href="/css/fontawesome/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        // a 태그 클릭 시 Ajax로 폼 전송 후 페이지 이동
        $(".book-detail-link").on("click", function (event) {
            event.preventDefault(); // 기본 페이지 이동 막기

            // 클릭한 책의 부모 div에서 해당 폼 찾기
            const form = $(this).closest(".book").find(".save-book-form");

            // 폼 데이터를 FormData로 생성
            const formData = new FormData(form[0]);
            const targetUrl = $(this).attr("href");

            // Ajax로 폼 제출
            $.ajax({
                url: form.attr("action"),
                type: "POST",
                data: formData,
                processData: false, // FormData 사용 시 필요
                contentType: false, // FormData 사용 시 필요
                success: function (response) {
                    if (response === "success") {
                        // 저장 성공 시 책 상세 페이지로 이동
                        window.location.href = targetUrl;
                    } else {
                        alert("도서 저장에 실패했습니다.");
                    }
                },
                error: function () {
                    alert("서버와의 통신 중 오류가 발생했습니다.");
                }
            });
        });
    });
</script>
</head>
<body>
    <h2>도서 검색</h2>
	<!-- 도서 검색 폼 -->
    <form action="/search.do" id="searchfrm" method="get" class="search-form">
        <input type="text" id="query" name="query" placeholder="검색어를 입력하세요." required />
        <button type="submit">검색</button>
    </form>

 <c:if test="${not empty books}">
    <h3>총 ${books.size()}권</h3>
    <div class="book-container">
        <c:forEach var="book" items="${books}">
            <div class="book" style="position: relative;">
                <!-- 도서 정보를 서버에 POST 방식으로 전송하는 숨겨진 폼 -->
                <form action="/book/saveBook.do" method="post" class="save-book-form">
                    <input type="hidden" name="title" value="${book.title}" />
                    <input type="hidden" name="author" value="${book.author}" />
                    <input type="hidden" name="publisher" value="${book.publisher}" />
                    <input type="hidden" name="pubdate" value="${book.pubdate}" />
                    <input type="hidden" name="isbn" value="${book.isbn}" />
                    <input type="hidden" name="discount" value="${book.discount}" />
                    <input type="hidden" name="description" value="${book.description}" />
                    <input type="hidden" name="link" value="${book.link}" />
                    <input type="hidden" name="image" value="${book.image}" />
                </form>

                <!-- 도서 상세 페이지 이동 링크 -->
                <a href="/bookDetail.do?isbn=${book.isbn}" class="book-detail-link" >
                    <div class="book-image">
                        <img src="${book.image}" alt="${book.title}" width="50" />
                    </div>
                    <div class="book-title-wrap">
                        <div class="book-title">${book.title}</div>
                        <div class="book-author">${book.author}</div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</c:if>

<!-- 검색 결과 없을 때 -->
    <c:if test="${empty books}">
        <h3>검색 결과가 없습니다.</h3>
    </c:if>

</body>
</html>