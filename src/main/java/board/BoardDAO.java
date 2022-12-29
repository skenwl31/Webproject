package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

import common.JDBConnect;
import board.BoardDTO;

public class BoardDAO extends JDBConnect{
		
	public BoardDAO(ServletContext application) {
		//부모 생성자에서는 application을 통해 web.xml에 직접
		//접근하여 컨텍스트 초기화 파라미터를 얻어온다.
		super(application);
	}
	
	public BoardDAO() {}
	
	//멤버메서드
	//게시물의 갯수를 카운트하여 int형으로 반환한다.
	public int selectCount(Map<String, Object> map) {
		
		//결과(게시물 수)를 담을 변수
		int totalCount = 0;
		
		//게시물 수를 얻어오는 쿼리문 작성
		String query = "SELECT COUNT(*) FROM Board";
		//검색어가 있는 경우 where절을 추가하여 조건에 맞는 게시물만
		//인출한다.
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
					+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		try {
			//정적쿼리문 실행을 위한 Statement객체 생성
			stmt = con.createStatement();
			//쿼리문 실행후 결과는 ResultSet으로 반환한다.
			rs = stmt.executeQuery(query);
			//커서를 첫번째 행으로 이동하여 레코드를 읽는다.
			rs.next();
			//첫번째 컬럼의 값을 가져와서 변수에 저장한다.
			totalCount = rs.getInt(1);
		}
		catch (Exception e) {
			System.out.println("게시물 수를 구하는 중 예외 발생");
			e.printStackTrace();
		}
		return totalCount;
	}
	
