<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.integrosys.cms.app.common.constant.ICMSConstant,
                 com.integrosys.cms.ui.manualinput.limit.XRefDetailForm,
                  java.util.Collection,
				 java.util.Iterator,
				 java.util.List,
                 com.integrosys.cms.ui.limit.CategoryCodeConstant" %>
<%@page import="java.text.SimpleDateFormat"%>

<%@ taglib uri="/WEB-INF/IntegroTag.tld" prefix="integro" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>


<%@page import="java.util.ArrayList"%>
<%@page import="com.integrosys.cms.app.generalparam.bus.IGeneralParamEntry"%>
<%@page import="com.integrosys.cms.app.generalparam.bus.IGeneralParamGroup"%>
<%@page import="com.integrosys.cms.app.generalparam.bus.IGeneralParamDao"%>
<%@page import="com.integrosys.base.techinfra.propertyfile.PropertyManager"%>
			
<%@page
	import="com.integrosys.cms.ui.manualinput.limit.LmtDetailForm,
	            com.integrosys.cms.ui.common.UIUtil,
				com.integrosys.cms.ui.manualinput.limit.FacCoBorrowerDetailsForm,
				com.integrosys.cms.app.customer.bus.ICoBorrowerDetails,
				com.integrosys.cms.ui.manualinput.limit.LmtDetailAction,
				java.util.List"%>
				

<%@page import="com.integrosys.base.techinfra.context.BeanHouse"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="org.apache.struts.util.LabelValueBean"%><html> <!-- InstanceBegin template="/Templates/ContentPage.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable -->

<!-- InstanceBeginEditable name="CssStyle" -->
<%

String event = request.getParameter("event");

String fromPage = request.getParameter("fromPage");

Collection subSecurityList = (Collection) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.subSecurityList");
request.setAttribute("subSecurityList", subSecurityList);


List systemIdList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.systemIdList");
pageContext.setAttribute("systemIdList",systemIdList);

List fccBranchList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.fccBranchList");
pageContext.setAttribute("fccBranchList",fccBranchList);

List branchAllowedList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.branchAllowedList");
pageContext.setAttribute("branchAllowedList",branchAllowedList);

List branchAllowedList1 =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.branchAllowedList1");
pageContext.setAttribute("branchAllowedList1",branchAllowedList1);

List productAllowedList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.productAllowedList");
pageContext.setAttribute("productAllowedList",productAllowedList);

List productAllowedList1 =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.productAllowedList1");
pageContext.setAttribute("productAllowedList1",productAllowedList1);

List currencyAllowedList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.currencyAllowedList");
pageContext.setAttribute("currencyAllowedList",currencyAllowedList);

List currencyAllowedList1 =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.currencyAllowedList1");
pageContext.setAttribute("currencyAllowedList1",currencyAllowedList1);

String productListFromProperty =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.productListFromProperty");
String productIdList =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.productIdList");

System.out.println("productListFromProperty:"+productListFromProperty+" productIdList:"+productIdList); 
//System.out.println("branchAllowedList:"+branchAllowedList+"branchAllowedList1 "+branchAllowedList1+" fccBranchList:"+fccBranchList);

//added by santosh ubs limit upload

List udfLbValList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.udfLbValList");
pageContext.setAttribute("udfLbValList",udfLbValList);
List udfLbValList1 =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.udfLbValList1");
pageContext.setAttribute("udfLbValList1",udfLbValList1);
//end by santosh ubs limit upload

List udfLbValList_2 =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.udfLbValList_2");
pageContext.setAttribute("udfLbValList_2",udfLbValList_2);
List udfLbValList1_2 =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.udfLbValList1_2");
pageContext.setAttribute("udfLbValList1_2",udfLbValList1_2);


List mainLineCodeList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.mainLineCodeList");
pageContext.setAttribute("mainLineCodeList",mainLineCodeList);


String currency =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.currency");
pageContext.setAttribute("currency",currency);

List vendorList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.vendorList");
pageContext.setAttribute("vendorList",vendorList);
String mastscmFlag =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.scmFlag");

String limitType =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.limitType");
String ruleId =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.ruleId");
Date camExtentionDate =(Date) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.camExtentionDate");
String internalRemarks =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.internalRemarks");
String revolvingLine =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.revolvingLine");
String partyScmFlag =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.partyScmFlag");
String linecurrency =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.currency");
String currencyRestriction =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.currencyRestriction");
String intradayLimit =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.intradayLimit");
System.out.println("<<<<intradayLimit>>>>"+intradayLimit);
/* System.out.println("limitType:"+limitType+" ruleId:"+ruleId+" camExtentionDate:"+camExtentionDate+"internalRemarks:"+internalRemarks);
System.out.println("revolvingLine:"+revolvingLine+" linecurrency:"+linecurrency+" currencyRestriction:"+currencyRestriction+" intradayLimit:"+intradayLimit); */
String BASE_INT_RATE =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.BASE_INT_RATE");

String BPLR_INT_RATE =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.BPLR_INT_RATE");

String scfStatus=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.scfStatus");

String scfErrMsg=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.scfErrMsg");

String scfFlag=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.scfFlag");

String responseDate=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.responseDate");
String requestDate=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.requestDate");
String radioInterfaceCompleted=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.radioInterfaceCompleted");



System.out.println("subSecurityList+++++++++++++"+subSecurityList.size());
System.out.println("systemIdList+++++++++++"+systemIdList.size());
System.out.println("partyScmFlag+++++++++"+partyScmFlag);
System.out.println("BASE_INT_RATE+++++++++"+BASE_INT_RATE);
System.out.println("BASE_INT_RATE+++++++++"+BASE_INT_RATE);

String context = request.getContextPath() + "/";

	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
			
String partyCapitalMarExp=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.partyCapitalMarExp");
String partySegment=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.partySegment");
String segment1=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.segment1");

IGeneralParamDao generalParamDao =(IGeneralParamDao)BeanHouse.get("generalParamDao");
IGeneralParamGroup generalParamGroup  =generalParamDao.getGeneralParamGroupByGroupType("actualGeneralParamGroup", "GENERAL_PARAM");
IGeneralParamEntry[]generalParamEntries= generalParamGroup.getFeedEntries();
String appDate="";
DateFormat df=new SimpleDateFormat("dd/MMM/yyyy");
for(int i=0;i<generalParamEntries.length;i++){
	if(generalParamEntries[i].getParamCode().equals("APPLICATION_DATE")){
		System.out.println("generalParamEntries[i].getParamValue():"+generalParamEntries[i].getParamValue());
		appDate=df.format(new Date((generalParamEntries[i].getParamValue())));
	}
}

String camExtDateStr=""; 
if(null!=camExtentionDate){
	camExtDateStr=df.format(camExtentionDate); 
}

System.out.println("partyCapitalMarExp:"+partyCapitalMarExp+" partySegment:"+partySegment+"appDate:"+appDate);

String liabilityId =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.liabilityId");
String partyId =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.partyId");
System.out.println("liabilityId:"+liabilityId+" partyId:"+partyId); 

String guarantee =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.guarantee");

System.out.println("guarantee:"+guarantee); 

XRefDetailForm form = (XRefDetailForm) request.getAttribute("XRefDetailForm");
pageContext.setAttribute("XRefDetailForm", form);

String adhocFacility = (String)request.getAttribute("adhocFacility");
System.out.println("==========172=========form.getAdhocFacility() : "+form.getAdhocFacility()); 
System.out.println("==========173=========request.getAttribute adhocFacility : "+request.getAttribute("adhocFacility")); 
if(adhocFacility==null){
	adhocFacility = form.getAdhocFacility();
}
System.out.println("==========173=========adhocFacility : "+adhocFacility);

List facCoBorrowerList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.facCoBorrowerList");
pageContext.setAttribute("facCoBorrowerList",facCoBorrowerList);


