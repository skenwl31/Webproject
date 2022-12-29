<%@page import="utils.BoardPageboots"%>
<%@page import="utils.BoardPageBoot"%>
<%@page import="utils.BoardPage"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.util.ArrayList" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/bootstrap-icons.css">
<%
//application은 jsp에서만 사용가능함 
//DB연결 및 CRUD작업을 위한 DAO객체를 생성한다.
BoardDAO dao = new BoardDAO(application);

/*
검색어가 있는경우 클라이언트가 선택한 필드명과 검색 
*/
Map<String, Object> param = new HashMap<String, Object>();
/*
검색폼에서 입력한 검색어와 필드명을 파라미터로 받아온다.
해당 <form>의 전송방식은 get, action속성은 없는 상태이므로
현재 페이지 폼값이 전송된다.
*/
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
//사용자가 입력한 검색어가 있다면
if (searchWord != null){
	/* Map컬렉션에 컬럼명과 검색어를 추가한다.*/
	param.put("searchField", searchField);
	param.put("searchWord", searchWord);
}

//Map컬렉션을 인수로 게시물의 갯수를 카운트한다.
int totalCount = dao.selectCount(param);

/**페이징 코드 추가 부분 start************************/
//web.xml에 설정한 컨텍스트 초기화 파라미터를 읽어와서 산술연산을 위해
//정수(int)로 변환한다.
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));

/*전체 페이지수를 계산한다. 
(전체게시물갯수 / 페이지당 출력할게시물 갯수) =>결과값의 올림처리
가령 게시물의 갯수가 51개라면 나눴을때의 결과가 5.1이 된다. 이때 무조건
올림처리 하여 6 페이지가 나오게 된다. 만약 totalCount를 double로 형변환
하지 않으면 정수의 결과가 나오게 되므로 6페이지가 아니라 5페이지라는 결과가 
나오게 되므로 주의해야 한다.
*/
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

/*
목록에 처음 진입했을때는 페이지 관련 파라미터가 없는 상태이므로 무조건
1page로 지정한다. 만약 파라미터 pageNum이 있다면 request 내장객체를 통해
받아온 후 페이지 번호로 지정한다.
List.jsp => 이와같이 파라미터가 없는 상태일때는 null
List.jsp?pageNum ==> 이와같이 파라미터는 있는데 값이 없을때는 빈값으로 체크된다.
	따라서 아래 if문은 2개의 조건으로 구성해야 한다.
*/
int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals(""))
	pageNum = Integer.parseInt(pageTemp);

/*
게시물의 구간을 계산한다.
MySQL에서는 limit를 통해 게시물의 범위를 결정하므로 Oracle을
사용할때와 조금 다르게 구간을 계산해야 한다.
형식] 쿼리문... limit 시작위치, 한페이지에 출력할 게시물 갯수;
	한페이지에 5개의 게시물을 출력한다고 가정하면..
	start  = 
		계산식 : (현재페이지-1) * 출력할게시물 갯수
			1페이지 : (1-1) * 5 = 0
			2페이지 : (2-1) * 5 = 0
		end =>
			한페이지에 출력할 게시물의 갯수인 pageSize를 그대로
			사용하면 된다.
*/
int start = (pageNum -1) * pageSize;
//한 페이지에 출력할 게시물의 갯수를 설정 한다.
int end = pageSize;
param.put("start", start);
param.put("end", end);
	
/**페이징 코드 추가부분 end************************/


//목록에 출력한 게시물을 추출하여 반환받는다.
List<BoardDTO> boardLists = dao.selectListPage(param);
dao.close();
	
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >  <!-- 반응형 웹에 사용하는 메타태그 -->
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 참조  -->
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a, a:hover{
		color: #000000;
		text-decoration:none;
	}
	
.div #search{
	display:flex;
	float : right;
	
}

.shape{
	border-radius: 7px;
}

#bps.li{
	width:33.79px;
	height:34px; 
}

