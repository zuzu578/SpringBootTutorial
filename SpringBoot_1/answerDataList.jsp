<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="seed.utils.SeedProperties"%>
<%@ page import="seed.utils.SeedUtils"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%--context 설정 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!doctype html>
<html lang="ko">
	<head>
	<title><c:out escapeXml='true' value='${siteMenuTitle}'/> <s:message code="common.list.title"/></title>
	<link href="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/navigation/css/navigation.css" rel="stylesheet" type="text/css"/>
		
	<c:if test='${siteMenuCharge == "Y"}'>
	<link href="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/charge/css/charge.css" rel="stylesheet" type="text/css"/>
	</c:if>

	<c:if test='${siteMenuSatisfaction == "Y"}'>
	<link href="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/satisfaction/css/satisfaction.css" rel="stylesheet" type="text/css"/>
	</c:if>

	<c:choose>
	<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
	<link href="${ctx }/css/user/bbs/bbs.css" rel="stylesheet" type="text/css"/>
	</c:when>
	<c:otherwise>
	<link href="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_css/skin_<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />.css?scver=0509" rel="stylesheet" type="text/css"/>
	</c:otherwise>
	</c:choose>

	<c:import url="/common/jsPage/sub.do"></c:import>
	<script>
	/* <![CDATA[ */
	            
	//2021-05-06 주환 수정 : checkBox click 시 checkBox 모두 체크되도록 수정 	
		function checkAll()
		{
			var checkStatus = $('input:checkbox[name="idxs"]').is(':checked');
			if(checkStatus == false)
				{
				$('input:checkbox[name="idxs"]').prop("checked",true);
				}
			if(checkStatus == true)
				{
				$('input:checkbox[name="idxs"]').prop("checked",false);
				}
		}
		 

    $(document).ready(function(){
	    	
		if($("#column option:selected").val() == "bbsDataRegDate"){
			$("#searchDate").show();
			$("#search").hide();
		}else{
			$("#searchDate").hide();
			$("#search").show();
		}
		
		$("#dataCopy").click(function(){
			$("#dataCMType").val("C");
		});
		
		$("#dataMove").click(function(){
			$("#dataCMType").val("M");
		});
	
		$("#frmData").submit(function(){
			
			if(!$('input:checkbox[name="idxs"]').is(":checked")){
				alert("<s:message code="common.message.no.check"/>");
				return false;
			}
			
			if($("#selDataCM option:selected").val() == ""){
				alert("<s:message code="common.message.no.select"/>");
				$("#selDataCM").focus();
				return false;
			}
			
			var dataIdxs = "";
	
			$('input:checkbox[name="idxs"]:checked').each(function(){
				dataIdxs += $(this).val()+",";
			});
	
			if(dataIdxs != ""){
				dataIdxs = dataIdxs.substring(0, dataIdxs.length-1);
				$("#dataIdxs").val(dataIdxs);
			}
			
			$.blockUI({ message : '<h1><img src="${ctx }/img/blockbusy.gif" />&nbsp;&nbsp;<s:message code="common.message.ajaxwait"/></h1>' });
		});	
			
		$("#frm").submit(function(){
			
			if(!confirm("<s:message code='common.message.bbs.confirm.dels'/>")){
				return false;
			}
				
			if(!$('input:checkbox[name="idxs"]').is(":checked")){
				alert("<s:message code="common.message.no.check"/>");
				return false;
			}
				
			$.blockUI({ message : '<h1><img src="${ctx }/img/blockbusy.gif" />&nbsp;&nbsp;<s:message code="common.message.ajaxwait"/></h1>' });
		});
		
		$("#frmSearch").submit(function(){
			
			// 특수 문자 모음 
			var num = "{}[]()<>?|`~'!@#$%^&*-+=,.;:\"'\\/";
			var specialCheck = false;
	
			for (var i = 0;i < $("#search").val().length;i++){
				if(num.indexOf($("#search").val().charAt(i)) != -1){
					specialCheck = true;
					break;
				}
			}
	
			if(specialCheck && $("#column option:selected").val() != "bbsDataRegDate"){ 
				alert("<s:message code="common.message.no.specialkey"/>");
				return false;
			}
			
			if($("#column").val() == "bbsDataRegDate"){
				var dateChk = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
				
			    if (!dateChk.test($("#searchSDate").val()) || !dateChk.test($("#searchEDate").val()) ){
			        alert("작성일의 날짜는 YYYY-MM-DD 형식으로 입력해주세요.");
			        return false;
			    }
			    
			    if(new Date($("#searchSDate").val()) > new Date($("#searchEDate").val())) {
			    	alert("작성일 시작일자가 종료일자보다 이후일자 입니다.");
			        return false;
			    }
			}
		});
		
		$("#column").change(function(){
			if($(this).val() == "bbsDataRegDate"){
				$("#searchDate").show();
				$("#search").hide();
				$("#searchSDate").val();
				$("#searchEDate").val();
				$("#search").val();				
			}else{
				$("#searchDate").hide();
				$("#search").show();
				$("#searchSDate").val();
				$("#searchEDate").val();
				$("#search").val();
			}
		});
	
		$("#bbsCategory1").change(function(){
	
			if($("#bbsCategory1").val() != undefined && $("#bbsCategory1").val() != "undefined" && $("#bbsCategory1").val() != ""){
				$("#bbsDataCategory").val($("#bbsCategory1").val());
			}else{
				$("#bbsDataCategory").val("");
			}
	
			$("#bbsCategory2").empty();
			$("#bbsCategory2").append("<option value=''><s:message code="common.select.option.value"/></option>");
			$("#bbsCategory3").empty();
			$("#bbsCategory3").append("<option value=''><s:message code="common.select.option.value"/></option>");
			$("#bbsCategory4").empty();
			$("#bbsCategory4").append("<option value=''><s:message code="common.select.option.value"/></option>");
			$("#bbsCategory5").empty();
			$("#bbsCategory5").append("<option value=''><s:message code="common.select.option.value"/></option>");
	
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 2}'>
				if($(this).val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){					
					$("#bbsCategory2").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				</c:if>
			</c:forEach>
	
		});
	
		$("#bbsCategory2").change(function(){
	
			if($("#bbsCategory2").val() != undefined && $("#bbsCategory2").val() != "undefined" && $("#bbsCategory2").val() != ""){
				$("#bbsDataCategory").val($("#bbsCategory2").val());
			}else{
				$("#bbsDataCategory").val($("#bbsCategory1").val());
			}
	
			$("#bbsCategory3").empty();
			$("#bbsCategory3").append("<option value=''><s:message code="common.select.option.value"/></option>");
			$("#bbsCategory4").empty();
			$("#bbsCategory4").append("<option value=''><s:message code="common.select.option.value"/></option>");
			$("#bbsCategory5").empty();
			$("#bbsCategory5").append("<option value=''><s:message code="common.select.option.value"/></option>");
	
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 3}'>
				if($(this).val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){					
					$("#bbsCategory3").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				</c:if>
			</c:forEach>
	
		});
	
		$("#bbsCategory3").change(function(){
	
			if($("#bbsCategory3").val() != undefined && $("#bbsCategory3").val() != "undefined" && $("#bbsCategory3").val() != ""){
				$("#bbsDataCategory").val($("#bbsCategory3").val());
			}else{
				$("#bbsDataCategory").val($("#bbsCategory2").val());
			}
	
			$("#bbsCategory4").empty();
			$("#bbsCategory4").append("<option value=''><s:message code="common.select.option.value"/></option>");
			$("#bbsCategory5").empty();
			$("#bbsCategory5").append("<option value=''><s:message code="common.select.option.value"/></option>");
	
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 4}'>
				if($(this).val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){					
					$("#bbsCategory4").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				</c:if>
			</c:forEach>
	
		});
	
		$("#bbsCategory4").change(function(){
	
			if($("#bbsCategory4").val() != undefined && $("#bbsCategory4").val() != "undefined" && $("#bbsCategory4").val() != ""){
				$("#bbsDataCategory").val($("#bbsCategory4").val());
			}else{
				$("#bbsDataCategory").val($("#bbsCategory3").val());
			}
	
			$("#bbsCategory5").empty();
			$("#bbsCategory5").append("<option value=''><s:message code="common.select.option.value"/></option>");
	
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 5}'>
				if($(this).val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){					
					$("#bbsCategory5").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				</c:if>
			</c:forEach>
	
		});
	
		$("#bbsCategory5").change(function(){
	
			if($("#bbsCategory5").val() != undefined && $("#bbsCategory5").val() != "undefined" && $("#bbsCategory5").val() != ""){
				$("#bbsDataCategory").val($("#bbsCategory5").val());
			}else{
				$("#bbsDataCategory").val($("#bbsCategory4").val());
			}
		});
	
		var bbsDataCategory = "<c:out escapeXml='true' value='${bbsDataCategory}' />";
	
		var bbsCategoryParentIdxs = "";
		
		var tmpCategoryIdx = "0000000000";
	
		var check = 10;
		
		for(var i=0; i<5; i++){
			
			check = check - 2;
			
			tmpCategoryIdx = tmpCategoryIdx.substring(0, check);
			
			bbsCategoryParentIdxs = bbsDataCategory.substring(0, ((i*2)+2)) + tmpCategoryIdx;
						
			if(i == 0){
				$("#bbsCategory1").val(bbsCategoryParentIdxs);
				$("#bbsCategory1 > option[value='"+bbsCategoryParentIdxs+"']").attr("selected", "selected");
			}
			
			if(i == 1){
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 2}'>
				if($("#bbsCategory1").val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){
					$("#bbsCategory2").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				$("#bbsCategory2").val(bbsCategoryParentIdxs);
				$("#bbsCategory2 > option[value='"+bbsCategoryParentIdxs+"']").attr("selected", "selected");
				</c:if>
			</c:forEach>
			}
	
			if(i == 2){
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 3}'>
				if($("#bbsCategory2").val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){
					$("#bbsCategory3").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				$("#bbsCategory3").val(bbsCategoryParentIdxs);
				$("#bbsCategory3 > option[value='"+bbsCategoryParentIdxs+"']").attr("selected", "selected");
				</c:if>
			</c:forEach>
			}
	
			if(i == 3){
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 4}'>
				if($("#bbsCategory3").val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){
					$("#bbsCategory4").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				$("#bbsCategory4").val(bbsCategoryParentIdxs);
				$("#bbsCategory4 > option[value='"+bbsCategoryParentIdxs+"']").attr("selected", "selected");
				</c:if>
			</c:forEach>
			}
	
			if(i == 4){
			<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
				<c:if test='${bbsCategoryList._bbsCategoryDepth == 5}'>
				if($("#bbsCategory4").val() == "<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryParentIdx}' />"){
					$("#bbsCategory5").append("<option value='<c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryIdxs}' />'><c:out escapeXml='true' value='${bbsCategoryList._bbsCategoryName}' /></option>");
				}
				$("#bbsCategory5").val(bbsCategoryParentIdxs);
				$("#bbsCategory5 > option[value='"+bbsCategoryParentIdxs+"']").attr("selected", "selected");
				</c:if>
			</c:forEach>
			}
		}
		
    });
	
    
	/* ]]> */
	</script>
	
	<style type="text/css">
	input.date-input	{cursor:text;}
	input::placeholder	{color:#aaa; font-size:13px; cursor:text;}
	button.btn_datePicker {background-color:#fff;}
	</style>
	
	</head>
	
	<body>
	
	<c:import url="/${siteIdx}/sub/header/layOut.do"></c:import>
	
	<c:import url="/${siteIdx}/sub/sub/layOut.do"></c:import>

	<c:if test='${memberAuthM || memberGrant == "S"}'>
	<div class="seedLayOutBtn"><a href="${ctx }/gtm/<c:out escapeXml='true' value='${siteIdx}'/>/siteLayOutSet.do?siteLayOutType=sub#siteLayOutSet" id="layOutEdit"><s:message code="common.button.layOut.edit"/></a></div>
	</c:if>
	
	<c:if test='${siteMenuSNS == "Y"}'>
	<c:import url="/common/sns/${siteIdx}/${siteMenuIdx}.do"></c:import>
	</c:if>

	<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
	<div class="seedFunctionBtn"><a href="${ctx }/gtm/<c:out escapeXml='true' value='${siteIdx}' />/bbsSetEdit/<c:out escapeXml='true' value='${bbsSetIdx}' />.do#bbsSetList" id="managerPop"><s:message code="user.bbs.button.manager"/></a></div>
	</c:if>
		<!-- 경로 표시 -->
	<div class="nc-route-wrap">
		<div class="nc-route-inner">
			<div id="nc-route">
				<span>HOME</span> <span>알림</span><span>묻고 답하기</span>
			</div>
		</div>
	</div>
	<!-- 경로 표시 끝 -->
	<div class="nc-inner">
		<section class="nc-side-nav-wrap">
			<h2 class="hidden">사이드 메뉴</h2>
			<div class="nc-side-current">알림</div>
			<ul id="side-nav">
				<li class="depth-1"><a href='/nsk/user/bbs/ntcc/21/102/bbsDataList.do' title='공지사항 ' data-url='/nsk/user/bbs/ntcc/21/102/bbsDataList.do'  data-seed='ntcc_06010000000000000000' data-auth='N,Y,Y,Y,Y' >공지사항</a></li>
				<!-- 'depth-2'가 존재할 시 'depth-1' 클래스명에 'more-depth' 추가 -->
				<li class="depth-1"><a href='/nsk/user/bbs/ntcc/22/103/bbsDataList.do' title='보도자료 ' data-url='/nsk/user/bbs/ntcc/22/103/bbsDataList.do'  data-seed='ntcc_06020000000000000000' data-auth='N,Y,Y,Y,Y' >보도자료</a></li>
				<li class="depth-1"><a href='/nsk/user/bbs/ntcc/221/104/bbsDataList.do' title='이벤트 ' data-url='/nsk/user/bbs/ntcc/221/104/bbsDataList.do'  data-seed='ntcc_06030000000000000000' data-auth='N,Y,Y,Y,Y' >이벤트</a></li>
				<li class="depth-1"><a href='/nsk/user/extra/ntcc/105/announce/oftenQuestion/jsp/LayOutPage.do?categoryVal=01' title='자주하는 질문 ' data-url='/nsk/user/extra/ntcc/105/announce/oftenQuestion/jsp/LayOutPage.do?categoryVal=01'  data-seed='ntcc_06040000000000000000' data-auth='N,Y,Y,Y,Y' >자주하는 질문</a></li>
				<li class="depth-1 on"><a href='/nsk/user/bbs/ntcc/241/106/bbsDataList.do' title='묻고 답하기 ' data-url='/nsk/user/bbs/ntcc/241/106/bbsDataList.do'  data-seed='ntcc_06050000000000000000' data-auth='N,Y,Y,Y,Y' >묻고 답하기</a></li>
			</ul>
		</section>
		<section class="nc-content">
	<div class="seed_bbs_box">
	<h2 class="main-title">묻고 답하기</h2>
	<c:out escapeXml='false' value='${tBbsSetDB.bbsSetTHtml}' />

	<c:choose>
	<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || tBbsAuthDB.bbsAuthList == "Y"}'>
	<div class="totalCnt_bbsSearch seed_cf">
		<p class="totalCnt"><s:message code="common.all"/> ${fn:length(bbsNoticeDataList) + bbsDataCnt}<s:message code="common.all.count"/>, <c:out escapeXml='true' value='${page}' />/<c:out escapeXml='true' value='${lPage}' /> <s:message code="common.page"/></p>
		<div class="bbsSearch">
			<form:form name="frmSearch" id="frmSearch" method="post" action="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataList.do">
				<fieldset class="seed_cf">
					<legend><s:message code='common.fieldset.legend'/></legend>
					<input type="hidden" name="page" value="1" />
					<input type="hidden" name="tSite.siteIdx" value="<c:out escapeXml='true' value='${siteIdx}' />" />
					<input type="hidden" name="tBbsSet.bbsSetIdx" value="<c:out escapeXml='true' value='${bbsSetIdx}' />" />
					<input type="hidden" name="bbsDataCategory" id="bbsDataCategory" value="<c:out escapeXml='true' value='${bbsDataCategory}' />" />

					<c:set var="categoryChk" value="N" />
					<c:set var="categoryName" value="" />
					<c:set var="categoryLoop" value="false" />
											
					<c:forEach items="${bbsItemList}" var="bbsItemList" varStatus="status">
						<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemSearch == "Y" && bbsItemList._bbsItemPattern == "CATEGORY" && not doneLoop}'>
							<c:set var="categoryChk" value="Y" />
							<c:set var="categoryName" value='${bbsItemList._bbsItemName}' />
							<c:set var="categoryLoop" value="true" />
						</c:if>
					</c:forEach>
					
					<c:if test='${categoryChk == "Y"}'>
						<c:set var="categoryDepth" value="0"/>
						<c:set var="categoryCnt" value="0"/>
						<c:set var="categoryOption" value=""/>
						<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
							<c:if test='${bbsCategoryList._bbsCategoryDepth != categoryDepth}'>
								<c:set var="categoryCnt" value='${categoryCnt+1}' />
							</c:if>
							<c:if test='${bbsCategoryList._bbsCategoryDepth == "1"}'>
								<c:set var="categoryOption" value="${categoryOption}<option value='${bbsCategoryList._bbsCategoryIdxs}'>${bbsCategoryList._bbsCategoryName}</option>"/>
							</c:if>
							<c:set var="categoryDepth" value="${bbsCategoryList._bbsCategoryDepth}" />
						</c:forEach>
						
						<label for="bbsCategory1" class="wa">${categoryName} <s:message code="common.select.option.value"/></label>
	
						<c:forEach begin="1" end="${categoryCnt}" step="1" varStatus="status">
							<select name="bbsCategory${status.index}" id="bbsCategory${status.index}" class="seed_fl">
								<option value=""><s:message code="common.select.option.value"/></option>
								<c:if test='${status.index == 1}'>
								<c:out escapeXml='false' value='${categoryOption}' />
								</c:if>
							</select>
						</c:forEach>
					</c:if>  
					
					<label for="column" class="wa">검색 조건 선택</label>
					<select name="column" id="column" class="seed_fl">
						<option value="bbsDataTitle">제목</option>
					</select>
					
					
		            <%--<span id="searchDate">
		            <!-- 
					<input type="text" class="seed_fl datepicker" name="searchSDate" id="searchSDate" value="<c:out escapeXml='true' value='${searchSDate}' />" title="<s:message code="user.bbs.bbsDataNoticeSdate"/>" readonly  />
					<span class="dash">~</span>
					<input type="text" class="seed_fl datepicker" name="searchEDate" id="searchEDate" value="<c:out escapeXml='true' value='${searchEDate}' />" title="<s:message code="user.bbs.bbsDataNoticeEdate"/>" readonly  />
					 -->
					<input type="text" class="seed_fl date-input numHyphenOnly" name="searchSDate" id="searchSDate" value="<c:out escapeXml='true' value='${searchSDate}' />" placeholder="2020-01-01" title="<s:message code="user.bbs.bbsDataNoticeSdate"/>" />
					<button type="button" class="seed_fl btn_datePicker" id="btn_sDate"><img src="${ctx }/site/ntcc/images/common/icon_cal.png" alt="시작 작성일 선택" width="30px" height="30px"></button>
					<span class="dash seed_fl">~</span>
					<input type="text" class="seed_fl date-input numHyphenOnly" name="searchEDate" id="searchEDate" value="<c:out escapeXml='true' value='${searchEDate}' />" placeholder="2020-01-01" title="<s:message code="user.bbs.bbsDataNoticeEdate"/>" />
					<button type="button" class="seed_fl btn_datePicker" id="btn_eDate"><img src="${ctx }/site/ntcc/images/common/icon_cal.png" alt="종료 작성일 선택" width="30px" height="30px"></button>
					</span>--%>
					
					<label for="search" class="wa"><s:message code='common.search.value'/></label>
					<input type="text" name="search" id="search" value="<c:out escapeXml='true' value='${search}' />" class="specialKeyNot seed_fl">
					<input type="submit" value="<s:message code="user.bbs.button.search"/>" class="seed_fl search" />
				</fieldset>
			</form:form>
		</div>
	</div>
	
	<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
	<div class="postFunc">
		<form:form name="frmData" id="frmData" action="${ctx }/user/bbs/proc/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataCMProc.do" method="post">
			<input type="hidden" name="page" value="<c:out escapeXml='true' value='${page}' />" />
			<input type="hidden" name="column" value="<c:out escapeXml='true' value='${column}' />" />
			<input type="hidden" name="search" value="<c:out escapeXml='true' value='${search}' />" />
			<input type="hidden" name="bbsDataCategory" value="<c:out escapeXml='true' value='${bbsDataCategory}' />" />
			<input type="hidden" name="searchSDate" value="<c:out escapeXml='true' value='${searchSDate}' />" />
			<input type="hidden" name="searchEDate" value="<c:out escapeXml='true' value='${searchEDate}' />" />
			<input type="hidden" name="dataCMType" id="dataCMType" value="" />
			<input type="hidden" name="dataIdxs" id="dataIdxs" value="" />
			<fieldset>
				<legend><s:message code="common.message.choice"/> <s:message code="common.button.copy"/></legend>
				<label for="selDataCM"><s:message code="common.message.choice"/></label>
				<select name="selDataCM" id="selDataCM" title="">
					<option value=""><s:message code="common.select.option.value"/></option>
					<c:forEach items="${bbsSetTypeList}" var="bbsSetTypeList" varStatus="status">
						<option value="<c:out escapeXml='true' value='${bbsSetTypeList._bbsSetIdx}' />"><c:out escapeXml='true' value='${bbsSetTypeList._bbsSetName}' /></option>
					</c:forEach>
				</select>
				<input type="submit" id="dataCopy" value="<s:message code="common.button.copy"/>" class="copy" />
			
				<!-- 
				<c:choose>
				<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
				<input type="image" id="dataMove" src="${ctx }/img/user/bbs/btn_move.gif" alt="<s:message code="common.button.move"/>" />
				</c:when>
				<c:otherwise>
				<input type="image" id="dataMove" src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/btn_move.gif" alt="<s:message code="common.button.move"/>" />
				</c:otherwise>
				</c:choose>
				-->	
			</fieldset>
		</form:form>
	</div>
	</c:if>
    
	<div class="listWrap default bbsList_<c:out escapeXml='true' value='${bbsSetIdx}'/>">
			<!--  input type ="hidden -->
		<form:form name="frm" id="frm" method="post" action="${ctx }/user/bbs/proc/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataStatusProc.do">
			<input type="hidden" name="tSite.siteIdx" value="<c:out escapeXml='true' value='${siteIdx}' />" />
			<input type="hidden" name="tBbsSet.bbsSetIdx" value="<c:out escapeXml='true' value='${bbsSetIdx}' />" />
			<input type="hidden" name="page" value="<c:out escapeXml='true' value='${page}' />" />			
			<input type="hidden" name="column" value="<c:out escapeXml='true' value='${column}' />" />
			<input type="hidden" name="search" value="<c:out escapeXml='true' value='${search}' />" />
			<input type="hidden" name="bbsDataCategory" value="<c:out escapeXml='true' value='${bbsDataCategory}' />" />
			<input type="hidden" name="searchSDate" value="<c:out escapeXml='true' value='${searchSDate}' />" />
			<input type="hidden" name="searchEDate" value="<c:out escapeXml='true' value='${searchEDate}' />" />
			
			<c:set var="colspan" value="0" />
			
			<fieldset>
				<legend>답변게시판 리스트</legend>
				<div class="seed_tbl">
					<table>
						<caption><%-- <c:out escapeXml='true' value='${tBbsSetDB.bbsSetName}'/> 게시판의 <c:forEach items="${bbsItemList}" var="bbsItemList" varStatus="status"><c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'><c:if test='${status.index > 0}'>, </c:if><c:out escapeXml='true' value='${bbsItemList._bbsItemName}' /></c:if></c:forEach> <s:message code="common.list.caption"/> --%>묻고 답하기 게시판의 게시물 목록입니다. 번호, 제목, 작성자, 작성일, 답변상태 등으로 구성되어있습니다.</caption>
						<colgroup>
							<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
							<col style="width: 30px;" class="small_checkbox" />
							<c:set var="colspan" value='${colspan+1}' />
							</c:if>
							<c:forEach items="${bbsItemList}" var="bbsItemList">
							<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'>
							<c:choose>
								<c:when test='${bbsItemList._bbsItemColWidth == "0"}'>
								<col <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>class="activeHidden"</c:if> style="width: auto;" />
								</c:when>
								<c:otherwise>
								<col <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>class="activeHidden"</c:if> style="width: <c:out escapeXml='true' value='${bbsItemList._bbsItemColWidth}' />;" />
								</c:otherwise>
							</c:choose>
							<c:set var="colspan" value='${colspan+1}' />
							</c:if>
							</c:forEach>
						</colgroup>
						<thead>
						<!--  타이틀 제목 (번호 , 제목 , 작성일 , 진행상황 ) -->
						<tr>
							<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
							<th scope="col"><input type="checkbox" onclick="checkAll()" name="allcheck" id="allcheck"  /></th>
							</c:if>
							<c:forEach items="${bbsItemList}" var="bbsItemList" varStatus="status">
							<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y" }'>
							<th scope="col" z><c:out escapeXml='true' value='${bbsItemList._bbsItemName}' /></th>
							</c:if>
							
							
							
							
							
							</c:forEach>
							<!-- 2021-04-12 주환 수정 : 답변상태 표기  -->
							<th scope="col" style="width:13%"> 답변상태</th>
						     
						</tr>                 
						</thead>
						<tbody>
						<c:if test="${!empty bbsNoticeDataList}">
							<c:forEach items="${bbsNoticeDataList}" var="bbsNoticeDataList" varStatus="status">
							<c:set var="itemCheck" value="N" />
							<tr>
								<c:forEach items="${bbsItemList}" var="bbsItemList">
								
								<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'>
								
								<c:set var="bbsItemLinks" value="" />
								<c:set var="bbsItemLinke" value="" />
								
								<c:if test='${bbsItemList._bbsItemLink == "Y"}'>
									<c:choose>
									<c:when test='${bbsNoticeDataList._bbsDataSecret == "Y" || bbsNoticeDataList._bbsDataReplySecret == "Y"}'>
										<c:choose>
										<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && (bbsNoticeDataList._memberIdx == memberIdx || bbsNoticeDataList._bbsDataReplyMemberIdx == memberIdx)) || (memberCertify != null && memberCertify == bbsNoticeDataList._bbsDataCertify)}'>
											<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsNoticeDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
										</c:when>
										<c:otherwise>
											<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataPwForm/${bbsNoticeDataList._bbsDataIdx}.do?formType=view&amp;page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
										</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test='${tBbsSetDB.bbsSetType == "F"}'>
													<c:choose>
														<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsNoticeDataList._memberIdx == memberIdx) || (memberCertify != null && memberCertify == bbsNoticeDataList._bbsDataCertify)}'>
															<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsNoticeDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
														</c:when>
														<c:when test='${bbsNoticeDataList._bbsDataPw != null && bbsNoticeDataList._bbsDataPw != ""}'>
															<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataPwForm/${bbsNoticeDataList._bbsDataIdx}.do?formType=view&amp;page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
														</c:when>
													</c:choose>
											</c:when>
											<c:otherwise>
			
												<c:choose>
													<c:when test='${tBbsSetDB.bbsSetType == "L"}'>
														<c:choose>
															<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsNoticeDataList._memberIdx == memberIdx) || (memberCertify != null && memberCertify == bbsNoticeDataList._bbsDataCertify)}'>
																<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsNoticeDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
															</c:when>
															<c:otherwise>
																<c:choose>
																<c:when test='${bbsNoticeDataList._bbsDataLinkType == "B"}'>
																	<c:set var="bbsItemLinks" value='<a href="${bbsNoticeDataList._bbsDataLinkUrl}" target="_blank" class="list_${bbsItemList._bbsItemGroup}">' />
																</c:when>
																<c:otherwise>
																	<c:set var="bbsItemLinks" value='<a href="${bbsNoticeDataList._bbsDataLinkUrl}" class="list_${bbsItemList._bbsItemGroup}">' />
																</c:otherwise>
																</c:choose>
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:otherwise>
														<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsNoticeDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
													</c:otherwise>
												</c:choose>
			
											</c:otherwise>
										</c:choose>
									</c:otherwise>
									</c:choose>
									<c:if test='${bbsItemLinks != ""}'>
									<c:set var="bbsItemLinke" value="</a>" />
									</c:if>
								</c:if>
								
								<c:if test='${itemCheck == "N"}'>
									<c:set var="itemCheck" value="Y" />
									<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
									<td class="ac"></td>
									</c:if>
								</c:if>						
																	
								<c:choose>
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataIdx"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
										<c:choose>
										<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
										<img src="${ctx }/img/user/bbs/icon_notice.gif" alt="<s:message code="common.message.icon.notice"/>" />
										</c:when>
										<c:otherwise>
										<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_notice.gif" alt="<s:message code="common.message.icon.notice"/>" />
										</c:otherwise>
										</c:choose>	
									</td>
								</c:when>
								
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataTitle"}'>
									<td class="al <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
										<c:if test='${bbsNoticeDataList._bbsDataSecret == "Y"}'>
											<c:choose>
											<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
											<img src="${ctx }/img/user/bbs/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
											</c:when>
											<c:otherwise>
											<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
											</c:otherwise>
											</c:choose>
										</c:if>
										<c:choose>
											<c:when test='${fn:length(fn:replace(bbsNoticeDataList._bbsDataTitle, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> 
											<c:out escapeXml='true' value='${fn:substring(fn:replace(bbsNoticeDataList._bbsDataTitle, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> .. <c:if test='${bbsNoticeDataList._bbsCommentCount > 0}'><span class="listComment">[<c:out escapeXml='true' value='${bbsNoticeDataList._bbsCommentCount}' />]</span></c:if>
					 						<c:if test='${fn:substring(bbsNoticeDataList._bbsDataRegDate, 0, 10) == toDate}'>
												<c:choose>
												<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
												<img src="${ctx }/img/user/bbs/icon_new.gif" alt="<s:message code="common.message.icon.new"/>" />
												</c:when>
												<c:otherwise>
												<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_new.gif" alt="<s:message code="common.message.icon.new"/>" />
												</c:otherwise>
												</c:choose>
											</c:if>
											<c:out escapeXml='false' value='${bbsItemLinke}' />
											</c:when>
											<c:otherwise>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> 
											<c:out escapeXml='true' value='${fn:replace(bbsNoticeDataList._bbsDataTitle, "|:|", ",")}' /> <c:if test='${bbsNoticeDataList._bbsCommentCount > 0}'><span class="listComment">[<c:out escapeXml='true' value='${bbsNoticeDataList._bbsCommentCount}' />]</span></c:if>
											<c:if test='${fn:substring(bbsNoticeDataList._bbsDataRegDate, 0, 10) == toDate}'>
												<c:choose>
												<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
												<img src="${ctx }/img/user/bbs/icon_new.gif" alt="<s:message code="common.message.icon.new"/>" />
												</c:when>
												<c:otherwise>
												<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_new.gif" alt="<s:message code="common.message.icon.new"/>" />
												</c:otherwise>
												</c:choose>
											</c:if>
											<c:out escapeXml='false' value='${bbsItemLinke}' />
											</c:otherwise>
										</c:choose>
									</td>
								</c:when>
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataCategory"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
									
										<c:set var="categoryNames" value="" />
										<c:set var="doneLoop" value="false"/> 
											
										<c:choose>
											<c:when test='${tBbsSetDB.bbsSetCategoryView == "Y"}'>
												<c:set var="bbsDataCategory" value='${bbsNoticeDataList._bbsDataCategory}' />
												<c:set var="bbsCategoryParentIdxs" value="" />
												<c:set var="tmpCategoryIdx" value="0000000000" />
												<c:set var="check" value="10" />
					
												<c:forEach begin="0" end="5" step="1" varStatus="status">
													<c:if test="${not doneLoop}">
														<c:set var="check" value='${check-2}' />
					
														<c:set var="tmpCategoryIdx" value='${fn:substring(tmpCategoryIdx, 0, check)}' />
					
														<c:set var="bbsCategoryParentIdxs" value='${fn:substring(bbsDataCategory, 0, ((status.index*2)+2))}${tmpCategoryIdx}' />
					
														<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
															<c:if test='${bbsCategoryList._bbsCategoryIdxs == bbsCategoryParentIdxs}'>
																<c:set var="categoryNames" value="${categoryNames}${bbsCategoryList._bbsCategoryName} > " />
															</c:if>
					
															<c:if test='${bbsDataCategory == bbsCategoryParentIdxs}'>
																<c:set var="doneLoop" value="true"/>
															</c:if>
														</c:forEach>
													</c:if>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<c:if test="${not doneLoop}">
													<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
														<c:if test='${bbsCategoryList._bbsCategoryIdxs == bbsNoticeDataList._bbsDataCategory}'>
															<c:set var="categoryNames" value="${categoryNames}${bbsCategoryList._bbsCategoryName} > " />
														</c:if>
			
														<c:if test='${bbsDataCategory == bbsCategoryParentIdxs}'>
															<c:set var="doneLoop" value="true"/>
														</c:if>
													</c:forEach>
												</c:if>
											</c:otherwise>
										</c:choose>
			
										<c:choose>
											<c:when test='${fn:length(categoryNames) > bbsItemList._bbsItemDataLength}'>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(fn:substring(categoryNames, 0, fn:length(categoryNames)-2), 0, bbsItemList._bbsItemDataLength)}' /> .. <c:out escapeXml='false' value='${bbsItemLinke}' />
											</c:when>
											<c:otherwise>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(categoryNames, 0, fn:length(categoryNames)-2)} ${bbsItemLinke}' />
											</c:otherwise>
										</c:choose>
									</td>
								</c:when>
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataContent"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
			
										<c:set var="bbsDataContent" value='${bbsNoticeDataList._bbsDataContent}' />
			
										<%
											String bbsDataContent = SeedUtils.setReplaceNull((String)pageContext.getAttribute("bbsDataContent"));
											bbsDataContent = bbsDataContent.replaceAll("&[a-z]+;", " ");
											bbsDataContent = bbsDataContent.replaceAll("(<([a-z!/]+)[^>]*>)|([\\t\\x0B\\f]+)|(([\\r\\n][\\r\\n])+)|(-->)", "");
										%>
			
										<c:set var="bbsDataContent" value="<%=bbsDataContent%>" />
			
										<c:choose>
											<c:when test='${fn:length(fn:replace(bbsDataContent, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(fn:replace(bbsDataContent, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> .. <c:out escapeXml='false' value='${bbsItemLinke}' />  
											</c:when>
											<c:otherwise>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:replace(bbsDataContent, "|:|", ",")}' /> <c:out escapeXml='false' value='${bbsItemLinke}' /> 
											</c:otherwise>
										</c:choose>	
									</td>
								</c:when>
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataName"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
										<c:out escapeXml='false' value='${bbsItemLinks}' />
										<c:choose>
											<c:when test='${tBbsSetDB.bbsSetDataSaveType == "memberDept"}'>
												<c:out escapeXml='true' value='${bbsNoticeDataList._bbsDataDept}' />
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${bbsNoticeDataList._bbsDataName != null && bbsNoticeDataList._bbsDataName != ''}">
														<c:choose>
															<c:when test='${fn:length(bbsNoticeDataList._bbsDataName) > bbsItemList._bbsItemDataLength}'>
															<c:out escapeXml='true' value='${fn:substring(bbsNoticeDataList._bbsDataName, 0, bbsItemList._bbsItemDataLength)}' /> ..
															</c:when>
															<c:otherwise>
															<c:out escapeXml='true' value='${bbsNoticeDataList._bbsDataName}' />
															</c:otherwise>
														</c:choose>	
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test='${fn:length(bbsNoticeDataList._memberName) > bbsItemList._bbsItemDataLength}'>
															<c:out escapeXml='true' value='${fn:substring(bbsNoticeDataList._memberName, 0, bbsItemList._bbsItemDataLength)}' /> ..
															</c:when>
															<c:otherwise>
															<c:out escapeXml='true' value='${bbsNoticeDataList._memberName}' />
															</c:otherwise>
														</c:choose>	
													</c:otherwise> 
												</c:choose> 
											</c:otherwise>
										</c:choose>
										<c:out escapeXml='false' value='${bbsItemLinke}' /> 
									</td>
								</c:when>
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataRegDate"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>"><c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(bbsNoticeDataList._bbsDataRegDate, 0, 10)}' /> <c:out escapeXml='false' value='${bbsItemLinke}' /></td>
								</c:when>			
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataHit"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>"><c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${bbsNoticeDataList._bbsDataHit}' /> <c:out escapeXml='false' value='${bbsItemLinke}' /></td>
								</c:when>
								<c:when test='${bbsItemList._bbsItemGroup == "bbsDataFile"}'>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
									<c:choose>
										<c:when test='${tBbsSetDB.bbsSetType == "F" || tBbsSetDB.bbsSetType == "L"}'>
											<c:if test="${bbsNoticeDataList._bbsFileCount > 0}">
												<c:forEach items="${bbsNoticeFileList}" var="bbsFiles" >
													<c:if test='${bbsFiles.tBbsData.bbsDataIdx == bbsNoticeDataList._bbsDataIdx}'>
			
														<c:if test='${bbsNoticeDataList._bbsDataSecret != "Y" || memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsNoticeDataList._memberIdx == memberIdx)}'>
															<a href="${ctx }/common/proc/<c:out escapeXml='true' value='${siteIdx}' />/bbs/<c:out escapeXml='true' value='${bbsSetIdx}' />/fileDownLoad/<c:out escapeXml='true' value='${bbsFiles.bbsFileIdx}' />.do" title="<s:message code="common.message.blank"/> <c:out escapeXml='true' value='${bbsFiles.bbsFileName}' /> <s:message code="common.message.down"/>">
														</c:if>
													
														<c:choose>
														<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
														<img src="${ctx }/img/user/bbs/icon_<c:out escapeXml='true' value='${bbsFiles.bbsFileType}' />.gif" onerror="this.src='${ctx }/img/user/bbs/icon_file.gif';" alt="<c:out escapeXml='true' value='${bbsFiles.bbsFileName}' />" />
														</c:when>
														<c:otherwise>
														<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_<c:out escapeXml='true' value='${bbsFiles.bbsFileType}' />.gif" onerror="this.src='${ctx }/img/user/bbs/icon_file.gif';" alt="<c:out escapeXml='true' value='${bbsFiles.bbsFileName}' />" />
														</c:otherwise>
														</c:choose>	
			
														<c:if test='${bbsNoticeDataList._bbsDataSecret != "Y" || memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsNoticeDataList._memberIdx == memberIdx)}'>
															</a>
														</c:if>
			
													</c:if>
												</c:forEach>
											</c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${bbsNoticeDataList._bbsFileCount > 0}">
												<c:out escapeXml='false' value='${bbsItemLinks}' />
												<c:choose>
												<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
												<img src="${ctx }/img/user/bbs/icon_file.gif" alt="<s:message code="common.message.icon.file"/>" />
												</c:when>
												<c:otherwise>
												<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_file.gif" alt="<s:message code="common.message.icon.file"/>" />
												</c:otherwise>
												</c:choose>
												<c:out escapeXml='false' value='${bbsItemLinke}' />	
											</c:if>
										</c:otherwise>
									</c:choose>
									</td>
								</c:when>
								<c:otherwise>
									<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
										<c:set var="bbsItemGroup" value="_${bbsItemList._bbsItemGroup}" />
										
										<c:choose>
											<c:when test='${bbsItemList._bbsItemPattern == "TEXT" || bbsItemList._bbsItemPattern == "TEXTAREA"}'>
											<c:set var="status" value="0" />
											<c:out escapeXml='false' value='${bbsItemLinks}' />
											<c:forEach items="${bbsItemValuesList}" var="bbsItemValuesList">
												<c:if test='${bbsItemValuesList._bbsItemGroup == bbsItemList._bbsItemGroup}'>
												<c:set var="bbsData" value='${fn:split(bbsNoticeDataList[bbsItemGroup], ",")[status]}' />
												<c:set var="status" value='${status+1}' />
													<c:choose>
														<c:when test='${fn:length(fn:replace(bbsData, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
														<c:out escapeXml='true' value='${fn:substring(fn:replace(bbsData, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> ..<c:if test='${bbsItemValuesList._bbsItemValue != null && bbsItemValuesList._bbsItemValue != ""}'>&nbsp;<c:out escapeXml='true' value='${bbsItemValuesList._bbsItemValue}' /></c:if>
														</c:when>
														<c:otherwise>
														<c:out escapeXml='true' value='${fn:replace(bbsData, "|:|", ",")}' /><c:if test='${bbsItemValuesList._bbsItemValue != null && bbsItemValuesList._bbsItemValue != ""}'>&nbsp;<c:out escapeXml='true' value='${bbsItemValuesList._bbsItemValue}' /></c:if>
														</c:otherwise>
													</c:choose>	
												</c:if>
											</c:forEach>
											<c:out escapeXml='false' value='${bbsItemLinke}' />
											</c:when>
											<c:when test='${bbsItemList._bbsItemPattern == "LINK"}'>
											<c:set var="status" value="0" />
											<c:set var="dataLength" value='${fn:split(bbsNoticeDataList[bbsItemGroup], ",")}' />
											
											<c:out escapeXml='false' value='${bbsItemLinks}' />
											<c:forEach items="${bbsItemValuesList}" var="bbsItemValuesList">
												<c:if test='${bbsItemValuesList._bbsItemGroup == bbsItemList._bbsItemGroup}'>
												
													<c:set var="bbsData" value='${fn:split(bbsNoticeDataList[bbsItemGroup], ",")[fn:length(dataLength) / 2 * status]}' />
													<c:set var="bbsDataUrl" value='${fn:split(bbsNoticeDataList[bbsItemGroup], ",")[(fn:length(dataLength) / 2 * status) + 1]}' />
													
													<c:if test='${bbsData != "" && bbsDataUrl != ""}'>	
													<p>
													<c:choose>
														<c:when test='${fn:length(fn:replace(bbsData, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
														<a href="${ctx }<c:out escapeXml='true' value='${bbsDataUrl}'/>" target="_blank"><c:out escapeXml='true' value='${fn:substring(fn:replace(bbsData, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> ..</a>
														</c:when>
														<c:otherwise>
														<a href="${ctx }<c:out escapeXml='true' value='${bbsDataUrl}'/>" target="_blank"><c:out escapeXml='true' value='${fn:replace(bbsData, "|:|", ",")}' /></a>
														</c:otherwise>
													</c:choose>
													</p>
													</c:if>
														
													<c:set var="status" value='${status+1}' />
												</c:if>
											</c:forEach>
											<c:out escapeXml='false' value='${bbsItemLinke}' />
											</c:when>
											<c:otherwise>		
											<c:out escapeXml='false' value='${bbsItemLinks}' /> 
											<c:choose>
												<c:when test='${fn:length(fn:replace(bbsNoticeDataList[bbsItemGroup], "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
												<c:out escapeXml='true' value='${fn:substring(fn:replace(bbsNoticeDataList[bbsItemGroup], "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> ..
												</c:when>
												<c:otherwise>
												<c:out escapeXml='true' value='${fn:replace(bbsNoticeDataList[bbsItemGroup], "|:|", ",")}' /> 
												</c:otherwise>
											</c:choose>	
											<c:out escapeXml='false' value='${bbsItemLinke}' />
											</c:otherwise>
										</c:choose>
									</td>
								</c:otherwise>
								</c:choose>
								
								</c:if>
								</c:forEach>
							</tr>
							</c:forEach>
						</c:if>
						<c:choose>
							<c:when test="${!empty bbsDataList}">
							
								<c:forEach items="${bbsDataList}" var="bbsDataList" varStatus="status">
								<c:set var="itemCheck" value="N" />
								<tr>
									<c:forEach items="${bbsItemList}" var="bbsItemList">
									
									<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'>
									
									<c:set var="bbsItemLinks" value="" />
									<c:set var="bbsItemLinke" value="" />
			
									<c:if test='${bbsItemList._bbsItemLink == "Y"}'>
										<c:choose>
										<c:when test='${bbsDataList._bbsDataSecret == "Y" || bbsDataList._bbsDataReplySecret == "Y"}'>
											<c:choose>
											<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && (bbsDataList._memberIdx == memberIdx || bbsDataList._bbsDataReplyMemberIdx == memberIdx)) || (memberCertify != null && memberCertify == bbsDataList._bbsDataCertify) || (!empty sessionScope.sDupInfo && (sessionScope.sDupInfo == bbsDataList._bbsDataItemF6 || sessionScope.sDupInfo == bbsDataList._bbsDataItemG7) ) }'>
												<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${!empty sessionScope.memberIdx && !empty bbsDataList._memberIdx }"><%-- 사용자가 로그인 한 상태이고 회원이 등록한 비밀글이면 --%>
												<c:set var="bbsItemLinks" value='<a href="#none" onclick="alert(\'자신의 글만 조회 가능합니다.\')" class="list_${bbsItemList._bbsItemGroup}">' />
													</c:when>
													<c:otherwise>
												<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataCertify.do?bbsDataIdx=${bbsDataList._bbsDataIdx}" class="list_${bbsItemList._bbsItemGroup}">' />
													</c:otherwise>
												</c:choose>
												
											</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test='${tBbsSetDB.bbsSetType == "F"}'>
														<c:choose>
															<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsDataList._memberIdx == memberIdx) || (memberCertify != null && memberCertify == bbsDataList._bbsDataCertify)}'>
																<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
															</c:when>
															<c:when test='${bbsDataList._bbsDataPw != null && bbsDataList._bbsDataPw != ""}'>
																<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataPwForm/${bbsDataList._bbsDataIdx}.do?formType=view&amp;page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
															</c:when>
														</c:choose>
												</c:when>
												<c:otherwise>
			
													<c:choose>
														<c:when test='${tBbsSetDB.bbsSetType == "L"}'>
															<c:choose>
																<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsDataList._memberIdx == memberIdx) || (memberCertify != null && memberCertify == bbsDataList._bbsDataCertify)}'>
																	<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
																</c:when>
																<c:otherwise>
																	<c:choose>
																	<c:when test='${bbsDataList._bbsDataLinkType == "B"}'>
																		<c:set var="bbsItemLinks" value='<a href="${bbsDataList._bbsDataLinkUrl}" target="_blank" class="list_${bbsItemList._bbsItemGroup}">' />
																	</c:when>
																	<c:otherwise>
																		<c:set var="bbsItemLinks" value='<a href="${bbsDataList._bbsDataLinkUrl}" class="list_${bbsItemList._bbsItemGroup}">' />
																	</c:otherwise>
																	</c:choose>
																</c:otherwise>
															</c:choose>
														</c:when>
														<c:otherwise>
															<c:set var="bbsItemLinks" value='<a href="${ctx }/user/bbs/${siteIdx}/${bbsSetIdx}/${siteMenuIdx}/bbsDataView/${bbsDataList._bbsDataIdx}.do?page=${page}&amp;column=${column}&amp;search=${search}&amp;searchSDate=${searchSDate}&amp;searchEDate=${searchEDate}&amp;bbsDataCategory=${bbsDataCategory}" class="list_${bbsItemList._bbsItemGroup}">' />
														</c:otherwise>
													</c:choose>
			
												</c:otherwise>
											</c:choose>
										</c:otherwise>
										</c:choose>
										<c:if test='${bbsItemLinks != ""}'>
										<c:set var="bbsItemLinke" value="</a>" />
										</c:if>
									</c:if>
									
									<c:if test='${itemCheck == "N"}'>
										<c:set var="itemCheck" value="Y" />
										<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
										<td class="ac">
											<input type="checkbox" name="idxs" value="<c:out escapeXml='true' value='${bbsDataList._bbsDataIdx}' />" />
										</td>
										</c:if>
									</c:if>
													
									<c:choose>
									
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataIdx"}'>	
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${bbsDataCnt - (page-1)*row - status.index}' /> <c:out escapeXml='false' value='${bbsItemLinke}' />
										</td>
									</c:when>
									
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataCategory"}'>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
											<c:if test="${bbsDataList._bbsDataSecret eq 'Y'}">
												<img src="${ctx }/img/user/bbs/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
											</c:if>
											<c:set var="categoryNames" value="" />
											<c:set var="doneLoop" value="false"/> 
												
											<c:choose>
												<c:when test='${tBbsSetDB.bbsSetCategoryView == "Y"}'>
													<c:set var="bbsDataCategory" value='${bbsDataList._bbsDataCategory}' />
													<c:set var="bbsCategoryParentIdxs" value="" />
													<c:set var="tmpCategoryIdx" value="0000000000" />
													<c:set var="check" value="10" />
					
													<c:forEach begin="0" end="5" step="1" varStatus="status">
														<c:if test="${not doneLoop}">
															<c:set var="check" value='${check-2}' />
					
															<c:set var="tmpCategoryIdx" value='${fn:substring(tmpCategoryIdx, 0, check)}' />
					
															<c:set var="bbsCategoryParentIdxs" value='${fn:substring(bbsDataCategory, 0, ((status.index*2)+2))}${tmpCategoryIdx}' />
					
															<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
																<c:if test='${bbsCategoryList._bbsCategoryIdxs == bbsCategoryParentIdxs}'>
																	<c:set var="categoryNames" value="${categoryNames}${bbsCategoryList._bbsCategoryName} > " />
																</c:if>
					
																<c:if test='${bbsDataCategory == bbsCategoryParentIdxs}'>
																	<c:set var="doneLoop" value="true"/>
																</c:if>
															</c:forEach>
														</c:if>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<c:if test="${not doneLoop}">
														<c:forEach items="${bbsCategoryList}" var="bbsCategoryList">
															<c:if test='${bbsCategoryList._bbsCategoryIdxs == bbsDataList._bbsDataCategory}'>
																<c:set var="categoryNames" value="${categoryNames}${bbsCategoryList._bbsCategoryName} > " />
															</c:if>
			
															<c:if test='${bbsDataCategory == bbsCategoryParentIdxs}'>
																<c:set var="doneLoop" value="true"/>
															</c:if>
														</c:forEach>
													</c:if>
												</c:otherwise>
											</c:choose>
			
											<c:choose>
												<c:when test='${fn:length(categoryNames) > bbsItemList._bbsItemDataLength}'>
												<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(fn:substring(categoryNames, 0, fn:length(categoryNames)-2), 0, bbsItemList._bbsItemDataLength)}' /> .. <c:out escapeXml='false' value='${bbsItemLinke}' />
												</c:when>
												<c:otherwise>
												<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(categoryNames, 0, fn:length(categoryNames)-2)}' /> <c:out escapeXml='false' value='${bbsItemLinke}' />
												</c:otherwise>
											</c:choose>
										</td>
									</c:when>
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataContent"}'>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
											<c:if test="${bbsDataList._bbsDataSecret eq 'Y'}">
												<img src="${ctx }/img/user/bbs/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
											</c:if>
										<c:set var="bbsDataContent" value='${bbsDataList._bbsDataContent}' />
			
										<%
											String bbsDataContent = SeedUtils.setReplaceNull((String)pageContext.getAttribute("bbsDataContent"));
											bbsDataContent = bbsDataContent.replaceAll("&[a-z]+;", " ");
											bbsDataContent = bbsDataContent.replaceAll("(<([a-z!/]+)[^>]*>)|([\\t\\x0B\\f]+)|(([\\r\\n][\\r\\n])+)|(-->)", "");
										%>
			
										<c:set var="bbsDataContent" value="<%=bbsDataContent%>" />
			
										<c:choose>
											<c:when test='${fn:length(fn:replace(bbsDataContent, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(fn:replace(bbsDataContent, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> .. <c:out escapeXml='false' value='${bbsItemLinke}' /> 
											</c:when>
											<c:otherwise>
											<c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:replace(bbsDataContent, "|:|", ",")}' /> <c:out escapeXml='false' value='${bbsItemLinke}' /> 
											</c:otherwise>
										</c:choose>	
									</td>
									</c:when>
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataName"}'>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
											<c:if test="${bbsDataList._bbsDataSecret eq 'Y'}">
												<img src="${ctx }/img/user/bbs/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
											</c:if>
											<c:out escapeXml='false' value='${bbsItemLinks}' />
											<c:choose>
												<c:when test='${tBbsSetDB.bbsSetDataSaveType == "memberDept"}'>
													<c:out escapeXml='true' value='${bbsDataList._bbsDataDept}' />
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${bbsDataList._bbsDataName != null && bbsDataList._bbsDataName != ''}">
															<c:choose>
																<c:when test='${fn:length(bbsDataList._bbsDataName) > bbsItemList._bbsItemDataLength}'>
																<c:out escapeXml='true' value='${fn:substring(bbsDataList._bbsDataName, 0, bbsItemList._bbsItemDataLength)}' /> ..
																</c:when>
																<c:otherwise>
																<c:out escapeXml='true' value='${bbsDataList._bbsDataName}' />
																</c:otherwise>
															</c:choose>	
														</c:when>
														<c:otherwise>
															<c:choose>
																<c:when test='${fn:length(bbsDataList._memberName) > bbsItemList._bbsItemDataLength}'>
																<c:out escapeXml='true' value='${fn:substring(bbsDataList._memberName, 0, bbsItemList._bbsItemDataLength)}' /> ..
																</c:when>
																<c:otherwise>
																<c:out escapeXml='true' value='${bbsDataList._memberName}' />
																</c:otherwise>
															</c:choose>	
														</c:otherwise> 
													</c:choose> 
												</c:otherwise>
											</c:choose>
											<c:out escapeXml='false' value='${bbsItemLinke}' /> 
										</td>
									</c:when>
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataRegDate"}'>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>"><c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${fn:substring(bbsDataList._bbsDataRegDate, 0, 10)}' /> <c:out escapeXml='false' value='${bbsItemLinke}' /></td>
									</c:when>			
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataHit"}'>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>"><c:out escapeXml='false' value='${bbsItemLinks}' /> <c:out escapeXml='true' value='${bbsDataList._bbsDataHit}' /> <c:out escapeXml='false' value='${bbsItemLinke}' /></td>
									</c:when>
									<c:when test='${bbsItemList._bbsItemGroup == "bbsDataFile"}'>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
										<c:if test="${bbsDataList._bbsDataSecret eq 'Y'}">
											<img src="${ctx }/img/user/bbs/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
										</c:if>
										<c:choose>
											<c:when test='${tBbsSetDB.bbsSetType == "F" || tBbsSetDB.bbsSetType == "L"}'>
											<c:if test="${bbsDataList._bbsFileCount > 0}">
												<c:forEach items="${bbsFileList}" var="bbsFiles" >
													<c:if test='${bbsFiles.tBbsData.bbsDataIdx == bbsDataList._bbsDataIdx}'>
			
														<c:if test='${bbsDataList._bbsDataSecret != "Y" || memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsDataList._memberIdx == memberIdx)}'>
															<a href="${ctx }/common/proc/<c:out escapeXml='true' value='${siteIdx}' />/bbs/<c:out escapeXml='true' value='${bbsSetIdx}' />/fileDownLoad/<c:out escapeXml='true' value='${bbsFiles.bbsFileIdx}' />.do" title="<s:message code="common.message.blank"/> <c:out escapeXml='true' value='${bbsFiles.bbsFileName}' /> <s:message code="common.message.down"/>">
														</c:if>
			
														<c:choose>
														<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
														<img src="${ctx }/img/user/bbs/icon_<c:out escapeXml='true' value='${bbsFiles.bbsFileType}' />.gif" onerror="this.src='${ctx }/img/user/bbs/icon_file.gif';" alt="<c:out escapeXml='true' value='${bbsFiles.bbsFileName}' />" />
														</c:when>
														<c:otherwise>
														<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_<c:out escapeXml='true' value='${bbsFiles.bbsFileType}' />.gif" onerror="this.src='${ctx }/img/user/bbs/icon_file.gif';" alt="<c:out escapeXml='true' value='${bbsFiles.bbsFileName}' />" />
														</c:otherwise>
														</c:choose>	
			
														<c:if test='${bbsDataList._bbsDataSecret != "Y" || memberGrant == "S" || memberAuthM || memberAuth || (memberIdx != null && bbsDataList._memberIdx == memberIdx)}'>
															</a>
														</c:if>
			
													</c:if>
												</c:forEach>
											</c:if>
											</c:when>
											<c:otherwise>
												<c:if test="${bbsDataList._bbsFileCount > 0}">
												<c:out escapeXml='false' value='${bbsItemLinks}' /> 
												<c:choose>
												<c:when test='${tBbsSetDB.bbsSetSkinCode == "basic"}'>
												<img src="${ctx }/img/user/bbs/icon_file.gif" alt="<s:message code="common.message.icon.file"/>" />
												</c:when>
												<c:otherwise>
												<img src="${ctx }/site/<c:out escapeXml='true' value='${siteIdx}' />/jsp/bbs/skin/<c:out escapeXml='true' value='${tBbsSetDB.bbsSetSkinCode}' />/_images/icon_file.gif" alt="<s:message code="common.message.icon.file"/>" />
												</c:otherwise>
												</c:choose>	
												<c:out escapeXml='false' value='${bbsItemLinke}' />
												</c:if>
											</c:otherwise>
										</c:choose>
										</td>
									</c:when>
									<c:otherwise>
										<td class="ac <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>activeHidden</c:if>">
											<c:set var="bbsItemGroup" value="_${bbsItemList._bbsItemGroup}" />
											<c:if test="${bbsDataList._bbsDataSecret eq 'Y'}">
												<img src="${ctx }/img/user/bbs/icon_secret.gif" alt="<s:message code="common.message.icon.secret"/>" />
											</c:if>
											<c:choose>
												<c:when test='${bbsItemList._bbsItemPattern == "TEXT" || bbsItemList._bbsItemPattern == "TEXTAREA"}'>
												<c:set var="status" value="0" />
												<c:out escapeXml='false' value='${bbsItemLinks}' />
												<c:forEach items="${bbsItemValuesList}" var="bbsItemValuesList">
													<c:if test='${bbsItemValuesList._bbsItemGroup == bbsItemList._bbsItemGroup}'>
													<c:set var="bbsData" value='${fn:split(bbsDataList[bbsItemGroup], ",")[status]}' />
													<c:set var="status" value='${status+1}' />
														<c:choose>
															<c:when test='${fn:length(fn:replace(bbsData, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
															<c:out escapeXml='true' value='${fn:substring(fn:replace(bbsData, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> ..<c:if test='${bbsItemValuesList._bbsItemValue != null && bbsItemValuesList._bbsItemValue != ""}'>&nbsp;<c:out escapeXml='true' value='${bbsItemValuesList._bbsItemValue}' /></c:if>
															</c:when>
															<c:otherwise>
															<c:out escapeXml='true' value='${fn:replace(bbsData, "|:|", ",")}' /><c:if test='${bbsItemValuesList._bbsItemValue != null && bbsItemValuesList._bbsItemValue != ""}'>&nbsp;<c:out escapeXml='true' value='${bbsItemValuesList._bbsItemValue}' /></c:if>
															</c:otherwise>
														</c:choose>	
													</c:if>
												</c:forEach>
												<c:out escapeXml='false' value='${bbsItemLinke}' />
												</c:when>
												<c:when test='${bbsItemList._bbsItemPattern == "LINK"}'>
												<c:set var="status" value="0" />
												<c:set var="dataLength" value='${fn:split(bbsDataList[bbsItemGroup], ",")}' />
												
												<c:out escapeXml='false' value='${bbsItemLinks}' />
												<c:forEach items="${bbsItemValuesList}" var="bbsItemValuesList">
													<c:if test='${bbsItemValuesList._bbsItemGroup == bbsItemList._bbsItemGroup}'>
													
														<c:set var="bbsData" value='${fn:split(bbsDataList[bbsItemGroup], ",")[fn:length(dataLength) / 2 * status]}' />
														<c:set var="bbsDataUrl" value='${fn:split(bbsDataList[bbsItemGroup], ",")[(fn:length(dataLength) / 2 * status) + 1]}' />
														
														<c:if test='${bbsData != "" && bbsDataUrl != ""}'>	
														<p>
														<c:choose>
															<c:when test='${fn:length(fn:replace(bbsData, "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
															<a href="${ctx }<c:out escapeXml='true' value='${bbsDataUrl}'/>" target="_blank"><c:out escapeXml='true' value='${fn:substring(fn:replace(bbsData, "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> ..</a>
															</c:when>
															<c:otherwise>
															<a href="${ctx }<c:out escapeXml='true' value='${bbsDataUrl}'/>" target="_blank"><c:out escapeXml='true' value='${fn:replace(bbsData, "|:|", ",")}' /></a>
															</c:otherwise>
														</c:choose>
														</p>
														</c:if>
															
														<c:set var="status" value='${status+1}' />
													</c:if>
												</c:forEach>
												<c:out escapeXml='false' value='${bbsItemLinke}' />
												</c:when>
												<c:otherwise>		
												<c:out escapeXml='false' value='${bbsItemLinks}' /> 
												<c:choose>
													<c:when test='${fn:length(fn:replace(bbsDataList[bbsItemGroup], "|:|", ",")) > bbsItemList._bbsItemDataLength}'>
													<c:out escapeXml='true' value='${fn:substring(fn:replace(bbsDataList[bbsItemGroup], "|:|", ","), 0, bbsItemList._bbsItemDataLength)}' /> ..
													</c:when>
													<c:otherwise>
													<c:out escapeXml='true' value='${fn:replace(bbsDataList[bbsItemGroup], "|:|", ",")}' /> 
													</c:otherwise>
												</c:choose>	
												<c:out escapeXml='false' value='${bbsItemLinke}' />
												</c:otherwise>
											</c:choose>
										</td>
									</c:otherwise>
									</c:choose>
									
									</c:if>
									
									</c:forEach>
									<!--  진행 상황 표시 : 2021-04-08 주환 수정     <td>'${bbsItemList}'</td> -->
									<td>
										${bbsDataList._bbsDataReplyStatus}
									</td>
								</tr>
								</c:forEach>
								
									
							</c:when>
							
							<c:otherwise>
								
								<c:set var="bbsItemListCnt" value="0" />
								<c:forEach items="${bbsItemList}" var="bbsItemList">
								
								<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'>
									<c:set var="bbsItemListCnt" value='${bbsItemListCnt + 1}' />
								</c:if>
								</c:forEach>
			
							    <tr>
							        <td class="ac" colspan="${colspan}"><span class="noData"><s:message code="common.message.no.data"/></span></td>
							    </tr>
							</c:otherwise>
						</c:choose>	
					
						</tbody>
					</table>
				</div>
				
				<div class="seedbbs_pagination">
					<div class="seed_cf">
						<ul class="paginationList">
							<li class="paginationFirst"><a role="button" class="pagination arrow_prev" href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataList.do?page=1&amp;column=<c:out escapeXml='true' value='${column}' />&amp;search=<c:out escapeXml='true' value='${search}' />&amp;searchSDate=<c:out escapeXml='true' value='${searchSDate}' />&amp;searchEDate=<c:out escapeXml='true' value='${searchEDate}' />&amp;bbsDataCategory=<c:out escapeXml='true' value='${bbsDataCategory}' />" title="<s:message code="common.page.first"/>">‹‹</a></li>
							<c:if test="${block > 1}">
							<li class="paginationPrev">
								<a role="button" class="pagination arrow_prev" href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataList.do?page=<c:out escapeXml='true' value='${fPage-1}' />&amp;column=<c:out escapeXml='true' value='${column}' />&amp;search=<c:out escapeXml='true' value='${search}' />&amp;searchSDate=<c:out escapeXml='true' value='${searchSDate}' />&amp;searchEDate=<c:out escapeXml='true' value='${searchEDate}' />&amp;bbsDataCategory=<c:out escapeXml='true' value='${bbsDataCategory}' />" title="<s:message code="common.page.prev"/>">‹</a>
							</li>
							</c:if>								
							<li class="paginationNumber">
								<ul class="paginationListNum seed_cf">
									<c:forEach begin="0"  end="${lPage-fPage}" var="index" >
										<c:choose>
											<c:when test="${index+fPage==page}">
												<li><strong title="<s:message code="common.page.now"/>"><c:out escapeXml='true' value='${page}' /></strong></li>
											</c:when>
											<c:otherwise>
												<li><a href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataList.do?page=${index+fPage}&amp;column=${column}&amp;search=<c:out escapeXml='true' value='${search}' />&amp;searchSDate=<c:out escapeXml='true' value='${searchSDate}' />&amp;searchEDate=<c:out escapeXml='true' value='${searchEDate}' />&amp;bbsDataCategory=<c:out escapeXml='true' value='${bbsDataCategory}' />" title="<c:out escapeXml='true' value='${index+fPage}' /> <s:message code="common.page.page"/>"><c:out escapeXml='true' value='${index+fPage}' /></a></li>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</ul>
							</li>
							<c:if test="${block < blocks}">
							<li class="paginationNext">
								<a role="button" class="pagination arrow_next" href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataList.do?page=<c:out escapeXml='true' value='${lPage+1}' />&amp;column=<c:out escapeXml='true' value='${column}' />&amp;search=<c:out escapeXml='true' value='${search}' />&amp;searchSDate=<c:out escapeXml='true' value='${searchSDate}' />&amp;searchEDate=<c:out escapeXml='true' value='${searchEDate}' />&amp;bbsDataCategory=<c:out escapeXml='true' value='${bbsDataCategory}' />" title="<s:message code="common.page.next"/>">›</a>
							</li>
							</c:if>
							<li class="paginationLast"><a role="button" class="pagination arrow_next" href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataList.do?page=<c:out escapeXml='true' value='${pages}' />&amp;column=<c:out escapeXml='true' value='${column}' />&amp;search=<c:out escapeXml='true' value='${search}' />&amp;searchSDate=<c:out escapeXml='true' value='${searchSDate}' />&amp;searchEDate=<c:out escapeXml='true' value='${searchEDate}' />&amp;bbsDataCategory=<c:out escapeXml='true' value='${bbsDataCategory}' />" title="<s:message code="common.page.last"/>">››</a></li>
						</ul>
					</div>
				</div>

		<c:choose>
			<c:when test='${memberGrant == "S" || memberAuthM || memberAuth || tBbsAuthDB.bbsAuthWrite == "Y" || "Y" == sessionScope.qnaCheck}'>
				<div class="seed_btnArea seed_cf">
				
					<c:if test='${memberGrant == "S" || memberAuthM || memberAuth}'>
					<div class="seed_fl">
						<input type="submit" value="<s:message code="common.message.choice"/> <s:message code="user.bbs.button.del"/>" class="del" />
					</div>
					</c:if>

					<div class="seed_fr">
						<a class="seedbbs_btn reg" href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataForm.do"><s:message code="user.bbs.button.reg"/></a>
					</div>
				</div>
			</c:when>
			<c:otherwise>
				<%--일반회원 문의등록하기 --%>
				<div class="seed_btnArea seed_cf">
					<div class="seed_fr">
						<a class="seedbbs_btn reg" href="${ctx }/user/bbs/<c:out escapeXml='true' value='${siteIdx}' />/<c:out escapeXml='true' value='${bbsSetIdx}' />/<c:out escapeXml='true' value='${siteMenuIdx}' />/bbsDataCertify.do"><s:message code="user.bbs.button.reg"/></a>
					</div>
				</div>			
			</c:otherwise>
		</c:choose>
				

				
						
			</fieldset>
		</form:form>
	</div>
	
	</c:when>
	<c:otherwise>

	<div class="listWrap default bbsList_<c:out escapeXml='true' value='${bbsSetIdx}'/>">

		<c:set var="colspan" value="0" />
		
		<fieldset>
			<legend>게시판 리스트</legend>
			<div class="seed_tbl">
				<table>
					<caption><c:out escapeXml='true' value='${tBbsSetDB.bbsSetName}'/> 게시판의 <c:forEach items="${bbsItemList}" var="bbsItemList" varStatus="status"><c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'><c:out escapeXml='true' value='${bbsItemList._bbsItemName}' /></c:if></c:forEach> <s:message code="common.list.caption"/></caption>
					<colgroup>
						<c:forEach items="${bbsItemList}" var="bbsItemList">
						<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'>
						<c:choose>
							<c:when test='${bbsItemList._bbsItemColWidth == "0"}'>
							<col <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>class="activeHidden"</c:if> style="width: auto;" />
							</c:when>
							<c:otherwise>
							<col <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>class="activeHidden"</c:if> style="width: <c:out escapeXml='true' value='${bbsItemList._bbsItemColWidth}' />;" />
							</c:otherwise>
						</c:choose>
						<c:set var="colspan" value='${colspan+1}' />
						</c:if>
						</c:forEach>
					</colgroup>
					<thead>
					<tr>
						<c:forEach items="${bbsItemList}" var="bbsItemList" varStatus="status">
						<c:if test='${bbsItemList._bbsItemStatus == "U" && bbsItemList._bbsItemList == "Y"}'>
						<th scope="col" <c:if test='${bbsItemList._bbsItemActiveHidden == "Y"}'>class="activeHidden"</c:if>><c:out escapeXml='true' value='${bbsItemList._bbsItemName}' /></th>
						</c:if>
						</c:forEach>
					</tr>
					</thead>
					<tbody>
					<tr>
						<td class="ac" colspan="${colspan}" ><span class="noGrant"><s:message code="user.bbs.message.no.list"/></span></td>
					</tr>
					</tbody>
				</table>
			</div>
		</fieldset>
	</div>
	
	</c:otherwise>
	</c:choose>
	
	<c:out escapeXml='false' value='${tBbsSetDB.bbsSetFHtml}' />
	
	</div>
		
	<c:if test='${siteMenuCharge == "Y"}'>
	<c:import url="/common/charge/${siteIdx}.do?siteMenuManagerIdx=${siteMenuManagerIdx}"></c:import>
	</c:if>
	
	<c:if test='${siteMenuSatisfaction == "Y"}'>
	<c:import url="/common/satisfaction/${siteIdx}/${siteMenuIdx}.do"></c:import>
	</c:if>
		</section>
		</div>
	<c:import url="/${siteIdx}/sub/footer/layOut.do"></c:import>
	
	</body>
	

 
</html>





















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































