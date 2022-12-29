<%@page import="fileupload.MyfileDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/custom.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >  <!-- 반응형 웹에 사용하는 메타태그 -->
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 참조  -->

<style type="text/css">
#button{
	display: flex;
	text-align: right;

}
</style>
<script>
function formValidate(){
	//alert("버튼클릭");
	var form = document.getElementById("writeForm");
	if(form.BoardTitle.value  == "" ){
		alert("글제목을 입력하세요");
		form.BoardTitle.focus();
		return false;
	}
	if(form.BoardContent.value  == "" ){
		alert("내용을 입력하세요");
		form.BoardContent.focus();
		return false;
	}
	if (form.attachedFile.value == "") {
        alert("첨부파일은 필수 입력입니다.");
        return false;
    }
	
	form.submit();

}

</script>
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <% 
    MyfileDTO dto = new MyfileDTO();
    String UserId = null;
    if (session.getAttribute("UserId") != null){
        UserId = (String)session.getAttribute("UserId");
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
                <li><a href="Board.jsp">게시판</a></li>
                <li class="active"><a href="FileBoard.jsp">파일업로드게시판</a></li>
            </ul>
            <%
           	if (UserId == null){
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" 
                    aria-haspopup="true"
                    aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>                    
                    </ul>
                </li>
            </ul>
            <%
            }else{
            %>
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
            <% 
           	}
            %>
            
        </div>
    </nav>
    
  
    <span style="color: red; font-size:25px;">${errorMEssage }</span>
    <div class= "container">
    	<div class= "row">
    		<form method="post" name="fileForm" id="writeForm" enctype="multipart/form-data"
    			 action="writeAction222.jsp" onsubmit="return validateForm(this);">
    			<table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
	    	    	<thead>
		    	    	<tr>
		    	    		<th colspan= "2" style= "background-color: #eeeeee; text-align: center;">파일 업로드 게시판 글쓰기 양식</th>
		    	    	</tr>
	    	    	</thead>
			    	<tbody>
			    		<tr>
			    			<td><input type="text" class="form-control" placeholder="글 제목"  name="BoardTitle" maxlength="50" ></td>
			    		</tr>
			    		
			    		<tr>
			    			<td><textarea class="form-control" placeholder="글 내용"  name="BoardContent" maxlength="2048" style= "height:350px" ></textarea></td>
			    		</tr>
			    		
			    		<tr style="display:none">
			    			<td><input type="text" class="form-control" placeholder="작성자"  name="UserID" value = <%= (String)session.getAttribute("UserId") %> ></td>
			    		</tr>
			    		
			    		<%-- 
			    		<tr style="display:none">
			    			<td><input type="text" class="form-control"  name="BoardID"
			    			 value = <%= dto.getBoardID() %> ></td>
			    		</tr>
			    		--%>
			    		
			    		<%--
			    		<tr style="display:none">
			    		<td><input type="text" class="form-control" placeholder="작성날짜"  name="BoardDate" <%= dto.getBoardDate() %>></td>
				    	</tr>
			    		 --%>
			    					    					    		
			    		<tr style="display:none">
			    			<td><input type="text" class="form-control"  name="BoardAvailable" value = <%= dto.getBoardAvailable() %> ></td>
			    		</tr>
			    		 		    		
			    		
			    		
			    	</tbody>
    	    	</table>
    	    	<div id="button">
    	    	<input type="file" class="btn btn-primary" name="attachedFile" value="파일첨부" style="width:210px;"> 
    	    	&nbsp;&nbsp;
    	    	<input type="button" class="btn btn-primary pull-right" value="글쓰기" onclick="formValidate();">
    	    	&nbsp;&nbsp;
    	    	<a href= "FileBoard.jsp" class= "btn btn-primary pull-right" style="margin-right:5px;">글목록</a>
    	    	
    	    	</div>
    	    	
    		</form>
    	    </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>