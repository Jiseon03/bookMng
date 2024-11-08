package egovframework.com.book.web;

import egovframework.com.book.domain.BookItem;
import egovframework.com.book.domain.BookResponse;
import egovframework.com.book.service.BookService;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BookController {

	@Resource(name="BookService")
    private BookService BookService;
	
	// 도서 검색
	@RequestMapping("/search.do")
	public String searchBooks(
	        @RequestParam(value = "query", required = false) String query, 
	        @RequestParam(value = "searchCondition", required = false) List<String> conditions,
	        Model model) {
	    try {
	        // query가 없을 경우 기본값 설정
	        if (query == null || query.isEmpty()) {
	            query = "기본 검색어";
	        }
	        
	        // 도서 검색 목록 가져오기
	        BookResponse response = BookService.searchBooks(query, conditions);
	        List<BookItem> books = response.getItems();
	        
	       
	        model.addAttribute("total", response.getTotal());
	        model.addAttribute("books", books);
	    } catch (Exception e) {
	        e.printStackTrace();
	        model.addAttribute("error", "도서 검색 중 오류가 발생했습니다.");
	    }
	    return "book/bookList"; 
	}

	
	// 도서 정보 저장
	@PostMapping("/book/saveBook.do")
	@ResponseBody
	public String saveBook(BookItem bookItem) {
	    try {
	        BookService.saveBook(bookItem);  
	        return "success";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error";
	    }
	}
	

	// 책 세부 정보 및 좋아요 정보 가져오기
	@GetMapping("/bookDetail.do")
	public ModelAndView getBookDetail(@RequestParam("isbn") String isbn, HttpSession session) {
	    ModelAndView mv = new ModelAndView();
	    
	    try {
	        // 책 정보를 리스트 형태로 가져오기
	        List<BookItem> bookList = BookService.getBookDetail(isbn);
	        mv.addObject("bookList", bookList);  
	        
	        // 책의 좋아요 개수를 가져오기
	        int likeCount = BookService.selectLikeCountByBook(isbn);
	        mv.addObject("likeCount", likeCount);  
	        
	        // 세션에서 로그인한 사용자 정보 가져오기
	        HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	        
	        if (loginInfo != null) {
	            int userIdx = (int) loginInfo.get("userIdx");

	            // 사용자가 해당 책에 좋아요를 눌렀는지 확인
	            boolean userLiked = BookService.checkUserLiked(userIdx, isbn);
	            mv.addObject("userLiked", userLiked);  
	        }
	        
	        // 평균 별점 가져오기
	        double avgRating = BookService.selectAvgRating(isbn);
	        mv.addObject("avgRating", avgRating);  
	       
	    } catch (Exception e) {
	        e.printStackTrace();
	        mv.addObject("error", "책 상세 정보를 가져오는 중 오류가 발생했습니다.");
	    }
	    
	    // 뷰 이름 설정
	    mv.setViewName("book/bookDetail");
	    return mv;  // ModelAndView 반환
	}

	
    //독서노트 입력 페이지 보여줌
  	@RequestMapping("/bookNote.do")
  	public String login() {
  		return "book/bookNote";
  	}
  	
   //독서노트 세부 정보 불러오기
	@GetMapping("/bookNote.do")
	public ModelAndView getBookNoteDetail(@RequestParam("isbn") String isbn, HttpSession session) {
	    ModelAndView mv = new ModelAndView();
	    
	    // 로그인 여부 확인 (세션에 "loginInfo"가 있는지 확인)
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	    if (loginInfo == null) {
	        // 로그인 정보가 없으면 로그인 페이지로 리다이렉트하면서 리다이렉트 URL 전달
	        mv.setViewName("redirect:/login.do?redirectURL=/bookNote.do?isbn=" + isbn);
	        return mv;
	    }
	    
	    try {
	        // 책 정보를 리스트 형태로 가져오기
	        List<BookItem> bookList = BookService.getBookDetail(isbn);
	        mv.addObject("bookList", bookList);  // 모델에 책 정보를 추가
	    } catch (Exception e) {
	        e.printStackTrace();
	        mv.addObject("error", "책 상세 정보를 가져오는 중 오류가 발생했습니다.");
	    }
	    
	    // 뷰 이름 설정
	    mv.setViewName("book/bookNote");
	    return mv;  // ModelAndView 반환
	}
	
	// 독서 노트를 DB에 등록
	@RequestMapping("/insertBookNote.do")
	public ModelAndView insertBookNote(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
	    ModelAndView mv = new ModelAndView();

	    // 현재 로그인된 사용자 정보를 가져오기
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");

	    // 로그인된 사용자 정보가 있을 경우에만 처리
	    if (loginInfo != null) {
	        // 사용자 ID를 paramMap에 추가
	        int userIdx = (int) loginInfo.get("userIdx");
	        paramMap.put("userIdx", userIdx);

	        // 별점 값 확인 및 기본 값 처리 (null 방지)
	        String noteRatingStr = (String) paramMap.get("noteRating");
	        int noteRating = 0; // 기본값
	        if (noteRatingStr != null && !noteRatingStr.isEmpty()) {
	            try {
	                noteRating = Integer.parseInt(noteRatingStr); // 별점 값이 있을 때 변환
	            } catch (NumberFormatException e) {
	                noteRating = 0; // 변환 실패 시 기본 값으로 설정
	            }
	        }
	        paramMap.put("noteRating", noteRating); // 별점 값 추가

	        // 독서노트 등록 서비스 호출
	        int resultChk = BookService.insertBookNote(paramMap);

	        mv.addObject("resultChk", resultChk);
	    } else {
	        // 로그인 정보가 없을 경우 처리
	        mv.addObject("resultChk", 0);
	        mv.addObject("message", "로그인 정보가 없습니다.");
	    }

	    mv.setViewName("jsonView");
	    return mv;
	}

	
	// 독서 피드 페이지에서 쓸 정보 가져오기
	@RequestMapping("/bookFeed.do")
	public ModelAndView getBookNoteDetails(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
	    ModelAndView mv = new ModelAndView("book/bookFeed");  // bookFeed.jsp로 이동

	    // 로그인 정보 확인
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");

	    // BookService에서 작성한 독서 노트 정보 가져옴
	    List<HashMap<String, Object>> bookNoteDetails = BookService.getBookNoteDetails(paramMap);

	    // 작성된 시간 차이를 계산하고, 프로필 이미지 경로를 각 노트에 추가
	    for (HashMap<String, Object> note : bookNoteDetails) {
	        
	        Timestamp noteCreateDate = (Timestamp) note.get("note_create_date");

	        if (noteCreateDate != null) {
	            // Timestamp를 LocalDateTime으로 변환
	            LocalDateTime createDateTime = noteCreateDate.toLocalDateTime();

	            // LocalDateTime을 기준으로 시간 차이를 계산
	            String timeDifference = BookService.getTimeDifference(createDateTime);

	            note.put("timeDifference", timeDifference);
	        } else {
	            note.put("timeDifference", "날짜 정보 없음");
	        }

	        // 프로필 이미지 경로 추가
	        String userProfileImage = (String) note.get("user_profile_image");
	        
	        if (userProfileImage == null || userProfileImage.isEmpty()) {
	            // 프로필 이미지가 없을 경우 기본 이미지 경로 설정
	            userProfileImage = "/images/egovframework/myPage/기본프로필2.png";
	        } else {
	            // 프로필 이미지가 있는 경우 외부 디렉토리 경로로 수정
	            userProfileImage = "/userprofile/" + userProfileImage;
	        }

	        // 각 노트에 프로필 이미지 경로 추가
	        note.put("profileImagePath", userProfileImage);
	    }

	    // 모델에 데이터를 추가하여 JSP로 전달
	    mv.addObject("currentPage", "/bookFeed.do");
	    mv.addObject("bookNoteDetails", bookNoteDetails);
	    mv.addObject("loginInfo", loginInfo);

	    return mv;  // bookFeed.jsp로 이동하며 데이터 전달
	}

	//독서 기록 페이지 보여줌
	@RequestMapping("/bookRecordPage.do")
	public String bookRecordPage(HttpSession session,Model model) {
		HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");  
		if (loginInfo == null) {
			return "redirect:/login.do";	        
	    }
		model.addAttribute("currentPage", "/bookRecordPage.do");
		return "book/bookRecord";  // JSP 파일로 이동
	}
		
	//독서노트 권수 카운트
	@RequestMapping("/bookRecord.do")
	public ModelAndView bookRecord(@RequestParam HashMap<String, Object> paramMap,HttpSession session, Model model) {
	        // 세션에서 로그인된 사용자 정보를 가져옴
			ModelAndView mv = new ModelAndView();
			
	        HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");  
	        int userIdx = (int) loginInfo.get("userIdx");
	        paramMap.put("userIdx", userIdx);
	        // 좋아요한 도서 목록 및 독서 노트 개수 조회
	        List<HashMap<String, Object>> likedBookList = BookService.getLikedBooks(paramMap);	        
	        
	        // 작성한 독서 노트 수 조회
	        int bookNoteCount = BookService.getBookNoteCount(userIdx);
	        
	        // 모델에 데이터를 추가
	        mv.addObject("likedBookList", likedBookList); // JSP로 전달
	        mv.addObject("bookNoteCount", bookNoteCount); // JSP로 전달
	        mv.addObject("result", "success");
	        
	        mv.setViewName("jsonView");
			return mv;
	}
		
	//독서 노트 목록 조회 페이지 보여줌
	@RequestMapping("/bookNoteListPage.do")
	public String bookNoteListPage() {
		    return "book/bookNoteList";  // JSP 파일로 이동
	}
		
	//독서노트 권수 카운트
	@RequestMapping("/selectBookNoteList.do")
	@ResponseBody
	public ModelAndView selectBookNoteList(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		    ModelAndView mv = new ModelAndView();
		    
		    // 현재 로그인된 사용자 정보를 가져오기
		    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		    int userIdx = (int) loginInfo.get("userIdx");
		    
		    // 사용자 ID를 paramMap에 추가
		    paramMap.put("userIdx", userIdx);  
		    
		    // 독서 노트 목록 가져오기
		    List<HashMap<String, Object>> list = BookService.selectMyBookNotes(paramMap);
		    int totCnt = BookService.countMyBookNotes(paramMap);
		    
		    // 데이터를 모델에 추가하여 전달
		    mv.addObject("list", list);
		    mv.addObject("totCnt", totCnt);
		    
		    // JSON 데이터를 반환하도록 설정
		    mv.setViewName("jsonView");
		    return mv;
	}

	@RequestMapping("/bookNoteDetail.do")
	public String bookNoteDetail(@RequestParam(name="noteIdx") int noteIdx, Model model, HttpSession session) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		if(loginInfo != null) {		
			HashMap<String, Object> noteInfo = BookService.selectBookNoteDetail(noteIdx);
			
			String isbn = (String) noteInfo.get("bookIsbn");
			// 책 정보 조회 - getBookDetail이 List<BookItem>을 반환함
			HashMap<String, Object> bookInfo = BookService.selectBookInfo(isbn);
			
			model.addAttribute("noteIdx", noteIdx);
			model.addAttribute("bookInfo", bookInfo);
			model.addAttribute("noteInfo", noteInfo);
			model.addAttribute("loginInfo", loginInfo);
			return "book/bookNoteDetail";
		}else {
			return "redirect:/login.do";
		}
	}
	
	//독서 노트 DB에 등록
	@RequestMapping("/updateBookNote.do")
	public ModelAndView updateBookNote(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		    ModelAndView mv = new ModelAndView();
		   
		    // 현재 로그인된 사용자 정보를 가져오기
		    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		        
		    // 사용자 ID를 paramMap에 추가
		    int userIdx = (int) loginInfo.get("userIdx");
		    paramMap.put("userIdx", userIdx);  
		        
		    // 독서노트 등록 서비스 호출
		    int resultChk = BookService.updateBookNote(paramMap);  

		    mv.addObject("resultChk", resultChk);
		    mv.setViewName("jsonView");

		    return mv;
	}
		
	//독서 노트 삭제
	@RequestMapping("/deleteBookNote.do")
	public ModelAndView deleteBookNote(@RequestParam HashMap<String, Object> paramMap,  @RequestParam(value = "noteIdxList[]", required = false) List<Integer> noteIdxList,HttpSession session) {
		    ModelAndView mv = new ModelAndView();

		    // 현재 로그인된 사용자 정보를 가져오기
		    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		        
		    // 사용자 ID를 paramMap에 추가
		    int userIdx = (int) loginInfo.get("userIdx");
		    paramMap.put("userIdx", userIdx);  
		        
		    // 여러 독서노트를 삭제
		    int resultChk = 0;
		        if (noteIdxList != null) {
		            for (int noteIdx : noteIdxList) {
		                paramMap.put("noteIdx", noteIdx);
		                resultChk += BookService.deleteBookNote(paramMap);  // 각각의 노트를 삭제
		            }
		        }

		    mv.addObject("resultChk", resultChk);
		    mv.setViewName("jsonView");

		    return mv;
		}
		
	//도서에 좋아요 하는 기능
	@RequestMapping(value = "/likeBook.do", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView likeBook(@RequestParam("isbn") String isbn, HttpSession session) {
		
		ModelAndView mv = new ModelAndView();
		    
		// 로그인한 사용자 정보 가져오기
		HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		
		// 로그인 여부 확인
		if (loginInfo == null) {
		    mv.addObject("result", "fail");
		    mv.addObject("message", "로그인이 필요한 기능입니다.");
		    mv.setViewName("jsonView");
		    
		    return mv;
		 }
		
		 int userIdx = (int) loginInfo.get("userIdx");

		 try {
		        // 사용자가 이 책에 이미 좋아요를 눌렀는지 확인
		        boolean isLiked = BookService.checkUserLiked(userIdx, isbn);

		        if (isLiked) {
		            // 이미 좋아요를 눌렀다면 좋아요 취소
		        	BookService.deleteLike(userIdx, isbn);
		            int likeCount = BookService.selectLikeCountByBook(isbn);
		            
		            mv.addObject("result", "unliked");	
		            mv.addObject("likeCount", likeCount);		           
		        } else {
		            // 좋아요 추가
		        	BookService.insertLike(userIdx, isbn);
		            int likeCount = BookService.selectLikeCountByBook(isbn);
		            mv.addObject("result", "success");
		            mv.addObject("likeCount", likeCount);	
		        }
		  }catch (Exception e) {
		        e.printStackTrace();
		        mv.addObject("result", "fail");	
		   }
		 
		  mv.setViewName("jsonView");
		  return mv;
	}
		
	// 좋아요한 도서 전체 목록 가져오기
	@RequestMapping("/likedBooksList.do")
	public ModelAndView likedBooksList(@RequestParam HashMap<String, Object> paramMap,HttpSession session) {
		    ModelAndView mv = new ModelAndView();

		    try {
		        // 세션에서 로그인된 사용자 정보 가져오기
		        HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");  
		        int userIdx = (int) loginInfo.get("userIdx");
		        paramMap.put("userIdx", userIdx);
		        // 좋아요한 도서 목록 및 독서 노트 개수 조회
		        List<HashMap<String, Object>> likedBookList = BookService.getLikedBooks(paramMap);

		        // 모델에 데이터를 추가
		        mv.addObject("likedBookList", likedBookList);  // 좋아요한 도서 목록 전달		       
		        mv.addObject("result", "success");              // 결과 상태 전달
		        
		    } catch (Exception e) {
		        e.printStackTrace();
		        mv.addObject("result", "error");
		        mv.addObject("message", "좋아요한 도서를 불러오는 중 오류가 발생했습니다.");
		    }

		    // jsonView로 설정하여 JSON 형식으로 데이터 반환
		    mv.setViewName("book/likedbooks");
		    return mv;
	}

}
