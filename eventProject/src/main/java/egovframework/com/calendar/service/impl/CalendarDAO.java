package egovframework.com.calendar.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("CalendarDAO")
public class CalendarDAO extends EgovAbstractMapper{
	public List<HashMap<String, Object>> selectBookNotesForCalendar(int userIdx) {
        return selectList("selectBookNotesForCalendar",userIdx);
    }
	
	public int getMonthlyReadBookCount(int userIdx, String yearMonth) {
		HashMap<String, Object> params = new HashMap<>();
	    params.put("userIdx", userIdx);
	    params.put("yearMonth", yearMonth);
	    return selectOne("getMonthlyReadBookCount", params); // Map을 파라미터로 전달
	}

	public int getMonthlyLikeBookCount(int userIdx, String yearMonth) {
		HashMap<String, Object> params = new HashMap<>();
	    params.put("userIdx", userIdx);
	    params.put("yearMonth", yearMonth);
	    return selectOne("getMonthlyLikeBookCount", params); // Map을 파라미터로 전달
	}

}
