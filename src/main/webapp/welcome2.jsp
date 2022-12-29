<!DOCTYPE html>
<html>
<!-- 
시청
var mapOptions = {
    center: new naver.maps.LatLng(37.3595704, 127.105399),
    zoom: 10
};

학원 37.563398 경도 126.9863309

 -->
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>간단한 지도 표시하기</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=z2sab8bj2c"></script>
</head>
<body>
<div class="container">
    <div id="map" style="width:100%;height:600px;margin:0 auto;"></div>
</div>
<script>


var mapOptions = {
	    center: new naver.maps.LatLng(37.563398, 126.9863309),
	    zoom: 15
	};
var map = new naver.maps.Map('map', mapOptions);


		

</script>
</body>
</html>