List restCoBorrowerList = (List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.restCoBorrowerList");
 
String lineCoBorrowerLiabIds =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.restCoBorrowerIds");
if(null !=lineCoBorrowerLiabIds){
	if(!lineCoBorrowerLiabIds.contains("\"")){
	    List<String> selectedCoBorrowerIds = UIUtil.getListFromDelimitedString(lineCoBorrowerLiabIds, ",");
	    lineCoBorrowerLiabIds = UIUtil.getJSONStringFromList(selectedCoBorrowerIds, ",");
	}
	}
	if (!(restCoBorrowerList == null)) {
	//	System.out.println("restCoBorrowerList size="+restCoBorrowerList.size());
		pageContext.setAttribute("restCoBorrowerList", restCoBorrowerList);
	}else {
		restCoBorrowerList = new ArrayList();
	pageContext.setAttribute("restCoBorrowerList", new ArrayList());
	}

//System.out.println("restCoBorrowerList==========="+restCoBorrowerList); 

   
int vno = 0;

String facCoBorrowerLiabIds =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.facCoBorrowerLiabIds");
pageContext.setAttribute("facCoBorrowerLiabIds",facCoBorrowerLiabIds);


String wsCall=PropertyManager.getValue("fetch.coBorrower.wsCall");
String lastExpDate=""; 
String lastAvailDate=""; 
if(null != request.getParameter("adhocFacilityExpDate")){
	lastExpDate=  request.getParameter("adhocFacilityExpDate");  //dateOfReset
	
}
if(null != request.getParameter("adhocLastAvailDate")){
	lastAvailDate=  request.getParameter("adhocLastAvailDate");
}

String releasableAmtForCheck1 = (String)request.getAttribute("releasableAmtForCheck");
System.out.println("+++++++++++++releasableAmtForCheck=>"+releasableAmtForCheck1);	
pageContext.setAttribute("releasableAmtForCheck",releasableAmtForCheck1);


%>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
  <script type="text/javascript" src="js/emulation.js"></script>
  <script language="JavaScript" src="js/itgPrjConfigSetup.js"></script>
  <script language="JavaScript" src="js/itgCheckForm.js"></script>
  <script type="text/javascript" src="js/calendar.js"></script>
  <script type="text/javascript" src="js/calDriver.js"></script>
  <script type="text/javascript" src="js/imageNavigation.js"></script>
  <!-- <script type="text/javascript" src="js/itgDualList.js"></script> -->
  <script type="text/javascript" src="js/ajaxDropdown.js"></script>
   <script type="text/javascript" src="js/jquery.min.js"></script> 
     <script type="text/javascript" src="js/moment.js"></script>
   
  
  <link rel="stylesheet" type="text/css" media="all" href="css/calendar-blue.css" />
</head>

<body onload="MM_preloadImages('img/return2.gif')">
 <script language="javascript">
 
   function submitAccount()
   {
	   
	   var releasableAmountCheck = <%=releasableAmtForCheck1%>;
		
		var idlAmt = document.getElementById("idlAmount").value ;
		idlAmt = idlAmt.replace(/,/g,'');
		if(releasableAmountCheck < idlAmt && releasableAmountCheck != null){
			alert("IDL Amount Can Not be Greater than Releasable Amount.");
		}else{
	   document.getElementById('dateOfReset').disabled = false;
	   
	   document.getElementById('lastavailableDate').disabled = false;
	   document.getElementById('adhocLineY').disabled = false;
	   document.getElementById('adhocLineN').disabled = false;
	 
    if(document.getElementById('interestRateType').checked=='false'||document.getElementById('interestRateType').checked==false)
   	{
    	var margin=eval(document.getElementById('intRateFloatingMargin').value);
		var range=eval(document.getElementById('intRateFloatingRange').value);
   		if(document.getElementById('intRateFloatingMarginFlag').checked=='false'||document.getElementById('intRateFloatingMarginFlag').checked==false)
   		{
   			if(margin>range)
   			{
   			 alert('Interest rate cannot be negative');
   			 return;
   			}
   		}else if((margin + range) > 100){
   		 		alert('Interest rate cannot greater than 100');
			 return;
   		}   		
   		
   	}

    var  prodAllowed=document.getElementById('productAllowed').value;
   
   var productIdList= '<%= productIdList %>';
   var productListFromProperty= '<%= productListFromProperty %>';
  // alert("productIdList:"+productIdList);

   var productIdListArr="";
   if(productIdList!==""){
	 productIdListArr=productIdList.split(",");
   }
  // alert("productIdListArr:"+productIdListArr+"test");

   var productCodeFlag=false;
  // alert("length:"+productIdListArr.length);
   if(prodAllowed==="" && productIdListArr!==""){
 	  productCodeFlag=true;
   }else{
   for(var i=0;i<productIdListArr.length;i++){
 //	  alert("1:"+productIdListArr[i]+" index:"+prodAllowed.indexOf(productIdListArr[i]));
  if(prodAllowed.indexOf(productIdListArr[i])==-1){
 //	 alert("2");
 	 productCodeFlag=true;
 	 break;
  }
   }
   }

   //alert("productCodeFlag:"+productCodeFlag);
    if(productCodeFlag){
 	alert("Product Codes "+productListFromProperty+" are mandatory for Product Allowed.");
 	return;
    } 
    
   var segment= document.forms[0].segment.value;

   var sel=document.forms[0].segment;
 var segmentText=sel.options[sel.selectedIndex].text;
 //  alert(segmentText);
   
   var udfAllowed= document.forms[0].udfAllowed.value;
   var udfAllowed_2= document.forms[0].udfAllowed_2.value;
  
   var releasedAmountChk1= document.forms[0].releasedAmount.value;
   var utilizedAmountChk1= document.forms[0].utilizedAmount.value;
   var releasedAmountChk = releasedAmountChk1.replace(/,\s?/g, "");
   var utilizedAmountChk = utilizedAmountChk1.replace(/,\s?/g, "");
   
   var str='<%=partySegment%>';
   //alert("str.toLowerCase"+str.toLowerCase());
  // alert("segment.toLowerCase"+segmentText.toLowerCase());
  var dateOfReset= document.getElementById("dateOfReset").value;
  // 	var dateOfReset= document.forms[0].dateOfReset[0].value;
   	
	var appDate='<%=appDate%>';
	var dateOfResetDate;
	var appDateDate;
	if(dateOfReset.indexOf("/")>=0){
		var temp1=dateOfReset.split("/");
		var d1 = new Date(Number(temp1[2]), getMonthFromMMM(temp1[1]), Number(temp1[0]));
		dateOfResetDate=d1;
	}
	if(appDate.indexOf("/")>=0){
		var temp1=appDate.split("/");
		var d1 = new Date(Number(temp1[2]), getMonthFromMMM(temp1[1]), Number(temp1[0]));
		appDateDate=d1;
	}
	
	// alert("dateOfResetDate "+" "+dateOfReset+" "+appDate+" "+dateOfResetDate+" "+appDateDate);
   if(segment !='' && str.toLowerCase() != segmentText.toLowerCase()){
	
   		var answer=  confirm("Selected Segment1 value does not match with party. Do you want to proceed.");
   		
		if(answer == true){
			
			if(dateOfResetDate!='' && dateOfResetDate < appDateDate){
				 var answer1=  confirm("CAM or Limit is expired. Do you still want to proceed?");
			 	if(answer1==true){
			 		mandatoryUdfPopUp();
   				}
		   }
		else {
			mandatoryUdfPopUp();
		}
	}
		
  }
  else if(dateOfResetDate!='' && dateOfResetDate < appDateDate){
	  
		 var answer3=  confirm("CAM or Limit is expired. Do you still want to proceed?");
		 if(answer3==true){
			mandatoryUdfPopUp();
		}
	}
  else if( '' == udfAllowed) {
	  mandatoryUdfPopUp();
  }
  else if('' == udfAllowed_2) {
	  mandatoryUdfPopUp();
  }
  else if(+utilizedAmountChk > +releasedAmountChk) {
	  checkAmount();
  } 
  else {
  		
	if (document.forms[0].indexID.value == '') {
	    document.forms[0].event.value = 'create_ubs';
    }
    else {
	    document.forms[0].event.value = 'submit_ubs';	
	} 
   	
	if(document.forms[0].isPrioritySector.value != 'Blank') {
		if(document.forms[0].isPrioritySector[0].checked) {
			document.forms[0].prioritySector.value = document.all.prioritySector[1].value;
			document.getElementById("prioritySector").value = document.all.prioritySector[1].value;
		}
	}
	
	//selectBranchAllowedLists();
	//selectProductAllowedLists();
	//selectCurrencyAllowedLists();
	document.forms[0].submit();	
  }
 }
   
 //Santosh ubs limit
   function mandatoryUdfPopUp() {
   		   if(udfAllowed == '') {
   				var answer4=  confirm("Non mandatory UDF are not selected. Do you want to continue?.");
   				if(answer4 == true){
   					checkAmount();
   				}
   		   }
   		   else {
   			checkAmount();
   		   }
   }
 
   function checkAmount() {
		   if(+utilizedAmountChk > +releasedAmountChk) {
				var answer5=  confirm("Outstanding is more than the limit, do you still want to proceed?");
				if(answer5 == true){
					if (document.forms[0].indexID.value == '') {
					    document.forms[0].event.value = 'create_ubs';
				    }
				    else {
					    document.forms[0].event.value = 'submit_ubs';
					} 
				   	
					if(document.forms[0].isPrioritySector.value != 'Blank') {
						if(document.forms[0].isPrioritySector[0].checked) {
							document.forms[0].prioritySector.value = document.all.prioritySector[1].value;
							document.getElementById('prioritySector').value = document.all.prioritySector[1].value;
						}
					}
				//	selectBranchAllowedLists();
			//	selectProductAllowedLists();
			//	selectCurrencyAllowedLists();
				document.forms[0].submit();	
				}
		   }
		   else {
			   if (document.forms[0].indexID.value == '')
				{
				    document.forms[0].event.value = 'create_ubs';
			        }
			        else
				{
				    document.forms[0].event.value = 'submit_ubs';	
				} 
			   	
				if(document.forms[0].isPrioritySector.value != 'Blank') {
					if(document.forms[0].isPrioritySector[0].checked) {
						document.forms[0].prioritySector.value = document.all.prioritySector[1].value;
						document.getElementById('prioritySector').value = document.all.prioritySector[1].value;
					}
				}
			//	selectBranchAllowedLists();
		//	selectProductAllowedLists();
		//	selectCurrencyAllowedLists();
			document.forms[0].submit();	
		   }
	}
   //end santosh ubs limit  
}//main function end

   function getMonthFromMMM(month)
   {
	   if(month == 'Jan'){
		return 0;
	   }else  if(month == 'Feb'){
		return 1;
	   }else  if(month == 'Mar'){
		return 2;
	   }else  if(month == 'Apr'){
		return 3;
	   }else  if(month == 'May'){
		return 4;
	   }else  if(month == 'Jun'){
		return 5;
	   }else  if(month == 'Jul'){
		return 6;
	   }else  if(month == 'Aug'){
		return 7;
	   }else  if(month == 'Sep'){
		return 8;
	   }else  if(month == 'Oct'){
		return 9;
	   }else  if(month == 'Nov'){
		return 10;
	   }else  if(month == 'Dec'){
		return 11;
	   }

   }
   
   function cancelSubmit()
   {
	document.forms[0].event.value = 'cancel';
	document.forms[0].submit();
   }
	
   function refreshHostSystem(dropdown)
   {
	var curSel = "";
	for(i=0; i<dropdown.options.length; i++)
	{
	     if (dropdown.options[i].selected == true)
	     {
		 curSel = dropdown.options[i].value;		
	     }
        }	
        var dep = 'hostSystemName';
        var url = '/cms/MIAcntDetail.do?event=refresh_hostsyscountry&hostSystemCountry='+curSel;
        sendLoadDropdownReq(dep, url);
   }	



   function JumpOnSelect(selectObj)
   {
     		var selectIndex = selectObj.selectedIndex;
   		
   		//Process Customer
   		if (selectObj.options[selectIndex].value == 1)
   		window.location.href('../customer/CustDetails(mode=view,cpcMaker).htm');
   		
   		//View Limits
   		else if (selectObj.options[selectIndex].value == 2)
   		window.location.href('searchLimit(SACmaker,result).htm');
   		
   		/*View Sec Coverage
   		else if(selectObj.options[selectIndex].value == 3)
   		parent.window.location.href('../Collateral/ViewSecurityCoverageContainer.htm');*/
   		
   		//View Securities
   		else if(selectObj.options[selectIndex].value == 3)
   		parent.window.location.href('../Deal/Dealframe(GMRA,MRmaker).htm');
   		
   		//View Valuation
   		else if(selectObj.options[selectIndex].value == 4)
   		parent.window.location.href('../Valuation/Valuationframe(MRmaker).htm');
   		
   		//Maintain Security Checklist
   		else if(selectObj.options[selectIndex].value == 5)
   		window.location.href('#');
   		
   		//Update C/C Doc Receipt
   		else if(selectObj.options[selectIndex].value == 6)
   		parent.window.location.href('../Documentation/UpCCDocReceiptContainer(cpcdocmaker).htm');
   		else if(selectObj.options[selectIndex].value == 9)
   		window.location.href('../Collateral/ViewLimitsContainer(SACmaker).htm');
   		
   }
   function shwhd(selfObj){
   	if(selfObj.value == 'fixed'){
   		document.getElementById('intRateFloatingMarginFlag').value='';
   		document.getElementById('intRateFloatingMargin').value='';	
   		document.getElementById('intRateFloatingRange').value='';	
   		document.getElementById('intRateFloatingType').value='';
   		document.getElementById('fixed').style.display = ''; 
   		document.getElementById('margin').style.display = 'none';
   	}
	if (selfObj.value == 'floating'){
   		document.getElementById('fixed').style.display = 'none';
   		document.getElementById('margin').style.display = '';
   		document.getElementById('intRateFloatingType').style.visibility ="visible";
   	}
   }  
   function lastExpDT(){
	   alert("Limit Expiry Date is not allowed to change, as this facility is Adhoc facility.")
   }
   function lastAvailDT(){
	   alert("Last Availability Date is not allowed to change, as this facility is Adhoc facility.")
   }  
   
   function shwhdPSec(selfObj){
	   
	   	if(selfObj.value == 'No'){
	   		document.getElementById('pSec_No').style.display = 'block'; 
	   		document.getElementById('pSec_Yes').style.display = 'none';
// 	   		document.getElementsByName("prioritySector").style.visibility ="visible";
	   		var x = document.getElementsByName("prioritySector");
	   	    var i;
	   	    for (i = 0; i < x.length; i++) {
	   	    	x[i].style.visibility ="visible";
	   	    }
	   	 	document.all.prioritySector[0].name='prioritySector';
	   	 	document.all.prioritySector[1].name='';	
	   	}
		if (selfObj.value == 'Yes'){
	   		document.getElementById('pSec_Yes').style.display = 'block';
	   		document.getElementById('pSec_No').style.display = 'none';
	   		//document.getElementsByName("prioritySector").style.visibility ="visible";
	   		var x = document.getElementsByName("prioritySector");
	   	    var i;
	   	    for (i = 0; i < x.length; i++) {
	   	    	x[i].style.visibility ="visible";
	   	    }
	   	    
	   	 	document.all.prioritySector[1].name='prioritySector';
	   	 	document.all.prioritySector[0].name='';
	   	}
		document.all.prioritySector[0].value='';
		document.all.prioritySector[1].value='';
  }
	   function shwhdEstateType(selfObj){
		   	if(selfObj.value == 'Commercial Real estate'){
		   		document.getElementById('CommRE').style.display = '';
		   		document.getElementById('commRealEstateType').style.visibility ="visible";
		   	} else {
		   		document.getElementById('CommRE').style.display = 'none';
		   	}
		}
	   function shwhdRealEstateExposer(selfObj){
		   	if(selfObj== 'Yes'){
		   		document.forms[0].estateType[0].disabled =false;
				document.forms[0].estateType[1].disabled =false;
				document.forms[0].estateType[2].disabled =false;
				document.forms[0].estateType[0].checked =false;
				document.forms[0].estateType[1].checked =false;
				document.forms[0].estateType[2].checked =false;
				document.getElementById('CommRE').style.display = 'none';
				document.getElementById('commRealEstateType').style.visibility ="visible";
		   	}
			if(selfObj == 'No'){
				document.forms[0].estateType[0].disabled =true;
				document.forms[0].estateType[1].disabled =true;
				document.forms[0].estateType[2].disabled =true;
				document.forms[0].isRealEstateExposer[1].checked =true;
				document.getElementById('CommRE').style.display = 'none';
		   	}
		}
		
	   function enableUtilizedAmount()
		{
			var relAmt="";
			var releasedAmount=document.forms[0].releasedAmount.value;
			if(releasedAmount=='')
			{
				document.forms[0].utilizedAmount.disabled=true;
			}
			else
			{
				document.forms[0].utilizedAmount.disabled=false;
			}
			//var letters = /^[A-Za-z]+$/;
			
			
			for(var i=0;i<releasedAmount.length;i++){
				if(releasedAmount[i]!=="m" && releasedAmount[i]!=="M" && releasedAmount[i]!=="b" && releasedAmount[i]!=="B"){
					relAmt=relAmt+releasedAmount.charAt(i);			
				}
				
	        if(releasedAmount[i]==="m"|| releasedAmount[i]==="M"){	        	
	        	releasedAmount=releasedAmount.toLowerCase().replace('M'," ");	        
	        	releasedAmount=relAmt*1000000;	    	        
	        }
	        
	        if(releasedAmount[i]==="B"|| releasedAmount[i]==="b"){
	        	releasedAmount=releasedAmount.replace('B'," ");
	        	releasedAmount=relAmt*1000000000;		       
		        }
	        
	        //if(releasedAmount[i]===letters){
	        //	releasedAmount="0.00";
	        //}
	        }
		}
		

		function onBlurEvent(txtReleaseAmount){
			var releasedAmount=txtReleaseAmount.value;
			var len="";
			if(releasedAmount.length>=1 && releasedAmount.length<=38){
				var secondLastChar=releasedAmount.charAt(releasedAmount.length-1);
				if(secondLastChar==="M"){
					//sancAmount=sancAmount.slice(0,-1);
					releasedAmount=releasedAmount.replace("M"," ");
					releasedAmount=releasedAmount*1000000;
					//alert(sancAmount);
					len=releasedAmount.toString().length;
					if(len<=38 && releasedAmount.toString().charAt(1)!=="e"){
						txtReleaseAmount.value=releasedAmount;
					}else{
						txtReleaseAmount.value="0.00";
					}
					
					//alert(sancAmount.toString().charAt(1));
					
				}
				else if(secondLastChar==="m"){
					//sancAmount=sancAmount.slice(0,-1);
					releasedAmount=releasedAmount.replace("m"," ");
					releasedAmount=releasedAmount*1000000;
					len=releasedAmount.toString().length;
					if(len<=38 && releasedAmount.toString().charAt(1)!=="e"){
						txtReleaseAmount.value=releasedAmount;
					}else{
						txtReleaseAmount.value="0.00";
					}
					
				}
				else if(secondLastChar==="B"){
					//sancAmount=sancAmount.slice(0,-1);
					releasedAmount=releasedAmount.replace("B"," ");
					releasedAmount=releasedAmount*1000000000;
					len=releasedAmount.toString().length;
					if(len<=38 && releasedAmount.toString().charAt(1)!=="e"){
						txtReleaseAmount.value=releasedAmount;
					}else{
						txtReleaseAmount.value="0.00";
					}
				}
				else if(secondLastChar==="b"){
					//sancAmount=sancAmount.slice(0,-1);
					releasedAmount=releasedAmount.replace("b"," ");
					releasedAmount=releasedAmount*1000000000;
					len=releasedAmount.toString().length;
					if(len<=38 && releasedAmount.toString().charAt(1)!=="e"){
						txtReleaseAmount.value=releasedAmount;
					}else{
						txtReleaseAmount.value="0.00";
					}
				}
				else if(secondLastChar == 0 || secondLastChar == 1|| secondLastChar == 2|| 
						secondLastChar == 3|| secondLastChar == 4|| secondLastChar == 5|| secondLastChar == 6
						|| secondLastChar == 7 || secondLastChar == 8 || secondLastChar == 9){
					len=releasedAmount.toString().length;
					if(len<=38){
						txtReleaseAmount.value=releasedAmount;
					}else{
						txtReleaseAmount.value="0.00";
					}
				}
				else{
					//alert("Please enter numeric value only.");
					txtReleaseAmount.value="0.00";
				}
				
			}
			else{
				//alert("Please enter numeric value only.");
				txtReleaseAmount.value="0.00";
			}
		}

		
		function onKeyUpEvent(txtReleaseAmount){
			var releasedAmount=txtReleaseAmount.value;
			if(releasedAmount.length>1){
				var secondLastChar=releasedAmount.charAt(releasedAmount.length-2);
				if(secondLastChar==="M"){
					releasedAmount=releasedAmount.slice(0,-1);
					//sancAmount=sancAmount*1000000;
					txtReleaseAmount.value=releasedAmount;
					//onChangeEvent(txtSancAmount.value);
				}
				if(secondLastChar==="m"){
					releasedAmount=releasedAmount.slice(0,-1);
					//sancAmount=sancAmount.replace("m","M");
					//sancAmount=sancAmount*1000000;
					txtReleaseAmount.value=releasedAmount;
					//alert("Not Allow to enter more value.");
					
				}
				if(secondLastChar==="B"){
					releasedAmount=releasedAmount.slice(0,-1);
					//sancAmount=sancAmount.replace("B"," ");
					//sancAmount=sancAmount*1000000000;
					txtReleaseAmount.value=releasedAmount;
					//alert("Not Allow to enter more value.");
				}
				if(secondLastChar==="b"){
					releasedAmount=releasedAmount.slice(0,-1);
					//sancAmount=sancAmount.replace("b"," ");
					//sancAmount=sancAmount*1000000000;
					txtReleaseAmount.value=releasedAmount;
					//alert("Not Allow to enter more value.");
				}
			}
		}

		function floatingRate(rateType) {
			if(rateType == 'BASE'){
				document.getElementById('intRateFloatingRange').value='<%=BASE_INT_RATE%>';
			}else if(rateType == 'BPLR'){
				document.getElementById('intRateFloatingRange').value='<%=BPLR_INT_RATE%>';
			}else {
				document.getElementById('intRateFloatingRange').value='0';
			}
		}

		function moveBranchAllowedList( srcList, destList, moveAll,category) 
		{
			// Do nothing if source is empty
			if (!hasOptions(srcList) ||
				(( srcList.selectedIndex == -1 ) && ( moveAll == false ) )) { return; } // or nothing is selected 

			var SelID='';
			var SelText='';
			// Move rows from srcList to destList from bottom to top
			for (i=srcList.options.length - 1; i>=0; i--)
			{
				if (srcList.options[i].selected == true || moveAll)
				{
					SelID=srcList.options[i].value;
					SelText=srcList.options[i].text;
					
				/*	if(branchAllowedFlagValues != ""){
						branchAllowedFlagValues = branchAllowedFlagValues + "," + SelID + "#" + operation;
					}else{
						branchAllowedFlagValues = SelID + "#" + operation;
					} */
					
					var newRow = new Option(SelText,SelID);
					destList.options[destList.length]=newRow;
					srcList.options[i]=null;
				}
			}
			sortSelect(destList);

			if(category=='branch'){
			//	alert("test1");
			selectBranchAllowedLists();
			}
			if(category=='product'){
			//	alert("test2");
				selectProductAllowedLists();
			}
			if(category=='currency'){
			//	alert("test3");
				selectCurrencyAllowedLists();
			}

		}
		
		function moveDualList( srcList, destList, moveAll,operation) 
		{
			// Do nothing if source is empty
			if (!hasOptions(srcList) ||
				(( srcList.selectedIndex == -1 ) && ( moveAll == false ) )) { return; } // or nothing is selected 

			var SelID='';
			var SelText='';
			// Move rows from srcList to destList from bottom to top
			for (i=srcList.options.length - 1; i>=0; i--)
			{
				if (srcList.options[i].selected == true || moveAll)
				{
					SelID=srcList.options[i].value;
					SelText=srcList.options[i].text;
					
					var newRow = new Option(SelText,SelID);
					destList.options[destList.length]=newRow;
					srcList.options[i]=null;
				}
			}
			sortSelect(destList);
			
			var temp="";
			if(operation=="Add"){
				for(var i=0;i<destList.length-1;i++){
					temp+=destList[i].value+",";
				}
				temp+=destList[destList.length-1].value
				document.getElementById('udfAllowed').value=temp;
			}
			if(operation=="Delete"){
				if(srcList.length==0)
					document.getElementById('udfAllowed').value="";
				
				for(var i=0;i<srcList.length-1;i++){
					temp+=srcList[i].value+",";
				}
				temp+=srcList[srcList.length-1].value
				document.getElementById('udfAllowed').value=temp;
			}	
		}

	function moveDualList_2( srcList, destList, moveAll,operation) 
		{
			// Do nothing if source is empty
			if (!hasOptions(srcList) ||
				(( srcList.selectedIndex == -1 ) && ( moveAll == false ) )) { return; } // or nothing is selected 

			var SelID='';
			var SelText='';
			// Move rows from srcList to destList from bottom to top
			for (i=srcList.options.length - 1; i>=0; i--)
			{
				if (srcList.options[i].selected == true || moveAll)
				{
					SelID=srcList.options[i].value;
					SelText=srcList.options[i].text;
					
					var newRow = new Option(SelText,SelID);
					destList.options[destList.length]=newRow;
					srcList.options[i]=null;
				}
			}
			sortSelect(destList);
			
			var temp="";
			if(operation=="Add"){
				for(var i=0;i<destList.length-1;i++){
					temp+=destList[i].value+",";
				}
				temp+=destList[destList.length-1].value
				document.getElementById('udfAllowed_2').value=temp;
			}
			if(operation=="Delete"){
				if(srcList.length==0)
					document.getElementById('udfAllowed_2').value="";
				
				for(var i=0;i<srcList.length-1;i++){
					temp+=srcList[i].value+",";
				}
				temp+=srcList[srcList.length-1].value
				document.getElementById('udfAllowed_2').value=temp;
			}	
		}
		function hasOptions(obj) 
		{
			if (obj!=null && obj.options!=null && obj.options.length>0) { return true; }
			return false;
		}

		function sortSelect(obj) 
		{
			var o = new Array();
			if (!hasOptions(obj)) { return; }

			for (var i=0; i<obj.options.length; i++) {
				o[o.length] = new Option( obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected) ;
			}
			if (o.length==0) { return; }
			o = o.sort(
				function(a,b) {
					if ((a.text+"") < (b.text+"")) { return -1; }
					if ((a.text+"") > (b.text+"")) { return 1; }
					return 0;
				}
			);

			for (var i=0; i<o.length; i++) {
				obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
			}
		}

		function selectAllOptions(selectElement) {  
				for( len = 0; len < selectElement.options.length; len++ ){
					selectElement.options[ len ].selected = true;
				}
		}
		
		function selectBranchAllowedLists(){
			var destList = document.forms[0].aliasBranchCodes;
		 	var temp="";
		
				for(var i=0;i<destList.length-1;i++){
					temp+=destList[i].value+",";
				}
				
				if(destList.length!=0){
				temp+=destList[destList.length-1].value
				}
				document.getElementById('branchAllowed').value=temp;
			
		//	alert("temp:"+temp);
		 

		}
		function selectProductAllowedLists(){
			
			var destList = document.forms[0].productCodes;
		 	var temp="";
		
				for(var i=0;i<destList.length-1;i++){
					temp+=destList[i].value+",";
				}
				if(destList.length!=0){
				temp+=destList[destList.length-1].value
				}
				document.getElementById('productAllowed').value=temp;
		}
		function selectCurrencyAllowedLists(){
			
			var destList = document.forms[0].currencyCodes;
		 	var temp="";
		
				for(var i=0;i<destList.length-1;i++){
					temp+=destList[i].value+",";
				}
				if(destList.length!=0){
				temp+=destList[destList.length-1].value
				}
				document.getElementById('currencyAllowed').value=temp;
		}

		/* function checkboxCurrencyRestriction(){

			if(document.getElementById("currencyRestriction").value=='N'){
				document.getElementById("currencyRestriction").value= "Y";
			}else if(document.getElementById("currencyRestriction").value==''){
				document.getElementById("currencyRestriction").value= "Y";
			}else{
				document.getElementById("currencyRestriction").value= "N";
			}
			
		} */

		function checkboxSendToFile(){
	//alert("1:"+document.getElementById("sendToFile").value+" IndexId: senToFile:"+document.forms[0].indexID.value+" action:"+document.getElementById("lineAction").value+" chk 1:"+document.getElementById("limitSendToFile").checked
	//		+" serailNo:"+document.getElementById("serialNo").value);

	if(document.getElementById("sendToFile").value=='N'){
		if((document.forms[0].indexID.value=='' && document.getElementById("lineAction").value=='')
				|| (document.forms[0].indexID.value!=='' && document.getElementById("lineAction").value=='NEW')){
			if(document.getElementById("serialNo").value==''){
				document.getElementById("serialNo").readOnly=true;
				document.getElementById("sendToFile").value= "Y";
			}
			else{
				document.getElementById("serialNo").value='';
				document.getElementById("serialNo").readOnly=true;
				document.getElementById("sendToFile").value= "Y";
				//alert("Please clear the Serial No value.");
				//document.getElementById("limitSendToFile").checked=false;
				
			}
		}else{
		
			document.getElementById("serialNo").readOnly=true;
			document.getElementById("sendToFile").value= "Y";
		}
		
	}else if(document.getElementById("sendToFile").value==''){
		document.getElementById("sendToFile").value= "N";
		if((document.forms[0].indexID.value=='' && document.getElementById("lineAction").value=='')
				|| (document.forms[0].indexID.value!=='' && document.getElementById("lineAction").value=='NEW')){
		document.getElementById("serialNo").readOnly=false;
		}
	}else if(document.getElementById("sendToFile").value=='Y'){
		document.getElementById("sendToFile").value= "N";
		if((document.forms[0].indexID.value=='' && document.getElementById("lineAction").value=='')
				|| (document.forms[0].indexID.value!=='' && document.getElementById("lineAction").value=='NEW')){
		document.getElementById("serialNo").readOnly=false;
		}
	}
			
		}
 
		window.onload = function(){ 
		//	alert("Inside clearField:sendToFile:"+document.getElementById("sendToFile").value+" serial No:"+document.getElementById("serialNo").value
		//			+" IndexId:"+document.forms[0].indexID.value+" action:"+document.forms[0].lineAction.value+" chk:"+document.getElementById("limitSendToFile").checked);
			if(document.getElementById("sendToFile").value=='N'){
				if((document.forms[0].indexID.value=='' && (document.forms[0].lineAction.value=='NEW' || document.forms[0].lineAction.value=='')) || ( document.forms[0].lineAction.value=='NEW')){
					document.getElementById("serialNo").readOnly=false;
				}
			}
			
		//	alert("lineAction:"+document.forms[0].lineAction.value+" status:"+document.forms[0].status.value+" facilitySystemID:"+document.getElementById("facilitySystemID").value);
			var flag=true;
			if(("" == document.forms[0].lineAction.value && "" ==  document.forms[0].status.value) ||
          			(null== document.forms[0].lineAction.value &&  null ==  document.forms[0].status.value) ||
          			('NEW' == document.forms[0].lineAction.value && 
          			"PENDING_UPDATE" ==  document.forms[0].status.value ) || (""== document.forms[0].lineAction.value &&  "ND" ==  document.forms[0].status.value) || (""== document.forms[0].lineAction.value &&  "ACTIVE" ==  document.forms[0].status.value)  ) {
				flag=false;
			}
			if(flag){
			var  facilitySystemID=document.forms[0].facilitySystemID;
			//	alert("facilitySystemID:"+facilitySystemID+" index:"+facilitySystemID.selectedIndex+" length:"+facilitySystemID.length);
				var systemIdValue=facilitySystemID.options[facilitySystemID.selectedIndex].value;
				var systemIdText=facilitySystemID.options[facilitySystemID.selectedIndex].text;
			
	//		 alert("systemIdValue:"+systemIdValue+" systemIdText:"+systemIdText);
			 
			 	for(var i=facilitySystemID.options.length-1;i>=0;i--)
			 	{
			 		facilitySystemID.remove(i);
			 	}
			 	var opt=document.createElement("option");
			 	opt.text = systemIdText;
			 	opt.value = systemIdValue;
			 	facilitySystemID.add(opt);
		}
				
		/* 	 var liabBranchFlag=false;
			if(("" == document.forms[0].lineAction.value && "" ==  document.forms[0].status.value) ||
          			(null== document.forms[0].lineAction.value &&  null ==  document.forms[0].status.value) ||
          			('NEW' == document.forms[0].lineAction.value && 
          			"PENDING_UPDATE" ==  document.forms[0].status.value ) ) {
				liabBranchFlag=true;
			} 
			
		//	alert("liabBranchFlag:"+liabBranchFlag);
			
			var hiddenLiabBranch=document.getElementById("hiddenLiabBranch").value;
			var  liabBranch=document.forms[0].liabBranch;
			//	alert(" liabBranch:"+liabBranch+" liabBranch length:"+liabBranch.length+" liabBranch.selectedIndex:"+liabBranch.selectedIndex);
			//	alert("liabBranch value:"+liabBranch.value+" liabBranch text:"+liabBranch.label);
				
				var liabBranchValue;
				var liabBranchText;
				
				if(liabBranchFlag){
				//	alert("1");
					if(''!=hiddenLiabBranch && 'null'!= hiddenLiabBranch){
				//		alert("2");
					
					for(var i=liabBranch.options.length-1;i>=0;i--)
				 	{
						
						var val=liabBranch.options[i].value;
						hiddenLiabBranch=hiddenLiabBranch.replace(/^\s+|\s+$/g, '');
						if(hiddenLiabBranch == val){
							liabBranchValue=hiddenLiabBranch;
							liabBranchText=liabBranch.options[i].text;
							break; 
						}
				 	}}else{
				 	//	alert("inside else");
				 		for(var i=liabBranch.options.length-1;i>=0;i--)
					 	{
				 			if(liabBranch.value == liabBranch.options[i].value){
				 		//		alert("if value match");
							liabBranchValue=liabBranch.value;
							liabBranchText=liabBranch.options[i].text;
						//	alert("liabBranchValue else:"+liabBranchValue+" liabBranchText else:"+liabBranchText);
							break;
						}
					 }
				 	}
				}else{ 
				 liabBranchValue=liabBranch.options[liabBranch.selectedIndex].value;
				 liabBranchText=liabBranch.options[liabBranch.selectedIndex].text;
				}
		//	 alert("liabBranchValue:"+liabBranchValue+" liabBranchText:"+liabBranchText);
			 
			 	for(var i=liabBranch.options.length-1;i>=0;i--)
			 	{
			 		liabBranch.remove(i);
			 	}
			 	var opt=document.createElement("option");
			 	opt.text = liabBranchText;
			 	opt.value = liabBranchValue;
			 	liabBranch.add(opt);  */
			 	
		}

		//fetch co borrower name WS 
		function fetchCoBorrowerNameWS(){ 
			
			var facilitySystem = document.getElementById("facilitySystem").value; 
			var coBorrowerDropDown = document.getElementById("coBorrowerId"); 
			var coBorrowerDropDownId = coBorrowerDropDown.options[coBorrowerDropDown.selectedIndex].value;

			 var xmlhttp;
			 if (window.XMLHttpRequest)
			 {// code for IE7+, Firefox, Chrome, Opera, Safari
			  xmlhttp=new XMLHttpRequest();
			 }
			 else
		  	 {// code for IE6, IE5
		  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		     }
		     var systemId;   
		   
			 var partyId= '<%=partyId%>';
		     var lineNo=document.getElementById("lineNo").value;
		     var serialNo=document.getElementById("serialNo").value; 
		   //  alert("readyState: "+xmlhttp.readyState);
		//	 alert("status: "+xmlhttp.status);
		
		     if("UBS-LIMITS" == facilitySystem) {
				 
			 xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_CoBorrowerName_FCUBS&systemId="+systemId+"&lineNo="+lineNo+"&serialNo="+serialNo+"&partyId="+partyId+"&coBorrowerDropDownId="+coBorrowerDropDownId,true);
			 xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		     xmlhttp.send();
		     
			} if("BAHRAIN" == facilitySystem) {
					 
					 xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_CoBorrowerName_BH&systemId="+systemId+"&lineNo="+lineNo+"&serialNo="+serialNo+"&partyId="+partyId+"&coBorrowerDropDownId="+coBorrowerDropDownId,true);
					 xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				     xmlhttp.send();
				     
		    } if("HONGKONG" == facilitySystem) {
					 
					 xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_CoBorrowerName_HK&systemId="+systemId+"&lineNo="+lineNo+"&serialNo="+serialNo+"&partyId="+partyId+"&coBorrowerDropDownId="+coBorrowerDropDownId,true);
					 xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				     xmlhttp.send();
				     
		    } if("GIFTCITY" == facilitySystem) {
							 
							 xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_CoBorrowerName_GC&systemId="+systemId+"&lineNo="+lineNo+"&serialNo="+serialNo+"&partyId="+partyId+"&coBorrowerDropDownId="+coBorrowerDropDownId,true);
							 xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
						     xmlhttp.send();
		    } if("Singapore" == facilitySystem) {
				 
				 xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_CoBorrowerName_SG&systemId="+systemId+"&lineNo="+lineNo+"&serialNo="+serialNo+"&partyId="+partyId+"&coBorrowerDropDownId="+coBorrowerDropDownId,true);
				 xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			     xmlhttp.send();							     
						     
			}
		    
		     xmlhttp.onreadystatechange=function()
				{
		    	
				 if (xmlhttp.readyState==4 && xmlhttp.status==200)
				 {
				 		document.getElementById('fcubsCoBorrowerResponceText').innerHTML =  xmlhttp.responseText;
				 		
				 		var str=document.getElementById('fcubsCoBorrowerResponceText').innerHTML;
				 		if(str.indexOf("fcubsCoBorrowerResponce")==-1){
				 	
				 		if(str.indexOf("coborrowerName:")!=-1){
						var sep=str.indexOf(":");
				 		var coborrowerNm=str.substr(sep+1);
				 	//	alert("coborrowerNm from WS:"+coborrowerNm);
				 		document.getElementById('coBorrowerName').value=coborrowerNm ;
				 		}
				 		}
				 		else{
				 	//		alert(str);
				 		}
				 
				 }
				}
				 
		
		     
		} //End Co Borrower WS
		     
		function getUtilizedAmount(guarantee,liabilityId){
			var utilizedAmount=document.getElementById("utilizedAmount").value;
			
		//	alert('getUtilizedAmount:guarantee:'+guarantee+" liabilityId:"+liabilityId+"utilizedAmt:"+utilizedAmount);

			 var xmlhttp;
			 if (window.XMLHttpRequest)
			 {// code for IE7+, Firefox, Chrome, Opera, Safari
			  xmlhttp=new XMLHttpRequest();
			 }
			 else
		  	 {// code for IE6, IE5
		  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		     }

			  //alert("status: "+xmlhttp.status);
			 	
		     var systemId;   
		     var liabilityId;
		   //  alert("systemId");
			 if(guarantee!==null && 'Yes'===guarantee){
			//	 alert("if");
				liabilityId=liabilityId;
				var  facilitySystemID=document.forms[0].facilitySystemID;
				var systemId=facilitySystemID.options[facilitySystemID.selectedIndex].value;
				 
				 
			 }else{
			//	 alert("else");
				
				var  facilitySystemID=document.forms[0].facilitySystemID;
			//	alert("facilitySystemID:"+facilitySystemID);
				var systemId=facilitySystemID.options[facilitySystemID.selectedIndex].value;
			//	 alert("else 2:"+facilitySystemID+" systemId:"+systemId);
				liabilityId='';
				  
			 }
			 
			 var partyId= '<%=partyId%>';
			// alert("systemId:"+systemId);
		     var lineNo=document.getElementById("lineNo").value;
		  //   alert("lineNo:"+lineNo);
		     var serialNo=document.getElementById("serialNo").value; 

		   //  alert("systemId:"+systemId+" lineNo:"+lineNo+" serialNo:"+serialNo);
		     
		     xmlhttp.onreadystatechange=function()
				{
				 //alert("readyState: "+xmlhttp.readyState);
				 //alert("status: "+xmlhttp.status);
				 if (xmlhttp.readyState==4 && xmlhttp.status==200)
				 {
					// alert("responcetext:"+xmlhttp.responseText);
					// eval(xmlhttp.responseText);
				 	
				 		document.getElementById('fcubsFacilityResponce').innerHTML =  xmlhttp.responseText;
				 		
				 		var str=document.getElementById('fcubsFacilityResponce').innerHTML;
				 	//	alert(str);
				 	//	alert("unable:"+str.indexOf("Unable"));
				 	//	alert("No:"+str.indexOf("No"));
				 	//	if(str.indexOf("Unable")==-1 && str.indexOf("No")==-1){
				 		if(str.indexOf("fcubsResponce")==-1){
				 	//	var amount=str.substr(16);
				 	//	alert("amount==="+amount);
				 		alert(str);
				 		if(str.indexOf("utilizedAmt:")!=-1){
						var sep=str.indexOf(":");
					//	alert(sep);
				 		var amount=str.substr(sep+1);
				 	//	alert("amount:"+amount);
				 		amount=formatAmountAsCommaSeparated1(amount);
				 	//	alert("amount 2:"+amount);
				 		document.getElementById('utilizedAmount').value=amount ;
				 		}
				 		}
				 		else{
				 			alert(str);
				 		}
				 
				 }
				}
			 xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_utilizedAmt&systemId="+systemId+"&lineNo="+lineNo+"&serialNo="+serialNo+"&liabilityId="+liabilityId+"&utilizedAmount="+utilizedAmount+"&partyId="+partyId,true);
			 xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		     xmlhttp.send();

		} 
		
		function fetchLiabBranch(systemID){
			var partyId= '<%=partyId%>';
			var guarantee= '<%=guarantee%>';
			var liabilityId= '<%=liabilityId%>';
		//	alert("fetchLiabBranch"+" guarantee:"+guarantee+" liabilityId:"+liabilityId);
			var xmlhttp;
			if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp=new XMLHttpRequest();
			}else{// code for IE6, IE5
				xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
			}
			 var systemIdValue;   
		 	if(guarantee!==null && 'Yes'=== guarantee){
		 		//systemIdValue=liabilityId;
		 		systemIdValue=systemID.value;
			//	alert("guarantee is Yes and "+systemIdValue);
		 		xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_LiabBranch&sysLiabID="+systemIdValue+"&partyId="+partyId,true);
				xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				xmlhttp.send();
			}else{
				systemIdValue=systemID.value
			//	alert("guarantee is no and "+systemIdValue);
				
					xmlhttp.open("GET","/cms/MIAcntDetail.do?event=fetch_LiabBranch&sysLiabID="+systemIdValue+"&partyId="+partyId,true);
					xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
					xmlhttp.send();
				
			}
		 	
			
			
		 	xmlhttp.onreadystatechange=function(){
				
			 	if (xmlhttp.readyState==4 && xmlhttp.status==200)
			 	{
			 		//alert(xmlhttp.responseText);
			 		document.getElementById('fcubsLiabBranchResponce').innerHTML =  xmlhttp.responseText;
			 		var fcubsLiabBranch=document.getElementById('fcubsLiabBranchResponce').innerHTML;
			 //	alert("index of - "+fcubsLiabBranch.indexOf("-"));
				//alert("index of : "+fcubsLiabBranch.indexOf(":"));
					//if(fcubsLiabBranch.indexOf("Unable")==-1 ){
						if(fcubsLiabBranch.indexOf("fcubsLiabResponce")==-1){
				 		var fcubsLiabBranchText=fcubsLiabBranch.substr(fcubsLiabBranch.indexOf(":")+1,((fcubsLiabBranch.indexOf("-")-(fcubsLiabBranch.indexOf(":")+1))));
				 		var fcubsLiabBranchValue=fcubsLiabBranch.substr(fcubsLiabBranch.indexOf("-")+1);
				 	//	alert("fcubsLiabBranchText:"+fcubsLiabBranchText+"fcubsLiabBranchValue:"+fcubsLiabBranchValue);
				 		var  liabBranch=document.forms[0].liabBranch;
					//	alert("liabBranch"+liabBranch);
						alert("fcubsLiabBranch:"+fcubsLiabBranchText);
					 /* 	for(var j=liabBranch.options.length-1;j>=0;j--)
					 	{	
							liabBranch.remove(j);
					 	}
					 	var opt=document.createElement("option");
								opt.text = fcubsLiabBranchText;
							 	opt.value = fcubsLiabBranchValue;
						
					 	liabBranch.add(opt); */
				 	//	document.getElementById('liabBranch').text=liabBranch
				 	
				 	 for(var j=liabBranch.options.length-1;j>=0;j--)
							{	
							 if(liabBranch.options[j].text==fcubsLiabBranchText){
								// alert("liabBranch.options[j].text:"+liabBranch.options[j].text);
							 
							liabBranch.options[j].selected=true;
							}
							}
				 	}else{
				 		
				 		alert(fcubsLiabBranch);
				 		}
			 	
				} 
			}
		 }

		 	
		function	 checkboxDayLightLimitApproved(){
			 if(document.forms[0].dayLightLimitApproved[0].checked){
			 document.forms[0].intradayLimitExpiryDate.value = document.forms[0].dateOfReset.value;
			 //document.forms[0].dayLightLimitApproved.value = "Yes";
			 document.getElementById('dayLightLimitApproved').value = "Yes";
		 }else{
			 document.getElementById('dayLightLimitApproved').value = "No";
			 document.forms[0].intradayLimitExpiryDate.value = "";
			// alert(document.forms[0].dayLightLimitApproved.value);
		 }
		 }
		
		function viewConvenantScreen(name)
		{
			var adhocFac = '<%=adhocFacility%>';
		
			document.forms[0].action="MIAcntDetail.do?event="+name+"&adhocFacility="+adhocFac;
		    document.forms[0].submit();
		}
		

		function ValidateParty(){
			//alert('Inside Validate');
			var partyScmFlag =  '<%=partyScmFlag%>';
			 if(partyScmFlag == 'No'){
				 alert("Borrower SCM flag on party UDF should be Y for this borrower");
			 }
			 }
		
		 window.onload = function(){
			if(document.getElementById("scmFlag").value == "Yes"){
				ValidateParty();
			}
		 }
		 
       //Co-Borrower Delete 
		  function deleteRestCoBorrower(coBorrowerId,index) {
				document.forms[0].action = "MIAcntDetail.do?coBorrowerId=" +coBorrowerId +"&indexIDD="+index;		
				document.forms[0].event.value = "delete_coBorrower_rest";
				document.forms[0].submit();
			}	     
     
		  var lineCoBorrowerLiabIds = "[" +'<%=lineCoBorrowerLiabIds%>' + "]";  
		//  var coBorrowerIdArr = JSON.parse( lineCoBorrowerLiabIds);
		  var coBorrowerIdArr = jQuery.parseJSON(lineCoBorrowerLiabIds);
		  //console.log("LineCoBorrowerLiabIds:--"+lineCoBorrowerLiabIds+"--");

          //Add Co-Borrower
			function addCoBorrower(){
			//	document.getElementById('coBorrowerId').disabled = true;
			//	document.getElementById('coBorrowerName').disabled = true;
				var coBorrowerDropDown = document.getElementById("coBorrowerId"); 
				var coBorrowerId = coBorrowerDropDown.options[coBorrowerDropDown.selectedIndex].value;
				var coBorrowerName =  document.getElementById('coBorrowerName').value;
			//	alert("coBorrowerId::"+coBorrowerId+"  && coBorrowerName::"+coBorrowerName)
				
				if(validateInput(coBorrowerId))
					return;
			
				
		//	alert(" ## "+coBorrowerName);
			document.forms[0].action="MIAcntDetail.do?coBorrowerName="+coBorrowerName;
            var pageType="";
		<%	
	   //	System.out.println("event:"+event+" fromPage:"+fromPage); 
		if(event.equals("prepare_update_ubs") || event.equals("edit_released_line_details") || "add_coBorrower".equals(event)){ %>	
					pageType="edit_line";
					document.forms[0].event.value = "add_coBorrower";

				<%}else{%>
			       	pageType="create_line";		
			       	document.forms[0].event.value = "add_coBorrower_create";

				<%}%>
			document.forms[0].submit();
			setLineCoBorrowerLiabIds();
			}
			
 function validateInput(coBorrowerId){
			  //	alert("validateInput id=="+coBorrowerId)
				  if("" == coBorrowerId){
				  		document.getElementById("restCoBorrowerListError")
				  		.innerHTML = "<font color=red size=1 >Select Co-Borrower</font>";
				  		
				  		return true;
				  	}
			  document.getElementById("restCoBorrowerListError").innerHTML = "";
			 //alert("coBorrowerIdArr.length ==="+coBorrowerIdArr.length)
			  	if(coBorrowerIdArr.length === 5){
			  		document.getElementById("restCoBorrowerListError")
			  		.innerHTML = "<font color=red size=1 >Maximum 5 Co-Borrowers are allowed</font>";
			  		return true;
			  	}

			  for(var i = 0 ; i < coBorrowerIdArr.length ; i++) {
			//  	alert("coBorrowerIdArr[i]:: "+coBorrowerIdArr[i]+ "   && coBorrowerId:: "+coBorrowerId )
			  		if(coBorrowerIdArr[i] == coBorrowerId) {
			  			document.getElementById("restCoBorrowerListError")
			  			.innerHTML = "<font color=red size=1 >Duplicate Co-Borrower, Co-Borrower Liab Id "+coBorrowerId+" is already added.</font>";
			  			 return true;
			  		}
			  }
	}
	
	function setLineCoBorrowerLiabIds(){
		var latestCoBorrowerIds = coBorrowerIdArr.join(",");
		//console.log("latestCoBorrowerIds: "+latestCoBorrowerIds);
		document.getElementById("lineCoBorrowerIds").value=latestCoBorrowerIds;
		//console.log("lineCoBorrowerIds.value: "+document.getElementById("lineCoBorrowerIds").value);
	}
			 
	
	function parseDate(s) {
		  var months = {jan:0,feb:1,mar:2,apr:3,may:4,jun:5,
		                jul:6,aug:7,sep:8,oct:9,nov:10,dec:11};
		  var p = s.split('/');
		  return new Date(p[2], months[p[1].toLowerCase()], p[0]);
		}
	
	function populateIdlExpiryDate(idlEffectiveDate){
		if(idlEffectiveDate.value != ""){
		var ss=parseDate(idlEffectiveDate.value);
			// alert("sss"+ss);
			var result = new Date(ss);
			var mmmm =   result.setDate(result.getDate() + 1);
			 // alert("result"+result);
		//alert("final:: "+ Moment(result).format('DD/MM/YYYY'));
		//var parsed1 = moment(result).format('MM/DD/YYYY');
		//alert("final:: "+ parsed1);
			  //var datemilli = Date.parse(result);
				//alert('1111=>'+taskDate(datemilli));
				//var ffdate = formatDate(mmmm);
				var ffdate1 = formatDate1(mmmm);
				ffdate1 = ffdate1.replace(/-/g,'/');
				//var qqq = ffdate1.split(' ');
				//alert(qqq[1]);
				//ffdate1 = qqq[0] +'/'+ qqq[1].substring(0,3) +'/'+ qqq[2];
				//ffdate1 = ffdate1.substring(0, 11);
				//ffdate1 = ffdate1.replace(/ /g,'/');
				//ffdate1 = ffdate1.replace(' ','/');
				//alert('666=>'+ffdate1);
				document.getElementById("idlExpiryDate1").value=ffdate1;
		}else{
			document.getElementById("idlExpiryDate1").value="";
		}
			}
			
			
	function taskDate(dateMilli) {
	    var d = (new Date(dateMilli) + '').split(' ');
	    d[2] = d[2] + ',';

	    return [d[0], d[1], d[2], d[3]].join(' ');
	}

	 /* function formatDate(date) {
	    var d = new Date(date),
	        month = '' + (d.getMonth() + 1),
	        day = '' + d.getDate(),
	        year = d.getFullYear();

	    if (month.length < 2) 
	        month = '0' + month;
	    if (day.length < 2) 
	        day = '0' + day;

	    //return [year, month, day].join('/');
	    return [day, month, year].join('/');
	}  */
	
	function formatDate1(value) {
	    var date = new Date(value);
	    var day = date.toLocaleString('en-US',{ day: '2-digit' });
	    
	    var month = date.toLocaleString('en-US', { month: 'short' });
	   // alert(month);
	   // month = month.substring(0, 2);
	    var year = date.toLocaleString( 'en-US',{ year: 'numeric' });
	    //alert(day + '-' + month + '-' + year);
	    return day + '-' + month + '-' + year;
	   // return month;
	}
	
	
	
	function onBlurEventIDLAmount(txtReleaseAmount){
		var releasedAmount=txtReleaseAmount.value;
		//alert("txtReleaseAmount=>"+releasedAmount);
		var len="";
		if(releasedAmount.length>=1 && releasedAmount.length<=43){
			var secondLastChar=releasedAmount.charAt(releasedAmount.length-1);
			if(secondLastChar==="M"){
				//sancAmount=sancAmount.slice(0,-1);
				releasedAmount=releasedAmount.replace("M"," ");
				releasedAmount=releasedAmount*1000000;
				//alert(sancAmount);
				len=releasedAmount.toString().length;
				if(len<=43 && releasedAmount.toString().charAt(1)!=="e"){
					txtReleaseAmount.value=releasedAmount;
				}else{
					txtReleaseAmount.value="";
				}
				
				//alert(sancAmount.toString().charAt(1));
				
			}
			else if(secondLastChar==="m"){
				//sancAmount=sancAmount.slice(0,-1);
				releasedAmount=releasedAmount.replace("m"," ");
				releasedAmount=releasedAmount*1000000;
				len=releasedAmount.toString().length;
				if(len<=43 && releasedAmount.toString().charAt(1)!=="e"){
					txtReleaseAmount.value=releasedAmount;
				}else{
					txtReleaseAmount.value="";
				}
				
			}
			else if(secondLastChar==="B"){
				//sancAmount=sancAmount.slice(0,-1);
				releasedAmount=releasedAmount.replace("B"," ");
				releasedAmount=releasedAmount*1000000000;
				len=releasedAmount.toString().length;
				if(len<=43 && releasedAmount.toString().charAt(1)!=="e"){
					txtReleaseAmount.value=releasedAmount;
				}else{
					txtReleaseAmount.value="";
				}
			}
			else if(secondLastChar==="b"){
				//sancAmount=sancAmount.slice(0,-1);
				releasedAmount=releasedAmount.replace("b"," ");
				releasedAmount=releasedAmount*1000000000;
				len=releasedAmount.toString().length;
				if(len<=43 && releasedAmount.toString().charAt(1)!=="e"){
					txtReleaseAmount.value=releasedAmount;
				}else{
					txtReleaseAmount.value="";
				}
			}
			else if(secondLastChar == 0 || secondLastChar == 1|| secondLastChar == 2|| 
					secondLastChar == 3|| secondLastChar == 4|| secondLastChar == 5|| secondLastChar == 6
					|| secondLastChar == 7 || secondLastChar == 8 || secondLastChar == 9){
				len=releasedAmount.toString().length;
				if(len<=43){
					txtReleaseAmount.value=releasedAmount;
				}else{
					txtReleaseAmount.value="";
				}
			}
			else{
				//alert("Please enter numeric value only.");
				txtReleaseAmount.value="";
			}
			
		}
		else{
			//alert("Please enter numeric value only.");
			txtReleaseAmount.value="";
		}
	}
	

 </script>
