package egovframework.com.mypage.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.book.domain.BookItem;
import egovframework.com.book.domain.BookResponse;
import egovframework.com.book.service.BookService;
import egovframework.com.mypage.service.MyPageService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MyPageService")
public class MyPageServiceImpl extends EgovAbstractServiceImpl implements MyPageService{

	@Resource(name="MyPageDAO")
	private MyPageDAO MyPageDAO;
	

	@Override
	public String uploadProfileImage(MultipartFile file, int userIdx) {
	    // 파일 검증 (예: 파일이 비어 있는지, 이미지 파일 형식인지 확인)
	    if (file.isEmpty() || !isImageFile(file)) {
	        throw new IllegalArgumentException("유효한 이미지 파일이 아닙니다.");
	    }
	    
	    // 저장할 경로 설정
	    String uploadDir = "C:/userprofile/";
	    String fileName ="profile_" + userIdx + "_" + file.getOriginalFilename();
	    
	    try {
	        // 파일을 디렉토리에 저장
	        Path filePath = Paths.get(uploadDir + fileName);
	        System.out.println(">>>>>>>>>>>>>파일 저장 경로: " + filePath.toString());
	        Files.write(filePath, file.getBytes());
	        
	        // 업로드한 파일 경로를 데이터베이스에 저장
	        MyPageDAO.updateProfileImage(userIdx, fileName);
	        
	        return fileName;  // 저장된 파일 경로 반환
	    } catch (IOException e) {
	        throw new RuntimeException("파일 저장 중 오류가 발생했습니다.");
	    }
	}

	// 이미지 파일 형식을 확인하는 메서드
	private boolean isImageFile(MultipartFile file) {
	    // 파일의 확장자를 가져와서 이미지 형식 여부를 확인
	    String contentType = file.getContentType();
	    return contentType != null && (contentType.equals("image/jpeg") || contentType.equals("image/png") || contentType.equals("image/gif"));
	}

	@Override
	public String getProfileImagePath(int userIdx) {
	    return MyPageDAO.getProfileImagePath(userIdx);
	}

	@Override
	public int updateProfile(HashMap<String, Object> paramMap) {
		System.out.println(">>>>>>>>>>>>>> 서비스로 넘어온 paramMap 값: " + paramMap);
		return MyPageDAO.updateProfile(paramMap);
	}

	@Override
	public HashMap<String, Object> getUserInfoById(int userIdx) {
		// TODO Auto-generated method stub
		return MyPageDAO.getUserInfoById(userIdx);
	}

	@Override
	public int deleteUser(int userIdx) {
		// TODO Auto-generated method stub
		return MyPageDAO.deleteUser(userIdx);
	}



}
