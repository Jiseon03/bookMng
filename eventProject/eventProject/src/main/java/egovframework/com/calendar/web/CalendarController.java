package egovframework.com.calendar.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.calendar.service.CalendarService;

@Controller
public class CalendarController {
	@Resource(name="CalendarService")
	private CalendarService CalendarService;
	
	//독서노트 입력 페이지 보여줌
  	@RequestMapping("/calendarPage.do")
  	public String calendarPage(HttpSession session, Model model) {
  		HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");  
		if (loginInfo == null) {
			return "redirect:/login.do";
	        
	    }
		 model.addAttribute("currentPage", "/calendarPage.do");
  		return "calendar/mainCalendar";
  	}
  	
  	@RequestMapping("/getBookNotesForCalendar.do")
  	public ModelAndView getBookNotesForCalendar(HttpSession session) {
  	    ModelAndView mv;

  	    // 현재 로그인된 사용자 정보를 세션에서 가져오기
  	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");

  	    // loginInfo에서 userIdx 가져오기
  	    int userIdx = (int) loginInfo.get("userIdx");

  	    mv = new ModelAndView("jsonView"); // jsonView 설정
  	    try {
  	        // Service를 통해 독서 기록 데이터를 가져옴
  	        List<HashMap<String, Object>> bookNotesInfo = CalendarService.selectBookNotesForCalendar(userIdx);

  	        // JSON 형식으로 반환할 데이터 추가
  	        mv.addObject("bookNotesInfo", bookNotesInfo);
  	    } catch (Exception e) {
  	        e.printStackTrace();
  	        mv.addObject("error", "독서 기록을 가져오는 중 오류가 발생했습니다.");
  	    }

  	    return mv;
  	}

  	@RequestMapping("/getMonthlyBookCounts.do")
  	public ModelAndView getMonthlyBookCounts(@RequestParam("yearMonth") String yearMonth, HttpSession session) {
  	    ModelAndView mv = new ModelAndView("jsonView");
  	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
  	    int userIdx = (int) loginInfo.get("userIdx");

  	    try {
  	        // 현재 월과 지난달 형식 설정 (예: "2024-10"이면 지난달은 "2024-09")
  	        String previousYearMonth = calculatePreviousYearMonth(yearMonth);

  	        // 현재 월 개수
  	        int readBookCount = CalendarService.getMonthlyReadBookCount(userIdx, yearMonth);
  	        int favoriteBookCount = CalendarService.getMonthlyLikeBookCount(userIdx, yearMonth);

  	        // 지난달 개수
  	        int previousReadBookCount = CalendarService.getMonthlyReadBookCount(userIdx, previousYearMonth);
  	        int previousFavoriteBookCount = CalendarService.getMonthlyLikeBookCount(userIdx, previousYearMonth);

  	        // 모델에 데이터 추가
  	        mv.addObject("readBookCount", readBookCount);
  	        mv.addObject("favoriteBookCount", favoriteBookCount);
  	        mv.addObject("previousReadBookCount", previousReadBookCount);
  	        mv.addObject("previousFavoriteBookCount", previousFavoriteBookCount);

  	    } catch (Exception e) {
  	        e.printStackTrace();
  	        mv.addObject("readBookCount", 0);
  	        mv.addObject("favoriteBookCount", 0);
  	        mv.addObject("previousReadBookCount", 0);
  	        mv.addObject("previousFavoriteBookCount", 0);
  	    }
  	    return mv;
  	}

  	// 현재 yearMonth를 기준으로 지난달 yearMonth를 계산하는 메서드
  	private String calculatePreviousYearMonth(String yearMonth) {
  	    String[] parts = yearMonth.split("-");
  	    int year = Integer.parseInt(parts[0]);
  	    int month = Integer.parseInt(parts[1]);

  	    // 지난달로 계산
  	    month--;
  	    if (month == 0) { // 1월에서 12월로 넘어갈 경우
  	        month = 12;
  	        year--;
  	    }

  	    return year + "-" + String.format("%02d", month);
  	}




}
