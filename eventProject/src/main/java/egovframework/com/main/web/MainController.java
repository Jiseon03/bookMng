package egovframework.com.main.web;

import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.main.service.MainService;
import egovframework.com.util.SHA256;

@Controller
public class MainController {
	@Resource(name="MainService")
	private MainService mainService;
	
	SHA256 sha256 = new SHA256();
	
	//mainPage.jsp반환  & 세션에 저장된 로그인 정보를 불러와 mainPage.jsp 로 넘겨줌
	@RequestMapping("/mainPage.do")
	public String main(HttpSession session, Model model) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		if(loginInfo != null) {
			model.addAttribute("loginInfo", loginInfo);
			
		}
		return "main/mainPage";
	}
	
	//로그인 페이지 보여줌
	@RequestMapping("/login.do")
	public String login() {
		return "main/login";
	}
	
	
	//로그아웃 기능
	@RequestMapping("/logout.do")
	public String logout(HttpServletRequest request) {
	    HttpSession session = request.getSession(); //현재 사용자의 세션 가져옴
	    session.invalidate();  // 세션을 완전히 무효화하여 모든 속성 제거
	    return "redirect:/mainPage.do";  // 메인 페이지로 리다이렉트
	}

	//회원가입 페이지 보여줌
	@RequestMapping("/join.do")
	public String join() {
		return "main/join";
	}
	
	//아이디 중복 체크 결과를 반환시킴
	@RequestMapping("/member/idChk.do")
	public ModelAndView idChk(@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		int idChk = 0;
		idChk = mainService.selectIdChk(paramMap);
		mv.addObject("idChk", idChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	//회원가입 처리. 회원가입 성공 여부를 반환시킴
	@RequestMapping("/member/insertMember.do")
	public ModelAndView insertMember(@RequestParam HashMap<String, Object> paramMap) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		//비밀번호 암호화 처리
		String pwd = paramMap.get("userPw").toString();
		paramMap.replace("userPw", sha256.encrypt(pwd));
		
		//이메일과 이메일 주소를 결합해 paramMap에 저장
		String userEmail = paramMap.get("email").toString() +"@"+paramMap.get("emailAddr").toString();
		paramMap.put("userEmail", userEmail);
		
		// 랜덤 닉네임 생성
	    String userNickname = mainService.generateRandomNickname();
	    paramMap.put("userNickname", userNickname);
	   
		//성공여부 반환
		int resultChk = 0;
		resultChk = mainService.insertMember(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	//로그인 처리
	@RequestMapping("/member/loginAction.do")
	public ModelAndView loginAction(HttpSession session, @RequestParam HashMap<String, Object> paramMap){

	    ModelAndView mv = new ModelAndView();

	    // 비밀번호 암호화 처리
	    String pwd = paramMap.get("userPw").toString();
	    String encryptPwd = null;
	    try {
	        encryptPwd = sha256.encrypt(pwd).toString();
	        paramMap.replace("userPw", encryptPwd);
	    } catch (NoSuchAlgorithmException e) {
	        e.printStackTrace();
	    }

	    // 로그인 정보 확인
	    HashMap<String, Object> loginInfo = null;
	    loginInfo = mainService.selectLoginInfo(paramMap);

	    // 로그인 성공 시
	    if (loginInfo != null) {
	    	//로그인 성공 처리
	        session.setAttribute("loginInfo", loginInfo);
	        mv.addObject("resultChk", true);
	    } else {
	        // 로그인 실패 처리
	        mv.addObject("resultChk", false);
	    }

	    // 항상 JSON 형식으로 응답 반환
	    mv.setViewName("jsonView");
	    return mv;
	}


	
	// 사용자의 세션 정보를 가져와 뷰로 전달하는 역할
	@RequestMapping("/getSessionInfo.do")
	public ModelAndView getSessionInfo(HttpServletRequest request) {
	    ModelAndView mv = new ModelAndView();
	    
	    HttpSession session = request.getSession();
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	    
	    if (loginInfo != null) {
	        mv.addObject("loginInfo", loginInfo);  // 데이터를 모델에 담기
	    }
	    
	    mv.setViewName("common/header");  // 뷰 이름 설정
	    return mv;  
	}
	
	//좋아요 개수 많은순 상위 10개 가져오기
	@RequestMapping("/getTopLikedBooks.do")
	public ModelAndView getTopLikedBooks() {
	    ModelAndView mv = new ModelAndView();
	    
	    try {
	        // 좋아요가 많은 상위 10개 도서 목록을 가져옴
	        List<HashMap<String, Object>> topLikedBooks = mainService.getTopLikedBooks();
	        
	        // 모델에 데이터 추가
	        mv.addObject("topLikedBooks", topLikedBooks);
	        mv.setViewName("jsonView");  // 해당 JSP 페이지를 반환
	    } catch (Exception e) {
	        e.printStackTrace();
	        mv.addObject("error", "책 목록을 가져오는 중 오류가 발생했습니다.");
	    }
	    
	    return mv;
	}
	
	//태그 별 인기 도서 가져오기
	@RequestMapping("/selectTopBooksByTag.do")
	public ModelAndView selectTopBooksByTag(@RequestParam("tag") String tag) {
	    ModelAndView mv = new ModelAndView();
	    
	    try {
	    	String modifiedTag = "#" + tag;
	        // 좋아요가 많은 상위 10개 도서 목록을 가져옴
	        List<HashMap<String, Object>> BooksByTag = mainService.selectTopBooksByTag(modifiedTag);
	        
	        // 모델에 데이터 추가
	        mv.addObject("BooksByTag", BooksByTag);
	        mv.setViewName("jsonView");  // 해당 JSP 페이지를 반환
	    } catch (Exception e) {
	        e.printStackTrace();
	        mv.addObject("error", "책 목록을 가져오는 중 오류가 발생했습니다.");
	    }
	    
	    return mv;
	}	
	
	@RequestMapping("/findIdView.do")
	public String findIdView() {
		return "main/findIdView";
	}
	
	@RequestMapping("/findId.do")
	public ModelAndView findId(@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		List<String> list = mainService.selectFindId(paramMap);
		mv.addObject("idList", list);
		mv.setViewName("jsonView");
		return mv;
	}
//	
//	@RequestMapping("/findPwView.do")
//	public String findPwView() {
//		return "findPwView";
//	}
//	
//	@RequestMapping("/certification.do")
//	public ModelAndView certification(@RequestParam HashMap<String, Object> paramMap) {
//		ModelAndView mv = new ModelAndView();
//		
//		int memberIdx = 0;
//		
//		memberIdx = mainService.selectMemberCertification(paramMap);
//		System.out.println(memberIdx);
//		
//		mv.addObject("memberIdx", memberIdx);
//		mv.setViewName("jsonView");
//		return mv;
//	}
	
//	@RequestMapping("/settingPwd.do")
//	public String settingPwd(@RequestParam(name="memberIdx") int memberIdx, Model model) {
//		model.addAttribute("memberIdx", memberIdx);
//		return "settingPwd";
//	}
	
//	@RequestMapping("/resettingPwd.do")
//	public ModelAndView resettingPwd(@RequestParam HashMap<String, Object> paramMap) {
//		ModelAndView mv = new ModelAndView();
//		
//		// 입력받은 패스워드
//		String pwd = paramMap.get("memberPw").toString();
//		// 암호화된 패스워드
//		String encryptPwd = null;
//		try {
//			encryptPwd = sha256.encrypt(pwd).toString();
//			paramMap.replace("memberPw", encryptPwd);
//		} catch (NoSuchAlgorithmException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		
//		int resultChk = 0;
//		resultChk = mainService.updatePwd(paramMap);
//		mv.addObject("resultChk", resultChk);
//		mv.setViewName("jsonView");
//		return mv;
//	}
	 
	
}
