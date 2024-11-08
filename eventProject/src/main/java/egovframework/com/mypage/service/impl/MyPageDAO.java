package egovframework.com.mypage.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;


import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("MyPageDAO")
public class MyPageDAO extends EgovAbstractMapper{
	 
	 
	 public void updateProfileImage(int userIdx, String fileName) {
		    HashMap<String, Object> paramMap = new HashMap<>();
		    paramMap.put("userIdx", userIdx);
		    paramMap.put("fileName", fileName);
		    
		    update("updateProfileImage", paramMap);
		}
		
	 public String getProfileImagePath(int userIdx) {
		    return selectOne("getProfileImagePath", userIdx);
		}
	 
	 public int updateProfile(HashMap<String, Object> paramMap) {
		 System.out.println(">>>>>>>>>>>>>> DAO로 넘어온 paramMap 값: " + paramMap);
		    return update("updateProfile", paramMap);
		}
	 public HashMap<String, Object> getUserInfoById(int userIdx){
			return selectOne("getUserInfoById", userIdx);
		}
	 
	 public int deleteUser(int userIdx){
		 return update("deleteUser",userIdx);
	 }
}