</style>


</head>
<body>
    <% 
         
    String UserId = null;
    if (session.getAttribute("UserId") != null){
        UserId = (String) session.getAttribute("UserId");
    }
    
    if (request.getParameter("pageNum") != null){
    	pageNum = Integer.parseInt(request.getParameter("pageNum"));
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
    <h3>목록 보기(List)-Paging기능 추가 
    현재 페이지<%= pageNum %> (전체 : <%= totalPage %>)</h3>
   	<div= "row">
   	    <table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
   	    	<thead>
   	    	<tr>
   	    		<th style= "background-color: #eeeeee; text-align: center;">번호</th>
   	    		<th style= "background-color: #eeeeee; text-align: center;">제목</th>
   	    		<th style= "background-color: #eeeeee; text-align: center;">작성자</th>
   	    		<th style= "background-color: #eeeeee; text-align: center;">작성일</th>
   	    		<th style= "background-color: #eeeeee; text-align: center;">조회수</th>
   	    	</tr>
   	    	</thead>
   	    	<tbody>
   	    			<%
   	    				BoardDAO BoardDAO = new BoardDAO();
   	    				//Map<String, Object> param = new HashMap<String, Object>();
   	    				//위에 param선언되어있음 
   	    				List<BoardDTO> list = BoardDAO.getList(param);
   	    				
   	    			%>
		    	    <%
		    	    if(boardLists.isEmpty()){
		    	    %>		
		    	    	   	<tr>    		
		    	    	   	<td colspan="6">등록된 게시물이 없습니다.</td>
		    	    	   	</tr>
		    	    <%
		    	    }
		    	    else{
		    	    	int virtualNum = 0;
		    	    	int countNum = 0;
		    	    	for (BoardDTO dto : boardLists){
		    	    	
		    	    		virtualNum = totalCount - (((pageNum-1)*pageSize) + countNum++);
		    	    	
		    	    %>
   	    			<tr>
   	    				
   	    				<td><%= dto.getBoardID() %></td>
   	    				<td><a href="view.jsp?BoardID=<%=dto.getBoardID()%>"><%=dto.getBoardTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></a></td>
   	    				<td><%= dto.getUserID() %></td>
   	    				<td><%= dto.getBoardDate().substring(0, 11) + dto.getBoardDate().substring(11, 13) + "시" + dto.getBoardDate().substring(14, 16) + "분" %></td>
   	    				<td><%= dto.getBoardAvailable() %></td>
   	    			</tr>
   	    				
   	    			<%		}
   	    				}
   	    			   	    			
   	    			%>
   	    		
   	    	</tbody>
   	    </table>
 	</div>
   </div>
   	  
   	 <div id="search">
   	 		<div>
    	    <form method="get" >  
		    <table class="table table-stripped">
		    <tr>
		        <td style="width:50%; text-align:center; padding-left:150px;">
		            <select name="searchField" style="width:80px; height:34px;" class="shape"> 
		                <option value="BoardTitle">제목</option> 
		                <option value="BoardContent">내용</option>
		            </select>
		            <input type="text" name="searchWord" style="width:150px; height:34px;" class="shape"/>
		            <input type="submit" value="검색하기" class="btn btn-primary" style="margin-bottom:1px;"/>
		        </td>
					        
		         
		       
		       <td>  
		       <div style="text-align:center;">
    	    	<a href= "write.jsp" class="btn btn-primary right" style="margin-left:0px;">글쓰기</a>
    	    	</div>
		        </td>
		     	</tr>   
			    </table>    
			    </form> 
		    	
		  </div>  
	  </div>
	
      
      <div style="text-align:center;" id="bps">
	   <% System.out.println("현재경로" + request.getRequestURI()); %>
       <%= BoardPageboots.pagingStr(totalCount, pageSize, blockPage, pageNum,
	        				request.getRequestURI()) %>
	  </div>
    
    	      	    
    	   
	
		    	     
    	
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>