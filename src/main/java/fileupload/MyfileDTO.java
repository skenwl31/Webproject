package fileupload;

import java.util.Date;

public class MyfileDTO {
	
	private int BoardID ;	     //일련번호
	private String BoardTitle;     // 게시물제목
	private String UserID;    //작성자이름
	private String BoardDate;
	private String BoardContent;
	private int BoardAvailable;
	private String ofile;    // 원본 파일명
	private String sfile;    // 저장된 파일명
	
	
	public int getBoardID() {
		return BoardID;
	}
	public void setBoardID(int boardID) {
		BoardID = boardID;
	}
	public String getBoardTitle() {
		return BoardTitle;
	}
	public void setBoardTitle(String boardTitle) {
		BoardTitle = boardTitle;
	}
	public String getUserID() {
		return UserID;
	}
	public void setUserID(String userID) {
		UserID = userID;
	}

	public String getBoardDate() {
		return BoardDate;
	}
	public void setBoardDate(String boardDate) {
		BoardDate = boardDate;
	}
	public String getBoardContent() {
		return BoardContent;
	}
	public void setBoardContent(String boardContent) {
		BoardContent = boardContent;
	}
	public int getBoardAvailable() {
		return BoardAvailable;
	}
	public void setBoardAvailable(int boardAvailable) {
		BoardAvailable = boardAvailable;
	}
	public String getOfile() {
		return ofile;
	}
	public void setOfile(String ofile) {
		this.ofile = ofile;
	}
	public String getSfile() {
		return sfile;
	}
	public void setSfile(String sfile) {
		this.sfile = sfile;
	}
	
	
	
	
}
