<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/custom.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >  <!-- 반응형 웹에 사용하는 메타태그 -->
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 참조  -->
<title>JSP 게시판 웹 사이트</title>
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
              script.println("location.href = 'login.jsp'");
              script.println("</script>");
          }
          int BoardID = 0;
          if (request.getParameter("BoardID") != null)
          {
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
          }
    %>
    <nav class ="navbar navbar-default">
        <div class="navbar-header"> <!-- 홈페이지의 로고 -->
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
                <span class ="icon-bar"></span> <!-- 줄였을때 옆에 짝대기 -->
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
            </button>
            <a class ="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li> <!-- 메인 페이지 -->
                <li class="active"><a href="Board.jsp">게시판</a></li>
                <li><a href="FileBoard.jsp">파일업로드게시판</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
            <li style="margin-top:15px; color:blue;"> <%= session.getAttribute("UserName") %>님 환영합니다. </li>
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" 
                    aria-haspopup="true"
                    aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
    <div class= "container">
    	<div class= "row">
    		<form method="post" action="updateAction.jsp?BoardID=<%= BoardID%>">
    			<table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
	    	    	<thead>
		    	    	<tr>
		    	    		<th colspan= "2" style= "background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
		    	    	</tr>
	    	    	</thead>
			    	<tbody>
			    		<tr>
			    			<td><input type="text" class="form-control" placeholder="글 제목"  name="BoardTitle" maxlength="50" value="<%= Board.getBoardTitle()%>"></td>
			    		</tr>
			    		<tr>
			    			<td><textarea class="form-control" placeholder="글 내용"  name="BoardContent" maxlength="2048" style= "height:350px"><%= Board.getBoardContent()%></textarea></td>
			    		</tr>
			    	</tbody>
    	    	</table>
    	    	<input type="submit" class="btn btn-primary pull-right" value="글수정">
    		</form>
    	    </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>