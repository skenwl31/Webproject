package fileupload;


import java.sql.PreparedStatement;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import common.DBConnPool;

/*
DBCP(DataBase Connection Pool)를 이용해서 오라클에 연결한다.
커넥션풀은 DB연결객체를 풀(Pool)에 미리 만들어놓고 필요할때마다
가져다 사용한 후 반납하는 형태로, 필요이상으로 객체를 생성 및
소멸을 하지 않아도 되므로 효율적으로 자원관리를 할 수 있다.
DB연결에 필요한 정보는 Java나 JSP가 가지고 있지 않고
Tomcat(웹서버)에 설정하게 된다. 
 */

public class MyfileDAO extends DBConnPool {
	
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
			String SQL = "SELECT BoardID FROM dataBoard ORDER BY BoardID DESC";
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
	
	//새로운 게시물 등록시 첨부파일도 함께 저장한다.
	public int insertFile(MyfileDTO dto) {
		int applyResult = 0;
		try {
			/*
			게시물 입력을 위한 insert문 생성.
			제목, 이름과 원본파일명, 저장된 파일명을 등록한다.
			일련번호의 경우 회원제 게시판에서 생성했던 시퀀스를
			그대로 사용한다. 시퀀스의 목적은 중복되지 않는
			일련번호를 생성하는 것이므로 하나의 시퀀스를
			여러개의 테이블에 사용해도 된다.
			*/
			String query = " INSERT INTO dataBoard(BoardID, BoardTitle, UserID, BoardContent, BoardAvailable, ofile, sfile) VALUES (?, ?, ?, ?, ?, ?, ?)";
			System.out.println(query);	
			//인파라미터 설정
			psmt = con.prepareStatement(query);
			psmt.setInt(1, dto.getBoardID());
			psmt.setString(2, dto.getBoardTitle());
			psmt.setString(3, dto.getUserID());
			psmt.setString(4, dto.getBoardContent());
			psmt.setInt(5, dto.getBoardAvailable());
			psmt.setString(6, dto.getOfile());
			psmt.setString(7, dto.getSfile());
			
			//쿼리문 실행
			applyResult = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("INSERT 중 예외 발생");
			e.printStackTrace();
		}
		return applyResult;
	}
	
	public void getBoardAvailable(int BoardID) {
		String query = "UPDATE dataBoard SET "
					+ " BoardAvailable=BoardAvailable+1 "
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
	
	//파일 목록 구현을 위해 select 쿼리문 실행 
	public List<MyfileDTO> myFileList(Map<String, Object> map){
		List<MyfileDTO> fileList = new Vector<MyfileDTO>();
		
		//일련번호를 내림차순으로 정렬한 뒤 게시물을 select한다.
		String query = "SELECT * FROM databoard ORDER BY BoardID DESC";		
		try {
			//쿼리문 실행
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			//인출한 행의 갯수만큼 반복한다.
			while(rs.next()) {
				//레코드를 DTO객체에 저장한 후
				MyfileDTO dto = new MyfileDTO();
				dto.setBoardID(rs.getInt("BoardID"));
				dto.setBoardTitle(rs.getString("BoardTitle"));
				dto.setUserID(rs.getString("UserID"));
				dto.setBoardContent(rs.getString("BoardContent"));
				dto.setBoardAvailable(rs.getInt("BoardAvailable"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				//List컬렉션에 추가한다.
				fileList.add(dto);
			}
		}
		catch (Exception e) {
			System.out.println("SELECT시 예외 발생");
			e.printStackTrace();
		}
		return fileList;
	}

	//totalCount
	public int selectCount(Map<String, Object> map) {
		int total = 0;
		
		String query = "SELECT COUNT(*) FROM databoard ";
		if(map.get("searchWord")!=null) {
			query += " WHERE " + map.get("searchField") + " LIKE '%"
					+ map.get("searchWord") + "%' ";
		}
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			rs.next();
			total= rs.getInt(1);
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("토탈값 조회 중 에러");
		}
		
		return total;
	}
	
	
	public List<MyfileDTO> selectListPage(Map<String, Object> map){
		List<MyfileDTO> bbs = new Vector<MyfileDTO>();
		
		String query = "SELECT * FROM databoard ";
		//검색어가 있는 경우에만 where을 추가한다.
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField")
					+ " LIKE '%" + map.get("searchWord") + "%' ";
		}
				
		//between을 통해 게시물의 구간을 결정할 수 있다.
		query += " ORDER BY BoardID DESC LIMIT ?, ?";
				
			
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
				MyfileDTO dto = new MyfileDTO();
				
				dto.setBoardID(rs.getInt("BoardID"));
				dto.setBoardTitle(rs.getString("BoardTitle"));
				dto.setUserID(rs.getString("UserID"));
				dto.setBoardContent(rs.getString("BoardContent"));
				dto.setBoardDate(rs.getString("BoardDate"));
				dto.setBoardAvailable(rs.getInt("BoardAvailable"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				
				bbs.add(dto);
				
			}
		}
		catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		return bbs;
	}
}
