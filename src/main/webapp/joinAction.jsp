<%@page import="user.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "user.UserDAO" %>
<%@ page import = "java.io.PrintWriter" %>

<!-- 
	   	if (userID != null){
	           PrintWriter script = response.getWriter();
	           script.println("<script>");
	           script.println("alert('이미 로그인되었습니다.')");
	           script.println("location.href = 'main.jsp'");    // 메인 페이지로 이동
	           script.println("</script>");
	   	}
-->
<% request.setCharacterEncoding("UTF-8"); %>
   
    <%
    	String userID = request.getParameter("userID");
    	String userPassword = request.getParameter("userPassword1");
    	String userName = request.getParameter("userName");
    	String userGender = request.getParameter("userGender");
    	String userPhone1 = request.getParameter("userPhone1");
    	String userPhone2 = request.getParameter("userPhone2");
    	String userPhone3 = request.getParameter("userPhone3");
    	String userPhone = userPhone1.concat(userPhone2).concat(userPhone3);
    	String userEmail1 = request.getParameter("userEmail1");
    	String userEmail2 = request.getParameter("userEmail2"); 
    	String userEmail = userEmail1.concat("@"+userEmail2);
    			
       UserDTO user = new UserDTO();
       user.setUserID(userID);
       user.setUserEmail(userEmail);
       user.setUserGender(userGender);
       user.setUserName(userName);
       user.setUserPassword(userPassword);
       user.setUserPhone(userPhone);
       
       UserDAO userDAO = new UserDAO();
       int result = userDAO.join(user);
       if(result == 1 ){ // 회원가입 성공시
           session.setAttribute("userID", user.getUserID()); //세션에 ID값저장
           //name set 하기.
           session.setAttribute("userName", user.getUserName()); //세션에 Name값 저장 
           PrintWriter script = response.getWriter();
           script.println("<script>");
       	   script.println("alert('회원가입이 완료되었습니다.')");
           script.println("location.href = 'main.jsp'");    // 메인 페이지로 이동
           script.println("</script>");
           
           
       }else if (result == 0 ){
           PrintWriter script = response.getWriter();
       	   script.println("alert('회원가입에 실패하였습니다.')");
           script.println("<script>");
           script.println("location.href = 'join.jsp'");    // 메인 페이지로 이동
           script.println("</script>");
           return;
       }
       //회원가입 후 로그인처리해서 메인페이지로 이동
       if (session.getAttribute("userID") != null){
           userID = (String)session.getAttribute("userID");
           session.setAttribute("userID", user.getUserID());
           session.setAttribute("userName", user.getUserName());
           PrintWriter script = response.getWriter();
           script.println("<script>");
       	   script.println("alert('회원가입이 완료되었습니다.')");
           script.println("location.href = 'main.jsp'");    // 메인 페이지로 이동
           script.println("</script>");
         
   		}
   		
             
    %>
 
</body>
</html>