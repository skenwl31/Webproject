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
    	
    	
    //파일업로드Process
    
    
//파일업로드를 위한 디렉토리의 물리적경로(절대경로)를 얻어온다.
//물리적 경로가 필요한 이유는 운영체제에 따라 경로를 표현하는
//방식이 다르기 때문이다.
String saveDirectory = application.getRealPath("/Uploads");
//업로드할 파일의 최대용량제한(1mb로 지정함)
int maxPostSize = 1024 * 1000;
//인코딩 방식 지정
String encoding = "UTF-8";

try{
	/*
	앞에서 준비한 3개의 인수와 request내장객체까지 이용해서
	MultipartRequest객체를 생성한다. 해당 객체가 정상적으로
	생성되면 파일 업로드는 완료된다.
	*/
	MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);
	
	//mr객체를 통해 서버에 저장된 파일명을 가져온다.
	String fileName = mr.getFilesystemName("attachedFile");
	//파일명에서 확장자 앞의 .(닷)을 찾아 인덱스를 확인한 후
	//확장자를 잘라낸다. 확장자는 파일의 용도를 나타내는 부분이므로
	//중요하다. 파일명에 .(닷)을 여러개 사용할 수 있으므로 끝에서
	//부터 찾는다.
	String ext = fileName.substring(fileName.lastIndexOf("."));
	/* 현재날짜와 시간 및 밀리세컨즈까지 이용해서 파일명으로
	사용할 문자열을 만든다.
	*/
	String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
	//확장자와 파일명을 합쳐서 서버에 저장할 파일명을 만든다.
	String newFileName = now + ext;
	
	/* 서버에 저장된 파일의 파일명을 새로운 파일명으로 
	변경해준다. 여기서 사용된 sparator는 경로를 표시할때
	사용하는 구분기호로 윈도우의경우 \(역슬러시), 리눅스의
	경우 /(슬러시)를 자동으로 부여해준다. File객체를
	각각 생성한 후 renameTo()메서드를 통해 변경한다.*/
	File oldFile = new File(saveDirectory, File.separator + fileName);
	File newFile = new File(saveDirectory, File.separator + newFileName);
	oldFile.renameTo(newFile);
	
	/* 파일을 제외한 나머지 폼값을 받는다. 단 이때 request
	내장객체를 통해서가 아니라 mr객체를 통해 받아야
	하므로 주의해야 한다. 객체는 다르지만 폼값을 받기위한
	메서드명은 동일하다.*/ 
	
	
	//int boardid = Integer.parseInt(mr.getParameter("BoardID"));
	String title = mr.getParameter("BoardTitle");
	String userid = mr.getParameter("UserID");
	String content = mr.getParameter("BoardContent");
    int ba = Integer.parseInt(mr.getParameter("BoardAvailable"));
	
	
	//DTO 생성 및 폼값을 세팅한다.
	MyfileDTO dto = new MyfileDTO();
	//dto.setBoardID(boardid);
	dto.setBoardTitle(title);
	dto.setUserID(userid);
	dto.setBoardContent(content);
	dto.setBoardAvailable(ba);
	//입력전 StringBuffer 객체를  String으로 변환해야 한다.
	dto.setOfile(fileName);
	dto.setSfile(newFileName);
	
	//DAO를 통해 데이터베이스에 반영
	MyfileDAO dao = new MyfileDAO();
	dao.insertFile(dto);
	//자원반납(커넥션풀에 Connection 객체를 반납한다.)
	dao.close();
		
	//파일 업로드에 성공한 경우 파일 목록으로 이동한다.
	response.sendRedirect("FileBoard.jsp");
	
}
catch (Exception e){
	/* 파일 업로드에 실패한 경우에는 request영역에 에러 메세지를
	저장한 후 업로드 폼으로 포워드 한다.*/
	e.printStackTrace();
	request.setAttribute("errorMessage", "파일 업로드 오류");
	request.getRequestDispatcher("FileView.jsp")
		.forward(request, response);
}

 %>