<%
    String currentPage = request.getRequestURI(); // 현재 요청된 URL 경로를 가져옴
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<head>
<link type="text/css" rel="stylesheet" href="/css/egovframework/common/header.css?after"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>
<script type="text/javascript">
    $(document).ready(function() {
        // 스크롤 시 헤더 고정 효과 및 검색 폼 추가
        $(window).on('scroll', function() {
            const header = $('.header-wrap');

            if ($(this).scrollTop() > 250) {
                header.addClass('fixed-header'); // 스크롤이 100px 이상이면 고정

                // 검색 폼이 추가되어 있지 않으면 추가
                if (!$('#header-search-form').length) {
                	var listHtml = '';
                    listHtml += '<form id="header-search-form" class="header-search-form" action="/search.do" method="get">';
                    listHtml += '    <input type="text" id="header-query" name="query" placeholder="검색어를 입력하세요." required />';
                    listHtml += '    <button type="submit" class="search-icon"><i class="fas fa-search"></i></button>';
                    listHtml += '</form>';
                    
                    // search-section에 검색 폼을 추가
                    $('.search-section').html(listHtml).show();
                }
            } else {
                header.removeClass('fixed-header'); // 스크롤이 100px 미만이면 원래 상태로
                $('.search-section').empty(); // 검색 폼을 제거하여 숨김
            }
        });
        
        // 햄버거 메뉴 클릭 시 모달창 열기
        $("#hamburgerMenu").click(function() {
            $("#menuModal").fadeIn();
        });

        // 모달창 닫기 버튼 클릭 시 닫기
        $(".close-modal").click(function() {
            $("#menuModal").fadeOut();
        });

        // 모달창 외부 클릭 시 닫기
        $(window).click(function(event) {
            if ($(event.target).is("#menuModal")) {
                $("#menuModal").fadeOut();
            }
        });
    });


    </script>
</head>
<header>
    <div class="header-wrap">
        <div class="left-section">
            <a href="/mainPage.do" class="logo">Logo</a>
            <!-- 네비게이션 메뉴 -->
            <nav class="page-menu">
                <a href="/bookFeed.do" class="${currentPage == '/bookFeed.do' ? 'active' : ''}">독서 피드</a>
                <a href="/bookRecordPage.do" class="${currentPage == '/bookRecordPage.do' ? 'active' : ''}">독서 기록</a>
                <a href="/calendarPage.do" class="${currentPage == '/calendarPage.do' ? 'active' : ''}">독서 달력</a>
            </nav>
        </div>
        <div class="search-section"></div>
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${not empty loginInfo}">
                    <a href="/myPage.do" class="user-nickname">안녕하세요, <strong>${loginInfo.userNickname}</strong>님</a>
                    <a href="/logout.do" class="logout">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a href="/login.do" class="login">로그인</a>
                    <a href="/join.do" class="signup">회원가입</a>
                </c:otherwise>
            </c:choose>
            <!-- 햄버거 메뉴 아이콘 (모바일용) -->
            <div class="hamburger-menu" id="hamburgerMenu">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </div>
</header>

<!-- 모달 메뉴 -->
<div id="menuModal" class="menu-modal" style="display: none;">
    <div class="modal-content">
        <button class="close-modal">&times;</button>
        <nav class="modal-menu">
            <a href="/bookFeed.do">독서 피드</a>
            <a href="/bookRecordPage.do">독서 기록</a>
            <a href="/calendarPage.do">독서 달력</a>
        </nav>
    </div>
</div>
