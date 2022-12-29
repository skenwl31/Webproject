package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletContext;

import common.JDBConnect;
import model1.board.BoardDTO;
import user.UserDTO;


public class UserDAO extends JDBConnect {
	
	//private Connection con;
	private PreparedStatement pstmt;
	private ResultSet rs; 
	
	public UserDAO(String drv, String url, String id, String pw) {
		super(drv, url, id, pw);
	}
	
	public UserDAO(ServletContext application) {
		super(application);
	}
	
	//로그인할때 사용.
	public UserDTO getUserDTO(String id,String pass) {
		
			//로그인을 위한 쿼리문을 실행한 후 회원정보를 저장하기 위해
			//생성
			UserDTO dto = new UserDTO();
			//회원 로그인을 인파라미터가 있는 동적 쿼리문 작성
			String query = " SELECT * FROM user WHERE UserID=? AND UserPassword=? ";
			System.out.println(query);
			
			try {
				//쿼리문 실행을 위한 prepared객체 생성 및 인파라미터 설정
				psmt = con.prepareStatement(query);
				psmt.setString(1, id);
				psmt.setString(2, pass);
				//select쿼리문을 실행한 후 ResultSet으로 반환받는다.
				rs = psmt.executeQuery();
				
				//반환된 ResultSet객체를 통해 회원정보가 있는지 확인한다.
				if(rs.next()) {
					//정보가 있다면 DTO객체에 회원정보를 저장한다.
					dto.setUserID(rs.getString("userID"));
					dto.setUserPassword(rs.getString("userPassword"));
					dto.setUserName(rs.getString(3));
					dto.setUserGender(rs.getString(4));
					dto.setUserPhone(rs.getString(5));
					dto.setUserEmail(rs.getString(6));
					
					System.out.println(rs.getString("userID") +"<>"+ rs.getString(3));
				}
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			//호출한 지점으로 DTO객체를 반환한다.
			return dto;
		}

	//회원정보 수정할때 회원정보가져오기.
	public UserDTO getUserDTO(String id) {
		System.out.println("회원정보수정할때 사용하는 getUserDTO메서드 호출됨.");
				//로그인을 위한 쿼리문을 실행한 후 회원정보를 저장하기 위해
				//생성
			UserDTO dto = new UserDTO();
			//회원 로그인을 인파라미터가 있는 동적 쿼리문 작성
			String query = " SELECT * FROM user WHERE UserID=? ";
			System.out.println(query);
			
			try {
				//쿼리문 실행을 위한 prepared객체 생성 및 인파라미터 설정
				psmt = con.prepareStatement(query);
				psmt.setString(1, id);
				//select쿼리문을 실행한 후 ResultSet으로 반환받는다.
				rs = psmt.executeQuery();
				
				//반환된 ResultSet객체를 통해 회원정보가 있는지 확인한다.
				if(rs.next()) {
					//정보가 있다면 DTO객체에 회원정보를 저장한다.
					dto.setUserID(rs.getString("userID"));
					dto.setUserPassword(rs.getString("userPassword"));
					dto.setUserName(rs.getString(3));
					dto.setUserGender(rs.getString(4));
					dto.setUserPhone(rs.getString(5));
					dto.setUserEmail(rs.getString(6));
					
					System.out.println(rs.getString("userID") +"<>"+ rs.getString(3));
				}
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			//호출한 지점으로 DTO객체를 반환한다.
			return dto;
		}

	//회원정보 수정
	public int updateUser(UserDTO dto) {
		int result = 0;
		
		try {
			//특정 일련번호에 해당하는 게시물을 수정한다.
			String query = " UPDATE user SET "
						+ " userPassword=?, userName=?, userGender=?, "
						+ " userPhone=?, userEmail=? "
						+ " WHERE userID=? ";
			System.out.println(query);
			psmt = con.prepareStatement(query);
			//인파라미터 설정하기
			psmt.setString(1, dto.getUserPassword());
			psmt.setString(2, dto.getUserName());
			psmt.setString(3, dto.getUserGender());
			psmt.setString(4, dto.getUserPhone());
			psmt.setString(5, dto.getUserEmail());
			psmt.setString(6, dto.getUserID());
			
			//수정된 레코드의 갯수가 반환된다.
			result = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("회원정보 수정 중 예외 발생");
			e.printStackTrace();
		}
		System.out.println(result);
		return result;// * 행 이 변경되었음.
	}
		
	
	public UserDAO() {
		try {
			String dbURL = "jdbc:mariadb://localhost:3306/webproject1";
			String dbID = "webproject1";
			String dbPassword = "1234";
			Class.forName("org.mariadb.jdbc.Driver");
			con = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(userPassword))
					return 1; //로그인 성공
				else
					return 0; // 비밀번호 틀림
			}
			return -1; // 아이디 없음 
		}catch(Exception e) {
			e.printStackTrace();
			
		}
		return -2; //DB 오류 
	}
	
		
	public int join(UserDTO user) {
		String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?, ?, ?)";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserPhone());
			pstmt.setString(6, user.getUserEmail());
			return pstmt.executeUpdate(); // 0이상 값이 return된 경우 성공 
		}catch(Exception e) {
			e.printStackTrace();
			
		}
		return -1; //DB 오류 
	}
		//아이디중복체크 메서드
		public int joinIdCheck(String id){
			String sql;
			int result = -1;
			String dbURL = "jdbc:mariadb://localhost:3306/webproject1";
			String dbID = "webproject1";
			String dbPassword = "1234";
			
			try {
				//1. DB연결
				con = DriverManager.getConnection(dbURL, dbID, dbPassword);
				//2. sql 구문 & pstmt생성
				sql = " select userID from user where userID=? ";
				pstmt = con.prepareStatement(sql);
				System.out.println("실행되는 쿼리 " + sql);
				pstmt.setString(1, id);

				//3. 실행 -> select -> rs저장
				rs = pstmt.executeQuery();

				//4. 데이터처리
				if(rs.next()){	
					result = 0;
				}else{
					result = 1;
				}

				System.out.println("아이디 중복체크결과 : "+result);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return result;
		}//joinIdCheck 메서드닫음
		
		
		
		public UserDTO getuserDTO(String id, String pass) {
			//로그인을 위한 쿼리문을 실행한 후 회원정보를 저장하기 위해
			//생성
			UserDTO dto = new UserDTO();
			//회원 로그인을 인파라미터가 있는 동적 쿼리문 작성
			String query = "SELECT * FROM user WHERE UserID=? AND UserPassword=?";
			
			try {
				//쿼리문 실행을 위한 prepared객체 생성 및 인파라미터 설정
				psmt = con.prepareStatement(query);
				psmt.setString(1, id);
				psmt.setString(2, pass);
				//select쿼리문을 실행한 후 ResultSet으로 반환받는다.
				rs = psmt.executeQuery();
				
				//반환된 ResultSet객체를 통해 회원정보가 있는지 확인한다.
				if(rs.next()) {
					//정보가 있다면 DTO객체에 회원정보를 저장한다.
					dto.setUserID(rs.getString("id"));
					dto.setUserPassword(rs.getString("pass"));
					dto.setUserName(rs.getString(3));
					dto.setUserGender(rs.getString(4));
					dto.setUserPhone(rs.getString(5));
					dto.setUserEmail(rs.getString(6));
				}
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			//호출한 지점으로 DTO객체를 반환한다.
			return dto;
		}
		
	}
