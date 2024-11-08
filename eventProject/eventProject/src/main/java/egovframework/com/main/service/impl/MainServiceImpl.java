package egovframework.com.main.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.main.service.MainService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MainService")
public class MainServiceImpl extends EgovAbstractServiceImpl implements MainService{
	@Resource(name="MainDAO")
	private MainDAO mainDAO;

	@Override
	public int selectIdChk(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return mainDAO.selectIdChk(paramMap);
	}

	@Override
	public int insertMember(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return mainDAO.insertMember(paramMap);
	}

	@Override
	public HashMap<String, Object> selectLoginInfo(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return mainDAO.selectLoginInfo(paramMap);
	}
	
	//랜덤 닉네임 생성 메소드
	@Override
	public String generateRandomNickname() {
		 //형용사와 명사 설정하기
		 String[] adjectives = {"조용한", "용감한", "행복한", "똑똑한" , "신나는" , "부지런한" , "친절한", "귀여운", "씩씩한", "호기심 많은", "사랑스러운", "온화한","성공한","멋진","정직한","특별한","남다른","당당한"};
	     String[] animals = {"호랑이", "토끼", "사자", "고양이", "코알라" , "미어캣" ,"코끼리", "돌고래", "캥거루","햄스터","카피바라","수달","펭귄","너구리","바다사자","라쿤","고슴도치","얼룩말","하마"};
	     
	     //랜덤으로 고르기  
	     int randomAdjective = (int) (Math.random() * adjectives.length);
	     int randomAnimal = (int) (Math.random() * animals.length);
	     int randomNumber = (int) (Math.random() * 1000);
	     
	     //형용사+명사+숫자 합쳐서 랜덤 닉네임 생성 -> 반환
	     return adjectives[randomAdjective] + animals[randomAnimal] +"_" +randomNumber;
	}

	@Override
	public List<HashMap<String, Object>> getTopLikedBooks() {
		// TODO Auto-generated method stub
		return mainDAO.getTopLikedBooks();
	}

	@Override
	public List<HashMap<String, Object>> selectTopBooksByTag(String tag) {
		// TODO Auto-generated method stub
		return mainDAO.selectTopBooksByTag(tag);
	}
	
	@Override
	public List<String> selectFindId(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return mainDAO.selectFindId(paramMap);
	}

//	@Override
//	public int selectMemberCertification(HashMap<String, Object> paramMap) {
//		// TODO Auto-generated method stub
//		int chk = 0;
//		int memberIdx = 0;
//		chk = mainDAO.selectMemberCertificationChk(paramMap);
//		if(chk > 0) {
//			memberIdx = mainDAO.selectMemberCertification(paramMap);
//		}
//		return memberIdx;
//	}
//
//	@Override
//	public int updatePwd(HashMap<String, Object> paramMap) {
//		// TODO Auto-generated method stub
//		return mainDAO.updatePwd(paramMap);
//	}
}