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
<link rel="stylesheet" href="/css/egovframework/book/bookNote.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<script src="/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $("#btn_note_submit").on('click', function(){
        fn_note_submit();
    });
    
    $(".star-rating .star").on("click", function() {
        var onStar = parseInt($(this).data("value")); // 클릭한 별의 값을 가져옴
        var stars = $(this).parent().children(".star");

        // 선택된 별까지 선택 상태로 변경
        for (var i = 0; i < stars.length; i++) {
            if (i < onStar) {
                $(stars[i]).find("i").removeClass("far").addClass("fas"); // 선택된 별은 채워진 별 (fas)
            } else {
                $(stars[i]).find("i").removeClass("fas").addClass("far"); // 선택되지 않은 별은 비어있는 별 (far)
            }
        }

        // 선택된 별의 값을 숨겨진 input에 저장
        $(this).parent().find(".rating-value").val(onStar);
    });

    // 독서 노트 등록 버튼 클릭 시 폼 제출
    $("#btn_note_submit").on("click", function() {
        $("#frm").submit();
    });
    
    function fn_note_submit(){
        var bookStartDate = $("#bookStartDate").val();
        var bookEndDate = $("#bookEndDate").val();
        var noteContent = $("#noteContent").val();
        var noteShowYn = $("input[name='noteShowYn']:checked").val(); // 선택된 라디오 버튼 값 확인

        if(bookStartDate === ""){
            alert("읽기 시작한 날짜를 입력해주세요.");
            return;
        }else if(bookEndDate === ""){
            alert("마지막으로 읽은 날짜를 입력해주세요.");
            return;
        }else if(noteContent === ""){
            alert("내용을 입력해주세요.");
            return;
        }else if(noteShowYn === undefined){
            alert("공개 여부를 설정해주세요.");
            return;
        }else{
            // 폼 데이터 직렬화 후 서버로 전송
           var frm = $("#frm").serialize();
		   console.log(frm);  // 서버로 전송되는 데이터를 확인 (별점 값이 포함되어 있는지 확인)

            $.ajax({
                url: '/insertBookNote.do',
                method: 'post',
                data: frm,
                dataType: 'json',
                success: function (data, status, xhr) {
                	 if(data.resultChk > 0){
                         alert("독서노트가 등록되었습니다.");
                         // 이전 페이지로 이동
                         if (document.referrer) {
                             location.href = document.referrer;
                         } else {
                             location.href = "/search.do";  // 이전 페이지 정보가 없으면 기본 페이지로 이동
                         }
                     } else {
                         alert("독서노트 등록에 실패하였습니다.");
                     }
                },
                error: function (data, status, err) {
                    console.log("오류 발생: " + err);
                }
            });
        }
    }
    
 // 태그 선택 창 열기
    $("#tagSelector").on("click", function() {
        const tags = ["소설", "자기계발", "외국어", "여행", "에세이&시", "경제", "인문", "과학", "만화"];
        let tagOptions = '';

        // for 문을 사용해 태그 버튼 HTML을 하나씩 추가
        for (var i = 0; i < tags.length; i++) {
            tagOptions += '<button class="tag-option" data-tag="' + tags[i] + '">' +'#'+ tags[i] + '</button><br>';
        }
        
        // 모달 HTML 추가 (문자열 연결 방식 사용)
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
        // 선택된 태그 데이터 가져오기
        let selectedTag = $(this).data("tag");
        console.log("선택한 태그:", selectedTag); // 선택한 태그 확인용 로그
             	
        if (selectedTag) {
        	$("#tagSelector").text('#' + selectedTag);
            $("#selectedTag").val('#'+selectedTag);
        }
        
        
        // 모달 닫기
        $(".tag-modal").remove();
    });


    // 모달 외부를 클릭하면 모달 닫기
    $(document).on("click", ".tag-modal", function(event) {
        if (!$(event.target).closest(".tag-content").length) {
            $(".tag-modal").remove();
        }
    });
});

</script>
</head>
<body>
    <c:if test="${not empty bookList}">
        <c:forEach var="book" items="${bookList}">
            <div class="note-page">
                <h1 class="note-title">독서 노트 작성하기</h1>
                <p class="note-subtitle">나만의 독서 노트를 작성해보세요.</p>

                <div class="note-content">
                    <!-- 책 이미지 및 정보 -->
                    <div class="book-info">
                        <img src="${book.image}" alt="${book.title}" class="book-image" />
                        <div class="book-details">
                            <h2 class="book-title">${book.title}</h2>
                            <p class="book-author">${book.author}</p>
                        </div>
                    </div>

                    <!-- 독서 노트 작성 폼 -->
                    <form id="frm" name="frm" class="note-form">
                        <div class="input-section">
                            <!-- 날짜 입력란 나란히 배치 -->
                            <div class="date-inputs">
                                <div>
                                    <label for="bookStartDate">읽기 시작한 날짜</label>
                                    <input type="date" id="bookStartDate" name="bookStartDate" class="input-text" />
                                </div>
                                <div>
                                    <label for="bookEndDate">마지막으로 읽은 날짜</label>
                                    <input type="date" id="bookEndDate" name="bookEndDate" class="input-text" />
                                </div>
                            </div>
                        </div>

                        <!-- 본문 내용 요약 -->
                        <label for="noteContent" class="content-label">내용 요약</label>
                        <textarea id="noteContent" name="noteContent" class="content-textarea"></textarea>

                        <!-- 별점과 태그 선택 -->
                        <div class="metadata-section">
						    <div class="star-rating">
						        <label class="star-label">별점 선택</label> <!-- 별점 선택 레이블 -->
						        <span class="star" data-value="1"><i class="far fa-star"></i></span>
						        <span class="star" data-value="2"><i class="far fa-star"></i></span>
						        <span class="star" data-value="3"><i class="far fa-star"></i></span>
						        <span class="star" data-value="4"><i class="far fa-star"></i></span>
						        <span class="star" data-value="5"><i class="far fa-star"></i></span>
						        <input type="hidden" name="noteRating" class="rating-value" value="0" />
						    </div>
						
						    <div class="tag-section">
						        <div id="tagSelector" class="tag-selector">태그 선택하기</div>
						        <input type="hidden" id="selectedTag" name="selectedTag" />
						    </div>
						</div>

                        <!-- 공개 여부 및 저장 버튼 -->
                        <div class="button-section">
                            <input type="radio" id="noteShowYnY" name="noteShowYn" value="Y" />
                            <label for="noteShowYnY">공개</label>
                            <input type="radio" id="noteShowYnN" name="noteShowYn" value="N" />
                            <label for="noteShowYnN">비공개</label>
                            <button type="button" id="btn_note_submit" class="btn_note_submit">저장하기</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </c:if>
</body>
</html>