<html:hidden name="XRefDetailForm" property="lineCoBorrowerLiabIds" styleId="lineCoBorrowerIds" value="<%=form.getLineCoBorrowerLiabIds()%>"/>
<html:hidden name="LmtDetailForm" property="facCoBorrowerLiabIds" styleId="facCoBorrowerIds" value="<%=facCoBorrowerLiabIds%>"/>

  <p class="required"><font color="#0000FF">*</font> Mandatory for Submission&nbsp;&nbsp;&nbsp;&nbsp;</p>	
  <input type="hidden" name="event" value=""/> 
  <html:hidden property="fromEvent"/>
  <input type="hidden" name="fromEventForLineCov" value="<%=request.getAttribute("fromEventForLineCov") %>"/>
  <input type="hidden" name="isLineCreate" value="<%=request.getAttribute("isLineCreate") %>"/>
  <html:hidden property="limitProfileID"/>
  <html:hidden property="indexID" styleId="indexID"/>
  <input type="hidden" name="isCreate" value="<%=StringUtils.isNotBlank(request.getParameter("isCreate")) ? request.getParameter("isCreate") : (String)request.getAttribute("isCreate")%>"/> 
  <html:hidden property="customerID"/>
  
  <input type="hidden" name="inrValue"/>
  <input type="hidden" name="facilityType" value="<%=request.getParameter("facilityType") != null? request.getParameter("facilityType") : (String)request.getAttribute("facilityType")%>">
 <input type="hidden" name="adhocFacility"  value="<%=adhocFacility %>">
 <input type="hidden" name="adhocFacilityExpDate" value="<%=request.getParameter("adhocFacilityExpDate") %>"/>
  <input type="hidden" name="adhocLastAvailDate" value="<%=request.getParameter("adhocLastAvailDate") %>">