	//작성된 게시물을 반환하는 
	public List<BoardDTO> selectList(Map<String, Object> map){
		
		//List계열의 컬렉션을 생성한다. 이때 타입 매개변수는
		//BoardDTO객체로 설정한다.
		//게시판 목록은 출력순서가 보장되야 하므로 Set컬렉션은
		//사용할 수 없고 List컬렉션을 사용해야 한다.
		List<BoardDTO> bbs = new Vector<BoardDTO>();
		
		//레코드 추출을 위한 select 쿼리문 작성
		String query = "SELECT * FROM board ";
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
					+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		//최근게시물을 상단에 노출하기 위해 내림차순으로 정렬한다.
		//여기변경 원래 num이였음 => BoardID
		query += " ORDER BY BoardID DESC ";
		
		try {
			//쿼리실행 및 결과값 반환
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			//2개 이상의 레코드가 반환될 수 있으므로 while문을 사용함
			//갯수만큼 반복하게된다.
			while(rs.next()){
				//하나의 레코드를 저장할 수 있는 DTO객체를 생성
				BoardDTO board = new BoardDTO();
				
				//setter()를 이용해서 각 컬럼의 값을 저장
				//원래 다 쿼리였음
				board.setBoardID(rs.getInt("BoardID"));
				board.setBoardTitle(rs.getString("BoardTitle"));
				board.setUserID(rs.getString("UserID"));
				board.setBoardDate(rs.getString("BoardDate"));
				board.setBoardContent(rs.getString("BoardContent"));
				board.setBoardAvailable(rs.getInt("BoardAvailable"));
				
				//List컬렉션에 DTO객체를 추가한다.
				bbs.add(board);
			}
		}
		catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		return bbs;
	}
	//현재시각 구하기
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //DB 오류 
	}
	
	public int getNext() {
		String SQL = "SELECT BoardID FROM Board ORDER BY BoardID DESC";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
	
	public void getBoardAvailable(int BoardID) {
		String query = "UPDATE Board SET "
					+ " BoardAvailable = BoardAvailable+1 "
					+ " WHERE BoardID=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, BoardID);
			psmt.executeQuery();
		}
		catch (Exception e) {
			System.out.println("게시물 조회수 증가 중 예외 발생");
			e.printStackTrace();
		}
	}

	//게시물 목록 출력시 페이징 기능 추가 
	public List<BoardDTO> selectListPage(Map<String, Object> map){
		List<BoardDTO> bbs = new Vector<BoardDTO>();
		
		String query = " SELECT * FROM Board ";
		//검색어가 있는 경우에만 where을 추가한다.
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField")
					+ " LIKE '%" + map.get("searchWord") + "%' ";
		}
				
		//between을 통해 게시물의 구간을 결정할 수 있다.
		query += " ORDER BY BoardID DESC LIMIT ?, ? ";
				
			
		try {
			//인파라미터가 있는 쿼리문으로 prepared객체를 생성한다.
			psmt = con.prepareStatement(query);
			
			//인파라미터를 설정한다. 구간의 시작과 끝을 계산한 값이다.
			/* setString()으로 인파라미터를 설정하면 문자형이 되므로
			 * 값 양쪽에 싱글쿼테이션이 자동으로 삽입된다. 여기서는
			 * 정수를 입력해야 하므로 setInt()를 사용하고, 인수로 전달되는
			 변수를 정수로 변환해야 한다. */
			psmt.setInt(1, Integer.parseInt(map.get("start").toString()));
			psmt.setInt(2, Integer.parseInt(map.get("end").toString()));
			
			
			
			//쿼리문을 실행하고 결과레코드를 ResultSet으로 반환받는다.
			rs = psmt.executeQuery();
			//결과 레코드의 갯수만큼 반복하여 List컬렉션에 저장한다.
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setBoardID(rs.getInt((1)));
				board.setBoardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setBoardDate(rs.getString(4));
				board.setBoardContent(rs.getString(5));
				board.setBoardAvailable(rs.getInt(6));
				
				bbs.add(board);
				
			}
		}
		catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	//게시물 목록 출력시 페이징 기능 추가 
	public List<BoardDTO> getList(Map<String, Object> map){
		List<BoardDTO> bbs = new Vector<BoardDTO>();
		//String SQL = "SELECT * FROM Board WHERE BoardID < ? AND BoardAvailable = 1 ORDER BY BoardID DESC LIMIT 10";
		String SQL = "SELECT * FROM board";
		if(map.get("searchWord") != null) {		
			 SQL += " WHERE " + map.get("searchField")
			 		+ " LIKE '%" + map.get("searchWord") + "%' ";
		}
		
		SQL += " ORDER BY BoardID DESC LIMIT ?, ? ";
		System.out.println("sql="+ SQL);
		
		try {
			psmt = con.prepareStatement(SQL);
			
			psmt.setInt(1, Integer.parseInt(map.get("start").toString()));
			psmt.setInt(2, Integer.parseInt(map.get("end").toString()));
			
			rs = psmt.executeQuery();
			
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setBoardID(rs.getInt(1));
				board.setBoardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setBoardDate(rs.getString(4));
				board.setBoardContent(rs.getString(5));
				board.setBoardAvailable(rs.getInt(6));
				bbs.add(board);
			}
		}
		catch(Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		return bbs;
		
		
	}
		
		
	// 해당 페이지로 넘어갈 수 있는지 검사
	/*
	public boolean nextPage(int pageNumber){
		String SQL = "SELECT * FROM Board WHERE BoardID < ? AND BoardAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber -1)*10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false; 
	}
	*/
	
	
	
	//게시판 조회 기능 
	public BoardDTO getBoard(int BoardID)
    {
		String SQL = "SELECT * FROM Board WHERE BoardID = ?"; 
        try {
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setInt(1, BoardID);
				rs = pstmt.executeQuery();
				if (rs.next())
				{
	                BoardDTO board = new BoardDTO();
	                board.setBoardID(rs.getInt(1));
	                board.setBoardTitle(rs.getString(2));
	                board.setUserID(rs.getString(3));
	                board.setBoardDate(rs.getString(4));
	                board.setBoardContent(rs.getString(5));
	                board.setBoardAvailable(rs.getInt(6));
	                return board;
		        }
        } catch (Exception e) {
        	e.printStackTrace();
        }
        return null; 
    }
	
	//글쓰기 기능
	public int write(String BoardTitle, String UserID, String BoardContent){
		String SQL = "INSERT INTO Board VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, BoardTitle);
			pstmt.setString(3, UserID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, BoardContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
	
	//수정하기 기능 
	public int update(int BoardID, String BoardTitle, String BoardContent) {	
		String SQL = "UPDATE Board SET BoardTitle = ?, BoardContent = ? WHERE BoardID = ?";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, BoardTitle);
			pstmt.setString(2, BoardContent);
			pstmt.setInt(3, BoardID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
	
	
	//삭제기능 
	public int delete(int BoardID) {
		String SQL = "DELETE From Board WHERE BoardID = ?";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, BoardID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
}