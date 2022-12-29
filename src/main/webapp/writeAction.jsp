<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.File"%>
<%@page import="fileupload.MyfileDAO"%>
<%@page import="fileupload.MyfileDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>


 
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
            
    	}else{
    		if (request.getParameter("BoardTitle") == null || request.getParameter("BoardContent") == null){
        		PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('모든 문항을 입력해주세요.')");
                script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                script.println("</script>");
       		}else{
        		BoardDAO BoardDAO = new BoardDAO();
                int result = BoardDAO.write(request.getParameter("BoardTitle"), UserId, request.getParameter("BoardContent"));
                if (result == -1){ // 글쓰기 실패시
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('글쓰기에 실패했습니다.')");
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