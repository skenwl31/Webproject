<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import = "java.io.PrintWriter" %>
<%
request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; c harset=UTF-8">
<title>JSP Board</title>
</head>
<body>
    <%
    String UserId = null;
		if (session.getAttribute("UserId") != null){
		       UserId = (String) session.getAttribute("UserId");
		}
		if (UserId == null){
		       PrintWriter script = response.getWriter();
		       script.println("<script>");
		       script.println("alert('로그인하세요.')");
		       script.println("location.href = 'login.jsp'");    // 메인 페이지로 이동
		       script.println("</script>");
		}
		int BoardID = 0;
		if (request.getParameter("BoardID") != null){
			BoardID = Integer.parseInt(request.getParameter("BoardID"));
		}
		if (BoardID == 0)
		   {
		       PrintWriter script = response.getWriter();
		       script.println("<script>");
		       script.println("alert('유효하지 않은 글입니다')");
		       script.println("location.href = 'Board.jsp'");
		       script.println("</script>");
		   }
		   BoardDTO Board = new BoardDAO().getBoard(BoardID);
		   if (!UserId.equals(Board.getUserID())){
		   	PrintWriter script = response.getWriter();
		       script.println("<script>");
		       script.println("alert('권한이 없습니다.')");
		       script.println("location.href = 'Board.jsp'");
		       script.println("</script>");
		   }else{
			if (request.getParameter("BoardTitle") == null || request.getParameter("BoardContent") == null
					|| request.getParameter("BoardTitle").equals("") || request.getParameter("BoardContent").equals("")){
		   		PrintWriter script = response.getWriter();
		           script.println("<script>");
		           script.println("alert('모든 문항을 입력해주세요.')");
		           script.println("history.back()");    // 이전 페이지로 사용자를 보냄
		           script.println("</script>");
		   	}else{
		   		BoardDAO BoardDAO = new BoardDAO();
		           int result = BoardDAO.update(BoardID, request.getParameter("BoardTitle"), request.getParameter("BoardContent"));
		           if (result == -1){ // 글수정 실패시
		               PrintWriter script = response.getWriter();
		               script.println("<script>");
		               script.println("alert('글수정에 실패했습니다.')");
		               script.println("history.back()");    // 이전 페이지로 사용자를 보냄
		               script.println("</script>");
		           }else{ // 글쓰기 성공시
		           	PrintWriter script = response.getWriter();
		               script.println("<script>");
		               script.println("location.href = 'Board.jsp'");    // 메인 페이지로 이동
		               script.println("</script>");    
		           }
		   	}	
	}
    %>
 
</body>
</html>