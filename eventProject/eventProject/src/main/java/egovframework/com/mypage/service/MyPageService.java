package egovframework.com.mypage.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface MyPageService {
	
	public String uploadProfileImage(MultipartFile file, int userIdx);
	
	public String getProfileImagePath(int userIdx);
	
	public int updateProfile(HashMap<String, Object> paramMap);
	
	public HashMap<String, Object> getUserInfoById(int userIdx);
	
	public int deleteUser(int userIdx);
}