<input type="hidden" name="adhocTenor" value="<%=request.getParameter("adhocTenor") %>">
   <input type="hidden" name="adhocFacilityNew"  value="<%=request.getParameter("adhocFacilityNew") %>">
 
 <input type="hidden" name="facCat" value="<%=request.getParameter("facCat") != null? request.getParameter("facCat") : (String)request.getAttribute("facCat") %>"/>
 
 <input type="hidden"  name="inrValue" readonly="readonly" value="<%=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.inrValue") %>"/>
    <input type="hidden" name="fundedAmount" value="<%=(String)request.getAttribute("fundedAmount") %>"/>
	<input type="hidden" name="nonFundedAmount" value="<%=(String)request.getAttribute("nonFundedAmount")  %>" />
    <input type="hidden" name="memoExposer"  value="<%=(String)request.getAttribute("memoExposer")  %>" />
	<input type="hidden" name="sanctionedLimit"	value="<%=(String)request.getAttribute("sanctionedLimit") %>" />
  <%System.out.println("+++++++memoExposer+++++"+request.getAttribute("memoExposer")); %>
   <bean:define id="formObj" name="XRefDetailForm" scope="request" type="com.integrosys.cms.ui.manualinput.limit.XRefDetailForm"/>
   
   <input type="hidden" name="intradayLimitFlag"	value="<%=intradayLimit%>" /> 
   
  <input type="hidden" name="createdBy"	value="<%=(formObj.getCreatedBy()==null)?"":formObj.getCreatedBy()%>" />
 
  <input type="hidden" name="createdOn"	value="<%=(formObj.getCreatedOn()==null)?"":formObj.getCreatedOn()%>" />
  
   <input type="hidden" name="hiddenSerialNo"	value="<%=(formObj.getHiddenSerialNo()==null)?"":formObj.getHiddenSerialNo()%>" />
    <input type="hidden" name="edited"	value="<%=(formObj.getEdited()==null)?"":formObj.getEdited()%>" />
  
  <input type="hidden" name="updatedBy"	value="<%= (formObj.getUpdatedBy()==null)?"":formObj.getUpdatedBy()%>" />
  <input type="hidden" name="updatedOn"	value="<%=(formObj.getUpdatedOn()==null)?"":formObj.getUpdatedOn()%>" />

