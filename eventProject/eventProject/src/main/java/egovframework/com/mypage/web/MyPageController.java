package egovframework.com.mypage.web;
import egovframework.com.mypage.service.MyPageService;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MyPageController {
	@Resource(name="MyPageService")
	private MyPageService MyPageService;
	
	@RequestMapping("/myPage.do")
	public String myPage(HttpSession session, Model model) {
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>myPage컨트롤러실행");
	    // 로그인된 사용자 정보 확인
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	    
	    if (loginInfo == null) {
	        return "redirect:/login.do";
	    }

	    // DB에서 프로필 이미지 경로를 가져오기 (서비스에서 호출)
	    String profileImagePath = MyPageService.getProfileImagePath((int) loginInfo.get("userIdx"));

	    // 프로필 이미지 경로가 없을 경우 기본 이미지 설정
	    if (profileImagePath == null || profileImagePath.isEmpty()) {
	        profileImagePath = "/images/egovframework/myPage/기본프로필.png";
	    }

	    // JSP로 프로필 이미지 경로 전달
	    model.addAttribute("profileImagePath", "/userprofile/"+profileImagePath);
	    model.addAttribute("loginInfo", loginInfo);

	    return "myPage/myPage";
	}

		
	
	@RequestMapping(value = "/uploadProfileImage.do", method = RequestMethod.POST)
	public ModelAndView uploadProfileImage(@RequestParam("profileImage") MultipartFile file, HttpSession session) {
	    ModelAndView mv = new ModelAndView();
	    
	    // 로그인된 사용자 정보 확인
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	    if (loginInfo == null) {
	        mv.setViewName("redirect:/login.do");
	        return mv;
	    }
	    
	    int userIdx = (int) loginInfo.get("userIdx");
	    
	    // 파일 업로드 서비스 호출
	    String profileImagePath = MyPageService.uploadProfileImage(file, userIdx);
	    
	    if (profileImagePath != null) {
	    	// 세션에 프로필 이미지 경로를 추가
	        session.setAttribute("profileImagePath", profileImagePath);
	        mv.addObject("result", "success");
	        mv.addObject("profileImagePath", "/userprofile/" + profileImagePath);  // JSP로 경로 전달
	    } else {
	        mv.addObject("result", "fail");
	        mv.addObject("message", "파일 업로드에 실패했습니다.");
	    }
	    mv.setViewName("jsonView");
	    
	    return mv;
	}
	
	@RequestMapping("/updateProfile.do")
	public ModelAndView updateProfile(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
	    ModelAndView mv = new ModelAndView();
	    int resultChk = 0;

	    // 로그인된 사용자 정보 확인
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");

	    if (loginInfo == null) {
	        mv.addObject("resultChk", -1); // 세션에 로그인 정보가 없을 때 처리
	        mv.setViewName("jsonView");
	        return mv;
	    }

	    int userIdx = (int) loginInfo.get("userIdx");

	    // 이메일과 이메일 주소를 결합해 paramMap에 저장
	    String userEmail = paramMap.get("email").toString() + "@" + paramMap.get("emailAddr").toString();
	    paramMap.put("userEmail", userEmail);
	    paramMap.put("userIdx", userIdx);

	    // 프로필 정보 업데이트
	    resultChk = MyPageService.updateProfile(paramMap);

	    if (resultChk > 0) {
	        // 업데이트가 성공했을 경우, 새로운 사용자 정보를 DB에서 가져옴
	        HashMap<String, Object> updatedUserInfo = (HashMap<String, Object>) MyPageService.getUserInfoById(userIdx);

	        if (updatedUserInfo != null) {
	            // 세션에 저장된 로그인 정보 업데이트
	            session.setAttribute("loginInfo", updatedUserInfo);	           
	        } else {	           
	        }
	    } 

	    mv.addObject("resultChk", resultChk);
	    mv.setViewName("jsonView");
	    return mv;
	}
	
	@RequestMapping("/deleteUser.do")
	public ModelAndView deleteUser(HttpSession session) {
	    ModelAndView mv = new ModelAndView();
	    int resultChk = 0;

	    // 로그인된 사용자 정보 확인
	    HashMap<String, Object> loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	    
	    int userIdx = (int) loginInfo.get("userIdx");

	    // 프로필 정보 업데이트
	    resultChk = MyPageService.deleteUser(userIdx);

	    mv.addObject("resultChk", resultChk);
	    mv.setViewName("jsonView");
	    
	    return mv;
	}

}
