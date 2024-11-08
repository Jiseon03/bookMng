package egovframework.com.calendar.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.calendar.service.CalendarService;
import egovframework.com.calendar.service.impl.CalendarDAO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("CalendarService")
public class CalendarServiceImpl extends EgovAbstractServiceImpl implements CalendarService{
	@Resource(name="CalendarDAO")
	private CalendarDAO CalendarDAO;

	@Override
	public List<HashMap<String, Object>> selectBookNotesForCalendar(int userIdx) {
		// TODO Auto-generated method stub
		return CalendarDAO.selectBookNotesForCalendar(userIdx);
	}

	@Override
	public int getMonthlyReadBookCount(int userIdx, String yearMonth) {
		// TODO Auto-generated method stub
		return CalendarDAO.getMonthlyReadBookCount(userIdx, yearMonth);
	}

	@Override
	public int getMonthlyLikeBookCount(int userIdx, String yearMonth) {
		// TODO Auto-generated method stub
		return CalendarDAO.getMonthlyLikeBookCount(userIdx, yearMonth);
	}
}
