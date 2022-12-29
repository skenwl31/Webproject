<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/custom.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<script>
function commonFocusMove(thisObj, numLength, nextObj){
	var obj1 = document.getElementById(thisObj);
	var strLen2 = obj1.value.length;
	if(strLen2 == numLength){
		document.getElementById(nextObj).focus();
	}
}

<!-- 아이디중복체크 -->
function winopen(){
	var joinForm = document.getElementById("joinForm");
		
	//새창을 열어서 페이지를 오픈 후 -> 회원아이디정보를 가지고 중복체크
	//1. 아이디가 없으면 알림창과 진행x
	if(joinForm.userID.value =="" || document.fr.userID.value.length < 0){
		alert("아이디를 입력해주세요")
		document.fr.userID.focus();
	}else{
		//2. 회원정보아이디를 가지고 있는 지 체크하려면 DB에 접근해야한다.
		//자바스크립트로 어떻게 DB에 접근할까? => 파라미터로 id값을 가져가서 jsp페이지에서 진행하면 된다.
		window.open("joinIdcheck.jsp?userID="+document.fr.userID.value,"","width=500, height=300");
	}
}

$(function(){
	//패스워드 입력란에 입력후 키보드를 땠을때 함수를 실행한다. 
	$('#passwd1').keyup(function(){
		//패스워드1에 입력한 내용을 변수로 저장한다. 
		var inputVal = $(this).val();
		//콘솔에서 확인하기.
		console.log("입력", inputVal);
		
		if(inputVal.length>=8){
			//alert("정상");
			//패스워드가 8자 이상이면 검증처리한다.
			$('#confirm4').css({'color':'red','fontSize':'22px','fontWeight':'bold'});
		}
		else{
			//8자 미만이면 초기상태로 스타일을 지정한다.
			$('#confirm4').css('color','gray').css('fontSize','20px')
				.css('fontWeight','normal');
		}
		
		//대소문자 및 숫자를 체킹할 수 있는 변수 생성
		var strUpper=false, strLower=false, strNumber=false;
		
		//입력한 패스워드의 길이만큼 반복하여 모든 문자를 검사한다. 
		for(var i=0 ; i<inputVal.length ; i++){
			//입력값의 아스키코드를 확인해본다.
			console.log("아스키코드값", inputVal[i].charCodeAt(0));
			
			//입력한 문자열 중에 아래조건에 맞는 문자가 하나라도 존재하면 true로 
			//변경해준다.
			
			//대문자인지 확인
			if(inputVal[i].charCodeAt(0)>=65 && inputVal[i].charCodeAt(0)<=90){
				strUpper = true;
			}
			//소문자인지 확인
			if(inputVal[i].charCodeAt(0)>=97 && inputVal[i].charCodeAt(0)<=122){
				strLower = true;
			}
			//숫자인지 확인
			if(inputVal[i].charCodeAt(0)>=48 && inputVal[i].charCodeAt(0)<=57){
				strNumber = true;
			}			
		}
		
		//조건에 맞는 부분에 빨간색으로 변경해준다.
		//대문자 컨펌
		if(strUpper==true)			
			$('#confirm1').css({'color':'red','fontSize':'22px','fontWeight':'bold'});
		else
			$('#confirm1').css({'color':'gray','fontSize':'20px','fontWeight':'normal'});
		
		//소문자 컨펌
		if(strLower==true)			
			$('#confirm2').css({'color':'red','fontSize':'22px','fontWeight':'bold'});
		else
			$('#confirm2').css({'color':'gray','fontSize':'20px','fontWeight':'normal'});
		
		//숫자 컨펌
		if(strNumber==true)			
			$('#confirm3').css({'color':'red','fontSize':'22px','fontWeight':'bold'});
		else
			$('#confirm3').css({'color':'gray','fontSize':'20px','fontWeight':'normal'});
	});
	
	//패스워드 확인을 입력한 후 키보드를 땠을때 검증한다.
	$('#passwd2').keyup(function(){
		//패스워드입력과 확인 부분의 입력된값을 가져온다. 
		var p1 = $('#passwd1').val();
		var p2 = $(this).val();
		//2개의 값이 일치하는지 확인하여 텍스트를 출력한다. 
		if(p1==p2){
			$('#passConfirm').html('패스워드가 일치합니다.').css('color','red');
		}
		else{
			$('#passConfirm').html('패스워드가 틀렸습니다.').css('color','black');
		}
	});
});


function formValidate(){
	//alert("버튼클릭");
	var form = document.getElementById("joinForm");
	if(form.userID.value  == "" ){
		alert("아이디를 입력하세요");
		form.userID.focus();
		return false;
	}
	if(form.userPassword1.value  == "" ){
		alert("비밀번호1를 입력하세요");
		form.userPassword1.focus();
		return false;
	}
	if(form.userPassword2.value  == "" ){
		alert("비밀번호2를 입력하세요");
		form.userPassword2.focus();
		return false;
	}
	
	 
	if(form.userName.value  == "" ){
		alert("이름을 입력하세요");
		form.userName.focus();
		return false;
	}
	if(form.userGender.value  == "" ){
		alert("성별을 체크하세요");
		form.userGender.focus();
		return false;
	}
	if(form.userPhone1.value  == "" ){
		alert("전화번호를 입력하세요");
		form.userPhone1.focus();
		return false;
	}
	if(form.userPhone2.value  == "" ){
		alert("전화번호를 입력하세요");
		form.userPhone2.focus();
		return false;
	}
	if(form.userPhone3.value  == "" ){
		alert("전화번호를 입력하세요");
		form.userPhone3.focus();
		return false;
	}
	if(form.userEmail1.value  == "" ){
		alert("이메일을 입력하세요");
		form.userEmail1.focus();
		return false;
	}
	
	if(form.userEmail2.value  == "" ){
		alert("도메인을 선택해주세요");
		form.userEmail2.focus();
		return false;
	}
	
	form.submit();

}