<input type="hidden" name="idlApplicableFlagCheck"	value="<%=formObj.getIdlApplicableFlagCheck()%>" />
<input type="hidden" name="releaseableAmountCheck"	value="<%=formObj.getReleaseableAmountCheck()%>" />

<html:hidden property="lineAction" styleId="lineAction"/>
<html:hidden property="status" styleId="status"/>
<html:hidden property="sourceRefNo"/>
 <jsp:include page="udf_hidden_limit.jsp"></jsp:include>
  <jsp:include page="udf_limit_hidden_error.jsp"></jsp:include>
  <%

  String addUdf= "Add";
  String deleteUdf= "Delete";
  %>
    <%System.out.println("Limit Type:"+formObj.getLimitType());
    System.out.println("+++++++++++++++++IDL Applicable Flag:"+formObj.getIdlApplicableFlagCheck());
    System.out.println("+++++++++++++Releaseable Amount:"+formObj.getReleaseableAmountCheck());
    
    String idlApplicableFlagAddFacility1 = (String)request.getAttribute("idlApplicableFlagAddFacility");
    System.out.println("+++++++++++++idlApplicableFlagAddFacility1=>"+idlApplicableFlagAddFacility1);	
    if(null != idlApplicableFlagAddFacility1 && !"".equals(idlApplicableFlagAddFacility1)){
    	formObj.setIdlApplicableFlagCheck(idlApplicableFlagAddFacility1);
    }
    
    %>
  
  <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection">
   <thead>
    <tr> 
     <td><h3>Released Line Details </h3></td>
    </tr>
    <tr> 
      <td><hr /></td>
    </tr>
   </thead>
   <tbody>
    <tr> 
     <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tblInfo">
       <thead>
       </thead> 
       <tbody>
        <tr class="even">
                  
                  <td width="20%" class="fieldname">System ID <font color="#FF0000">*</font> </td>
                   <td width="30%">
          	<%
         
          	if(("".equals(formObj.getLineAction()) && "".equals(formObj.getStatus())) ||
          			(null==formObj.getLineAction() &&  null==formObj.getStatus()) ||
          			(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(formObj.getLineAction()) && 
          			"PENDING_UPDATE".equals(formObj.getStatus())) || (null==formObj.getLineAction() &&  "ND".equals(formObj.getStatus())) || (null==formObj.getLineAction() &&  "ACTIVE".equals(formObj.getStatus()))) {%>
                  	<html:select styleId="facilitySystemID" property="facilitySystemID" onchange="javascript:fetchLiabBranch(this)" >
		      			<option value="">Please Select </option>	
                      	<html:options collection="systemIdList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;
                 <%}else{ %>
                    <html:select styleId="facilitySystemID" property="facilitySystemID">
		      			<html:options collection="systemIdList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;
                    <%} %> 
                  
                    <html:errors property="facilitySystemID"/>
             	</td>
                 
                  
                  <td width="20%" class="fieldname">System</td>
                  <td width="30%"><html:text styleId="facilitySystem" property="facilitySystem" readonly="true"/></td>
                  
           </tr>
           
            <tr class="even">
		 		  <td width="20%" class="fieldname">Liab Branch<font color="#FF0000">*</font> </td>
                  <td width="30%"><html:select property="liabBranch" styleId="liabBranch">
                  <option value=""> </option>	
            			<html:options collection="fccBranchList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;<html:errors property="liabBranch"/></td>
               <%--    <input type="hidden" name="hiddenLiabBranch" id="hiddenLiabBranch"   value="<%=request.getParameter("liabBranch") %>"/> --%>
                 <td class="fieldname"><p>Currency Restriction</p></td>
                  <td>
                               <%System.out.println("+++++++getCurrencyRestriction+++++"+formObj.getCurrencyRestriction()); %>
								<% if(null!=currencyRestriction && currencyRestriction.equalsIgnoreCase("Yes")){%>  
								<input type="checkbox"  name="currencyRestriction" property="currencyRestriction" value="Y" checked="true" ></input>
								<html:hidden property="currencyRestriction" styleId="currencyRestriction"/>
								<% }else {%>
								<input type="checkbox"  name="currencyRestriction" property="currencyRestriction"  value="N"></input>
								<html:hidden property="currencyRestriction" styleId="currencyRestriction"/>
								<%} %>
			
        
                       &nbsp;&nbsp;           
                  </td> 
                  
          </tr>
           
          <tr class="even">
          
          		<td width="20%" class="fieldname">Line No.</td>
                  <td width="30%"><html:text property="lineNo" styleId="lineNo" readonly="true"/></td>
          
          		<td width="20%" class="fieldname">Serial No.</td>
          		<%System.out.println("formObj.getAction():"+formObj.getAction()+" formObj.getSendToFile():"+formObj.getSendToFile());if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(formObj.getAction()) && "N".equals(formObj.getSendToFile()) ){ %>
          		 <td width="30%"><html:text property="serialNo" maxlength="2" readonly="true" styleId="serialNo"/>
          		<%}else if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(formObj.getAction())){%>
          			 <td width="30%"><html:text property="serialNo" maxlength="2" readonly="true" value="" styleId="serialNo"/>	
          		<%}else{ %>
          		<td width="30%"><html:text property="serialNo" maxlength="2" readonly="true" styleId="serialNo"/>
                  
                  <%} %>
               
                  <html:errors property="serialNo"/>
                   <html:errors property="accountNo"/></td>
                   
          </tr>
        
          
           <tr class="even">
		 		  <td width="20%" class="fieldname">Main Line Code</td>
                  <td width="30%"><html:select property="mainLineCode" >
		      		<option value="">Please Select </option>	
                      <html:options collection="mainLineCodeList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;<html:errors property="mainLineCode"/></td>
                    
                  <td width="20%" class="fieldname">Currency</td>
                  <td width="30%"><html:text property="currency" readonly="true" value="<%=linecurrency%>"/></td>
                 <%--  <%System.out.println("formObj currency:"+formObj.getCurrency());
                  if(null!=formObj.getCurrency()){%>
                  <td width="30%"><html:text property="currency" readonly="true"/></td>
                  <%}else{ %>
                   <td width="30%"><html:text property="currency" readonly="true" value='<%=currency %>'/></td>
                   <%} %> --%>
          </tr>
          
          <tr class="even">
          
           		  <td class="fieldname">Released&nbsp; Amount <font color="#FF0000">*</font> </td>
                  <td><html:text property="releasedAmount" maxlength="41"  
                  styleId="releasedAmount" onkeyup="onKeyUpEvent(this);" onblur="onBlurEvent(this); enableUtilizedAmount(); javascript:formatAmountAsCommaSeparated(this);"/>
                  <html:errors property="releasedAmount"/></td>
          
          		  <td class="fieldname">Utilized Amount </td>
                  <td><html:text property="utilizedAmount" maxlength="23" styleId="utilizedAmount" 
                  onblur="javascript:formatAmountAsCommaSeparated(this)" readonly="true"/>
                 <% 
                 
                
                	 System.out.println("formObj.getStatus():"+formObj.getStatus()+ " formObj.getAction():"+formObj.getAction()+ " formObj.getLineAction():"+formObj.getLineAction());
                 if(ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(formObj.getLineAction()) || 
                		 (ICMSConstant.FCUBS_STATUS_SUCCESS.equals(formObj.getStatus()))) {%>
                   <input type="button" name="fetchUtilizedAmount" id="fetchUtilizedAmount"  value="Fetch Utilized Amount" class="btnNormal" onclick="getUtilizedAmount('<%=guarantee %>','<%=liabilityId %>')" />
                   
                   <%}
                 else{      %>
                   
                    <input type="button" name="fetchUtilizedAmount" id="fetchUtilizedAmount"  value="Fetch Utilized Amount" class="btnNormal"  disabled=true/>
                    <%} %>
                  <html:errors property="utilizedAmount"/></td>	
                   
          </tr>
         <tr class="even">
                  <td class="fieldname">Released date</td>
                  <td>
                  <html:text property="releaseDate" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','releaseDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('releaseDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp; 
									             <html:errors property="releaseDate"/> </td>           
				<td class="fieldname">Send To File</td>
                  <td>
                  <%if(formObj.getSendToFile()==null || formObj.getSendToFile().equals("")){%>
                  <input type="checkbox" id="limitSendToFile"   checked="true" value="true" onclick="javascript:checkboxSendToFile()"></input>
								<html:hidden property="sendToFile" styleId="sendToFile"/>
								<% }else if(formObj.getSendToFile().equals("Y")){%>
								<input type="checkbox" id="limitSendToFile"   checked="true" value="true" onclick="javascript:checkboxSendToFile()"></input>
								<html:hidden property="sendToFile" styleId="sendToFile"/>
								<%} else if(formObj.getSendToFile().equals("N")){%>
								<input type="checkbox" id="limitSendToFile"  value="false"  onclick="javascript:checkboxSendToFile()"></input>
								<html:hidden property="sendToFile" styleId="sendToFile"/>
								<%} %>
								</td>
                </tr> 
                
           <tr class="even">
		 		 <td width="20%" class="fieldname">Limit Start Date<font color="#FF0000">*</font> </td>
		 		 
		 		<%if(null==formObj.getLimitStartDate()) {%> 
                 <td><html:text property="limitStartDate" style="width:90px" readonly="true" value="<%=appDate %>" onblur="itg_checkform('frmMain','limitStartDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('limitStartDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
                  <%}else{ %>
                   <td><html:text property="limitStartDate" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','limitStartDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('limitStartDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
						 <%} %>
					&nbsp; <html:errors property="limitStartDate"/>
                  <td width="20%" class="fieldname">Limit Expiry Date<font color="#FF0000">*</font> </td>
                  <% 
/*                   System.out.println("+++++++request.getParameter adhocFacility66666 ="+request.getParameter("adhocFacility")); 
 */                  
                   if(null != adhocFacility){
                   if("Y".equalsIgnoreCase(adhocFacility)  ){  %>   
                 <td><input type="text" name="dateOfReset" id ="dateOfReset"  style="width:90px" readonly="true" value="<%=lastExpDate.trim()%>" disabled="true" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick=" lastExpDT()"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp; <html:errors property="dateOfReset"/> </td>
									        <%--   <html:hidden property="dateOfReset"/> --%>
  			<%}else{ %>    
                 <% System.out.println("formObj.getDateOfReset():"+formObj.getDateOfReset());
                 if(null==formObj.getDateOfReset()){  %>
                
                  <td><input type="text" name="dateOfReset" id ="dateOfReset" style="width:90px" readonly="true" value="<%=camExtDateStr %>" onblur="itg_checkform('frmMain','dateOfReset','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('dateOfReset', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp; <html:errors property="dateOfReset"/>
									             
				
					<%}else{   %>
	                  <td><input type="text"  name="dateOfReset"  id ="dateOfReset"  value="<%=formObj.getDateOfReset() %>" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','dateOfReset','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
	                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
										             onclick="showCalendar('dateOfReset', 'dd/mm/y')"
										             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
										             onmouseout="MM_swapImgRestore()"/>&nbsp; <html:errors property="dateOfReset"/>
						<%}
					}} %>
          </tr>
          
          <tr class="even">
         		 <% if("Yes".equalsIgnoreCase(intradayLimit)){%> 
                  <td class="fieldname">Day Light Limit Expiry Date</td>
                  <td>
                  <html:text property="intradayLimitExpiryDate" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','intradayLimitExpiryDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                  <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('intradayLimitExpiryDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp; 
									             <html:errors property="intradayLimitFutureDateError"/>
									         <%--     <html:errors property="intradayLimitExpiryDateError"/> --%>
				 </td> 				          
                  <%}else{ %>
                  <td class="fieldname">Day Light Limit Expiry Date</td>
                   <td>
                  <html:text property="intradayLimitExpiryDate" style="width:90px" readonly="true" disabled="true" onblur="itg_checkform('frmMain','intradayLimitExpiryDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <!-- <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725" hidden=""
									             onclick="showCalendar('intradayLimitExpiryDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/> -->&nbsp; 
									             <html:errors property="intradayLimitFutureDateError"/>
				 </td> 	
                  <%} %>  
                  <% System.out.println("formObj.getIntradayLimitExpiryDate():"+formObj.getIntradayLimitExpiryDate()+"getDayLightLimit:"+formObj.getDayLightLimit()+"+++++++getCurrencyRestriction+++++"+formObj.getCurrencyRestriction());%>
                  <% if("Yes".equalsIgnoreCase(intradayLimit)){%> 
                  <td width="20%" class="fieldname">Day Light Limit</td>
          		  <td width="30%">
          		  	<html:text property="dayLightLimit" styleId="dayLightLimit" onblur="javascript:formatAmountAsCommaSeparated(this)" 
          		 	 maxlength="41" />	 
          		<%--   <html:errors property="dayLightLimitError"/> --%>
          		  <html:errors property="dayLightLimitNumericError"/>
          		  <html:errors property="dayLightLimitDecimalExceed"/>
          		  <html:errors property="dayLightLimitLengthError"/>
          		  <html:errors property="dayLightLimitSpecialCharError"/>
                  </td>
          		  
          		  <%}else{ %>
          		  <td width="20%" class="fieldname">Day Light Limit</td>
          		  <td width="30%"><html:text property="dayLightLimit" styleId="dayLightLimit" disabled="true" onblur="javascript:formatAmountAsCommaSeparated(this)"
          		  		maxlength="41" />
          		  <html:errors property="dayLightLimitNumericError"/>
          		  <html:errors property="dayLightLimitDecimalExceed"/>
          		  <html:errors property="dayLightLimitLengthError"/>
          		  <html:errors property="dayLightLimitSpecialCharError"/>
          		  </td>
                  <%} %>
           </tr>
          
          <tr class="even">
          
          
          		   <td class="fieldname">Available<font color="#FF0000">*</font> </td>
		 		 
                  <td>
                  <% if(null==formObj.getAvailable() || "Yes".equals(formObj.getAvailable())){%> 
                  <input type="radio" id="available" name="available" value="Yes" checked="checked">Yes
                   <input type="radio" id="available" name="available" value="No" >No 
  					  <%}else{ %>
  					   <input type="radio" id="available" name="available" value="Yes">Yes
                   <input type="radio" id="available" name="available" value="No" checked="checked">No 
  					  <%} %>
  					  <html:errors property="available"/>
  				  </td>	
          
          		  <td class="fieldname">Freeze<font color="#FF0000">*</font></td>
          		  
                  <td>  <% if(null==formObj.getFreeze() || "No".equals(formObj.getFreeze())){%> 
                  <input type="radio" id="freeze" name="freeze" value="Yes" >Yes
                   <input type="radio" id="freeze" name="freeze" value="No" checked="checked">No 
  					  <%}else{ %>
  					   <input type="radio" id="freeze" name="freeze" value="Yes" checked="checked">Yes
                   <input type="radio" id="freeze" name="freeze" value="No" >No 
  					  <%} %>
                 
  					  <html:errors property="freeze"/>
  				  </td>	
                   
          </tr>
          
          
          <%if("UBS-LIMITS".equals(formObj.getFacilitySystem())){%>
          <%if("Yes".equals(formObj.getIdlApplicableFlagCheck())){ %>
           <tr class="even">
          
          
          		   <td class="fieldname">IDL Effective From date</td>
		 		<%if(null==formObj.getIdlEffectiveFromDate()) {%> 
                 <td><html:text property="idlEffectiveFromDate" style="width:90px" readonly="true" onchange="populateIdlExpiryDate(idlEffectiveFromDate);" onblur="itg_checkform('frmMain','idlEffectiveFromDate','Date','5');return document.MM_returnValue;" size="15" maxlength="10"
                  />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('idlEffectiveFromDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
                  <%}else{ %>
                   <td><html:text property="idlEffectiveFromDate" style="width:90px" readonly="true" onchange="populateIdlExpiryDate(idlEffectiveFromDate);" onblur="itg_checkform('frmMain','idlEffectiveFromDate','Date','5');return document.MM_returnValue;" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('idlEffectiveFromDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
						 <%} %>
					&nbsp; <html:errors property="idlEffectiveFromDate"/>					             
									             
									             
          
          		  <td class="fieldname">IDL Expiry Date</td>
									             
                 <td><html:text property="idlExpiryDate" styleId = 'idlExpiryDate1' style="width:90px" readonly="true"  size="15" maxlength="15" />
                     <img src="img/calendara.gif"  disabled="true"/>
                 
					&nbsp; <html:errors property="idlExpiryDate"/>					             
          </tr>
          
          <tr class="even">
          
          		   <td class="fieldname">IDL Amount</td>
                  <td><html:text property="idlAmount"  
                  styleId="idlAmount" onkeyup="onKeyUpEvent(this);" onblur="onBlurEventIDLAmount(this); javascript:formatAmountAsCommaSeparatedOnlyDigit(this);"/>
                  <html:errors property="idlAmount"/></td>	
          
          		  <td class="fieldname"></td>
                  <td></td> 
          </tr>
          
          <%}else{ %>
          <tr class="even">
          
          
          		   <td class="fieldname">IDL Effective From date</td>
		 		<%if(null==formObj.getIdlEffectiveFromDate()) {%> 
                 <td><html:text property="idlEffectiveFromDate" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','idlEffectiveFromDate','Date','5');return document.MM_returnValue;" size="15" maxlength="10"
                 disabled="true" />
                     <img src="img/calendara.gif"  disabled="true"/>
                  <%}else{ %>
                   <td><html:text property="idlEffectiveFromDate" style="width:90px" readonly="true" onchange="populateIdlExpiryDate(idlEffectiveFromDate);" onblur="itg_checkform('frmMain','idlEffectiveFromDate','Date','5');return document.MM_returnValue;" size="15" maxlength="10" disabled="true"/>
                     <img src="img/calendara.gif"  disabled="true"/>
						 <%} %>
					&nbsp; <html:errors property="idlEffectiveFromDate"/>					             
									             
									             
          
          		  <td class="fieldname">IDL Expiry Date</td>
									             
				
                 <td><html:text property="idlExpiryDate"  style="width:90px" readonly="true"  size="15" maxlength="15" disabled="true"/>
                     <img src="img/calendara.gif" disabled="true"/>
                  
					&nbsp; <html:errors property="idlExpiryDate"/>					             
          </tr>
          
          <tr class="even">
          
          		   <td class="fieldname">IDL Amount</td>
                  <td><html:text property="idlAmount"  
                  styleId="idlAmount" onkeyup="onKeyUpEvent(this);" onblur="onBlurEventIDLAmount(this); javascript:formatAmountAsCommaSeparatedOnlyDigit(this);" disabled="true"/>
                  <html:errors property="idlAmount"/></td>	
          
          		  <td class="fieldname"></td>
                  <td></td> 
          </tr>
          <%} %>
          <%} %>
          
          
          <tr class="even">
          
          		   <td class="fieldname">Revolving Line<font color="#FF0000">*</font> </td>
		 		 <%System.out.println("formObj.getRevolvingLine():"+formObj.getRevolvingLine()); %>
                  <td> 
                  <% if(null == formObj.getRevolvingLine()){ if("No".equalsIgnoreCase(revolvingLine)){%> 
                  <input type="radio" id="revolvingLine" name="revolvingLine" value="Yes" >Yes
                   <input type="radio" id="revolvingLine" name="revolvingLine" value="No" checked="checked">No 
  					  <%}else{ %>
  					   <input type="radio" id="revolvingLine" name="revolvingLine" value="Yes" checked="checked">Yes
                   <input type="radio" id="revolvingLine" name="revolvingLine" value="No" >No 
  					  <%}}else if ("Yes".equals(formObj.getRevolvingLine())){ %>
  					   <input type="radio" id="revolvingLine" name="revolvingLine" value="Yes" checked="checked">Yes
                   <input type="radio" id="revolvingLine" name="revolvingLine" value="No" >No 
  					  <%}else{ %>
  					  <input type="radio" id="revolvingLine" name="revolvingLine" value="Yes" >Yes
                   <input type="radio" id="revolvingLine" name="revolvingLine" value="No" checked="checked">No 
  					  <%} %>
                
  					  <html:errors property="revolvingLine"/>
  				  </td>	
           <td class="fieldname">SCM Flag<font color="#FF0000">*</font> </td>
                 <%if("UBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem()) || "FCUBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem())){ %>
                  <td> 
                   <% if(null == formObj.getScmFlag()){ if("No".equalsIgnoreCase(mastscmFlag)){%> 
                  <input type="radio" id="scmFlag" name="scmFlag" value="Yes" onclick="ValidateParty()">Yes
                   <input type="radio" id="scmFlag" name="scmFlag" value="No" checked="checked">No 
  					  <%}else{ %>
  					   <input type="radio" id="scmFlag" name="scmFlag" value="Yes" checked="checked" onclick="ValidateParty()">Yes
                   <input type="radio" id="scmFlag" name="scmFlag" value="No" >No 
  					  <%}}else if ("Yes".equals(formObj.getScmFlag())){ %>
  					   <input type="radio" id="scmFlag" name="scmFlag" value="Yes" checked="checked" onclick="ValidateParty()">Yes
                   <input type="radio" id="scmFlag" name="scmFlag" value="No" >No 
  					  <%}else{ %>
  					  <input type="radio" id="scmFlag" name="scmFlag" value="Yes" onclick="ValidateParty()" >Yes
                   <input type="radio" id="scmFlag" name="scmFlag" value="No" checked="checked">No 
  					  <%} %>
  					  <html:errors property="scmFlag"/>
  				  </td>	
                   <%}else{ %>
                   	  <td><input type="radio" id="scmFlag" name="scmFlag"  value="Yes" disabled="true"/> Yes
  					  <input type="radio" id="scmFlag" name="scmFlag" value="No"  disabled="true"/> No </td>
                   <%} %>
          </tr>
          
           <tr class="even">
				<td class="fieldname">SCF Interface Status</td>
				<td><html:text property="scfStatus" disabled="true" value="<%=scfStatus%>"></html:text>&nbsp;<br></td>
				<td class="fieldname">SCF Interface Failed Reason</td>
			<%if(null!=scfErrMsg && scfErrMsg.isEmpty()) {%>
					<td><html:text property="scfFailedReason" size="30"
								disabled="true" value="<%=scfErrMsg%>"></html:text><br/></td>
				<%}else{ %>
					<td><html:textarea property="scfFailedReason" rows="4"
								cols="50" disabled="true" value="<%=scfErrMsg%>"></html:textarea><br/></td>
				<%}%>
			</tr>


			<tr class="even">

				<td class="fieldname">ECBF Interface Completed</td>

				<td>
					<%
						if (radioInterfaceCompleted.equalsIgnoreCase("Checked")) {
					%> 
						<input type="radio" id="radioInterfaceCompleted" name="radioInterfaceCompleted" disabled="true" checked="checked" value="Yes">Yes 
						<input type="radio" id="radioInterfaceCompleted" name="radioInterfaceCompleted" disabled="true" value="No">No 
					<% 	} else { %> 
						<input type="radio" id="radioInterfaceCompleted" name="radioInterfaceCompleted" disabled="true" value="Yes">Yes
						<input type="radio" id="radioInterfaceCompleted" name="radioInterfaceCompleted" disabled="true" checked="checked" value="No">No 
					<% } %>
				</td>

				<td class="fieldname">Last Updated by ECBF Date</td>
					<%
						if (radioInterfaceCompleted.equalsIgnoreCase("Checked")) {
							if (responseDate != null) {
					%>
							<td><html:text property="responserequestDate" disabled="true" value="<%=responseDate%>"></html:text><br></td>
							<%
								} else {
							%>
							<td><html:text property="responserequestDate" disabled="true" value="<%=requestDate%>"></html:text><br></td>
							<%
								}
							%>
					<%
						} else {
					%>
							<td><html:text property="responserequestDate" disabled="true" value=""></html:text><br></td>
					<% } %>
			</tr>




				<tr class="even">          
          
          		  <td class="fieldname">Last Available Date</td>
          		  
          		  <%	
/*                   System.out.println("+++++++request.getParameter adhocFacility ="+request.getParameter("adhocFacility")); 
 */
          		  	if("Y".equalsIgnoreCase(request.getParameter("adhocFacility"))  ){%>   
                <td><input type="text"  name="lastavailableDate" style="width:90px" readonly="true" value="<%=lastAvailDate %>"  disabled="true"  id="lastavailableDate" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="lastAvailDT()"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp; 	
                   
  					 
  			<%}else{ %>

                  <td><input type="text" name="lastavailableDate" style="width:90px" readonly="true"  id="lastavailableDate" onblur="itg_checkform('frmMain','lastavailableDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />

                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('lastavailableDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp; 	
                   
                   <%} %>
		 		 <td class="fieldname">Upload Date </td>
		 		 
                 <td><html:text property="uploadDate" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','uploadDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('uploadDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>&nbsp;
                  </td>
          </tr>
          
            <tr class="even">
          
          			<%System.out.println("<<<<<<<<<<<segment1 "+segment1);
          			System.out.println("<<<<<<<<<<<<<formObj.getSegment() "+formObj.getSegment());%>
          		  <td class="fieldname">Segment1<font color="#FF0000">*</font></td>
          		  <td>
					<%if(formObj.getSegment()!=null){ %>
						<html:select property="segment" styleId="segment" value="<%=formObj.getSegment()%>">
                  		<integro:common-code
									categoryCode="<%=CategoryCodeConstant.SEGMENT_1 %>" descWithCode="false" />   
						</html:select>
					<%}else{ %>
						<html:select property="segment" styleId="segment" value="<%=segment1%>">
                  		<integro:common-code
									categoryCode="<%=CategoryCodeConstant.SEGMENT_1 %>" descWithCode="false" />   
						</html:select>
					<%} %>
					
					<html:errors property="segment"/>	
                  </td>
		 		 <td class="fieldname">Rule ID<font color="#FF0000">*</font> </td>
		 		  <td>
                  <%if(null!=formObj.getRuleId()){ %>
                  <html:select property="ruleId" styleId="ruleId" value="<%=formObj.getRuleId()%>">
                  <integro:common-code
								 categoryCode="<%=CategoryCodeConstant.NPA_RULE_ID %>" descWithCode="false" />   
					</html:select>
                  <%}else{ %>
                   <html:select property="ruleId" styleId="ruleId" value="<%=ruleId%>">
                    <integro:common-code
								 categoryCode="<%=CategoryCodeConstant.NPA_RULE_ID %>" descWithCode="false" />   
					</html:select>
                  <%} %>
                 <html:errors property="ruleId"/>	
                   </td>
          </tr>
          
                
          <tr class="even">
          
          		 <td class="fieldname">Capital market  exposure <font color="#FF0000">*</font></td>
          		 
          		 <% System.out.println("formObj.getIsCapitalMarketExposer():"+formObj.getIsCapitalMarketExposer());if(null==formObj.getIsCapitalMarketExposer()){ %>
                  <td>
                  <%if("Yes".equals(partyCapitalMarExp)){%>
                  <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="Yes" checked="checked"/> Yes
                  <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="No"/> No
                  <%}else if("No".equals(partyCapitalMarExp) || "".equals(partyCapitalMarExp)){ %>
                     <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="Yes" /> Yes
  					   <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="No" checked="checked"/> No 
  					<%} }else {%>
  					   <td> 
  					   <% if("Yes".equals(formObj.getIsCapitalMarketExposer())){%>
  					   <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="Yes" checked="checked"/> Yes
  					   <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="No"/> No
  					   <%}else if ("No".equals(formObj.getIsCapitalMarketExposer())){ %>
  					   <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="Yes" /> Yes
  					   <input type="radio" id="isCapitalMarketExposer" name="isCapitalMarketExposer" value="No" checked="checked"/> No 
  					  <%}}%>
  					  <html:errors property="isCapitalMarketExposer"/>
  					  
  				  </td>	
                   
                   
                   
				<%--   <td class="fieldname">PSL FLG <%if("Funded".equalsIgnoreCase(request.getParameter("facilityType"))) { %> <font color="#FF0000">*</font>  <%} %> </td> --%>
                       <td class="fieldname">PSL FLG  <font color="#FF0000">*</font> </td>
                 
                  <td>
                  
                     <html:radio property="isPrioritySector" styleId="isPrioritySector" value="Yes" onclick="javascript : shwhdPSec(this);" value="Yes"/>Yes
  					 <html:radio property="isPrioritySector" styleId="isPrioritySector" value="No" onclick="javascript : shwhdPSec(this);" value="No" />No 
  					 
				<div id="pSec_No" style="background:transparent;height:auto;border:0 none;display:none;">
   				<html:select property="prioritySector" styleId="prioritySector" >
                  <integro:common-code
									categoryCode="<%=CategoryCodeConstant.CommonCode_PRIORITY_SECTOR %>" descWithCode="false" />   
					</html:select>
				</div>
				<div id="pSec_Yes" style="background:transparent;height:auto;border:0 none;display:none;">
   				<html:select property="prioritySector" styleId="prioritySector" >
                  <integro:common-code
									categoryCode="<%=CategoryCodeConstant.CommonCode_PRIORITY_SECTOR_Y %>" descWithCode="false" />   
					</html:select>
				</div>
				&nbsp;<html:errors property="isPrioritySector"/>&nbsp;<html:errors property="prioritySector"/>
				
					
				</td>
                  
          </tr>
           
           
           <tr class="even">
                  <td class="fieldname">Real Estate Exposure <font color="#FF0000">*</font> </td>
                  <td><html:radio property="isRealEstateExposer" value="Yes"  onclick="javascript : shwhdRealEstateExposer(this.value);" /> Yes
  					  <html:radio property="isRealEstateExposer" value="No"  onclick="javascript : shwhdRealEstateExposer(this.value);"  /> No  <html:errors property="isRealEstateExposer"/>
  				  </td>
                  <td class="fieldname">UNCONDI CANCL COMMITMENT<font color="#FF0000">*</font></td>
                 	<td>	<html:select property="uncondiCancl" styleId="uncondiCancl" value="<%=formObj.getUncondiCancl()%>">
                  <integro:common-code
									categoryCode="<%=CategoryCodeConstant.UNCONDI_CANCL_COMMITMENT %>" descWithCode="false" />   
					</html:select><html:errors property="uncondiCancl"/>	</td>
                </tr>
           
           
           
           
                
           <tr class="even">
                   <td class="fieldname">Interest rate <font color="#FF0000">*</font></td>
                  <td><html:radio property="interestRateType" styleId="interestRateType"  onclick="javascript : shwhd(this);" value="fixed" />
                    Fixed                     
                    <html:radio property="interestRateType" styleId="interestRateType"  onclick="javascript : shwhd(this);" value="floating"  />
                    Floating                    
                    <br>
                    <div id="fixed" style="background:transparent;height:auto;border:0 none;display:none;">
                    <html:text property="intRateFix" styleId="intRateFix" maxlength="5"/>  <html:errors property="intRateFix"/>
                    </div>                
                    <div id="margin" style="background:transparent;height:auto;border:0 none;display:none;">
                      <html:select property="intRateFloatingType" styleId="intRateFloatingType" onchange="javascript : floatingRate(this.value);">
                        <html:option value="">Please Select</html:option>
                        <html:option value="BPLR">BPLR</html:option>
                        <html:option value="BASE">BASE</html:option>
                        </html:select>
                      <html:text property="intRateFloatingRange" styleId="intRateFloatingRange" readonly="true"> </html:text>
                      <br>
                      <html:radio property="intRateFloatingMarginFlag" styleId="intRateFloatingMarginFlag" value="+" />
                      +
                      <html:radio property="intRateFloatingMarginFlag" styleId="intRateFloatingMarginFlag" value="-" />
                      - Margin
                      <html:text property="intRateFloatingMargin" styleId="intRateFloatingMargin" maxlength="5" />
                      </div>  <html:errors property="interestRateType"/>  <html:errors property="intRateFloatingMargin"/>                  
                      </td>
                  <td class="fieldname">Commercial Real estate/ Residential real Estate  / Indirect real estate</td>
                  <td><html:radio property="estateType"  value="Commercial Real estate" onclick="javascript : shwhdEstateType(this);"  />
                    <span class="fieldname">Commercial Real estate</span> <br>
                    <html:radio property="estateType"  value="Residential real Estate" onclick="javascript : shwhdEstateType(this);" />
                    <span class="fieldname">Residential real Estate <br>
                    <html:radio property="estateType"  value="Indirect real estate" onclick="javascript : shwhdEstateType(this);" />
                    Indirect real estate</span>&nbsp; 
                    <%if(formObj.getEstateType()== null ||"".equals(formObj.getEstateType())){%>
                   <br><html:errors property="commRealEstateType"/>
               <div id="CommRE" style="background:transparent;height:auto;border:0 none;display:none;">
   				<html:select property="commRealEstateType" styleId="commRealEstateType">
                  <integro:common-code
									categoryCode="<%=CategoryCodeConstant.CommonCode_COMMERCIAL_REAL_ESTATE %>" descWithCode="false" />   
					</html:select>
					</div>
					<%}else{ %>
					<br><html:errors property="commRealEstateType"/>
                <div id="CommRE" style="background:transparent;height:auto;border:0 none;">
   				<html:select property="commRealEstateType" >
                  <integro:common-code
									categoryCode="<%=CategoryCodeConstant.CommonCode_COMMERCIAL_REAL_ESTATE %>" descWithCode="false" />   
					</html:select>
					</div>
					<%} %>
                    </td> 			
                </tr>
              
                
                
                <tr class="even">
                 <%if("UBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem()) || "FCUBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem())) %>
                 <%System.out.println("intradayLimit.............."+intradayLimit); %>
                 <% if("Yes".equalsIgnoreCase(intradayLimit)){%> 
                  <td class="fieldname">Day Light Limit Available </td>
                   <%System.out.println("formObj.getIsDayLightLimitAvailable().............."+formObj.getIsDayLightLimitAvailable()); %>
                   <% if(null==formObj.getIsDayLightLimitAvailable() || "No".equals(formObj.getIsDayLightLimitAvailable())){%> 
                  <td><input type="radio" id="isDayLightLimitAvailable" name="isDayLightLimitAvailable"  value="Yes"   /> Yes
  					  <input type="radio" id="isDayLightLimitAvailable" name="isDayLightLimitAvailable" value="No" checked="checked" /> No  
  				  </td>
  				  <html:hidden property="isDayLightLimitAvailable" />
  				  <%}else{ %>
  				  <td><input type="radio" id="isDayLightLimitAvailable" name="isDayLightLimitAvailable"  value="Yes"  checked="checked" /> Yes
  					  <input type="radio" id="isDayLightLimitAvailable" name="isDayLightLimitAvailable" value="No"  /> No  
  				  </td>
  				  <html:hidden property="isDayLightLimitAvailable" />
  				  <%} %>
  				  <%}else{%>
  				  <td class="fieldname">Day Light Limit Available  </td>
  				  <td><input type="radio" id="isDayLightLimitAvailable" name="isDayLightLimitAvailable"  value="Yes" disabled="true"/> Yes
  					  <input type="radio" id="isDayLightLimitAvailable" name="isDayLightLimitAvailable" value="No"  disabled="true"/> No  
  				  </td>
  				   <html:hidden property="isDayLightLimitAvailable" />
  				  <%} %>
  				   <td class="fieldname">Day Light Limit Approved</td>
  				    <%System.out.println("formObj.getDayLightLimitApproved().............."+formObj.getDayLightLimitApproved()); %>
  				     <% if(null!=formObj.getDayLightLimitApproved() && (formObj.getDayLightLimitApproved().equalsIgnoreCase("Yes") || formObj.getDayLightLimitApproved().equalsIgnoreCase("on"))){%> 
                 	<td>	 <input type="checkbox" name="dayLightLimitApproved" property="dayLightLimitApproved" disabled="true"  checked="true" onclick="javascript:checkboxDayLightLimitApproved()"></input>
                 	</td>
					 <html:hidden property="dayLightLimitApproved" styleId="dayLightLimitApproved"/>
					<% }else {%> 
					<td><input type="checkbox"  name="dayLightLimitApproved" property="dayLightLimitApproved" disabled="true" onclick="javascript:checkboxDayLightLimitApproved()"></input></td>
								<html:hidden property="dayLightLimitApproved" styleId="dayLightLimitApproved"/>
								<%} %>
                </tr>
                	
                	
                				
                <%if("Funded".equalsIgnoreCase(request.getParameter("facilityType"))) { %>
                
                <%}else{%>
					<html:hidden property="isPrioritySector" value="Blank"/>
				<% } %>
                <script language="javascript">

                <%if(formObj.getIsRealEstateExposer() != null && formObj.getIsRealEstateExposer().equals("Yes")) { %>
    		   		document.forms[0].estateType[0].disabled =false;
    				document.forms[0].estateType[1].disabled =false;
    				document.forms[0].estateType[2].disabled =false;
    				document.getElementById('CommRE').style.display = 'none';
    				<%}else{%>
    				document.forms[0].estateType[0].disabled =true;
    				document.forms[0].estateType[1].disabled =true;
    				document.forms[0].estateType[2].disabled =true;
    				document.getElementById('CommRE').style.display = 'none';
    				<%}%>

				
                <%if(formObj.getInterestRateType() != null && formObj.getInterestRateType().equals("fixed")) { %>
               		document.getElementById('intRateFloatingMarginFlag').value='';
               		document.getElementById('intRateFloatingMargin').value='';	
               		document.getElementById('intRateFloatingRange').value='';	
               		document.getElementById('intRateFloatingType').value='';
               		document.getElementById('fixed').style.display = ''; 
               		document.getElementById('margin').style.display = 'none';
               	<%}%>
               	<%if(formObj.getInterestRateType() != null && formObj.getInterestRateType().equals("floating")) { %>
               		document.getElementById('fixed').style.display = 'none';
               		document.getElementById('margin').style.display = '';
               	<%}%>


                
            	<%if(formObj.getEstateType() != null && formObj.getEstateType().equals("Commercial Real estate")) { %>
			   		document.getElementById('CommRE').style.display = ''; 
			   	 <%}else{%>
			   		document.getElementById('CommRE').style.display = 'none';
			   	<%}%>

                
                 <% if(formObj.getIsPrioritySector() == null || formObj.getIsPrioritySector().equals("")){%>
               
					document.forms[0].prioritySector.readonly =true;
				 
				 <%}else if(formObj.getIsPrioritySector().equalsIgnoreCase("No")) { %>
					 document.getElementById('pSec_No').style.display = '';
					 document.getElementById('pSec_Yes').style.display = 'none'; 
					 document.all.prioritySector[0].name='prioritySector';
				   	 document.all.prioritySector[1].name='';	
				 <%}else if(formObj.getIsPrioritySector().equalsIgnoreCase("Yes")) { %>
					 document.getElementById('pSec_No').style.display = 'none';
					 document.getElementById('pSec_Yes').style.display = ''; 
					 document.all.prioritySector[1].name='prioritySector';   
				   	 	document.all.prioritySector[0].name='';
				 <%}%>
				 <% if(formObj.getIsRealEstateExposer() == null || formObj.getIsRealEstateExposer().equals("No")){%>
				 		shwhdRealEstateExposer('No');
				 <%}%>
				 <% if(formObj.getInterestRateType() == null || formObj.getInterestRateType().equals("")){%>
				 <%}else{
					 if(formObj.getInterestRateType().equals("fixed")){
				 %>			 
				 		document.getElementById('fixed').style.display = ''; 
		   				document.getElementById('margin').style.display = 'none';
				 <%}if(formObj.getInterestRateType().equals("floating")){%>
				 		document.getElementById('fixed').style.display = 'none';
			   			document.getElementById('margin').style.display = '';
				 <%} }%>
				 
				 </script>
          <tr class="odd">
          
		  			<td class="fieldname">Limit (Tenor Days)</td>
		  			<td width="30%"><html:text property="limitTenorDays"  maxlength="14"/>
		  			 <br/><html:errors property="limitTenorDays"/>
		  			</td>
                    <td class="fieldname">Closed Flag</td>
          		  
                  <td>
                  <% if(formObj.getCloseFlag()==null || formObj.getCloseFlag().equals("")){%>
												<input type="checkbox" id="limitCloseFlag"  disabled="true"></input>
												<html:hidden property="closeFlag"/>
												<% }else if(formObj.getCloseFlag().equals("Y")){%>
												<input type="checkbox" id="limitCloseFlag" checked="checked"  disabled="true"></input>
												<html:hidden property="closeFlag"/>
												<%} else if(formObj.getCloseFlag().equals("N")){%>
												<input type="checkbox" id="limitCloseFlag"  disabled="true"></input>
												<html:hidden property="closeFlag"/>
											<%} %>
                 
  				  </td>
					</tr>
					<tr class="even">		
		  			 <%if("UBS-LIMITS".equals(formObj.getFacilitySystem())){%>
						<td class="fieldname">Banking Arrangement</td>
						<td>                  	
							<html:select property="bankingArrangement" disabled = "true" style="width:250px">
								<integro:common-code categoryCode="<%=CategoryCodeConstant.BANKING_ARRANGEMENT%>" descWithCode="false" />
							</html:select>
							 <html:hidden property="bankingArrangement" />
						</td>
						<%}else{%>
							<td class="fieldname">&nbsp;</td><td>&nbsp;</td>
						<%}%>
						
					<td class="fieldname"><bean:message key="label.lineRelease.adhocLine"/><font color="#FF0000">*</font></td>
                        <%  
                        System.out.println("++++2223+++request.getAttribute adhocFacility = "+adhocFacility);  
                        if(null != adhocFacility){  
                        
                         if(adhocFacility.equalsIgnoreCase("Y")  ){%> 
                     <td>
                    <input type="radio" id="adhocLineY" name="adhocLine" value="Y" checked="checked" disabled="true" >Yes
                   <input type="radio" id="adhocLineN" name="adhocLine" value="N" disabled="true"  >No 
                   </td>
  					  <%}else{
  						if("N".equalsIgnoreCase(adhocFacility)  || null==formObj.getAdhocLine() || "N".equals(formObj.getAdhocLine())){%>      
  					<td><input type="radio" id="adhocLineY" name="adhocLine"  value="Y"  disabled="true"  /> Yes
 					  <input type="radio" id="adhocLineN" name="adhocLine" value="N" checked="checked"  disabled="true" /> No  
 				  </td>
 				  <html:hidden property="adhocLine" />
 				  <%}else  if("Y".equals(formObj.getAdhocLine())){  %>
 				  <td><input type="radio" id="adhocLineY" name="adhocLine"  value="Y"  checked="checked"  disabled="true" /> Yes
 					  <input type="radio" id="adhocLineN" name="adhocLine" value="N"  disabled="true" /> No  
 				  </td>
 				  <html:hidden property="adhocLine" />
 				  <%}
                  } } %>
                  <html:hidden property="adhocLine" />
  
                </tr>
                <tr class="even">
		  			<td class="fieldname">Vendor Details</td>
		  			 <%if("UBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem()) || "FCUBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem())){ 
		  				if("Yes".equalsIgnoreCase(formObj.getLimitType())){
		  				%>
		  			<td width="30%"><html:select property="vendorDtls" >
		      		<option value="" >Please Select </option>	
                      <html:options collection="vendorList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;<html:errors property="vendorDtls"/></td>
                    <%}}else{ %>
                    <td width="30%"><html:select property="vendorDtls" >
		      		<option value="" disabled>Please Select </option>	
                      <html:options collection="vendorList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;<html:errors property="vendorDtls"/></td>
                    <%} %>
		  			<td class="fieldname">&nbsp;</td>
                   	<td></td>
                </tr>  
                
            <%-- <tr class="even">
             

              <td class="fieldname" width="20%">Limit Restriction/Customer Restriction<font color="#ff0000">*</font></td>
              <td width="30%">
									 <html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="facilityTypeList" >
						               <html:options collection="facilityTypeList" property="value" labelProperty="label"/>
						               <integro:common-code categoryCode="<%=CategoryCodeConstant.HDFC_RBI_CODE%>" excludeList="<%=filterActualRbiCodeCatIds %>"  pleaseSelect="false" />
		                			</html:select> 
             		   <td>
		             		<input type="button" name="Button" value="Add&gt;&gt;" style="width:80" onclick="moveDualList(allListrbiCodeCategory,rbiCodeCategorys, false)" class="btnNormal"/>
			                <br/> <br/> 
							<input type="button" name="Button" value="&lt;&lt;Remove" style="width:80" onclick="moveDualList(rbiCodeCategorys,allListrbiCodeCategory,false)" class="btnNormal"/>
		               </td>
		               
		               <td>
		               
									 <html:select name="RbiCategoryForm" size="10" multiple="multiple" style="width:260" property="rbiCodeCategorys" >
		                			</html:select> 
		                			&nbsp;</br><html:errors property="rbiCodeCategorys"/>
		                		</td>
              
            </tr>  --%>
            
            <tr class="even">
            <td class="fieldname">Limit Restriction/Customer Restriction</td>
             <td colspan="3"><html:textarea rows="2" cols="150" property="limitRestriction"  styleId="limitRestriction"/>
             </td>
            </tr>
        
        <%if(  "UBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem()) 
        	//|| "FCUBS-LIMITS".equalsIgnoreCase(formObj.getFacilitySystem())
           ||  "BAHRAIN".equalsIgnoreCase(formObj.getFacilitySystem())  
           ||  "HONGKONG".equalsIgnoreCase(formObj.getFacilitySystem()) 
           ||  "GIFTCITY".equalsIgnoreCase(formObj.getFacilitySystem())      ) { 
          %>
             <tr class="odd">
            <td class="fieldname" >Co-borrower Details </td>
            
            <td colspan="3">
	             <table><tbody>
	         
	             <tr>
	             <td  class="fieldname" colspan="2">Co-Borrower Liab Id &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	              <td >  <html:select property="coBorrowerId" styleId= "coBorrowerId" style="width:250">
		      		     <option value="" >Please Select </option>	
		      		    <html:options collection="facCoBorrowerList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;
                    </td> 
                     <% 
					if("false".equalsIgnoreCase(wsCall)  ){ 					
					%>
                     <td>  <input type="button" id="fetchCoBorrower" disabled="disabled"  value="Fetch Co-Borrower Name" class="btnNormal" onclick="fetchCoBorrowerNameWS()" />
                     </td>
                <% }else{%>
                    <td>  <input type="button" id="fetchCoBorrower"  value="Fetch Co-Borrower Name" class="btnNormal" onclick="fetchCoBorrowerNameWS()" />
                    </td>
                <% }%>
	             </tr>
	             
	             <tr>
	             <td  class="fieldname" colspan="2">Co-Borrower Name                        </td>
	             <td ><input type="text" style="width:250" property="coBorrowerName" id="coBorrowerName"></td> 
	             <td>  <input type="button" id="addBorrower"  value="Add" class="btnNormal" onclick="addCoBorrower()" />
                    </td>
	             </tr>
	             </tbody>
	             </table>
		       </td>
            </tr>
            
            <tr id="addCountryDetails">
   <td class="fieldname"></td>
							<td colspan="6">
							<table border="0" cellpadding="0" cellspacing="0" class="tblinfo"
								style="margin-top: 0" width="100%" align="center">
								<thead>
									<tr>
									  <span id="restCoBorrowerListError"></span>
									</tr>
									<tr>
										<td>Sr No</td>
										<td>Co-Borrower Liab Id </td>
										<td>Co-Borrower Name</td>
										<td>Action</td>
									</tr>
								</thead>
								 <tbody>
									<logic:present name="restCoBorrowerList">
										<logic:iterate id="ob" name="restCoBorrowerList"
											type="com.integrosys.cms.app.customer.bus.OBLimitXRefCoBorrower"
											 scope="page">
											<%
												String rowClass = "";
														vno++;
														rowClass = "even";
														
											%>
											 <tr class="<%=rowClass%>">
												<td class="index"><%=vno%></td>
												<td>
												<center><%=ob.getCoBorrowerId()%>&nbsp;</center>
												</td>
												<td>
												<center><%=ob.getCoBorrowerName()%>&nbsp;</center>
												<%-- <html:text property="coBorrowerName" styleId="coBorrowerName" value = "<%=ob.getCoBorrowerName()%>"/> --%>
												</td>
												 <td><a href="javascript:deleteRestCoBorrower('<%=ob.getCoBorrowerId()%>','<%=vno%>')">Delete</a></td>
											</tr> 
										</logic:iterate>
									</logic:present>
										<%if(restCoBorrowerList.size()==0){ %>
										<tr class="odd">
											<td colspan="8"><bean:message
												key="label.global.not.found" /></td>
										</tr>
								<%} %>
								</tbody> 
							</table>
							</td>
						</tr>
						 <%} %>
             <!-- End Bhushan --> 
            
            
            <tr class="even">
             

              <td class="fieldname" width="20%">Branch Allowed</td>

              <td width="30%">
									 <html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="allAliasBranchCodeList" >
						               <html:options collection="branchAllowedList" property="value" labelProperty="label"/>
						              
		                			</html:select> </td>
             		   <td>
		             		<input type="button" name="Button" value="Add&gt;&gt;" style="width:80" onclick="moveBranchAllowedList(allAliasBranchCodeList,aliasBranchCodes, false,'branch')" class="btnNormal"/>
			                <br/> <br/> 
							<input type="button" name="Button" value="&lt;&lt;Remove" style="width:80" onclick="moveBranchAllowedList(aliasBranchCodes,allAliasBranchCodeList,false,'branch')" class="btnNormal"/>
		               </td>
		               
		               <td>
		               
									 <html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="aliasBranchCodes" >
									 <html:options collection="branchAllowedList1" property="value" labelProperty="label"/> 
		                			</html:select> 
		                			
		                		</td>
               </tr> 
              
           <tr class="even">
             <td class="fieldname" width="20%">Product Allowed</td>
			  <td width="30%">
									 <html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="allProductAllowedList" >
						               <html:options collection="productAllowedList" property="value" labelProperty="label"/>
						            </html:select> 
             		   <td>
		             		<input type="button" name="Button" value="Add&gt;&gt;" style="width:80" onclick="moveBranchAllowedList(allProductAllowedList,productCodes, false,'product')" class="btnNormal"/>
			                <br/> <br/> 
							<input type="button" name="Button" value="&lt;&lt;Remove" style="width:80" onclick="moveBranchAllowedList(productCodes,allProductAllowedList,false,'product')" class="btnNormal"/>
		               </td>
		               <td>
		               				<html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="productCodes" >
		               				 <html:options collection="productAllowedList1" property="value" labelProperty="label"/> 
		                			</html:select> 
		                </td>
            </tr>
            
            <tr class="even">
             <td class="fieldname" width="20%">Currency Allowed</td>
			  <td width="30%">
									 <html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="allCurrencyAllowedList" >
						               <html:options collection="currencyAllowedList" property="value" labelProperty="label"/>
						               </html:select> 
             		   <td>
		             		<input type="button" name="Button" value="Add&gt;&gt;" style="width:80" onclick="moveBranchAllowedList(allCurrencyAllowedList,currencyCodes, false,'currency')" class="btnNormal"/>
			                <br/> <br/> 
							<input type="button" name="Button" value="&lt;&lt;Remove" style="width:80" onclick="moveBranchAllowedList(currencyCodes,allCurrencyAllowedList,false,'currency')" class="btnNormal"/>
		               </td>
		               <td>
		               		               
									 <html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="currencyCodes" >
									  <html:options collection="currencyAllowedList1" property="value" labelProperty="label"/> 
		                			</html:select> 
		               </td>
              </tr>  
            <!-- Start Santosh ubs limit -->
             <tr class="even">
             	<td class="fieldname" width="20%">UDF Allowed</td>
              		<td width="30%">
						<html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="allUdfList" >
						       <html:options collection="udfLbValList" property="value" labelProperty="label"/>
		                </html:select>
		           </td> 
            		<td>
		             	<input type="button" name="Button" value="Add&gt;&gt;" style="width:80" onclick="moveDualList(allUdfList,udfList, false,'<%=addUdf %>')" class="btnNormal"/>
			            <br/> <br/> 
						<input type="button" name="Button" value="&lt;&lt;Remove" style="width:80" onclick="moveDualList(udfList,allUdfList,false,'<%=deleteUdf %>')" class="btnNormal"/>
		           </td>
		                       
		            <td>
						<html:select name="XRefDetailForm"  size="10" multiple="multiple" style="width:260" property="udfList" >
							<html:options collection="udfLbValList1" property="value" labelProperty="label"/> 
						</html:select> 
		                	&nbsp;<br/>
		           </td>
            </tr> 
            <!--End Santosh ubs limit -->
                  
             <tr class="even">
             	<td class="fieldname" width="20%">UDF Allowed_2</td>
              		<td width="30%">
						<html:select name="XRefDetailForm" size="10" multiple="multiple" style="width:260" property="allUdfList_2" >
						       <html:options collection="udfLbValList_2" property="value" labelProperty="label"/>
						       
		                </html:select>
		           </td> 
            		<td>
		             	<input type="button" name="Button" value="Add&gt;&gt;" style="width:80" onclick="moveDualList_2(allUdfList_2,udfList_2, false,'<%=addUdf %>')" class="btnNormal"/>
			            <br/> <br/> 
						<input type="button" name="Button" value="&lt;&lt;Remove" style="width:80" onclick="moveDualList_2(udfList_2,allUdfList_2,false,'<%=deleteUdf %>')" class="btnNormal"/>
		           </td>
		                       
		            <td>
						<html:select name="XRefDetailForm"  size="10" multiple="multiple" style="width:260" property="udfList_2" >
							<html:options collection="udfLbValList1_2" property="value" labelProperty="label"/> 
						</html:select> 
		                	&nbsp;<br/>
		           </td>
            </tr> 
	                <tr class="even">
                  <td class="fieldname">Security 1</td>
                  <td>
                   <html:select property="security1" value="<%=formObj.getSecurity1() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subSecurityList" labelProperty ="label" property ="value" />								                   
					</html:select>
                  </td>
                  <td class="fieldname">Security 2</td>
                  <td><p>
                    <html:select property="security2" value="<%=formObj.getSecurity2() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subSecurityList" labelProperty ="label" property ="value" />								                   
					</html:select>
                  </p></td>
                </tr>
                <tr class="odd">
                  <td class="fieldname">Security 3</td>
                  <td>
                 <html:select property="security3" value="<%=formObj.getSecurity3() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subSecurityList" labelProperty ="label" property ="value" />								                   
					</html:select>
                  </td>
                  <td class="fieldname">Security 4</td>
                  <td><p>
                   <html:select property="security4" value="<%=formObj.getSecurity4() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subSecurityList" labelProperty ="label" property ="value" />								                   
					</html:select>
                  </p></td>
                  </tr>
                  <tr class="odd">
                  <td class="fieldname">Security 5</td>
                  <td>
                 <html:select property="security5" value="<%=formObj.getSecurity5() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subSecurityList" labelProperty ="label" property ="value" />								                   
					</html:select>
                  </td>
                  <td class="fieldname">Security 6</td>
                  <td><p>
                    <html:select property="security6" value="<%=formObj.getSecurity6() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subSecurityList" labelProperty ="label" property ="value" />								                   
					</html:select>
                  </p></td>
                  </tr>
                  
                  
                  
                  <tr class="odd">
                  <td class="fieldname">Internal Remarks</td>
                  <td colspan="3">
                 <!-- 	<html:text property="internalRemarks" maxlength="250" /> -->
                 <%System.out.println("getInternalRemarks :"+internalRemarks+" formObj.getInternalRemarks():"+formObj.getInternalRemarks());
                if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(formObj.getAction())){if(null!=formObj.getInternalRemarks() && formObj.getInternalRemarks().equals(internalRemarks)){ %>
                 	<html:textarea  rows="2" cols="150" property="internalRemarks"  styleId="internalRemarks" value="<%=internalRemarks%>"/>
                 	
                 	<%}else{%>
                 		<html:textarea  rows="2" cols="150" property="internalRemarks"  styleId="internalRemarks" />	
                 	<% }}else{ %>
                 	<html:textarea  rows="2" cols="150" property="internalRemarks"  styleId="internalRemarks"/>
                 	<%} %>
                 	 <br/><html:errors property="internalRemarks"/>
                  </td>
                  
                  </tr>
                  
               
                  
                  <tr class="odd">
                  <td class="fieldname">Core STP Rejected Reason</td>
                  <td colspan="3">
                 	<html:textarea  rows="2" cols="150" property="coreStpRejectedReason"  styleId="coreStpRejectedReason" readonly="true"/>
                 	
                  </td>
                  
              
                  </tr>
                  
                  
               <%--    <% SimpleDateFormat sdf = new SimpleDateFormat("dd-Mon-yy");
                  String createdOn = "";
                  String updatedOn = "";
                  if(formObj.getCreatedOn()!=null && !"".equals(formObj.getCreatedOn())){
					 createdOn =	sdf.parse(formObj.getCreatedOn().toString()).toString();
                  }
                 if(formObj.getUpdatedOn()!=null && !"".equals(formObj.getUpdatedOn())){
					 updatedOn =	sdf.parse(formObj.getUpdatedOn().toString()).toString();
                  }
                   %> --%>
                   
       </tbody>
      </table>
     </td>
    </tr>
    <tr>
     <td>
      &nbsp;
     </td>
    </tr>
    <tr>
    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
 <thead>
        <tr>
            <td><h3>CAM Covenant:</h3></td>
        </tr>
    </thead>
    <tbody>
    <tr>
            <td>
                <input class="btnNormal" type="button" name="btnedit_view" id="btnedit_view" value="Edit/View" onclick="javascript : viewConvenantScreen('create_covenant_detail_line')">				
            </td>
        </tr>
    </tbody>
</table>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  
    
   </tbody>
  </table>
     <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection">
     <tr> 
     <td>
     <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tblInfo">
     <tr class="odd">
     	<td class="fieldname">Created/Edited By</td>
     	<td>
     		<%System.out.println("created:"+formObj.getCreatedBy()); %>
     		<integro:empty-if-null value="<%=formObj.getCreatedBy()%>"/>
     	</td>
     	<td class="fieldname">Approved By</td>
     	<td>  
     		<integro:empty-if-null value="<%=formObj.getUpdatedBy()%>"/>
     	</td>
     </tr>
      <tr class="odd">
      		<td class="fieldname">Created/Edited On</td>
            <td>
            	<integro:empty-if-null value="<%=formObj.getCreatedOn()%>"/>
            </td>
            <td class="fieldname">Approved On</td>
            <td>
            	<integro:empty-if-null value="<%=formObj.getUpdatedOn()%>"/>
			</td>
      </tr>
      
      <html:hidden name="XRefDetailForm" property="branchAllowed" styleId="branchAllowed" />
      <html:hidden name="XRefDetailForm" property="productAllowed" styleId="productAllowed" />
      <html:hidden name="XRefDetailForm" property="currencyAllowed" styleId="currencyAllowed" />
      <html:hidden name="XRefDetailForm" property="limitType" styleId="limitType" value='<%=limitType%>' />
      <html:hidden name="XRefDetailForm" property="udfAllowed" styleId="udfAllowed" />
      <html:hidden name="XRefDetailForm" property="udfAllowed_2" styleId="udfAllowed_2" />
      <html:hidden name="XRefDetailForm" property="intradayLimitFlag" styleId="intradayLimitFlag" />
      <html:hidden name="XRefDetailForm" property="coBorrowerId" styleId="coBorrowerId" />
      <html:hidden name="XRefDetailForm" property="coBorrowerName" styleId="coBorrowerName" />			
					
	</table>
    </td>
    </tr></table>
  <table width="75" border="0" align="center" cellpadding="0" cellspacing="0">
   <tr> 
    <td colspan="2">&nbsp;</td>
   </tr>
   <tr> 
    <td><a href="javascript:submitAccount()"><img src="img/ok1.gif" border="0" /></a></td>
    <td><a href="javascript:cancelSubmit()"><img src="img/cancel1.gif" width="70" height="20" border="0" /></a></td>
   </tr>
   <tr> 
    <td colspan="2">&nbsp;</td>
   </tr>
  </table>
<div id="fcubsFacilityResponce" style="display: none"  /> 
<div id="fcubsLiabBranchResponce" style="display: none"  /> 
<div id="fcubsCoBorrowerResponceText" style="display: none"  /> 
</body>