<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="board.BoardDAO" %>
<%
String UserId = null; // 로그인이 된 사람들은 로그인정보를 담을 수 있도록한다
    if (session.getAttribute("UserId") != null)
    {
        UserId = (String)session.getAttribute("UserId");
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
    //여기 코드 완벽하게 이해하지 못함 선생님께서 두번작업해야 한다고 말씀해주심 
    BoardDTO Board = new BoardDAO().getBoard(BoardID);
    //조회수 증가를 위한 코드
    new BoardDAO().getBoardAvailable(BoardID); 
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >  <!-- 반응형 웹에 사용하는 메타태그 -->
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 참조  -->
<title>JSP 게시판 웹 사이트</title>
</head>
<body>

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
                <li><a href="main.jsp">메인</a></li>
                <li class="active"><a href="Board.jsp">게시판</a></li>
                <li><a href="FileBoard.jsp">파일업로드게시판</a></li>
            </ul>
            <%
            // 접속하기는 로그인이 되어있지 않은 경우만 나오게한다
                if(UserId == null)
                {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>                    
                    </ul>
                </li>
            </ul>
            <%
            // 로그인이 되어있는 사람만 볼수 있는 화면
                } else {
            %>
            <ul class="nav navbar-nav navbar-right">
            <li style="margin-top:15px; color:blue;"> <%= session.getAttribute("UserName") %>님 환영합니다. </li>
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="loginAction.jsp">로그아웃</a></li>
                        <li><a href="userEdit.jsp">회원정보수정</a></li>
                    </ul>
                </li>
            </ul>
            <%
                }
            %>
        </div>
    </nav>
    <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
                <thead>
                    <tr>
                        <th colspan="3" style="background-color:#eeeeee; text-align:center;">게시판 글 보기</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="width:20%;">글 제목</td>
                        <td colspan="2"><%= Board.getBoardTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>                  
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td colspan="2"><%= Board.getUserID().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
                    </tr>
                    <tr>
                        <td>작성일자</td>
                        <td colspan="2"><%= Board.getBoardDate().substring(0,11) + Board.getBoardDate().substring(11, 13) + "시" 
                                + Board.getBoardDate().substring(14,16) + "분"  %></td>
                    </tr>
                    <tr>
                    	<td>조회수</td>
                    	<td colspan="2">
                    	<%= Board.getBoardAvailable() %></td>
                    </tr>
                    <tr>
                        <td style="width:100px; vertical-align: middle;">내용</td>
                        <td colspan="2" style="height:100px; width:933px; vertical-align: middle; text-align:center;">
                        <!-- 특수문자를 제대로 출력하기위해 & 악성스크립트를 방지하기위해 -->
                        <%= Board.getBoardContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>    
                    </tr>
                    
                </tbody>
            </table>
            <a href="Board.jsp" class="btn btn-primary">목록</a>
            <%
                if(UserId != null && UserId.equals(Board.getUserID()))
                {
            %>
                <a href="update.jsp?BoardID=<%=BoardID %>" class="btn btn-primary">수정</a>
                <a href="deleteAction.jsp?BoardID=<%=BoardID %>" class="btn btn-primary">삭제</a>
                
            <%     
                }
            %>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>