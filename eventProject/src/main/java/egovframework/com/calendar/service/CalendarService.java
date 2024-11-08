package egovframework.com.calendar.service;

import java.util.HashMap;
import java.util.List;

public interface CalendarService {
	public List<HashMap<String, Object>> selectBookNotesForCalendar(int userIdx);
	
	public int getMonthlyReadBookCount(int userIdx, String yearMonth);
	
	public int getMonthlyLikeBookCount(int userIdx, String yearMonth);
}
