<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<link rel="stylesheet" href="/css/egovframework/book/bookNoteList.css?after">
<link rel="stylesheet" href="/css/egovframework/common/main.css?after">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function(){
		fn_selectList();
		
		$("#btn_search").on('click', function(){
			fn_selectList();
		});		
		// 전체 선택/해제 기능
	    $(document).on('change', '#checkAll', function() {
	        $('.note-checkbox').prop('checked', this.checked);
	    });
	});
	
	function fn_selectList(){
		var frm = $("#searchFrm").serialize();
		$.ajax({
		    url: '/selectBookNoteList.do',
		    method: 'post',
		    data : frm,
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	var listHtml = '';
		    	if(data.list.length >0){
		    		for(var i = data.list.length - 1; i >= 0; i--){    			
		    			listHtml += '<tr>';  
		    			listHtml += '<td>';
		    			listHtml += data.list[i].rnum;
		    			listHtml += '</td>';
		    			listHtml += '<td>';
		    			listHtml += '<a href="javascript:fn_detail(\''+data.list[i].noteIdx+'\');">';
		    			listHtml += data.list[i].bookTitle;
		    			listHtml += '</a>';
		    			listHtml += '</td>';
		    			listHtml += '<td>';
		    			listHtml += data.list[i].noteCreateDate;
		    			listHtml += '</td>';
		    			listHtml += '<td>';
		    			listHtml += data.list[i].noteShowYn;
		    			listHtml += '</td>';
		    			listHtml += '<td><input type="checkbox" class="note-checkbox" name="noteIdx" value="' + data.list[i].noteIdx + '"></td>';
		    			listHtml += '</tr>';
		    			
		    		}
		    	}else{
		    		listHtml += '<tr>';
		    		listHtml += '<td colspan="4" style="text-align:center;">조회된 결과가 없습니다.</td>';
		    		listHtml += '</tr>';
		    	}
		    	$("#tbody").html(listHtml);
		    	$("#total_counter").text('총 ' + data.totCnt + ' 건');
		    	
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	// 선택된 책 삭제
	function fn_deleteSelected() {
	    var selected = [];
	    $(".note-checkbox:checked").each(function() {
	        selected.push($(this).val());
	    });

	    if (selected.length == 0) {
	        alert("삭제할 책을 선택하세요.");
	        return;
	    }
	    if (confirm("삭제하시겠습니까?")) {
	    $.ajax({
	        url: '/deleteBookNote.do',
	        method: 'post',
	        data: {noteIdxList: selected},
	        dataType: 'json',
	        success: function (data, status, xhr) {
	            if (data.resultChk > 0) {
	                alert("선택된 독서노트가 삭제되었습니다.");
	                fn_selectList(); // 리스트 새로고침
	            } else {
	                alert("삭제 실패");
	            }
	        },
	        error: function (data, status, err) {
	            console.log(err);
	        }
	    });
	  }
	}

	function fn_detail(noteIdx){
		$("#noteIdx").val(noteIdx);
		var frm = $("#searchFrm");
		frm.attr("method", 'POST');
		frm.attr("action", "/bookNoteDetail.do");
		frm.submit();
	}
	
</script>
</head>
	<body>
	<h1>작성한 독서노트</h1>
		<div id="search" class="search-container">
		    <form id="searchFrm" name="searchFrm" class="search-form">
		    	<input type="hidden" id="noteIdx" name="noteIdx" value=""/>
		        <label id="total_counter" class="total-counter">총 0 건</label>
		        <ul class="search-options">
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
		                <input type="button" id="btn_search" name="btn_search" value="검색" class="btn-search"/>
		            </li>
		        </ul>
		    </form>
		</div>
	
	<div class="table-container">
    <form id="deleteFrm" name="deleteFrm" class="delete-form">
        <table class="result-table" cellpadding="0" cellspacing="0">
            <thead>
                <colgroup>
                    <col width="5%"/>
                    <col width="auto"/>
                    <col width="15%"/>
                    <col width="15%"/>
                    <col width="5%"/>
                </colgroup>
                <tr>
                    <!-- 전체 선택을 위한 체크박스 -->
                    <th align="center">번호</th>
                    <th align="center">책 이름</th>
                    <th align="center">작성일시</th>
                    <th align="center">공개여부</th>
                    <th align="center"><input type="checkbox" id="checkAll" /></th>
                </tr>
            </thead>
            <tbody id="tbody">
                <!-- 데이터가 없을 때 기본 출력 -->
                <tr>
                    <td colspan="5" style="text-align:center;">조회된 결과가 없습니다.</td>
                </tr>
            </tbody>
        </table>
        <div class="btn-wrap"><!-- 삭제 버튼 -->
        	<input type="button" id="btn_delete" name="btn_delete" value="삭제" onclick="fn_deleteSelected();" />
        </div>
    </form>
</div>

</body>
</html> 