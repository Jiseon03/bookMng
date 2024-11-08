<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
    <title>FullCalendar Demo</title>
    <link rel="stylesheet" href="/css/egovframework/common/main.css?after">
	<link rel="stylesheet" href="/css/egovframework/calendar/mainCalendar.css">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales/ko.js"></script> <!-- 한국어 지원 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <h1>독서 달력</h1>
    
    <!-- 읽은 책 개수와 관심 책 개수를 표시하는 영역 -->
    <div id="bookCountsInfo">
	    <div class="bookNoteCount">
	    	<div id="monthlyReadBookCount" class="count">0권</div>
	        <div class="icon-text">	            
	            <span>읽은 책</span>
	            <i class="fas fa-book"></i> <!-- 책 아이콘 -->
	            <div class = "block"></div>
	            <div class="change-info" id="readChange">
	            <!-- 상승/하락 정보가 표시될 위치 -->
	        	</div>
	        </div>	        
	    </div>
	    
	    <div class="bookLikeCount">
	    	<div id="monthlyFavoriteBookCount" class="count">0권</div>
	        <div class="icon-text">            
	            <span>관심 책</span>
	            <i class="fas fa-heart"></i> <!-- 하트 아이콘 -->
	            <div class = "block"></div>
	            <div class="change-info" id="likeChange">
	            <!-- 상승/하락 정보가 표시될 위치 -->
	        	</div>
	        </div>	        
	    </div>
	</div>
	
    <div id="calendar"></div>

	<script>
    // 월별 책 개수를 가져오는 함수
    function loadMonthlyBookCounts(yearMonth) {
        $.ajax({
            url: '/getMonthlyBookCounts.do',
            method: 'GET',
            data: { yearMonth: yearMonth },
            dataType: 'json',
            success: function(data) {
                // 현재 월의 개수 업데이트
                $('#monthlyReadBookCount').text(data.readBookCount + ' 권');
                $('#monthlyFavoriteBookCount').text(data.favoriteBookCount + ' 권');

                // 지난달 데이터와 비교하여 상승/하락 표시
                const readDifference = data.readBookCount - data.previousReadBookCount;
                const likeDifference = data.favoriteBookCount - data.previousFavoriteBookCount;
				console.log(readDifference)
                // 상승/하락 아이콘과 차이 표시
				if (readDifference > 0) {
				    $('#readChange').html('<i class="fas fa-caret-up" style="color: #28a745;"></i> ' + readDifference );
				} else if (readDifference < 0) {
				    $('#readChange').html('<i class="fas fa-caret-down" style="color: #dc3545;"></i> ' + Math.abs(readDifference) );
				} else {
				    $('#readChange').html('변동 없음');
				}

				if (likeDifference > 0) {
				    $('#likeChange').html('<i class="fas fa-caret-up" style="color: #28a745;"></i> ' + likeDifference );
				} else if (likeDifference < 0) {
				    $('#likeChange').html('<i class="fas fa-caret-down" style="color: #dc3545;"></i> ' + Math.abs(likeDifference) );
				} else {
				    $('#likeChange').html('변동 없음');
				}


            },
            error: function() {
                console.error("월별 책 개수를 가져오는 중 오류 발생");
                $('#monthlyReadBookCount').text('0 권');
                $('#monthlyFavoriteBookCount').text('0 권');
                $('#readChange').html('');
                $('#likeChange').html('');
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        if (!calendarEl) {
            console.error("calendarEl 요소를 찾을 수 없습니다. HTML에서 #calendar 요소를 확인하세요.");
            return;
        }

        $.ajax({
            url: '/getBookNotesForCalendar.do',
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                let events = [];

                if (data.bookNotesInfo && data.bookNotesInfo.length > 0) {
                    for (var i = 0; i < data.bookNotesInfo.length; i++) {
                        console.log(`noteIdx 값 확인 (index ${i}):`, data.bookNotesInfo[i].noteIdx);
                        const startDate = new Date(data.bookNotesInfo[i].noteStartDate);
                        const endDate = new Date(data.bookNotesInfo[i].noteEndDate);

                        events.push({
                            title: data.bookNotesInfo[i].bookTitle,
                            start: startDate,
                            end: endDate,
                            allDay: true,
                            noteIdx: data.bookNotesInfo[i].noteIdx
                        });
                    }
                }

                // FullCalendar 초기화
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    locale: 'ko',                  
                    dayMaxEventRows: true,
                    height: 'auto',
                    events: events,
                    eventColor: '#66cdaa',

                    // 날짜 이동 시 월별 개수 로드
                    datesSet: function(info) {
					    const currentDate = info.view.currentStart;  // 현재 표시된 달력의 시작 날짜를 가져옴
					    const yearMonth = currentDate.getFullYear() + '-' + String(currentDate.getMonth() + 1).padStart(2, '0');
					    
					    loadMonthlyBookCounts(yearMonth);
					},

                    // 이벤트 클릭 시 상세 화면으로 이동
                    eventClick: function(info) {
                        const noteIdx = info.event.extendedProps.noteIdx;

                        if (noteIdx) {
                            const url = '/bookNoteDetail.do?noteIdx=' + noteIdx;
                            window.location.href = url;
                        } else {
                            console.error("noteIdx가 포함되지 않았습니다.");
                        }
                    }
                });

                // 달력 렌더링
                calendar.render();

                // 초기 페이지 로드 시 현재 월의 책 개수를 로드
                const today = new Date();
                const initialYearMonth = today.getFullYear() + '-' + String(today.getMonth() + 1).padStart(2, '0');
                loadMonthlyBookCounts(initialYearMonth);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("AJAX 요청 실패:", textStatus, errorThrown);
                console.error("응답 내용:", jqXHR.responseText);
                alert("독서 기록을 불러오는 중 오류가 발생했습니다. 관리자에게 문의하세요.");
            }
        });
    });
</script>
	   
   
</body>
</html>
