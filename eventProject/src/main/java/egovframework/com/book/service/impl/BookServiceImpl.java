package egovframework.com.book.service.impl;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.book.domain.BookItem;
import egovframework.com.book.domain.BookResponse;
import egovframework.com.book.service.BookService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

@Service("BookService")
public class BookServiceImpl extends EgovAbstractServiceImpl implements BookService{
	
	@Resource(name="BookDAO")
	private BookDAO BookDAO;
	
	private final String CLIENT_ID = "H29AFGJ7DIAmFD0enaMD";     // 네이버에서 발급받은 Client ID
	private final String CLIENT_SECRET = "McHJubyv7N"; 		     // 네이버에서 발급받은 Client Secret
	private final String NAVER_API_URL = "https://openapi.naver.com/v1/search/book.json";
	

	
	
	// 공통 검색 메소드
	@Override   
	public BookResponse searchBooks(String query, List<String> conditions) throws IOException {
	    // 기본 URL에 query 추가
	    String encodedQuery = URLEncoder.encode(query, "UTF-8");
	    StringBuilder apiURL = new StringBuilder(NAVER_API_URL + "?query=" + encodedQuery + "&display=50");

	    // 조건별로 추가 파라미터 설정
	    boolean isTitleSet = false;
	    boolean isAuthorSet = false;
	    
	    if (conditions != null) {
	        for (String condition : conditions) {
	            if ("title".equals(condition)) {
	                apiURL.append("&d_titl=").append(encodedQuery); // 제목 검색
	                isTitleSet = true;
	            } else if ("author".equals(condition)) {
	                apiURL.append("&d_auth=").append(encodedQuery); // 저자 검색
	                isAuthorSet = true;
	            }
	        }
	    }

	    // 만약 조건이 없거나 제목과 저자 모두 미선택 시 기본 검색으로 처리
	    if (!isTitleSet && !isAuthorSet) {
	        apiURL.append("&d_titl=").append(encodedQuery);
	    }

	    // HTTP 요청 수행
	    CloseableHttpClient httpClient = HttpClients.createDefault();
	    HttpGet request = new HttpGet(apiURL.toString());
	    
	    request.addHeader("X-Naver-Client-Id", CLIENT_ID);
	    request.addHeader("X-Naver-Client-Secret", CLIENT_SECRET);
	    
	    HttpResponse response = httpClient.execute(request);
	    String responseBody = EntityUtils.toString(response.getEntity(), "UTF-8");
	    
	    httpClient.close();

	    // JSON 파싱
	    ObjectMapper objectMapper = new ObjectMapper();
	    return objectMapper.readValue(responseBody, BookResponse.class);
	}


	// 도서 정보 저장
	@Override
	public boolean saveBook(BookItem book) {
		//이미 존재하는 도서인지 확인
		if (BookDAO.existsByIsbn(book.getIsbn())) {
            return false; // 이미 존재하는 도서
        }
        BookDAO.insertBook(book);
        return true;
	}

	//책 세부 정보 불러오기
	@Override
	public List<BookItem> getBookDetail(String isbn) {
        return BookDAO.selectBookDetail(isbn);
    }

	@Override
	public int insertBookNote(HashMap<String, Object> paramMap) {
		
		return BookDAO.insertBookNote(paramMap);
	}

	@Override
	public List<HashMap<String, Object>> getBookNoteDetails(HashMap<String, Object> paramMap) {
		
		return BookDAO.getBookNoteDetails(paramMap);
	}

	// BookService에서 작성된 시간 차이를 계산하는 메소드
	public String getTimeDifference(LocalDateTime noteCreateDate) {
	    LocalDateTime now = LocalDateTime.now();

	    long minutes = ChronoUnit.MINUTES.between(noteCreateDate, now);
	    long hours = ChronoUnit.HOURS.between(noteCreateDate, now);
	    long days = ChronoUnit.DAYS.between(noteCreateDate, now);

	    if (minutes < 60) {
	        return minutes + "분 전";
	    } else if (hours < 24) {
	        return hours + "시간 전";
	    } else {
	        return days + "일 전";
	    }
	}

	@Override
	public int getBookNoteCount(int userIdx) {
		// TODO Auto-generated method stub
		return BookDAO.getBookNoteCount(userIdx);
	}

	@Override
	public List<HashMap<String, Object>> selectMyBookNotes(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return BookDAO.selectMyBookNotes(paramMap);
	}

	@Override
	public int countMyBookNotes(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return BookDAO.countMyBookNotes(paramMap);
	}

	@Override
	public HashMap<String, Object> selectBookNoteDetail(int noteIdx) {
		// TODO Auto-generated method stub
		return BookDAO.selectBookNoteDetail(noteIdx);
	}

	@Override
	public HashMap<String, Object> selectBookInfo(String isbn) {
		// TODO Auto-generated method stub
		return BookDAO.selectBookInfo(isbn);
	}

	@Override
	public int updateBookNote(HashMap<String, Object> paramMap) {
		
		return BookDAO.updateBookNote(paramMap);
	}

	@Override
	public int deleteBookNote(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return BookDAO.deleteBookNote(paramMap);
	}

	@Override
    public int insertLike(int userIdx, String isbn) {
        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("userIdx", userIdx);
        paramMap.put("isbn", isbn);
        return BookDAO.insertLike(paramMap);
    }

    @Override
    public int deleteLike(int userIdx, String isbn) {
        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("userIdx", userIdx);
        paramMap.put("isbn", isbn);
        return BookDAO.deleteLike(paramMap);
    }

    @Override
    public boolean checkUserLiked(int userIdx, String isbn) {
        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("userIdx", userIdx);
        paramMap.put("isbn", isbn);
        return BookDAO.checkUserLiked(paramMap) > 0;
    }

    @Override
    public int selectLikeCountByBook(String isbn) {
        return BookDAO.selectLikeCountByBook(isbn);
    }

	@Override
	public List<HashMap<String, Object>> getLikedBooks(HashMap<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return BookDAO.getLikedBooks(paramMap);
	}

	@Override
	public double selectAvgRating(String isbn) {
		// TODO Auto-generated method stub
		return BookDAO.selectAvgRating(isbn);
	}


}