$(function(){
    $('#selectEmail').change(function(){
        //select에서 선택한 option의 value를 가져올때
        //아래 두가지 방법 모두 사용할 수 있다.
        console.log("선택한값", $(this).val(),
            $('#selectEmail option:selected').val());

        var value = $(this).val();
        if(value=='direct'){
            //직접입력을 선택하면 readonly속성을 활성화한다.
            $('#email2').attr('readonly', false);
            $('#email2').val('');

        }
        else{
            //도메인을 선택하면 readonly속성을 비활성화한다.
            $('#email2').attr('readonly', true);
            //선택한 값을 입력해준다.
            $('#email2').val(value);

        }
    });


});


</script>


<style>
#wrap{
	display : flex;
	
}
#phone{
	display : flex;
}

#email{
	display:flex;
}

#chk{
	width:75px;
	height:34px;
	border-radius: 5px;
	border : solid 1px;
	background-color : #337AB7;
	font-weight : bold;
}

</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <nav class ="navbar navbar-default">
        <div class="navbar-header"> 
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
            </button>
            <a class ="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <li><a href="Board.jsp">게시판</a></li>
                <li><a href="FileBoard.jsp">파일업로드게시판</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" 
                    aria-haspopup="true"
                    aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li class="active"><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>                    
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
    
    <div class="container">
        <div class="col-lg-4"></div>
        <div class="col-lg-4">
            <div class ="jumbotron" style="padding-top:20px; width:500px;">
                <form method = "post" name="fr" id="joinForm" action="joinAction.jsp" style="width:380px;"> <!-- joinAction 페이지로 화면 넘기기 -->
                    <h3 style="text-align:center;">회원가입 화면</h3>
                    <div id="wrap">
                       <div>
                       <input type ="text" class="form-control" placeholder="아이디" name ="userID" maxlength='20' style = width:300px;>
                       </div>
                        <div style="margin-left:5px;">
                        <input type="button" id="chk" value="중복확인" name="userIDChk" onclick="winopen()"
                        style="width:70px; font-weigh:bold"></div>
                    </div>
                    <br>
                    
                    <div class ="form-group" style="margin-top:5px; margin-bottom:0px;">
                        <input type ="password" class="form-control" placeholder="비밀번호" name ="userPassword1" id="passwd1" maxlength='20'>
                    </div>
                    
                    <div style="padding-left:5px; margin-bottom:20px;">
						<span id="confirm1" class="confirmChar">√</span>대문자
						<span id="confirm2" class="confirmChar">√</span>소문자
						<span id="confirm3" class="confirmChar">√</span>숫자
						<span id="confirm4" class="confirmChar">√</span>8자이상
					</div> 
                    
                    <div class ="form-group" style="margin-bottom:7px;">
                        <input type ="password" class="form-control" placeholder="비밀번호확인" name ="userPassword2" id="passwd2" maxlength='20'>
                    </div>
                    
                    <div id="passConfirm" style="padding-left:5px;"></div>
                    <br>
                    <div class ="form-group" style="margin-top:5px;">
                        <input type ="text" class="form-control" placeholder="이름" name ="userName" maxlength='20'>
                    </div>
                    <div class ="form-group" style="text-align: center;">
                    	<div class ="btn-group" cata-toggle="buttons">
                    		<label class ="btn btn-primary active"> <!-- 버튼 활성화 -->
                    			<input type ="radio" name ="userGender" autocomplete ="off" value = "남자" >남자</label>
                    		<label class ="btn btn-primary"> <!-- 버튼 활성화 NO -->
                    			<input type ="radio" name ="userGender" autocomplete ="off" value = "여자" >여자</label>
                    	</div>         		
                    </div>
                    <div id="phone">
                        <div style="width:30%;"><input type ="text" class="form-control" placeholder="010" name ="userPhone1" id="tel1"  size="3" onkeyup="commonFocusMove('tel1', '3', 'tel2');" maxlength="3"></div><span style="margin-top:6px;">-</span>
                        <div style="width:35%;"><input type ="text" class="form-control" placeholder="번호를" name ="userPhone2" id="tel2" size="4" onkeyup="commonFocusMove('tel2', '4', 'tel3');" maxlength="4"></div><span style="margin-top:6px;">-</span>
                        <div style="width:35%;"><input type ="text" class="form-control" placeholder="입력하세요" name ="userPhone3" maxlength='4' id="tel3" onkeyup="commonFocusMove('tel3', '4', 'email1');" maxlength="4"></div>
                    </div>
                    <br>
                    <div class ="form-group" id="email">
                        <input type ="text" class="form-control" placeholder="이메일" name ="userEmail1" id="email1" maxlength='30'
                        style="width:30%;"><span style="margin-top:6px;">@</span>
                        <input type=text class="form-control" id="email2" style="width:35%;" readonly/>
                        &nbsp;&nbsp;
                        	<select id="selectEmail" style="width:35%;" class="form-control" name="userEmail2">
                        		<option value="">--선택--</option>
                        		<option value="direct">직접입력</option>
                        		<option value="naver.com">네이버</option>
                        		<option value="hanmail.net">다음(한메일)</option>
                        		<option value="gmail.com">구글(gmail)</option>
                        		
                        	</select>
                        	
                    </div>
                    <input type="button" class="btn btn-primary form-control" value="회원가입"  onclick="formValidate();">
                </form>
            </div> 
        </div> 
        <div class="col-lg-4"></div>
    </div>
    
    
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>