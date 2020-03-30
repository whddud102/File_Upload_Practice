<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img {
		width: 100px;
	}
	
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background:rgb(255, 255, 255, 0.5); 
	}
	
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img {
	width: 600px;
	}
</style>

</head>
<body>



	<h1>Upload with Ajax</h1>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple="multiple">
	</div>
	<button id="uploadBtn">업로드</button>
	
	
	<div class="uploadResult">
		<ul>
			<!-- 업로드된 파일들의 목록 리스트 -->
		</ul>
	</div>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
			<!-- 원본 이미지가 출력될 화면 -->
		</div>
	</div>
	

	<!-- jQuery 라이브러리를 불러오는 코드, min.js는 jQuery의 사용자용 압축 버전을 의미 -->
	<!--  요즘은 모바일 환경을 생각해서 파일 용량이 작은 min.js를 더 많이 사용 -->
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"
		integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
		crossorigin="anonymous">
		
	</script>

<script type="text/javascript">
	function showImage(fileCallPath) {
		//alert(fileCallPath);
		// display 속성 값을 flex로 수정
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture").html("<img src='/display?fileName=" + encodeURI(fileCallPath) + "'>").animate({width: "100%", height: "100%"}, 1000);
	}
</script>

	<script type="text/javascript">
		$(document).ready(function() {
			
			// 업로드 파일의 크기와 확장자를 제한			
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880;	// 5MB
			
			
			function checkExtension(fileName, fileSize) {
				
				if(fileSize >= maxSize) {
					alert("업로드 가능 파일 사이즈 초과 : " + fileName);
					return false;
				}
				
				if(regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드 할 수 없습니다 : " + fileName);
					return false;
				}
				
				return true;
			}
			
			
			// 비어있는 상태의 uploadDiv를 복사
			var cloneObj = $(".uploadDiv").clone();
			
			$("#uploadBtn").on("click", function(e) {
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				// 업로드 파일들의 리스트를 얻어옴
				var files = inputFile[0].files;

				console.log(files);
				
				// add fildedata to formdata
				for(var i = 0; i < files.length; i++) {
					if(!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					
					formData.append("uploadFile", files[i]);
					
					// 파일 업로드 요청 후, 비어있는 uploadDiv로 다시 초기화
				}
				
				
				$.ajax({
					URL: "/uploadAjax",
					type: "POST",
					processData : false,
					contentType : false,
					data : formData,
					dataType : 'json',
					success : function (result) {
						alert("업로드 성공");
						console.log(result);
						
						showUploadedFile(result);
						
						$(".uploadDiv").html(cloneObj.html());
						
					}
				});
			});
			
			
			// uploadResult 클래스의 ul 태그에 접근
			var uploadResult = $(".uploadResult ul");
			
			// 업로드된 파일의 이름들을 리스트로 보여주는 함수
			// param : 업로드된 파일들의 json 정보가 담긴 리스트		
			function showUploadedFile(uploadResultArr) {
				
				var str = "";
				
				$(uploadResultArr).each(function(i, obj) {
					
					// 일반 파일인 경우
					if(!obj.image) {
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						str += "<li><a href='/download?fileName=" + fileCallPath + "'><img src='/resources/img/attach.png'>" + obj.fileName + "</a>" 
								+ "<span data-file=\'" + fileCallPath + "\' data-type = 'file'> 삭제 </span></li>";						
					} 
					// 이미지 파일인 경우
					else {
						// str += "<li>" + obj.fileName + "</li>";
						
						// 한글이나 공백등을 url 호출에 적합한 문자열로 변환
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
						var orignPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
						
						orignPath = orignPath.replace(new RegExp(/\\/g), "/");
						
						// 썸네일에 원본 이미지를 표시하는 자바스크립트의 링크를 걸어둠
						str += "<li><a href=\"javascript:showImage(\'" + orignPath + "\')\"><img src='/display?fileName=" + fileCallPath + "'></a>"
								+ "<span data-file=\'" + fileCallPath + "\' data-type = 'image'> 삭제 </span></li>";
					}
				})
				
				
				console.log(str);
				uploadResult.append(str);
			}
			
			$(".bigPictureWrapper").on("click", function(e) {
				// 1초에 걸려서 width, height를 축소
				$(".bigPicture").animate({width: "0%", height: "0%"}, 1000);
				setTimeout(function() {
					$('.bigPictureWrapper').hide();
				}, 1000)
			})
			
		
		$(".uploadResult").on("click", "span", function (e) {
			// 삭제 하려는 파일의 data-file 속성 값 획득
			var targetFile = $(this).data("file");
			
			// 삭제 하려는 파일의 data-type 속성 값 획득
			var type = $(this).data("type");
			
			console.log(targetFile);
			
			$.ajax({
				url: "/deleteFile",
				data: {fileName : targetFile, type: type},
				dataType: "text",
				type: "POST",
					success: function (result) {
						alert("첨부파일 삭제 요청 성공");
					}
			});
		})			
			
		});
	</script>

</body>
</html>