package egovframework.com.book.domain;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)  // 인식되지 않는 필드를 무시
public class BookResponse {
	private List<BookItem> items;
	private int total;  // 총 검색 결과 개수
	
	// Getters and Setters
    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
    
    public List<BookItem> getItems() { 
    	return items; 
    }
    
    public void setItems(List<BookItem> items) { 
    	this.items = items; 
    }
}
