package egovframework.com.main.service;

import java.util.HashMap;
import java.util.List;

public interface MainService {

	public int selectIdChk(HashMap<String, Object> paramMap);
	
	public int insertMember(HashMap<String, Object> paramMap);
	
	public HashMap<String, Object> selectLoginInfo(HashMap<String, Object> paramMap);
	
	public String generateRandomNickname();
	
//	
//	public HashMap<String, Object> selectMemberInfo(HashMap<String, Object> paramMap);
	
//	
	public List<String> selectFindId(HashMap<String, Object> paramMap);
//	
//	public int selectMemberCertification(HashMap<String, Object> paramMap);
//	
//	public int updatePwd(HashMap<String, Object> paramMap);
	
	public List<HashMap<String, Object>> getTopLikedBooks();
	
	public List<HashMap<String, Object>> selectTopBooksByTag(String tag);
}
