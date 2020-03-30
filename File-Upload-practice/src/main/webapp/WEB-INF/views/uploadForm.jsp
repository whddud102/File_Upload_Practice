<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-type"  content="text/html; charset=UTF-8" >
<title>파일 업로드 연습</title>
</head>
<body>
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
		<input type="file" name="uploadFile"  multiple >
		
		<button>업로드</button>
	</form>
</body>
</html>