<%@page import="user.UserDAO"%>
<%@page import="user.UserDTO"%>
<%@page import="utils.JSFunction"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 

 -->
<%
//수정폼에서 입력한 내용을 파라미터로 받는다.
String id = request.getParameter("userID");
String pass = request.getParameter("userPassword1");
String name = request.getParameter("userName");
String gender = request.getParameter("userGender");
String phone = request.getParameter("userPhone1")+request.getParameter("userPhone2")+request.getParameter("userPhone3");
String email = request.getParameter("userEmail1")+"@"+request.getParameter("userEmail2");


//DTO객체에 수정할 내용을 셋팅한다.
UserDTO dto = new UserDTO();
dto.setUserID(id);
dto.setUserPassword(pass);
dto.setUserName(name);
dto.setUserGender(gender);
dto.setUserPhone(phone);
dto.setUserEmail(email);


//DAO객체 생성을 통해 오라클에 연결한다.
UserDAO dao = new UserDAO(application);
//update 쿼리문을 실행하여 게시물을 수정한다.
int affected = dao.updateUser(dto);



//session.invalidate(); // 세션값 제거

//자원해제
dao.close();



if(affected==1){
	
	session.setAttribute("UserId", dto.getUserID());
	session.setAttribute("UserName", dto.getUserName());
	response.sendRedirect("main.jsp");
	
		
}
else{
	//수정에 실패하면 뒤로 이동한다.
	JSFunction.alertBack("회원 정보 수정하기에 실패하였습니다.", out);
}

%>
