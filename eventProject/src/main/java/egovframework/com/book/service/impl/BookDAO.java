package egovframework.com.book.service.impl;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.com.book.domain.BookItem;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
@Repository("BookDAO")
public class BookDAO extends EgovAbstractMapper{

	public boolean existsByIsbn(String isbn) {
	    Integer count = selectOne("countByIsbn", isbn);
	    return count != null && count > 0;
	}

    public int insertBook(BookItem book) {
        return insert("insertBook", book);
    }
    
    public List<BookItem> selectBookDetail(String isbn) {
        return selectList("selectBookDetail", isbn);  
    }

    public int insertBookNote(HashMap<String, Object> paramMap) {
        return insert("insertBookNote", paramMap);
    }
    
    public List<HashMap<String, Object>> getBookNoteDetails(HashMap<String, Object> paramMap) {
        return selectList("getBookNoteDetails",paramMap);
    }
    public int getBookNoteCount(int userIdx) {
        return selectOne("getBookNoteCount", userIdx);
    }
 
	 public List<HashMap<String, Object>> selectMyBookNotes(HashMap<String, Object> paramMap){
			return selectList("selectMyBookNotes", paramMap);
		}
	 
	 public int countMyBookNotes(HashMap<String, Object> paramMap) {
			return selectOne("countMyBookNotes", paramMap);
		}
	 
	 public HashMap<String, Object> selectBookNoteDetail(int noteIdx) {
			return selectOne("selectBookNoteDetail", noteIdx);
		}
	 
	 public HashMap<String, Object> selectBookInfo(String isbn) {
	        return selectOne("selectBookInfo", isbn);  
	    }
	 
	 public int updateBookNote(HashMap<String, Object> paramMap) {
	        return update("updateBookNote", paramMap);
	    }
	 
	 public int deleteBookNote(HashMap<String, Object> paramMap) {
	        return update("deleteBookNote", paramMap);
	    }
	 
	// 좋아요 추가
	 public int insertLike(HashMap<String, Object> paramMap) {
	     return insert("insertLike", paramMap);
	 }

	 // 좋아요 취소
	 public int deleteLike(HashMap<String, Object> paramMap) {
	     return delete("deleteLike", paramMap);
	 }
	// 사용자가 해당 책에 좋아요를 눌렀는지 확인
	 public int checkUserLiked(HashMap<String, Object> paramMap) {
	     return selectOne("checkUserLiked", paramMap);
	 }

	 // 특정 책의 좋아요 개수 조회
	 public int selectLikeCountByBook(String isbn) {
	     return selectOne("selectLikeCountByBook", isbn);
	 }
	 
	 public List<HashMap<String, Object>> getLikedBooks(HashMap<String, Object> paramMap) {
	        return selectList("getLikedBooks",paramMap);
	    }
	 
	 public double selectAvgRating(String isbn) {
		 return selectOne("selectAvgRating", isbn);
	 }
}
