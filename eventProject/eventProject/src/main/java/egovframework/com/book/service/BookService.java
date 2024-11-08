package egovframework.com.book.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;

import egovframework.com.book.domain.BookItem;
import egovframework.com.book.domain.BookResponse;

public interface BookService {
	
	
	public BookResponse searchBooks(String query, List<String> conditions) throws IOException;
	
	public boolean saveBook(BookItem book);

	public  List<BookItem> getBookDetail(String isbn);

	public int insertBookNote(HashMap<String, Object> paramMap);  // 독서노트 등록
	
	public List<HashMap<String, Object>> getBookNoteDetails(HashMap<String, Object> paramMap);
	
	public String getTimeDifference(LocalDateTime noteCreateDate);
	
	public int getBookNoteCount(int userIdx);
	
	public List<HashMap<String, Object>> selectMyBookNotes(HashMap<String, Object> paramMap);
	
	public int countMyBookNotes(HashMap<String, Object> paramMap);
	
	public HashMap<String, Object> selectBookNoteDetail(int noteIdx);
	
	public HashMap<String, Object> selectBookInfo(String isbn);
	
	public int updateBookNote(HashMap<String, Object> paramMap);
	
	public int deleteBookNote(HashMap<String, Object> paramMap);
	
	// 좋아요 추가
	 public int insertLike(int userIdx, String isbn); 
		
	// 좋아요 취소
	public int deleteLike(int userIdx, String isbn); 
	
	// 사용자가 해당 책에 좋아요를 눌렀는지 확인
	public boolean checkUserLiked(int userIdx, String isbn); 

	// 특정 책의 좋아요 개수 조회
	public int selectLikeCountByBook(String isbn); 
	
	public List<HashMap<String, Object>> getLikedBooks(HashMap<String, Object> paramMap);
	
	public double selectAvgRating(String isbn);
}
