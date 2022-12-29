package board;

public class BoardDTO {
	private int BoardID;
	private String BoardTitle;
	private String UserID;
	private String BoardDate;
	private String BoardContent;
	private int BoardAvailable;
	
	private String ofile;
	private String sfile;
	private int downcount;
	private String pass;
	private int visitcount;
	
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
	public int getDowncount() {
		return downcount;
	}
	public void setDowncount(int downcount) {
		this.downcount = downcount;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public int getVisitcount() {
		return visitcount;
	}
	public void setVisitcount(int visitcount) {
		this.visitcount = visitcount;
	}

}
