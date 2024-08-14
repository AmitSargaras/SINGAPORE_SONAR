<%@page import="com.integrosys.cms.app.customer.bus.ICoBorrowerDetails"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.integrosys.base.techinfra.logger.DefaultLogger"%>
<%@ page import="java.util.Locale,
				 java.util.Collection,
				 java.util.Iterator,
				 java.util.List,
				   com.integrosys.base.techinfra.util.DateUtil,
				 org.apache.struts.util.LabelValueBean,
				 com.integrosys.base.techinfra.diff.CompareResult,
				 com.integrosys.cms.app.common.constant.ICMSConstant,
                 com.integrosys.cms.ui.common.constant.IGlobalConstant,
                 com.integrosys.component.bizstructure.app.bus.ITeam,
				 com.integrosys.base.businfra.currency.CurrencyManager,
                 com.integrosys.base.uiinfra.common.ICommonEventConstant,
                 com.integrosys.cms.app.customer.bus.ICustomerSysXRef,
                 com.integrosys.cms.app.limit.bus.ILimitSysXRef,
                 com.integrosys.cms.app.limit.bus.ILimit,
                 com.integrosys.cms.app.limit.trx.ILimitTrxValue,
                 com.integrosys.cms.app.limit.trx.OBLimitTrxValue,
                 com.integrosys.cms.ui.manualinput.limit.MILimitUIHelper,
                 com.integrosys.cms.ui.manualinput.limit.LmtDetailForm,
                  com.integrosys.cms.ui.common.CurrencyList,
                  java.text.DecimalFormat,
                  java.math.BigDecimal,
                 com.integrosys.cms.ui.limit.CategoryCodeConstant" %>
<%@page import="com.integrosys.cms.ui.manualinput.limit.LmtDetailAction"%>
<%@ taglib uri="/WEB-INF/IntegroTag.tld" prefix="integro" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@page import="com.integrosys.cms.ui.login.CMSGlobalSessionConstant"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.integrosys.cms.app.generalparam.bus.IGeneralParamEntry"%>
<%@page import="com.integrosys.cms.app.generalparam.bus.IGeneralParamGroup"%>
<%@page import="com.integrosys.cms.app.generalparam.bus.IGeneralParamDao"%>
<%@page import="com.integrosys.base.techinfra.context.BeanHouse"%>
<%
    ITeam userTeam = (ITeam) session.getAttribute(ICommonEventConstant.GLOBAL_SCOPE + "." + IGlobalConstant.USER_TEAM);
    Locale locale = (Locale) session.getAttribute(ICommonEventConstant.GLOBAL_SCOPE + "." + com.integrosys.base.uiinfra.common.Constants.GLOBAL_LOCALE_KEY);
    long oneTeamMshipID = userTeam.getTeamMemberships()[0].getTeamTypeMembership().getMembershipID();
    long teamTypeID = userTeam.getTeamType().getTeamTypeID();
    boolean isMr = false;
    String scodLineNoList=PropertyManager.getValue("scod.linenocode.name");
    		//PropertyManager.getValue("scod.linenocode.name");
    if (oneTeamMshipID == ICMSConstant.TEAM_TYPE_MR_MAKER ||
            oneTeamMshipID == ICMSConstant.TEAM_TYPE_MR_CHECKER) {
        isMr = true;
    }
    String teamTypeMemID = (String) session.getAttribute(ICommonEventConstant.GLOBAL_SCOPE + "." + CMSGlobalSessionConstant.TEAM_TYPE_MEMBERSHIP_ID);
    System.out.println("teamTypeMemID>>>>>>>>>>"+teamTypeMemID);
    System.out.println("Long.parseLong(teamTypeMemID)>>>>>>>>>>"+Long.parseLong(teamTypeMemID));
    System.out.println("ICMSConstant.TEAM_TYPE_CPU_MAKER_I>>>>>>>>>>"+ICMSConstant.TEAM_TYPE_CPU_MAKER_I);
    boolean isUserCpcMaker = false;       
    if(Long.parseLong(teamTypeMemID)==ICMSConstant.TEAM_TYPE_CPU_MAKER_I){
    	isUserCpcMaker = true;
    }
    System.out.println("isUserCpcMaker>>>>>>>>>>"+isUserCpcMaker+"==============>"+ICMSConstant.TEAM_TYPE_CPU_MAKER_I);
    MILimitUIHelper helper = new MILimitUIHelper();
    boolean isLmtSecChange = false;
    
    List facNameList=(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.facNameList");
    
    HashMap collateralMap=(HashMap) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.collateralMap");
    
    
    pageContext.setAttribute("facNameList",facNameList);
    
    Collection relationShipMngrList = (Collection) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.relationShipMngrList");
	request.setAttribute("relationShipMngrList", relationShipMngrList);
	
	Collection subFacNameList = (Collection) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.subFacNameList");
	request.setAttribute("subFacNameList", subFacNameList);
	
	Collection subPartyNameList = (Collection) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.subPartyNameList");
	request.setAttribute("subPartyNameList", subPartyNameList);
	
	Collection liabilityIDList = (Collection) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.liabilityIDList");
	request.setAttribute("liabilityIDList", liabilityIDList);
	pageContext.setAttribute("liabilityIDList", liabilityIDList);
	
    List facDetailList=(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.facDetailList");
    pageContext.setAttribute("facDetailList",facDetailList);
 
    String relationShipMgrName = (String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.relationShipMgrName");
    if(relationShipMgrName != null){
    pageContext.setAttribute("relationShipMgrName",relationShipMgrName);
    }
    Object obj = session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.lmtTrxObj");
    String limitIdFromObj = null;
    if(obj != null ) {
        ILimitTrxValue trxValue = (OBLimitTrxValue)obj;
        limitIdFromObj = trxValue.getReferenceID();
    }
    Boolean adhocVal=true;
    String actualreleaseAmt = null;
    Boolean isLineAdded=false;
    if( obj != null ) {
        ILimitTrxValue obTrxValue = (OBLimitTrxValue)obj;
		if(obTrxValue.getLimit() != null){
        actualreleaseAmt = obTrxValue.getLimit().getTotalReleasedAmount();
		}
        
    	//isLmtSecChange = helper.checkLimitSecMappingChanged( obTrxValue );
		
		    
        System.out.println("ReferenceID:"+ obTrxValue.getReferenceID()+"stag id: "+obTrxValue.getStagingReferenceID());
        if(obTrxValue.getStagingReferenceID()== null || obTrxValue.getReferenceID() ==null){
        	adhocVal=false;
        }
        
        System.out.println("obTrxValue.getStagingLimit():"+obTrxValue.getStagingLimit()+" obTrxValue.getStagingLimit().getLimitSysXRefs():"+obTrxValue.getStagingLimit().getLimitSysXRefs());
        if( null !=obTrxValue.getStagingLimit() && null!=obTrxValue.getStagingLimit().getLimitSysXRefs() && obTrxValue.getStagingLimit().getLimitSysXRefs().length>0){
        		isLineAdded=true;
        	  System.out.println("xref size:"+obTrxValue.getStagingLimit().getLimitSysXRefs().length);
        }
        System.out.println("adhocVal:"+adhocVal+" isLineAdded:"+isLineAdded);
	}

	String context = request.getContextPath() + "/";

	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
			
	String updateEvent=(String)request.getAttribute("updateEvent");
	if(updateEvent==null)
		updateEvent="";
	
	request.setAttribute("updateEvent",updateEvent);
	DecimalFormat dft = new DecimalFormat("#0.00");
	
	String isCreate=(String)request.getAttribute("isCreate");
	System.out.println("isCreate:"+isCreate);
	
	 String fcunsSystem=PropertyManager.getValue("fcubs.systemName");
	  String ubslimitSystem=PropertyManager.getValue("ubs.systemName");
	  String singaporeSystem=PropertyManager.getValue("singapore.systemName");
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
	  
	  String status= (String) request.getAttribute("status");

	  String event = request.getParameter("event");
	  String facCoBorrowerLiabIds =(String) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.facCoBorrowerLiabIds");
		pageContext.setAttribute("facCoBorrowerLiabIds",facCoBorrowerLiabIds);

	  String isCollateralMapped = (String) request.getAttribute("isCollateralMapped");
	  
	  List riskTypeList = (List)session.getAttribute(LmtDetailAction.class.getName() + "." + "riskTypeList");
	  pageContext.setAttribute("riskTypeList" ,riskTypeList);	  
	  System.out.println("riskTypeList => "+riskTypeList);
	  
	  String availAndOptionApplicable=(String)request.getAttribute("availAndOptionApplicable");
	  pageContext.setAttribute("availAndOptionApplicable" ,availAndOptionApplicable);
	  System.out.println(availAndOptionApplicable +"availAndOptionApplicable");
		
%>



<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.integrosys.cms.ui.common.UIUtil"%>
<%@page import="com.integrosys.base.techinfra.propertyfile.PropertyManager"%><html>
<head>
    <link rel="stylesheet" type="text/css" media="all" href="css/calendar-blue.css" />
    <!-- InstanceBeginEditable name="head" -->
    
    <script language="JavaScript" type="text/javascript"
	src="<%=context%>js/itgUtilities.js"></script>
	<script type="text/javascript" src="<%=context%>js/ajaxDropdown.js"></script>
	<link href="<%=context%>css/smartlender-print.css" media="print"
	rel="stylesheet" type="text/css" />
    
    <script type="text/javascript" src="js/emulation.js"></script>
    <script language="JavaScript" src="js/itgPrjConfigSetup.js"></script>
    <script language="JavaScript" src="js/itgCheckForm.js"></script>
    <script type="text/javascript" src="js/calendar.js"></script>
    <script type="text/javascript" src="js/calDriver.js"></script>
    <script type="text/javascript" src="js/imageNavigation.js"></script>

    <script type="text/javascript" src="js/ajaxDropdown.js"></script>
    <script type="text/javascript" src="js/ajaxList.js"></script>
    <script type="text/javascript" src="js/ajaxSancAmount.js"></script>

    <script language="javascript">

    function lineStartWith5or6(){
//alert("lineStartWith5or6");
    	var system=document.forms[0].facilitySystem.value;
    	var lineNo = "0";
    	if(system != 'ET'){
    		lineNo=document.getElementById("lineNo").value;
	    	//alert("lineNo:"+lineNo);
    		if(lineNo=="" || lineNo==undefined){
    			lineNo ="0";
    		}
    	}
    	    	
    	    	 // var lineNo=" 5123";
    	    	//alert("lineNo1:"+lineNo);
    	    	  lineNo=lineNo.replace(/^\s+/g, "");
    	    	//  alert("lineNo 2:"+lineNo);
    	    	  var index5=lineNo.indexOf("5");
    	    	  var index6=lineNo.indexOf("6");
    	    	//  alert("index5:"+index5+" index6:"+index6);
    	    	  if(index5 == 0 || index6 == 0 ){
    	    	//	  alert("lineNo 3:");
    	    		return true;
    		 
    	    	  }else{
    	    		  return false;
    	    	  }
    }

	function submitLimit( isLmtSecChange ,adhocVal)    { 
    var adhocVal_1=adhocVal; 
    var isLineAdded_1='<%=isLineAdded%>';
   // alert("isLineAdded_1:"+isLineAdded_1);
		//alert("adhocVal:"+adhocVal);
		var lineFlag=lineStartWith5or6();
		  var system=document.forms[0].facilitySystem.value;
		 var fcunsSystem1= '<%=fcunsSystem%>';
	     var ubslimitSystem1= '<%=ubslimitSystem%>';
	   //  alert("fcunsSystem1:"+fcunsSystem1 +" lineFlag:"+lineFlag+" limittype:"+document.forms[0].limitType[1].checked);
	   
	     var releasableAmount=document.getElementById("releasableAmount").value;
		   var requiredSecCov=document.getElementById("requiredSecCov").value;
		   var totalReleasedAmount=document.getElementById("totalReleasedAmount").value;
		   
		  
		   if(releasableAmount==""){
			   releasableAmount="0.00";
		   }
		   if(requiredSecCov==""){
			   requiredSecCov="0.00";
		   }
		   if(totalReleasedAmount==""){
			   totalReleasedAmount="0.00";
		   }
		     //  alert("isAdhoc val:"+document.getElementById("isAdhoc").value +" sanctione amt:"+requiredSecCov+" releaseable:"+releasableAmount+" totalReleasedAmount	:"+totalReleasedAmount);
			   if( (adhocVal_1 == true) && (isLineAdded_1 == 'true') && (document.getElementById("isAdhoc").value == 'Y' || document.getElementById("isAdhoc").value == 'on') && (totalReleasedAmount =="0.00" )
					   && (releasableAmount !="0.00" || requiredSecCov !="0.00" )){
				   alert("ADHOC LIMITS, SANCTIONED/RELEASABLE AMOUNT ALSO NEEDS TO BE ZEROISED.");
			   }else{
    	if((lineFlag== true) && (document.forms[0].limitType[1].checked== true ) && (system == fcunsSystem1 || system == ubslimitSystem1)){
    	
			alert("Sublimit cannot be main limit. Please select sublimit radio button as 'Yes'.");
		}else{
			
		document.forms[0].deletedLmtSec.value = '';
		
		var msg = "Please ensure that all legal documents required are completed.";		      
		var toProcess = 1;
		if( toProcess == 1 ) {
			if (document.forms[0].isCreate.value == 'Y' && document.forms[0].limitRef.value == "")   {
				document.forms[0].event.value = 'create';
			} else{
				document.forms[0].event.value = 'submit';
			}
			if(document.forms[0].isAdhoc.checked == true || document.forms[0].checkAdhoc.checked == true ){
				alert("Please add adhoc limit at Party Financial details.");
			}
			document.getElementById('facilityCat').disabled = false;
	    	document.getElementById('facilityName').disabled = false;
	    	document.getElementById('currencyCode').disabled = false;
	    	var scodLineNo = '<%=scodLineNoList%>';
	    	//var lineno = document.getElementById('lineNo').value;
	    	var lineno = document.getElementById('lineNo').value;
			 var lineno_array = scodLineNo.split(',');
			 //var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
			// alert(lineno_array);
			// document.forms[0].isCreate.value = 'Y';
			 var flag = false;
			 for(var i = 0; i < lineno_array.length; i++) {
				// alert("LA "+lineno_array[i]+" LN"+lineno);
			    if(lineno_array[i] == lineno){
				  //  alert("true");
			    	flag = true;
			    }
			 }
	    	if(flag && document.getElementById('lineNo').value != ""){
	    		
	    		if(document.forms[0].isCreate.value != 'Y'){
	    		document.getElementById('scodDate').disabled = false;
				document.getElementById('Image723').disabled = false;
				document.getElementById('remarksSCOD').disabled = false;
				document.all.projectDelayedFlag[0].disabled =  false;
				document.all.projectDelayedFlag[1].disabled =  false;
	 		  if(document.getElementById('legalOrArbitrationLevel2FlagC').checked){
			  document.getElementById('legalOrArbitrationLevel2Flag').value = 'Y';
			  document.forms[0].legalOrArbitrationLevel2Flag.value = 'Y';
			  }else{
			  document.getElementById('legalOrArbitrationLevel2Flag').value = 'N';
			  document.forms[0].legalOrArbitrationLevel2Flag.value = 'N';
			  } 
	 		if(document.getElementById('chngOfOwnPrjFlagNonInfraLevel2C').checked){
				  document.getElementById('chngOfOwnPrjFlagNonInfraLevel2').value = 'Y';
				  document.forms[0].chngOfOwnPrjFlagNonInfraLevel2.value = 'Y';
				  }else{
				  document.getElementById('chngOfOwnPrjFlagNonInfraLevel2').value = 'N';
				  document.forms[0].chngOfOwnPrjFlagNonInfraLevel2.value = 'N';
				  }
	 		
	 		if(document.getElementById('reasonBeyondPromoterLevel2FlagC').checked){
				  document.getElementById('reasonBeyondPromoterLevel2Flag').value = 'Y';
				  document.forms[0].reasonBeyondPromoterLevel2Flag.value = 'Y';
				  }else{
				  document.getElementById('reasonBeyondPromoterLevel2Flag').value = 'N';
				  document.forms[0].reasonBeyondPromoterLevel2Flag.value = 'N';
				  }
	 		
	 		if(document.getElementById('chngOfProjScopeNonInfraLevel2C').checked){
				  document.getElementById('chngOfProjScopeNonInfraLevel2').value = 'Y';
				  document.forms[0].chngOfProjScopeNonInfraLevel2.value = 'Y';
				  }else{
				  document.getElementById('chngOfProjScopeNonInfraLevel2').value = 'N';
				  document.forms[0].chngOfProjScopeNonInfraLevel2.value = 'N';
				  }
	 		

	 		if(document.getElementById('chngOfOwnPrjFlagInfraLevel2C').checked){
				  document.getElementById('chngOfOwnPrjFlagInfraLevel2').value = 'Y';
				  document.forms[0].chngOfOwnPrjFlagInfraLevel2.value = 'Y';
				  }else{
				  document.getElementById('chngOfOwnPrjFlagInfraLevel2').value = 'N';
				  document.forms[0].chngOfOwnPrjFlagInfraLevel2.value = 'N';
				  }
	 		
	 		if(document.getElementById('chngOfProjScopeInfraLevel2C').checked){
				  document.getElementById('chngOfProjScopeInfraLevel2').value = 'Y';
				  document.forms[0].chngOfProjScopeInfraLevel2.value = 'Y';
				  }else{
				  document.getElementById('chngOfProjScopeInfraLevel2').value = 'N';
				  document.forms[0].chngOfProjScopeInfraLevel2.value = 'N';
				  }
			  
	 		
	 		
	 		
	 		
	 		if(document.getElementById('legalOrArbitrationLevel3FlagC').checked){
				  document.getElementById('legalOrArbitrationLevel3Flag').value = 'Y';
				  document.forms[0].legalOrArbitrationLevel3Flag.value = 'Y';
				  }else{
				  document.getElementById('legalOrArbitrationLevel3Flag').value = 'N';
				  document.forms[0].legalOrArbitrationLevel3Flag.value = 'N';
				  } 
		 		 
		 		if(document.getElementById('chngOfOwnPrjFlagNonInfraLevel3C').checked){
					  document.getElementById('chngOfOwnPrjFlagNonInfraLevel3').value = 'Y';
					  document.forms[0].chngOfOwnPrjFlagNonInfraLevel3.value = 'Y';
					  }else{
					  document.getElementById('chngOfOwnPrjFlagNonInfraLevel3').value = 'N';
					  document.forms[0].chngOfOwnPrjFlagNonInfraLevel3.value = 'N';
					  }
		 		
		 		if(document.getElementById('reasonBeyondPromoterLevel3FlagC').checked){
					  document.getElementById('reasonBeyondPromoterLevel3Flag').value = 'Y';
					  document.forms[0].reasonBeyondPromoterLevel3Flag.value = 'Y';
					  }else{
					  document.getElementById('reasonBeyondPromoterLevel3Flag').value = 'N';
					  document.forms[0].reasonBeyondPromoterLevel3Flag.value = 'N';
					  }
		 		
		 		if(document.getElementById('chngOfProjScopeNonInfraLevel3C').checked){
					  document.getElementById('chngOfProjScopeNonInfraLevel3').value = 'Y';
					  document.forms[0].chngOfProjScopeNonInfraLevel3.value = 'Y';
					  }else{
					  document.getElementById('chngOfProjScopeNonInfraLevel3').value = 'N';
					  document.forms[0].chngOfProjScopeNonInfraLevel3.value = 'N';
					  }
		 		

		 		if(document.getElementById('chngOfOwnPrjFlagInfraLevel3C').checked){
					  document.getElementById('chngOfOwnPrjFlagInfraLevel3').value = 'Y';
					  document.forms[0].chngOfOwnPrjFlagInfraLevel3.value = 'Y';
					  }else{
					  document.getElementById('chngOfOwnPrjFlagInfraLevel3').value = 'N';
					  document.forms[0].chngOfOwnPrjFlagInfraLevel3.value = 'N';
					  }
		 		if(document.getElementById('chngOfProjScopeInfraLevel3C').checked){
					  document.getElementById('chngOfProjScopeInfraLevel3').value = 'Y';
					  document.forms[0].chngOfProjScopeInfraLevel3.value = 'Y';
					  }else{
					  document.getElementById('chngOfProjScopeInfraLevel3').value = 'N';
					  document.forms[0].chngOfProjScopeInfraLevel3.value = 'N';
					  }
		 		
		 		
	    	}
		 		
			}
	    	document.getElementById('facilityName').disabled = false;
	    	document.forms[0].facCat.value = document.getElementById('facCat').value;
	    	document.forms[0].facName.value = document.getElementById('facName').value;
	    	//alert("1."+document.forms[0].facName.value);
	    	//alert("2."+document.forms[0].facCat.value);
	 
	    	 if("undefined" != (document.getElementById('DP')) && null != (document.getElementById('DP'))  ){
	    		 document.getElementById('DP').disabled = false;
	    		 document.getElementById('DP1').disabled = false;
	    		 
		        	if( document.getElementById('DP').checked){
		        		  document.getElementById('isDP').value = 'Y';
		        	}else{
		        		document.getElementById('isDP').value = 'N';
		        	}
	    	 }else{	
				 document.getElementById('isDP').disabled = false;
	    	  }
	    
			document.forms[0].submit();
			//newShowSilkScreen();
		}
		}
		   }
    }

    function saveLimit() {
		document.getElementById('facilityCat').disabled = false;
    	document.getElementById('facilityName').disabled = false;
    	document.getElementById('currencyCode').disabled = false;
    	var scodLineNo = '<%=scodLineNoList%>';
    	var lineno = document.getElementById('lineNo').value;
		 var scodLineNo = '<%=scodLineNoList%>';
		 var lineno_array = scodLineNo.split(',');
		 //var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
		 document.forms[0].isCreate.value != 'Y'
		 var flag = false;
		 for(var i = 0; i < lineno_array.length; i++) {
		    
		    if(lineno_array[i] == lineno){
		    	flag = true;
		    }
		 }
    	if(flag && document.getElementById('lineNo').value != ""){
    		
    		if(document.forms[0].isCreate.value != 'Y'){
    			document.all.projectDelayedFlag[0].disabled =  false;
				document.all.projectDelayedFlag[1].disabled =  false;
    			
    		}
    	}
    	document.forms[0].deletedLmtSec.value='';
        document.forms[0].event.value = 'save';
        document.forms[0].facCat.value = document.getElementById('facCat').value;
        document.forms[0].submit();
        //newShowSilkScreen();
    }

    function cancelSubmit(){
    	document.forms[0].deletedLmtSec.value='';
        var url = '<%= (String) request.getAttribute("returnUrl") %>';
        document.location.href = url;
        //newShowSilkScreen();
    }

    function createXRef(fcunsSystem,ubslimitSystem) {
	
    	var system=document.forms[0].facilitySystem.value;
      //  alert("System:"+ document.forms[0].facilitySystem.value);
   
    	if(system == fcunsSystem || system == ubslimitSystem){
        document.forms[0].fromEvent.value = 'update';
        document.forms[0].indexID.value = '';
        document.forms[0].event.value = 'create_sub_acnt_ubs';
        
    	document.getElementById('facilityCat').disabled = false;
    	document.getElementById('facilityName').disabled = false;
    	document.getElementById('currencyCode').disabled = false;
    	if("undefined" != document.getElementById('scodDate').value || null != document.getElementById('scodDate'))
		{
	   document.getElementById('scodDate').disabled = false;
		}
		document.getElementById('Image723').disabled = false;
		document.getElementById('remarksSCOD').disabled = false;

        var adhocFacFlag= document.getElementById('adhocFacility').checked;
			var adhoclastAvailDate= document.getElementById('adhocLastAvailDate').value;
			var adhocfacExpDate= document.getElementById('adhocFacilityExpDate').value;
			//alert("1"+adhocFacFlag+"  2 "+adhoclastAvailDate+ "  3"+adhocfacExpDate)
			if(adhocFacFlag && ( ''== adhoclastAvailDate || ''==  adhocfacExpDate )){
				alert("Please enter Adhoc Facility Expiry date & Adhoc Last Availability Date.");
			}else{
				 document.forms[0].submit();
			}
    	}else if(system == "ET"){
    		document.forms[0].fromEvent.value = 'update';
            document.forms[0].indexID.value = '';
            document.forms[0].event.value = 'create_sub_acnt_ts';

            document.getElementById('facilityCat').disabled = false;
	    	document.getElementById('facilityName').disabled = false;
    		document.getElementById('currencyCode').disabled = false;
            document.forms[0].submit();
    	}else{
    		document.forms[0].fromEvent.value = 'update';
            document.forms[0].indexID.value = '';
            document.forms[0].event.value = 'create_sub_acnt';
            
        	document.getElementById('facilityCat').disabled = false;
        	document.getElementById('facilityName').disabled = false;
        	document.getElementById('currencyCode').disabled = false;
    		if("undefined" != document.getElementById('scodDate').value || null != document.getElementById('scodDate'))
    		{
    	   document.getElementById('scodDate').disabled = false;
    		}
			document.getElementById('Image723').disabled = false;
			document.getElementById('remarksSCOD').disabled = false;

			
				 document.forms[0].submit();
			
            
    	}
    }

    function deleteXRef(){
        document.forms[0].itemType.value = 'actnref';
        document.forms[0].event.value = 'delete_item';
		
		document.getElementById('facilityCat').disabled = false;
    	document.getElementById('facilityName').disabled = false;
    	document.getElementById('currencyCode').disabled = false;
        document.forms[0].submit();
    }

    function updateXRef(editOrView , ind, xrefId,fcunsSystem,ubslimitSystem){
    	var system=document.forms[0].facilitySystem.value;
        
      	if(system == fcunsSystem || system == ubslimitSystem){
          	
        if(editOrView=="edit") {
        document.forms[0].fromEvent.value = 'update';
          if(document.forms[0].event.value =='prepare_cust_update') {
      		document.forms[0].fromEvent.value = 'prepare_cust_update';
      	}
        document.forms[0].indexID.value = ind;
         document.forms[0].lineDetailId.value = xrefId;
        document.forms[0].event.value = 'update_sub_acnt_ubs';
        
    	document.getElementById('facilityCat').disabled = false;
    	document.getElementById('facilityName').disabled = false;
    	document.getElementById('currencyCode').disabled = false;
        document.forms[0].submit();
        }
        if(editOrView == "view"){
        	document.forms[0].fromEvent.value = 'view';
        	 if(document.forms[0].event.value =='prepare_cust_update'){
          		document.forms[0].fromEvent.value = 'prepare_cust_update';
          	}
            document.forms[0].indexID.value = ind;
             document.forms[0].lineDetailId.value = xrefId;
            document.forms[0].event.value = 'view_sub_acnt_ubs';
            
        	document.getElementById('facilityCat').disabled = false;
        	document.getElementById('facilityName').disabled = false;
        	document.getElementById('currencyCode').disabled = false;
            document.forms[0].submit();
        }

        if(editOrView=="reopen") {
            document.forms[0].fromEvent.value = 'reopen';
              if(document.forms[0].event.value =='prepare_cust_update') {
          		document.forms[0].fromEvent.value = 'prepare_cust_update';
          	}
            document.forms[0].indexID.value = ind;
             document.forms[0].lineDetailId.value = xrefId;
            document.forms[0].event.value = 'reopen_sub_acnt_ubs';
            
        	document.getElementById('facilityCat').disabled = false;
        	document.getElementById('facilityName').disabled = false;
        	document.getElementById('currencyCode').disabled = false;
            document.forms[0].submit();
            }
        if(editOrView=="close") {
        	document.forms[0].fromEvent.value = 'close';
       	 if(document.forms[0].event.value =='prepare_cust_update'){
         		document.forms[0].fromEvent.value = 'prepare_cust_update';
         	}
           document.forms[0].indexID.value = ind;
            document.forms[0].lineDetailId.value = xrefId;
           document.forms[0].event.value = 'close_sub_acnt_ubs';
           
       		document.getElementById('facilityCat').disabled = false;
    		document.getElementById('facilityName').disabled = false;
    	    document.getElementById('currencyCode').disabled = false;
           	document.forms[0].submit();
            }

        if(editOrView=="updateStatus") {
        	document.forms[0].fromEvent.value = 'updateStatus';
       	 if(document.forms[0].event.value =='prepare_cust_update'){
         		document.forms[0].fromEvent.value = 'prepare_cust_update';
         	}
           document.forms[0].indexID.value = ind;
            document.forms[0].lineDetailId.value = xrefId;
           document.forms[0].event.value = 'updateStatus_sub_acnt_ubs';
            
            document.getElementById('facilityCat').disabled = false;
    		document.getElementById('facilityName').disabled = false;
    		document.getElementById('currencyCode').disabled = false;
           
           document.forms[0].submit();
            }
        
      	}else if(system == '<%=singaporeSystem%>' ){

      		if(editOrView=="edit") {
              document.forms[0].fromEvent.value = 'update';
              if(document.forms[0].event.value =='prepare_cust_update') {
          		document.forms[0].fromEvent.value = 'prepare_cust_update';
          	   }
              document.forms[0].indexID.value = ind;
              document.forms[0].lineDetailId.value = xrefId;
              document.forms[0].event.value = 'update_sub_acnt';
            
        	  document.getElementById('facilityCat').disabled = false;
        	  document.getElementById('facilityName').disabled = false;
        	  document.getElementById('currencyCode').disabled = false;
              document.forms[0].submit();
             }
            
            if(editOrView == "view"){
            	document.forms[0].fromEvent.value = 'view';
           	    if(document.forms[0].event.value =='prepare_cust_update'){
             		document.forms[0].fromEvent.value = 'prepare_cust_update';
             	}
                document.forms[0].indexID.value = ind;
                document.forms[0].lineDetailId.value = xrefId;
                document.forms[0].event.value = 'view_sub_acnt';
               
            	document.getElementById('facilityCat').disabled = false;
            	document.getElementById('facilityName').disabled = false;
            	document.getElementById('currencyCode').disabled = false;
                document.forms[0].submit();
            }

      	}else if(system == "ET"){ 
      	 		document.getElementById('facilityCat').disabled = false;
    		document.getElementById('facilityName').disabled = false;
    		document.getElementById('currencyCode').disabled = false;
      	         	
      		 if(editOrView=="edit") {
      	        document.forms[0].fromEvent.value = 'update';
      	          if(document.forms[0].event.value =='prepare_cust_update') {
      	      		document.forms[0].fromEvent.value = 'prepare_cust_update';
      	      	}
      	        document.forms[0].indexID.value = ind;
      	         document.forms[0].lineDetailId.value = xrefId;
      	        document.forms[0].event.value = 'update_sub_acnt_ts';
      	        
      	        document.forms[0].submit();
      	        }
      	        if(editOrView == "view"){
      	        	document.forms[0].fromEvent.value = 'view';
      	        	 if(document.forms[0].event.value =='prepare_cust_update'){
      	          		document.forms[0].fromEvent.value = 'prepare_cust_update';
      	          	}
      	            document.forms[0].indexID.value = ind;
      	             document.forms[0].lineDetailId.value = xrefId;
      	            document.forms[0].event.value = 'view_sub_acnt_ts';
      	            document.forms[0].submit();
      	        }

      	        if(editOrView=="reopen") {
      	            document.forms[0].fromEvent.value = 'reopen';
      	              if(document.forms[0].event.value =='prepare_cust_update') {
      	          		document.forms[0].fromEvent.value = 'prepare_cust_update';
      	          	}
      	            document.forms[0].indexID.value = ind;
      	             document.forms[0].lineDetailId.value = xrefId;
      	            document.forms[0].event.value = 'reopen_sub_acnt_ts';
      	            document.forms[0].submit();
      	            }
      	        if(editOrView=="close") {
      	        	document.forms[0].fromEvent.value = 'close';
      	       	 if(document.forms[0].event.value =='prepare_cust_update'){
      	         		document.forms[0].fromEvent.value = 'prepare_cust_update';
      	         	}
      	           document.forms[0].indexID.value = ind;
      	            document.forms[0].lineDetailId.value = xrefId;
      	           document.forms[0].event.value = 'close_sub_acnt_ts';
      	           document.forms[0].submit();
      	            }

      	        if(editOrView=="updateStatus") {
      	        	document.forms[0].fromEvent.value = 'updateStatus';
      	       	 if(document.forms[0].event.value =='prepare_cust_update'){
      	         		document.forms[0].fromEvent.value = 'prepare_cust_update';
      	         	}
      	           document.forms[0].indexID.value = ind;
      	            document.forms[0].lineDetailId.value = xrefId;
      	           document.forms[0].event.value = 'updateStatus_sub_acnt_ts';
      	           document.forms[0].submit();
      	            }
          	
      	}else{

          	
            if(editOrView=="edit") {
            document.forms[0].fromEvent.value = 'update';
              if(document.forms[0].event.value =='prepare_cust_update') {
          		document.forms[0].fromEvent.value = 'prepare_cust_update';
          	}
            document.forms[0].indexID.value = ind;
             document.forms[0].lineDetailId.value = xrefId;
            document.forms[0].event.value = 'update_sub_acnt';
            
        	document.getElementById('facilityCat').disabled = false;
        	document.getElementById('facilityName').disabled = false;
        	document.getElementById('currencyCode').disabled = false;
            document.forms[0].submit();
            }
            if(editOrView == "view"){
            	document.forms[0].fromEvent.value = 'view';
            	 if(document.forms[0].event.value =='prepare_cust_update'){
              		document.forms[0].fromEvent.value = 'prepare_cust_update';
              	}
                document.forms[0].indexID.value = ind;
                 document.forms[0].lineDetailId.value = xrefId;
                document.forms[0].event.value = 'view_sub_acnt';
                
            	document.getElementById('facilityCat').disabled = false;
            	document.getElementById('facilityName').disabled = false;
            	document.getElementById('currencyCode').disabled = false;
                document.forms[0].submit();
            }
          	
      	}
    }

    function createLmtSec() {
        document.forms[0].fromEvent.value = 'update';
        document.forms[0].event.value = 'create_sub_sec';
		
		document.getElementById('facilityCat').disabled = false;
    	document.getElementById('facilityName').disabled = false;
    	document.getElementById('currencyCode').disabled = false;
    	document.forms[0].facCat.value = document.getElementById('facCat').value;
        document.forms[0].submit();
    }

    function deleteLmtSec(indexId, action, securityId, securitySubtype,object)  {
       
        if(action =='Delete'){
        /*code start:Uma Khot 18/08/2015 Phase 3 CR:Show message box while deleteing security */
            var answer=confirm("Security OMV amount cannot be less than Limit Released Amount");
            if(answer == true){
            
          /*code end:Uma Khot 18/08/2015 Phase 3 CR:Show message box while deleteing security */   
	        document.forms[0].deletedLmtSec.value = indexId;
	        document.forms[0].securityIdDel.value = securityId;
	        document.forms[0].itemType.value = 'lmtsec';
	        document.forms[0].event.value = 'delete_item';
	        document.forms[0].action = "MILimit.do?deletedLmtSec="+document.forms[0].deletedLmtSec.value+"&securityIdDel="+securityId;
	        document.getElementById('facilityCat').disabled = false;
			document.getElementById('facilityName').disabled = false;
			document.getElementById('currencyCode').disabled = false;
			document.forms[0].submit();
            }
            else{
            	var optionId=object.id;
            	document.getElementById(optionId).selectedIndex="0";    
            }
        }
        if(action =='View'){
          if(document.forms[0].event.value =='prepare_cust_update'){
        		document.forms[0].fromEvent.value = 'prepare_cust_update';
        	}
        	document.forms[0].action = "MILimit.do?securityId="+securityId +"&securitySubtype=" +securitySubtype;		
	        document.forms[0].event.value = 'view_security';
			document.getElementById('facilityCat').disabled = false;
			document.getElementById('facilityName').disabled = false;
			document.getElementById('currencyCode').disabled = false;
	        document.forms[0].submit();
        }
    }

    function refreshFacName(dropdown) {
        var curSel = "";
            for(i=0; i < dropdown.options.length; i++)   {
                if (dropdown.options[i].selected == true) {
                    curSel = dropdown.options[i].value;
                }
            }
        var dep = 'facilityName';
        var url = '/cms/MILimit.do?event=refresh_facility_name&facCat='+curSel;
        sendLoadDropdownReq(dep, url);
        document.getElementById('facCat').value=curSel;
   }
    
    function refreshRiskType(dropdown) {
    	var curSel = "";
        var facCat = document.getElementById('facilityCat').value;
	    var facName= document.getElementById('facilityName').value;
	    var facCode= document.getElementById('facilityCode').value;
//      var facCat = document.forms[0].facilityCat.value;
//	    var facName= document.forms[0].facilityName.value;
	    document.getElementById('facName').value=facName;

	    var dep = 'riskType';
        var url = '/cms/MILimit.do?event=refresh_risk_type&facCat='+facCat+'&facName='+facName+'&facCode='+facCode;
        sendLoadDropdownReq(dep, url);
   }

    function refreshFacDetail(dropdown) {
        var curSel = "";
        var custID = document.forms[0].customerID.value;
        for(i=0; i < dropdown.options.length; i++)   {
            if (dropdown.options[i].selected == true) {
                curSel = dropdown.options[i].value;
            }
        }  
        //alert("curSel"+curSel);
        var dep = 'facilityType';
        var url = '/cms/MILimit.do?event=refresh_facility_detail&facName='+curSel+'&customerID='+custID;
        sendLoadListReq(dep, url);
       // var b =setInterval( ,50);
        setTimeout(populateSCODFields,400);
        setTimeout(populateSCODFields,500);
        setTimeout(populateSCODFields,600);
        setTimeout(populateSCODFields,700);
        setTimeout(populateSCODFields,800);
        setTimeout(populateSCODFields,900);
        setTimeout(populateSCODFields,1000);
		

        refreshFacSystem();
        setTimeout(refreshRiskType,1200);
        refreshRiskType();
        
    }

    function refreshFacSystem(){
        var delayInMilliseconds = 1000; //1 second
        setTimeout(function() {

       	var isLoanOptionAvailable =  document.forms[0].availAndOptionApplicable.value;   
       	populateRiskTypeFields(isLoanOptionAvailable);

    	var facSystem =  document.forms[0].facilitySystem.value;   
    	
    	if("UBS-LIMITS" != facSystem && "BAHRAIN" != facSystem && "HONGKONG" != facSystem  && "GIFTCITY" != facSystem  && "Singapore" != facSystem){
    		document.getElementById('addCoborrowerTable').style.display = 'none';
    	}
    	else if( "UBS-LIMITS" == facSystem || "Singapore" == facSystem || "BAHRAIN" == facSystem || "HONGKONG" == facSystem  || "GIFTCITY"== facSystem ){
    		document.getElementById('addCoborrowerTable').style.display = '';
    	}  

        	if(facSystem == "ET"){
           		document.getElementById('syndicateLoanHeading').style.display = 'none';
           		document.getElementById('syndicateLoanField').style.display = 'none';
           		document.getElementById('lineNoHeading').style.display = 'none';
           		document.getElementById('lineNoField').style.display = 'none';
           		document.getElementById('subLimitId').disabled = true;
				document.getElementById('guarantee').disabled = true;
           		document.getElementById('isDPRequired').checked = true;
           		document.getElementById('isDP').checked = true;
				document.forms[0].limitType[1].checked =true;
				document.forms[0].guarantee[1].checked =true;
				document.getElementById('51').style.display = 'none';
				document.getElementById('52').style.display = 'none';
				document.getElementById('53').style.display = 'none';
				document.getElementById('41').style.display = 'none';
          }else{
               	document.getElementById('syndicateLoanHeading').style.display = '';
               	document.getElementById('syndicateLoanField').style.display = '';
               	document.getElementById('lineNoHeading').style.display = '';
           		document.getElementById('lineNoField').style.display = '';
               	document.getElementById('subLimitId').disabled = false;
				document.forms[0].guarantee[0].disabled =false;
				document.forms[0].guarantee[1].disabled =false;
				document.getElementById('guarantee').disabled = false;
				
				var lineno = document.getElementById('lineNo').value;
				 var scodLineNo = '<%=scodLineNoList%>';
				 var lineno_array = scodLineNo.split(',');
				 document.forms[0].isCreate.value != 'Y'
				 var flag = false;
				 for(var i = 0; i < lineno_array.length; i++) {
				    
				    if(lineno_array[i] == lineno){
				    	flag = true;
				    }
				 }
				 if(flag){
					document.getElementById('51').style.display = '';
					document.getElementById('52').style.display = '';
					document.getElementById('53').style.display = '';
					document.getElementById('41').style.display = '';
				 }
          }
        	enableCovenantBtn();
        	
        	var isLoanOptionAvailable =  document.forms[0].availAndOptionApplicable.value;   
        	populateRiskTypeFields(isLoanOptionAvailable);
        	
        }, delayInMilliseconds);
        
          
    }
    
    function populateRiskTypeFields(isLoanOptionAvailable){
    	if(isLoanOptionAvailable == 'on'){
    		document.getElementById('loanOptionAvailabilityId').style.display = '';
    		document.getElementById('putCallOptionHeading').style.display = '';
    		document.getElementById('putCallOptionField').style.display = '';
    	}
    	else{
    		document.getElementById('loanOptionAvailabilityId').style.display = 'none';
    		document.getElementById('putCallOptionHeading').style.display = 'none';
    		document.getElementById('putCallOptionField').style.display = 'none';
    	}
    }
    
    
    function enablePurpose(obj){
    	if(obj.value=="Y"){
    		document.forms[0].purpose.disabled = false;
    		document.forms[0].otherPurpose.disabled = false;
    	}else{
    		document.forms[0].purpose.disabled = true;
    		document.forms[0].otherPurpose.disabled = true;
    	}
    }
    
   function refreshSubLimit(){
	 //  alert("refreshSubLimit");
	   var system=document.forms[0].facilitySystem.value;
	      //  alert("System:"+system);
	        var fcunsSystem1= '<%=fcunsSystem%>';
	        var ubslimitSystem1= '<%=ubslimitSystem%>';
	      //  alert("fcunsSystem1:"+fcunsSystem1+" :"+ubslimitSystem1);

	        
	      if(document.forms[0].isCreate.value=='Y' && (system == fcunsSystem1 || system == ubslimitSystem1)){
	        //  alert("test");
	  		var lineFlag=lineStartWith5or6();

	  	if(lineFlag== true){
	  	//	alert("lineFlag:"+lineFlag);
	  	document.forms[0].limitType[0].checked=true;
	  	enbleGnt(document.forms[0].limitType[0]);
	  	}else{
	  	document.forms[0].limitType[1].checked=true;
	  	enbleGnt(document.forms[0].limitType[1]);
	  	}
	      }else if(document.forms[0].isCreate.value=='Y' && (system !== fcunsSystem1 || system !== ubslimitSystem1)){
		      
		  	document.forms[0].limitType[1].checked=true;
		  	enbleGnt(document.forms[0].limitType[1]);
		  	
		      }
   }

    function enbleadhoc(){
      //alert (document.getElementById("isAdhoc").value);
    	if(document.getElementById("isAdhoc").value == '' || document.getElementById("isAdhoc").value == 'N'){
    		document.getElementById("isAdhoc").value= 'Y';
        	document.getElementById('adhoc').style.display = ''
    	}else{
    		document.forms[0].isAdhocToSum.checked = false;
    		document.getElementById("isAdhoc").value= 'N';
    		document.forms[0].adhocLmtAmount.value = '';
    		document.getElementById('inrValue').value='';
    		document.getElementById('adhoc').style.display = 'none'
    	}
    }

    function enbleGnt(selfObj){
    	if(selfObj.value == "Yes"){
    		document.forms[0].guarantee[0].disabled =false;
        	document.forms[0].guarantee[1].disabled =false;
    		//document.getElementById('subFacilityName').value = '';
        	document.getElementById('subPartyName').value = '';
        	document.getElementById('liabilityID').value = '';
        	document.forms[0].guarantee[0].checked =false;
        	document.forms[0].guarantee[1].checked =false;
    	}
    	if(selfObj.value == "No"){
    		document.forms[0].guarantee[0].checked =false;
        	document.forms[0].guarantee[1].checked =false;
    		document.forms[0].guarantee[0].disabled =true;
        	document.forms[0].guarantee[1].disabled =true;
        	document.getElementById('subPartyName').value = '';
        	document.getElementById('liabilityID').value = '';
        	document.getElementById('guaranteeYes').style.display = 'none'
        	document.getElementById('guaranteeNo').style.display = 'none'
        	
    	}
    }

    function enbleGuarantee(selfObj){
    	if(selfObj.value == "Yes"){
        	document.getElementById('guaranteeYes').style.display = ''
        	document.getElementById('guaranteeNo').style.display = 'none'
    	}
    	if(selfObj.value == "No"){
    		document.getElementById('guaranteeYes').style.display = 'none'
            document.getElementById('guaranteeNo').style.display = ''
            document.getElementById('subPartyName').value = '';
        	document.getElementById('liabilityID').value = '';
    	}
    }
    
      function   adhocAlert(selfObj){
    	  var tempVal=selfObj.value;
    	var val= document.forms[0].adhocFacilitytest.value;
    	var newFac= document.forms[0].adhocFacilityNew.value;
    	if("false" == newFac ){
    		alert("Adhoc Facility field cannot be modified")  
    		displayfields(val)
    	}
    	else{
    		displayfields(tempVal)
    	}
  }
    
    function displayfields(tempVal)
    {
    	 if("Y" == tempVal){
     		document.forms[0].adhocFacility[0].checked = true;
     		
     		document.forms[0].adhocLastAvailDate.disabled =false;
            	document.forms[0].adhocTenor.disabled =false;
        		document.forms[0].multiDrawdownAllow[0].disabled =false;
            	document.forms[0].multiDrawdownAllow[1].disabled =false;
            	document.forms[0].adhocFacilityExpDate.disabled =false;
		    	document.forms[0].ImageadhocFacilityExpDate.disabled =false;
		    	document.forms[0].ImageadhocLastAvailDate.disabled =false;

           	
         	document.forms[0].partyC[1].checked = false;
             document.forms[0].adhocLmtAmount.value = '';
         		
             document.forms[0].adhocLmtAmount.disabled ="disabled";
         	document.forms[0].partyC[1].disabled = "disabled";
         	document.forms[0].checkAdhoc[0].disabled ="disabled";
         	document.forms[0].checkAdhoc[1].disabled ="disabled";
     	}else if ( "N"== tempVal){
     		document.forms[0].adhocFacility[1].checked = true;
     		
     		document.forms[0].adhocLastAvailDate.disabled =true;
            	document.forms[0].adhocTenor.disabled =true;
            	document.forms[0].multiDrawdownAllow[0].checked =false;
            	document.forms[0].multiDrawdownAllow[1].checked =false;
        		document.forms[0].multiDrawdownAllow[0].disabled =true;
            	document.forms[0].multiDrawdownAllow[1].disabled =true;
            	document.forms[0].adhocFacilityExpDate.disabled =true;
		    	document.forms[0].ImageadhocFacilityExpDate.disabled =true;
		    	document.forms[0].ImageadhocLastAvailDate.disabled =true;

             document.forms[0].adhocLmtAmount.disabled ="";
          	document.forms[0].adhocLmtAmount.value = '0.00';
             
            	document.forms[0].partyC[1].disabled = "";
            	document.forms[0].checkAdhoc[0].disabled ="";
         	document.forms[0].checkAdhoc[1].disabled ="";
     	}
    	
    }
    
    function liabiltyID(selfObj){

    	var tempVal=selfObj.value;
    	var testVal=tempVal.split("-",2);
        document.getElementById("liabilityID").value=testVal[0];
    }
    function  checkbox(){
		if((document.getElementById("facilityCat").value == '' ||  document.getElementById("facilityName").value == '') && document.getElementById("partyC")) {
			alert("Select facility category and name before adding lines");
			document.getElementById("isReleased").value ="N";
			document.getElementById("partyC").checked = false;
		}else{
    	
	    	if(document.getElementById("isReleased").value=='N')   	{
	    		document.getElementById("btnAddXRef").disabled = false;
	    		document.getElementById("isReleased").value= "Y";
	    	} 	else if(document.getElementById("isReleased").value=='')  	{
	    		document.getElementById("btnAddXRef").disabled = false;
	    		document.getElementById("isReleased").value= "Y";
	    	}
	    	else if(document.getElementById("isReleased").value=='Y')
	    	{
	    		document.getElementById("btnAddXRef").disabled = true;
	    		document.getElementById("isReleased").value= "N";
	    	}

	    	refreshSubLimit();
		}
    	
    }
function  checkboxSecured(){

    	
    	if(document.getElementById("isSecured").value=='N')
    	{
        
    		document.getElementById("btnAddLmtSec").disabled = false;
    		document.getElementById("isSecured").value= "Y";
    	
    	}
    	else if(document.getElementById("isSecured").value=='')
    	{
    	
    		document.getElementById("btnAddLmtSec").disabled = false;
    		document.getElementById("isSecured").value= "Y";
    		
    	}
    	else if(document.getElementById("isSecured").value=='Y')
    	{
    		var isDPRequired = document.getElementById('isDPRequired').checked;
    		var shouldDP = false;
    		if(document.getElementById('DP'))
    			shouldDP = document.getElementById('DP').checked;
    		else if(document.getElementById('isDP'))
    			shouldDP = document.getElementById('isDP').checked;
			
    		var securedCheckbox = document.getElementById('isSecuredCheckbox');
    		var isDp = document.getElementById('isDP');
    		var isCollateralMapped = '<%=isCollateralMapped%>';
    		console.log("isDPRequired: "+isDPRequired+", shouldDP: "+shouldDP+", securedCheckbox: "+securedCheckbox.checked+", isCollateralMapped: "+isCollateralMapped);
    		if(isDPRequired && shouldDP && isCollateralMapped === 'Y'){
    			alert("Security is linked to the facility hence Secured checkbox cannot be unchecked.")
    			securedCheckbox.checked = true;
    			return;
    		}
    		else
    		{
    			document.getElementById("btnAddLmtSec").disabled = true;
        		document.getElementById("isSecured").value= "N";	
    		}
    		
    		
    	}
    }

	function convertToINR() {
	
	 var curSel = "";
	 var san="";
	 var adhok="";
        var sancAmount =document.getElementById('requiredSecCov').value;
		for(var i=0;i<sancAmount.length;i++){
			if(sancAmount[i]!=="m" && sancAmount[i]!=="M" && sancAmount[i]!=="b" && sancAmount[i]!=="B" &&
				(sancAmount[i] == 0 || sancAmount[i] == 1|| sancAmount[i] == 2|| 
						sancAmount[i] == 3|| sancAmount[i] == 4|| sancAmount[i] == 5|| sancAmount[i] == 6
						|| sancAmount[i] == 7 || sancAmount[i] == 8 || sancAmount[i] == 9)){
			san=san+sancAmount.charAt(i);			
			}
			
        if(sancAmount[i]==="m"|| sancAmount[i]==="M"){	        	
        sancAmount=sancAmount.toLowerCase().replace('M'," ");	        
        sancAmount=san*1000000;	    	        
        }
        
        if(sancAmount[i]==="B"|| sancAmount[i]==="b"){
	        sancAmount=sancAmount.replace('B'," ");
	        sancAmount=san*1000000000;		       
	        }
        }
		
        var currencyCode = document.getElementById('currencyCode').value;
        var tempSancAmount = document.getElementById('actSancAmount').value;
        //var adhocAmount = eval(document.getElementById('adhocLmtAmount').value);
        var adhocAmount = document.getElementById('adhocLmtAmount').value;
        if(adhocAmount==null || adhocAmount==='undefined' || adhocAmount===""){
        	adhocAmount="0.00";
        }else{
        for(var i=0;i<adhocAmount.length;i++){
			if(adhocAmount[i]!=="m" && adhocAmount[i]!=="M" && adhocAmount[i]!=="b" && adhocAmount[i]!=="B"){
				adhok=adhok+adhocAmount.charAt(i);			
			}
			
        if(adhocAmount[i]==="m"|| adhocAmount[i]==="M"){	        	
        	adhocAmount=adhocAmount.toLowerCase().replace('M'," ");	        
        	adhocAmount=adhok*1000000;	    	        
        }
        
        if(adhocAmount[i]==="B"|| adhocAmount[i]==="b"){
        	adhocAmount=adhocAmount.replace('B'," ");
        	adhocAmount=adhok*1000000000;		       
	        }
        	}
        }
        	
        
        
	        var dep = 'inrValue';
	        var url = '/cms/MILimit.do?event=refresh_inr_sanc&sancAmount='+sancAmount+'&currencyCode='+currencyCode+'&tempSancAmount='+tempSancAmount+'&adhocAmount='+adhocAmount;
	        sendLoadSancAmountReq(dep, url);
}
function onBlurEvent(txtSancAmount){
	var sancAmount=txtSancAmount.value;
	var len="";
	if(sancAmount.length>=1 && sancAmount.length<=38){
		var secondLastChar=sancAmount.charAt(sancAmount.length-1);
		if(secondLastChar==="M"){
			//sancAmount=sancAmount.slice(0,-1);
			sancAmount=sancAmount.replace("M"," ");
			sancAmount=sancAmount*1000000;
			//alert(sancAmount);
			len=sancAmount.toString().length;
			if(len<=38 && sancAmount.toString().charAt(1)!=="e"){
				txtSancAmount.value=sancAmount;
			}else{
				txtSancAmount.value="0.00";
			}
			
			//alert(sancAmount.toString().charAt(1));
			
		}
		else if(secondLastChar==="m"){
			//sancAmount=sancAmount.slice(0,-1);
			sancAmount=sancAmount.replace("m"," ");
			sancAmount=sancAmount*1000000;
			len=sancAmount.toString().length;
			if(len<=38 && sancAmount.toString().charAt(1)!=="e"){
				txtSancAmount.value=sancAmount;
			}else{
				txtSancAmount.value="0.00";
			}
			
		}
		else if(secondLastChar==="B"){
			//sancAmount=sancAmount.slice(0,-1);
			sancAmount=sancAmount.replace("B"," ");
			sancAmount=sancAmount*1000000000;
			len=sancAmount.toString().length;
			if(len<=38 && sancAmount.toString().charAt(1)!=="e"){
				txtSancAmount.value=sancAmount;
			}else{
				txtSancAmount.value="0.00";
			}
		}
		else if(secondLastChar==="b"){
			//sancAmount=sancAmount.slice(0,-1);
			sancAmount=sancAmount.replace("b"," ");
			sancAmount=sancAmount*1000000000;
			len=sancAmount.toString().length;
			if(len<=38 && sancAmount.toString().charAt(1)!=="e"){
				txtSancAmount.value=sancAmount;
			}else{
				txtSancAmount.value="0.00";
			}
		}
		else if(secondLastChar == 0 || secondLastChar == 1|| secondLastChar == 2|| 
				secondLastChar == 3|| secondLastChar == 4|| secondLastChar == 5|| secondLastChar == 6
				|| secondLastChar == 7 || secondLastChar == 8 || secondLastChar == 9){
			len=sancAmount.toString().length;
			if(len<=38){
				txtSancAmount.value=sancAmount;
			}else{
				txtSancAmount.value="0.00";
			}
		}
		else{
			//alert("Please enter numeric value only.");
			txtSancAmount.value="0.00";
		}
	}
	else{
		//alert("Please enter numeric value only.");
		txtSancAmount.value="0.00";
	}
}
function onKeyUpEvent(txtSancAmount){
	var sancAmount=txtSancAmount.value;
	if(sancAmount.length>1){
		var secondLastChar=sancAmount.charAt(sancAmount.length-2);
		if(secondLastChar==="M"){
			sancAmount=sancAmount.slice(0,-1);
			//sancAmount=sancAmount*1000000;
			txtSancAmount.value=sancAmount;
			//onChangeEvent(txtSancAmount.value);
		}
		if(secondLastChar==="m"){
			sancAmount=sancAmount.slice(0,-1);
			//sancAmount=sancAmount.replace("m","M");
			//sancAmount=sancAmount*1000000;
			txtSancAmount.value=sancAmount;
			//alert("Not Allow to enter more value.");
			
		}
		if(secondLastChar==="B"){
			sancAmount=sancAmount.slice(0,-1);
			//sancAmount=sancAmount.replace("B"," ");
			//sancAmount=sancAmount*1000000000;
			txtSancAmount.value=sancAmount;
			//alert("Not Allow to enter more value.");
		}
		if(secondLastChar==="b"){
			sancAmount=sancAmount.slice(0,-1);
			//sancAmount=sancAmount.replace("b"," ");
			//sancAmount=sancAmount*1000000000;
			txtSancAmount.value=sancAmount;
			//alert("Not Allow to enter more value.");
		}
	}
}
	
	function refreshLiabilityID(dropdown) {
        var curSel = "";
        for(i=0; i < dropdown.options.length; i++)   {
            if (dropdown.options[i].selected == true) {
                curSel = dropdown.options[i].value;
            }
        }  
        var dep = 'liabilityID';
        var url = '/cms/MILimit.do?event=refresh_facility_liability&subProfileId='+curSel;
        sendLoadDropdownReq(dep, url);
    }
	function checkAmount()
	{
		var relAmt="";
		 
        var releaseAmount =document.getElementById('releasableAmount').value;
		for(var i=0;i<releaseAmount.length;i++){
			if(releaseAmount[i]!=="m" && releaseAmount[i]!=="M" && releaseAmount[i]!=="b" && releaseAmount[i]!=="B"){
				relAmt=relAmt+releaseAmount.charAt(i);			
			}
			
        if(releaseAmount[i]==="m"|| releaseAmount[i]==="M"){	        	
        	releaseAmount=releaseAmount.toLowerCase().replace('M'," ");	        
        	releaseAmount=relAmt*1000000;	    	        
        }
        
        if(releaseAmount[i]==="B"|| releaseAmount[i]==="b"){
        	releaseAmount=releaseAmount.replace('B'," ");
        	releaseAmount=relAmt*1000000000;		       
	        }
        }
		
	}

	// Start: Uma:Phase 3 CR :Limit Calculation Dashboard 
	function limitCalculationDashboard(){
		// document.forms[0].fromEvent.value = 'update';
	     document.forms[0].event.value = 'create_limit_dashboard';
		document.getElementById('facilityCat').disabled = false;
    	document.getElementById('facilityName').disabled = false;
    	document.getElementById('currencyCode').disabled = false;
	     document.forms[0].submit();
    }
	// End: Uma:Phase 3 CR :Limit Calculation Dashboard 

	
	function disableSCOD(whlmreupSCOD){
		var whlmreupSCOD =document.all.whlmreupSCOD[0].checked;
		if(whlmreupSCOD == true){
		//document.getElementById('scodDate').disabled = true;
		//document.getElementById('Image723').disabled = true;
		//document.getElementById('remarksSCOD').disabled = true;
		document.all.projectDelayedFlag[0].disabled =  false;
		document.all.projectDelayedFlag[1].disabled =  false;
		document.getElementById('lelvelDelaySCOD').disabled = false;
		/*document.getElementById('actualCommOpsDate').disabled = false;
		document.getElementById('Image758').style.display = ''; */
		disableSCODOnDelay(document.all.projectDelayedFlag[0].checked);
		}
		
		if(whlmreupSCOD == false){
			//document.getElementById('scodDate').disabled = true;
			//document.getElementById('Image723').disabled = true;
			//document.getElementById('Image723').style.display = 'none';
			//document.getElementById('remarksSCOD').disabled = false;
			document.getElementById('lelvelDelaySCOD').disabled = true;
			//document.getElementById('actualCommOpsDate').disabled = true;
			//document.getElementById('Image758').style.display = 'none';
			document.getElementById('lelvelDelaySCOD').value = '';
			//document.getElementById('actualCommOpsDate').value = '';
			//alert(document.forms[0].lelvelDelaySCOD.value);
			document.getElementById('lelvelDelaySCOD').value = '';
			lelvelDelaySCODFun(document.getElementById('lelvelDelaySCOD').value);
			document.all.projectDelayedFlag[0].disabled =  true;
			document.all.projectDelayedFlag[1].disabled =  true;
			document.all.projectDelayedFlag[1].checked =  true;
			
			disableSCODOnDelay(document.all.projectDelayedFlag[0].checked);
		}
		
		
	}
	
	 function disableSCODOnDelay(projectDelayed){
		 
		var projectDelayed =document.all.projectDelayedFlag[0].checked;
		var whlmreupSCOD =document.all.whlmreupSCOD[0].checked;
		
		if(projectDelayed == true && whlmreupSCOD== true){
		document.getElementById('lelvelDelaySCOD').disabled = false;
		//document.getElementById('actualCommOpsDate').disabled = true;
		//document.getElementById('Image758').style.display = 'none';
		//document.getElementById('actualCommOpsDate').value = '';
		//document.forms[0].actualCommOpsDate.value = '';
		}
		
		if(projectDelayed == false && whlmreupSCOD== true){
		document.getElementById('lelvelDelaySCOD').disabled = true;
		//document.getElementById('actualCommOpsDate').disabled = false;
		//document.getElementById('Image758').style.display = '';
		document.getElementById('lelvelDelaySCOD').value = '';
		lelvelDelaySCODFun(document.getElementById('lelvelDelaySCOD').value);
		
		}
		
		
	} 
	
	
	window.onload = function(){
		
		var scodLineNo = '<%=scodLineNoList%>';
    	var lineno = document.forms[0].lineNo.value;
		 var scodLineNo = '<%=scodLineNoList%>';
		 var lineno_array = scodLineNo.split(',');
	  	 //var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
		 document.forms[0].isCreate.value != 'Y'
		// alert("hii");
		 /* if(lineno == null || lineno==''){
			 populateSCODFields();
		 } */
		 var flag = false;
		 for(var i = 0; i < lineno_array.length; i++) {
		    
		    if(lineno_array[i] == lineno){
		    	flag = true;
		    }
		 }
		 
		 if(lineno == null || lineno=='' || flag== false){
			 populateSCODFields();
		 }

		//alert(scodLineNo);
		var status = '<%=status%>';
		document.forms[0].status.value = status
			if(flag){
		var event = document.forms[0].event.value;
		if( event == 'prepare_update' || event == 'null' || event == 'process_update'){
			disableSCOD(document.getElementById('whlmreupSCOD').value);
		var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
		var whlmreupSCOD = document.all.whlmreupSCOD[0].checked;
		/* if(whlmreupSCOD == true){
			document.getElementById('scodDate').disabled = true;
			document.getElementById('Image723').disabled = true;
			document.getElementById('remarksSCOD').disabled = true;
			}
			if(whlmreupSCOD == false){
				document.getElementById('scodDate').disabled = false;
				document.getElementById('Image723').disabled = false;
				document.getElementById('remarksSCOD').disabled = false;
			} */
			document.getElementById('exstAssetClass').disabled = false;
			var projectDelayed =document.all.projectDelayedFlag[0].checked;
			disableSCODOnDelay(projectDelayed);
			if (document.all.projectDelayedFlag[0].checked == false && document.all.projectDelayedFlag[1].checked == false){
				document.all.projectDelayedFlag[1].checked =  true;
				}
			if(levelOfDealy == "1"){
				//document.getElementById('reasonLevelOneDelay').style.display = 'none';
				
				/* document.getElementById('revsedESCODStpDate').disabled = true;
				document.getElementById('Image729').disabled = true; */
				//document.getElementById('Image101').style.display = 'none';
				document.getElementById('Image201').style.display = 'none';
				
				document.getElementById('4').style.display = 'none';
				document.getElementById('5').style.display = 'none';
				document.getElementById('7').style.display = 'none';
				document.getElementById('8').style.display = 'none';
				document.getElementById('9').style.display = 'none';
				document.getElementById('10').style.display = 'none';
				document.getElementById('11').style.display = 'none';
				document.getElementById('17').style.display = 'none';
				document.getElementById('18').style.display = 'none';
				document.getElementById('12').style.display = 'none';
				document.getElementById('13').style.display = 'none';
				document.getElementById('14').style.display = 'none';
				document.getElementById('15').style.display = 'none';
				document.getElementById('16').style.display = 'none';
				document.getElementById('17').style.display = 'none'; 
				document.getElementById('21').style.display = '';
				document.getElementById('23').style.display = 'none';
				document.getElementById('24').style.display = 'none';
				document.getElementById('26').style.display = 'none';
				document.getElementById('27').style.display = 'none';
				document.getElementById('29').style.display = 'none';
				document.getElementById('30').style.display = 'none';
				document.getElementById('23').style.display = 'none';
				document.getElementById('33').style.display = 'none'; 
				document.getElementById('6').style.display = 'none';
				document.getElementById('32').style.display = 'none';
				document.getElementById('20').style.display = 'none';
				document.getElementById('35').style.display = 'none';
				document.getElementById('38').style.display = 'none';
				document.getElementById('39').style.display = 'none';
				document.getElementById('40').style.display = 'none';
				//document.getElementById('2').style.display = 'none';
				document.getElementById('41').style.display = 'none';
				document.getElementById('36').style.display = 'none';
				//document.getElementById('45').style.display = 'none';
				document.getElementById('31').style.display = '';
				document.getElementById('0').style.display = 'none';
				document.getElementById('72').style.display = '';
				if (document.all.projectDelayedFlag[0].checked == false && document.all.projectDelayedFlag[1].checked == false){
				document.all.projectDelayedFlag[1].checked =  true;
				}
				if (document.all.principalInterestSchFlag[0].checked == false && document.all.principalInterestSchFlag[1].checked == false){
				document.all.principalInterestSchFlag[1].checked =  true;
				}
				if (document.all.recvPriorOfSCOD[0].checked == false && document.all.recvPriorOfSCOD[1].checked == false){
					document.all.recvPriorOfSCOD[1].checked =  true;
				}
				if (document.all.chngInRepaySchedule[0].checked == false && document.all.chngInRepaySchedule[1].checked == false){
					document.all.chngInRepaySchedule[1].checked =  true;
				}
				if (document.all.promotersCapRunFlag[0].checked == false && document.all.promotersCapRunFlag[1].checked == false){
					document.all.promotersCapRunFlag[1].checked =  true;
				}
				if (document.all.promotersCapRunFlag[0].checked == false && document.all.promotersCapRunFlag[1].checked == false){
					document.all.promotersCapRunFlag[1].checked =  true;
				}
				if (document.all.promotersHoldEquityFlag[0].checked == false && document.all.promotersHoldEquityFlag[1].checked == false){
					document.all.promotersHoldEquityFlag[1].checked =  true;
				}
				if (document.all.hasProjectViabReAssFlag[0].checked == false && document.all.hasProjectViabReAssFlag[1].checked == false){
					document.all.hasProjectViabReAssFlag[1].checked =  true;
				}
				if (document.all.changeInScopeBeforeSCODFlag[0].checked == false && document.all.changeInScopeBeforeSCODFlag[1].checked == false){
					document.all.changeInScopeBeforeSCODFlag[1].checked =  true;
				}
				if (document.all.costOverrunOrg25CostViabilityFlag[0].checked == false && document.all.costOverrunOrg25CostViabilityFlag[1].checked == false){
					document.all.costOverrunOrg25CostViabilityFlag[1].checked =  true;
				}
				if (document.all.projectViabReassesedFlag[0].checked == false && document.all.projectViabReassesedFlag[1].checked == false){
					document.all.projectViabReassesedFlag[1].checked =  true;
				}
				
				//document.getElementById('projectDelayedFlagL2A').style.checked = true;
				/* document.all.projectFinance[0].disabled =  true;
				document.all.projectFinance[1].disabled =  true;
				document.all.projectLoan[0].disabled =  true;
				document.all.projectLoan[1].disabled =  true;
				document.all.infaProjectFlag[0].disabled =  true;
				document.all.infaProjectFlag[1].disabled =  true; 
				*/
				document.all.whlmreupSCOD[0].disabled =  false;
				document.all.whlmreupSCOD[1].disabled =  false;
				/* document.all.principalInterestSchFlag[0].disabled =  true;
				document.all.principalInterestSchFlag[1].disabled =  true; */
				
				
				
				
			}
			
			
			if(levelOfDealy == "2"){
				//document.getElementById('reasonLevelOneDelay').style.display = 'none';
				disableReason();
				//document.getElementById('Image102').style.display = 'none';
				document.getElementById('3').style.display = 'none';
				document.getElementById('5').style.display = 'none';
				document.getElementById('6').style.display = 'none';
				document.getElementById('12').style.display = 'none';
				document.getElementById('13').style.display = 'none';
				document.getElementById('14').style.display = 'none';
				document.getElementById('15').style.display = 'none';
				document.getElementById('16').style.display = 'none';
				document.getElementById('18').style.display = 'none';
				document.getElementById('19').style.display = 'none';
				document.getElementById('28').style.display = 'none';
				document.getElementById('30').style.display = 'none';
				document.getElementById('34').style.display = 'none';
				document.getElementById('40').style.display = 'none';
				document.getElementById('37').style.display = 'none'; 
				//document.getElementById('1').style.display = 'none';
				document.getElementById('39').style.display = 'none';
				document.getElementById('31').style.display = 'none';
				document.getElementById('33').style.display = 'none';
				document.getElementById('27').style.display = 'none';
				document.getElementById('30').style.display = 'none';
				document.getElementById('33').style.display = 'none'; 
				document.getElementById('6').style.display = 'none';
				document.getElementById('32').style.display = '';
				//document.getElementById('2').style.display = 'none';
				document.getElementById('41').style.display = 'none';
				document.getElementById('22').style.display = 'none';
				document.getElementById('24').style.display = 'none';
				document.getElementById('25').style.display = 'none';
				//document.getElementById('45').style.display = 'none';
				document.getElementById('36').style.display = 'none';
				document.getElementById('0').style.display = 'none';
				document.getElementById('9').style.display = '';
				document.getElementById('21').style.display = '';
				document.getElementById('72').style.display = 'none';
				document.getElementById('41').style.display = 'none';
				if (document.all.projectDelayedFlag[0].checked == false && document.all.projectDelayedFlag[1].checked == false){
				document.all.projectDelayedFlag[1].checked =  true;
				}
				if (document.all.principalInterestSchFlag[0].checked == false && document.all.principalInterestSchFlag[1].checked == false){
				document.all.principalInterestSchFlag[1].checked =  true;
				}
				if (document.all.recvPriorOfSCOD[0].checked == false && document.all.recvPriorOfSCOD[1].checked == false){
					document.all.recvPriorOfSCOD[1].checked =  true;
				}
				if (document.all.chngInRepaySchedule[0].checked == false && document.all.chngInRepaySchedule[1].checked == false){
					document.all.chngInRepaySchedule[1].checked =  true;
				}
				if (document.all.promotersCapRunFlag[0].checked == false && document.all.promotersCapRunFlag[1].checked == false){
					document.all.promotersCapRunFlag[1].checked =  true;
				}
				if (document.all.promotersCapRunFlag[0].checked == false && document.all.promotersCapRunFlag[1].checked == false){
					document.all.promotersCapRunFlag[1].checked =  true;
				}
				if (document.all.promotersHoldEquityFlag[0].checked == false && document.all.promotersHoldEquityFlag[1].checked == false){
					document.all.promotersHoldEquityFlag[1].checked =  true;
				}
				if (document.all.hasProjectViabReAssFlag[0].checked == false && document.all.hasProjectViabReAssFlag[1].checked == false){
					document.all.hasProjectViabReAssFlag[1].checked =  true;
				}
				if (document.all.changeInScopeBeforeSCODFlag[0].checked == false && document.all.changeInScopeBeforeSCODFlag[1].checked == false){
					document.all.changeInScopeBeforeSCODFlag[1].checked =  true;
				}
				if (document.all.costOverrunOrg25CostViabilityFlag[0].checked == false && document.all.costOverrunOrg25CostViabilityFlag[1].checked == false){
					document.all.costOverrunOrg25CostViabilityFlag[1].checked =  true;
				}
				if (document.all.projectViabReassesedFlag[0].checked == false && document.all.projectViabReassesedFlag[1].checked == false){
					document.all.projectViabReassesedFlag[1].checked =  true;
				}
				//document.getElementById('projectDelayedFlagL2A').style.checked = true;
				/* document.all.projectFinance[0].disabled =  true;
				document.all.projectFinance[1].disabled =  true;
				document.all.projectLoan[0].disabled =  true;
				document.all.projectLoan[1].disabled =  true; */
				document.all.infaProjectFlag[0].disabled =  true;
				document.all.infaProjectFlag[1].disabled =  true;
				document.all.whlmreupSCOD[0].disabled =  false;
				document.all.whlmreupSCOD[1].disabled =  false;
				/* document.all.principalInterestSchFlag[0].disabled =  true;
				document.all.principalInterestSchFlag[1].disabled =  true; */
			}
			
			
			if(levelOfDealy == "3"){
				disableReason();
				//document.getElementById('Image103').style.display = 'none';
				document.getElementById('3').style.display = '';
				document.getElementById('5').style.display = '';
				document.getElementById('6').style.display = '';
				document.getElementById('12').style.display = '';
				document.getElementById('13').style.display = '';
				document.getElementById('14').style.display = '';
				document.getElementById('15').style.display = '';
				document.getElementById('16').style.display = '';
				document.getElementById('18').style.display = '';
				document.getElementById('19').style.display = '';
				document.getElementById('28').style.display = '';
				document.getElementById('30').style.display = '';
				document.getElementById('34').style.display = '';
				document.getElementById('40').style.display = '';
				document.getElementById('37').style.display = ''; 
				
				document.getElementById('39').style.display = '';
				document.getElementById('31').style.display = '';
				document.getElementById('33').style.display = '';
				document.getElementById('27').style.display = '';
				document.getElementById('30').style.display = '';
				document.getElementById('33').style.display = ''; 
				document.getElementById('6').style.display = '';
				document.getElementById('32').style.display = '';
				document.getElementById('20').style.display = '';
				//document.getElementById('2').style.display = '';
				document.getElementById('41').style.display = '';
				document.getElementById('22').style.display = '';
				document.getElementById('24').style.display = '';
				document.getElementById('25').style.display = '';
				
				
				
				
				
				//document.getElementById('1').style.display = 'none';
				//document.getElementById('2').style.display = 'none';
				document.getElementById('20').style.display = 'none';
				document.getElementById('4').style.display = 'none';
				document.getElementById('3').style.display = 'none';
				document.getElementById('7').style.display = 'none';
				document.getElementById('8').style.display = 'none';
				document.getElementById('9').style.display = 'none';
				document.getElementById('10').style.display = 'none';
				document.getElementById('11').style.display = 'none';
				document.getElementById('17').style.display = 'none';
				document.getElementById('19').style.display = 'none';
				document.getElementById('22').style.display = 'none';
				document.getElementById('23').style.display = 'none';
				document.getElementById('25').style.display = 'none'; 
				
				document.getElementById('26').style.display = 'none';
				document.getElementById('28').style.display = 'none';
				document.getElementById('29').style.display = 'none';
				document.getElementById('34').style.display = 'none';
				document.getElementById('35').style.display = 'none';
				document.getElementById('37').style.display = 'none'; 
				document.getElementById('38').style.display = 'none';
				document.getElementById('32').style.display = 'none';
				document.getElementById('31').style.display = 'none';
				document.getElementById('41').style.display = 'none';
				document.getElementById('22').style.display = 'none';
				document.getElementById('36').style.display = 'none';
				document.getElementById('0').style.display = 'none';
				document.getElementById('21').style.display = '';
				document.getElementById('72').style.display = 'none';
				
				
				
				
				
				
				/* if (document.all.projectDelayedFlagL3[0].checked == false && document.all.projectDelayedFlagL3[1].checked == false){
					document.all.projectDelayedFlagL3[1].checked =  true;
					} */
					if (document.all.principalInterestSchFlag[0].checked == false && document.all.principalInterestSchFlag[1].checked == false){
					document.all.principalInterestSchFlag[1].checked =  true;
					}
					if (document.all.chngInRepayScheduleL3[0].checked == false && document.all.chngInRepayScheduleL3[1].checked == false){
						document.all.chngInRepayScheduleL3[1].checked =  true;
					}
					if (document.all.promotersCapRunFlagL3[0].checked == false && document.all.promotersCapRunFlagL3[1].checked == false){
						document.all.promotersCapRunFlagL3[1].checked =  true;
					}
					
					if (document.all.promotersHoldEquityFlagL3[0].checked == false && document.all.promotersHoldEquityFlagL3[1].checked == false){
						document.all.promotersHoldEquityFlagL3[1].checked =  true;
					}
					if (document.all.hasProjectViabReAssFlagL3[0].checked == false && document.all.hasProjectViabReAssFlagL3[1].checked == false){
						document.all.hasProjectViabReAssFlagL3[1].checked =  true;
					}
					if (document.all.changeInScopeBeforeSCODFlagL3[0].checked == false && document.all.changeInScopeBeforeSCODFlagL3[1].checked == false){
						document.all.changeInScopeBeforeSCODFlagL3[1].checked =  true;
					}
					if (document.all.costOverrunOrg25CostViabilityFlagL3[0].checked == false && document.all.costOverrunOrg25CostViabilityFlagL3[1].checked == false){
						document.all.costOverrunOrg25CostViabilityFlagL3[1].checked =  true;
					}
					if (document.all.projectViabReassesedFlagL3[0].checked == false && document.all.projectViabReassesedFlagL3[1].checked == false){
						document.all.projectViabReassesedFlagL3[1].checked =  true;
					}
					/* document.all.projectFinance[0].disabled =  true;
					document.all.projectFinance[1].disabled =  true;
					document.all.projectLoan[0].disabled =  true;
					document.all.projectLoan[1].disabled =  true; */
					document.all.infaProjectFlag[0].disabled =  true;
					document.all.infaProjectFlag[1].disabled =  true;
					document.all.whlmreupSCOD[0].disabled =  false;
					document.all.whlmreupSCOD[1].disabled =  false;
					/* document.all.principalInterestSchFlag[0].disabled =  true;
					document.all.principalInterestSchFlag[1].disabled =  true; */
				
					
			}
			
			if(levelOfDealy == ""){
				//document.getElementById('1').style.display = 'none';
				//document.getElementById('2').style.display = 'none';
				document.getElementById('20').style.display = 'none';
				document.getElementById('4').style.display = 'none';
				document.getElementById('3').style.display = 'none';
				document.getElementById('7').style.display = 'none';
				
				document.getElementById('8').style.display = 'none';
				document.getElementById('9').style.display = 'none';
				document.getElementById('10').style.display = 'none';
				document.getElementById('11').style.display = 'none';
				document.getElementById('17').style.display = 'none';
				document.getElementById('19').style.display = 'none';
				document.getElementById('22').style.display = 'none';
				document.getElementById('23').style.display = 'none';
				document.getElementById('25').style.display = 'none'; 
				
				document.getElementById('26').style.display = 'none';
				document.getElementById('28').style.display = 'none';
				document.getElementById('29').style.display = 'none';
				document.getElementById('34').style.display = 'none';
				document.getElementById('35').style.display = 'none';
				document.getElementById('37').style.display = 'none'; 
				document.getElementById('38').style.display = 'none';
				document.getElementById('32').style.display = 'none';
				document.getElementById('31').style.display = 'none';
				document.getElementById('41').style.display = 'none';
				document.getElementById('22').style.display = 'none';
				
				document.getElementById('3').style.display = 'none';
				document.getElementById('5').style.display = 'none';
				document.getElementById('6').style.display = 'none';
				document.getElementById('12').style.display = 'none';
				document.getElementById('13').style.display = 'none';
				document.getElementById('14').style.display = 'none';
				document.getElementById('15').style.display = 'none';
				document.getElementById('16').style.display = 'none';
				document.getElementById('18').style.display = 'none';
				document.getElementById('19').style.display = 'none';
				document.getElementById('28').style.display = 'none';
				document.getElementById('30').style.display = 'none';
				document.getElementById('34').style.display = 'none';
				document.getElementById('40').style.display = 'none';
				document.getElementById('37').style.display = 'none'; 
				//document.getElementById('1').style.display = 'none';
				document.getElementById('39').style.display = 'none';
				document.getElementById('31').style.display = 'none';
				document.getElementById('33').style.display = 'none';
				document.getElementById('27').style.display = 'none';
				document.getElementById('30').style.display = 'none';
				document.getElementById('33').style.display = 'none'; 
				document.getElementById('6').style.display = 'none';
				document.getElementById('32').style.display = 'none';
				document.getElementById('39').style.display = 'none';
				//document.getElementById('2').style.display = 'none';
				document.getElementById('22').style.display = 'none';
				document.getElementById('24').style.display = 'none';
				document.getElementById('25').style.display = 'none';
				//document.getElementById('45').style.display = 'none';
				
				document.getElementById('4').style.display = 'none';
				document.getElementById('5').style.display = 'none';
				document.getElementById('7').style.display = 'none';
				document.getElementById('8').style.display = 'none';
				document.getElementById('9').style.display = 'none';
				document.getElementById('10').style.display = 'none';
				document.getElementById('11').style.display = 'none';
				document.getElementById('17').style.display = 'none';
				document.getElementById('18').style.display = 'none';
				document.getElementById('12').style.display = 'none';
				document.getElementById('13').style.display = 'none';
				document.getElementById('14').style.display = 'none';
				document.getElementById('15').style.display = 'none';
				document.getElementById('16').style.display = 'none';
				document.getElementById('17').style.display = 'none'; 
				
				document.getElementById('23').style.display = 'none';
				document.getElementById('24').style.display = 'none';
				document.getElementById('26').style.display = 'none';
				document.getElementById('27').style.display = 'none';
				document.getElementById('29').style.display = 'none';
				document.getElementById('30').style.display = 'none';
				document.getElementById('23').style.display = 'none';
				document.getElementById('33').style.display = 'none'; 
				document.getElementById('6').style.display = 'none';
				document.getElementById('32').style.display = 'none';
				document.getElementById('20').style.display = 'none';
				document.getElementById('35').style.display = 'none';
				document.getElementById('38').style.display = 'none';
				document.getElementById('39').style.display = 'none';
				document.getElementById('40').style.display = 'none';
				//document.getElementById('2').style.display = 'none';
				document.getElementById('41').style.display = '';
				document.getElementById('36').style.display = '';
				//document.getElementById('45').style.display = 'none';
				document.getElementById('21').style.display = 'none';
				document.getElementById('0').style.display = '';
				document.getElementById('72').style.display = 'none';
				
				/* document.all.projectFinance[0].disabled =  true;
				document.all.projectFinance[1].disabled =  true;
				document.all.projectLoan[0].disabled =  true;
				document.all.projectLoan[1].disabled =  true;
				document.all.infaProjectFlag[0].disabled =  true;
				document.all.infaProjectFlag[1].disabled =  true; */

				/* document.all.principalInterestSchFlag[0].disabled =  true;
				document.all.principalInterestSchFlag[1].disabled =  true; */

				/* if(document.getElementById('exstAssetClass').value != null || document.getElementById('exstAssetClass').value != "" ){
				document.getElementById('exstAssetClass').disabled = true;
				document.getElementById('exstAssClassDate').disabled = true;
				document.getElementById('Image756').style.display = 'none';
				
				
				} */
				if (document.all.chngInRepaySchedule[0].checked == false && document.all.chngInRepaySchedule[1].checked == false){
					document.all.chngInRepaySchedule[1].checked =  true;
				}
				
				//alert(delayFlag);
				if((status == 'REJECTED'  || status == 'DRAFT') && (document.all.whlmreupSCOD[0].checked == false && document.all.whlmreupSCOD[1].checked == false)){
					document.all.projectFinance[0].disabled =  false;
					document.all.projectFinance[1].disabled =  false;
					document.all.projectLoan[0].disabled =  false;
					document.all.projectLoan[1].disabled =  false;
					document.all.infaProjectFlag[0].disabled =  false;
					document.all.infaProjectFlag[1].disabled =  false;
					document.all.projectDelayedFlag[0].checked = false;
					document.all.projectDelayedFlag[1].checked =  false;
					document.getElementById('exstAssetClass').disabled = false;
					document.getElementById('exstAssClassDate').disabled = false;
					document.getElementById('Image756').style.display = '';
					
					document.getElementById('41').style.display = '';
					document.getElementById('80').style.display = 'none';
					document.getElementById('81').style.display = 'none';
					document.getElementById('82').style.display = 'none';
					document.getElementById('36').style.display = 'none';
					document.getElementById('0').style.display = 'none';
					
				}
			}
			
			
		}
		}
		<%-- document.forms[0].availAndOptionApplicable.value= '<%=availAndOptionApplicable%>'; --%>
		var availAndOptionApplicable = '<%=availAndOptionApplicable%>';
		document.getElementById('availAndOptionApplicable').value = '<%=availAndOptionApplicable%>';
		populateRiskTypeFields(availAndOptionApplicable);

		setTimeout(enableCovenantBtn(), 1000);
		
	}
	
	function changeLevelOfDelay(actualCommOpsDate){
		if(document.getElementById('lelvelDelaySCOD').value != ''){
			document.getElementById('lelvelDelaySCOD').value = '';
			lelvelDelaySCODFun(document.getElementById('lelvelDelaySCOD').value);
		}
	}
	
	
	function disableReason(){
		if(document.all.infaProjectFlag[1].checked == true){
			document.getElementById('legalOrArbitrationLevel2FlagC').disabled = true;
			document.getElementById('reasonBeyondPromoterLevel2FlagC').disabled = true;
			document.getElementById('chngOfOwnPrjFlagInfraLevel2C').disabled = true;
			document.getElementById('chngOfProjScopeInfraLevel2C').disabled = true;
			
			document.getElementById('legalOrArbitrationLevel3FlagC').disabled = true;
			document.getElementById('reasonBeyondPromoterLevel3FlagC').disabled = true;
			document.getElementById('chngOfOwnPrjFlagInfraLevel3C').disabled = true;
			document.getElementById('chngOfProjScopeInfraLevel3C').disabled = true;
			document.getElementById('leaglOrArbiProceed').disabled = true;
			document.getElementById('detailsRsnByndPro').disabled = true;
			document.getElementById('chngOfOwnPrjFlagNonInfraLevel2C').disabled = false;
			document.getElementById('chngOfProjScopeNonInfraLevel2C').disabled = false;
			document.getElementById('chngOfOwnPrjFlagNonInfraLevel3C').disabled = false;
			document.getElementById('chngOfProjScopeNonInfraLevel3C').disabled = false;
			document.getElementById('leaglOrArbiProceedLevel3').disabled = true;
			document.getElementById('detailsRsnByndProLevel3').disabled = true;
		}else{
			document.getElementById('legalOrArbitrationLevel2FlagC').disabled = false;
			document.getElementById('reasonBeyondPromoterLevel2FlagC').disabled = false;
			document.getElementById('chngOfOwnPrjFlagInfraLevel2C').disabled = false;
			document.getElementById('chngOfProjScopeInfraLevel2C').disabled = false;
			
			document.getElementById('legalOrArbitrationLevel3FlagC').disabled = false;
			document.getElementById('reasonBeyondPromoterLevel3FlagC').disabled = false;
			document.getElementById('chngOfOwnPrjFlagInfraLevel3C').disabled = false;
			document.getElementById('chngOfProjScopeInfraLevel3C').disabled = false;
			document.getElementById('leaglOrArbiProceed').disabled = false;
			document.getElementById('detailsRsnByndPro').disabled = false;
			document.getElementById('chngOfOwnPrjFlagNonInfraLevel2C').disabled = true;
			document.getElementById('chngOfProjScopeNonInfraLevel2C').disabled = true;
			document.getElementById('chngOfOwnPrjFlagNonInfraLevel3C').disabled = true;
			document.getElementById('chngOfProjScopeNonInfraLevel3C').disabled = true;
			document.getElementById('leaglOrArbiProceedLevel3').disabled = false;
			document.getElementById('detailsRsnByndProLevel3').disabled = false;
		}
		
	}
	function lelvelDelaySCODFun(levelOfDealy){
		var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
		
		
		
		if(levelOfDealy == "1"){
			//document.getElementById('reasonLevelOneDelay').style.display = 'none';
			//document.getElementById('Image101').style.display = 'none';
			document.getElementById('Image201').style.display = 'none';
			document.getElementById('3').style.display = '';
			document.getElementById('5').style.display = '';
			document.getElementById('6').style.display = '';
			document.getElementById('12').style.display = '';
			document.getElementById('13').style.display = '';
			document.getElementById('14').style.display = '';
			document.getElementById('15').style.display = '';
			document.getElementById('16').style.display = '';
			document.getElementById('18').style.display = '';
			document.getElementById('19').style.display = '';
			document.getElementById('28').style.display = '';
			document.getElementById('30').style.display = '';
			document.getElementById('34').style.display = '';
			document.getElementById('40').style.display = '';
			document.getElementById('37').style.display = ''; 
			document.getElementById('21').style.display = '';
			document.getElementById('39').style.display = '';
			document.getElementById('31').style.display = '';
			document.getElementById('33').style.display = '';
			document.getElementById('27').style.display = '';
			document.getElementById('30').style.display = '';
			document.getElementById('33').style.display = ''; 
			document.getElementById('6').style.display = '';
			document.getElementById('32').style.display = '';
			document.getElementById('20').style.display = '';
			document.getElementById('39').style.display = '';
			document.getElementById('40').style.display = '';
			//document.getElementById('2').style.display = '';
			document.getElementById('41').style.display = 'none';
			document.getElementById('22').style.display = '';
			document.getElementById('24').style.display = '';
			document.getElementById('25').style.display = '';
			
			
			//document.getElementById('1').style.display = '';
			//document.getElementById('2').style.display = '';
			document.getElementById('20').style.display = '';
			document.getElementById('4').style.display = '';
			document.getElementById('3').style.display = '';
			document.getElementById('7').style.display = '';
			document.getElementById('8').style.display = '';
			document.getElementById('9').hidden =false;
			document.getElementById('10').style.display = '';
			document.getElementById('11').style.display = '';
			document.getElementById('17').style.display = '';
			document.getElementById('19').style.display = '';
			document.getElementById('22').style.display = '';
			document.getElementById('23').style.display = '';
			document.getElementById('25').style.display = ''; 
			
			document.getElementById('26').style.display = '';
			document.getElementById('28').style.display = '';
			document.getElementById('29').style.display = '';
			document.getElementById('34').style.display = '';
			document.getElementById('35').style.display = '';
			document.getElementById('37').style.display = ''; 
			document.getElementById('38').style.display = '';
			document.getElementById('32').style.display = '';
			document.getElementById('31').style.display = '';
			document.getElementById('22').style.display = '';
			
			document.getElementById('4').style.display = 'none';
			document.getElementById('5').style.display = 'none';
			document.getElementById('7').style.display = 'none';
			document.getElementById('8').style.display = 'none';
			document.getElementById('9').style.display = 'none';
			document.getElementById('10').style.display = 'none';
			document.getElementById('11').style.display = 'none';
			document.getElementById('17').style.display = 'none';
			document.getElementById('18').style.display = 'none';
			document.getElementById('12').style.display = 'none';
			document.getElementById('13').style.display = 'none';
			document.getElementById('14').style.display = 'none';
			document.getElementById('15').style.display = 'none';
			document.getElementById('16').style.display = 'none';
			document.getElementById('17').style.display = 'none'; 
			
			document.getElementById('23').style.display = 'none';
			document.getElementById('24').style.display = 'none';
			document.getElementById('26').style.display = 'none';
			document.getElementById('27').style.display = 'none';
			document.getElementById('29').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('23').style.display = 'none';
			document.getElementById('33').style.display = 'none'; 
			document.getElementById('6').style.display = 'none';
			document.getElementById('32').style.display = 'none';
			document.getElementById('20').style.display = 'none';
			document.getElementById('35').style.display = 'none';
			document.getElementById('38').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			document.getElementById('40').style.display = 'none';
			//document.getElementById('2').style.display = 'none';
			document.getElementById('41').style.display = 'none';
			document.getElementById('36').style.display = 'none';
			document.getElementById('31').style.display = '';
			document.getElementById('0').style.display = 'none';
			document.getElementById('72').style.display = '';
			
			/* document.all.principalInterestSchFlag[0].disabled =  false;
			document.all.principalInterestSchFlag[1].disabled =  false; */
			
			
			
			if (document.all.chngInRepayScheduleL1[0].checked == false && document.all.chngInRepayScheduleL1[1].checked == false){
				document.all.chngInRepayScheduleL1[1].checked =  true;
			}
			
			if (document.all.projectDelayedFlag[0].checked == false && document.all.projectDelayedFlag[1].checked == false){
			document.all.projectDelayedFlag[1].checked =  true;
			}
			if (document.all.principalInterestSchFlag[0].checked == false && document.all.principalInterestSchFlag[1].checked == false){
			document.all.principalInterestSchFlag[1].checked =  true;
			}
			if (document.all.recvPriorOfSCOD[0].checked == false && document.all.recvPriorOfSCOD[1].checked == false){
				document.all.recvPriorOfSCOD[1].checked =  true;
			}
			/* if (document.all.chngInRepaySchedule[0].checked == false && document.all.chngInRepaySchedule[1].checked == false){
				document.all.chngInRepaySchedule[1].checked =  true;
			} */
			if (document.all.promotersCapRunFlag[0].checked == false && document.all.promotersCapRunFlag[1].checked == false){
				document.all.promotersCapRunFlag[1].checked =  true;
			}
			if (document.all.promotersCapRunFlag[0].checked == false && document.all.promotersCapRunFlag[1].checked == false){
				document.all.promotersCapRunFlag[1].checked =  true;
			}
			if (document.all.promotersHoldEquityFlag[0].checked == false && document.all.promotersHoldEquityFlag[1].checked == false){
				document.all.promotersHoldEquityFlag[1].checked =  true;
			}
			if (document.all.hasProjectViabReAssFlag[0].checked == false && document.all.hasProjectViabReAssFlag[1].checked == false){
				document.all.hasProjectViabReAssFlag[1].checked =  true;
			}
			if (document.all.changeInScopeBeforeSCODFlag[0].checked == false && document.all.changeInScopeBeforeSCODFlag[1].checked == false){
				document.all.changeInScopeBeforeSCODFlag[1].checked =  true;
			}
			if (document.all.costOverrunOrg25CostViabilityFlag[0].checked == false && document.all.costOverrunOrg25CostViabilityFlag[1].checked == false){
				document.all.costOverrunOrg25CostViabilityFlag[1].checked =  true;
			}
			if (document.all.projectViabReassesedFlag[0].checked == false && document.all.projectViabReassesedFlag[1].checked == false){
				document.all.projectViabReassesedFlag[1].checked =  true;
			}
			//document.getElementById('projectDelayedFlagL2A').style.checked = true;
			document.all.infaProjectFlag[0].disabled =  false;
			document.all.infaProjectFlag[1].disabled =  false; 
			
		}else if(levelOfDealy == "2"){
			//document.getElementById('reasonLevelOneDelay').style.display = 'none';
			disableReason();
			//document.getElementById('Image102').style.display = 'none';
			document.getElementById('4').style.display = '';
			document.getElementById('5').style.display = '';
			document.getElementById('7').style.display = '';
			document.getElementById('8').style.display = '';
			document.getElementById('9').hidden =false;
			document.getElementById('10').style.display = '';
			document.getElementById('11').style.display = '';
			document.getElementById('17').style.display = '';
			document.getElementById('18').style.display = '';
			document.getElementById('12').style.display = '';
			document.getElementById('13').hidden =false;
			document.getElementById('14').style.display = '';
			document.getElementById('15').style.display = '';
			document.getElementById('16').style.display = '';
			document.getElementById('17').style.display = '';
			
			document.getElementById('23').style.display = '';
			document.getElementById('24').style.display = '';
			document.getElementById('26').style.display = '';
			document.getElementById('27').style.display = '';
			document.getElementById('29').style.display = '';
			document.getElementById('30').style.display = '';
			document.getElementById('23').style.display = '';
			document.getElementById('33').style.display = ''; 
			document.getElementById('6').style.display = '';
			document.getElementById('32').style.display = '';
			document.getElementById('20').style.display = '';
			document.getElementById('35').style.display = '';
			document.getElementById('38').style.display = '';
			document.getElementById('39').style.display = '';
			document.getElementById('40').style.display = '';
			//document.getElementById('2').style.display = '';
			document.getElementById('36').style.display = '';
			
			
			
			document.getElementById('3').style.display = 'none';
			document.getElementById('5').style.display = 'none';
			document.getElementById('6').style.display = 'none';
			document.getElementById('12').style.display = 'none';
			document.getElementById('13').style.display = 'none';
			document.getElementById('14').style.display = 'none';
			document.getElementById('15').style.display = 'none';
			document.getElementById('16').style.display = 'none';
			document.getElementById('18').style.display = 'none';
			document.getElementById('19').style.display = 'none';
			document.getElementById('28').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('34').style.display = 'none';
			document.getElementById('40').style.display = 'none';
			document.getElementById('37').style.display = 'none'; 
			//document.getElementById('1').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			document.getElementById('31').style.display = 'none';
			document.getElementById('33').style.display = 'none';
			document.getElementById('27').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('33').style.display = 'none'; 
			document.getElementById('6').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			document.getElementById('41').style.display = 'none';
			document.getElementById('22').style.display = 'none';
			document.getElementById('24').style.display = 'none';
			document.getElementById('25').style.display = 'none';
			//document.getElementById('45').style.display = 'none';
			document.getElementById('36').style.display = 'none';
			document.getElementById('0').style.display = 'none';
			document.getElementById('72').style.display = 'none';
			document.getElementById('9').style.display = '';
			document.getElementById('21').style.display = '';
			/* if (document.all.projectDelayedFlagL2[0].checked == false && document.all.projectDelayedFlagL2[1].checked == false){
			document.all.projectDelayedFlagL2[1].checked =  true;
			} */
			if (document.all.principalInterestSchFlag[0].checked == false && document.all.principalInterestSchFlag[1].checked == false){
			document.all.principalInterestSchFlag[1].checked =  true;
			}
			if (document.all.recvPriorOfSCOD[0].checked == false && document.all.recvPriorOfSCOD[1].checked == false){
				document.all.recvPriorOfSCOD[1].checked =  true;
			}
			if (document.all.chngInRepayScheduleL2[0].checked == false && document.all.chngInRepayScheduleL2[1].checked == false){
				document.all.chngInRepayScheduleL2[1].checked =  true;
			}
			if (document.all.promotersCapRunFlagL2[0].checked == false && document.all.promotersCapRunFlagL2[1].checked == false){
				document.all.promotersCapRunFlagL2[1].checked =  true;
			}
			
			if (document.all.promotersHoldEquityFlagL2[0].checked == false && document.all.promotersHoldEquityFlagL2[1].checked == false){
				document.all.promotersHoldEquityFlagL2[1].checked =  true;
			}
			if (document.all.hasProjectViabReAssFlagL2[0].checked == false && document.all.hasProjectViabReAssFlagL2[1].checked == false){
				document.all.hasProjectViabReAssFlagL2[1].checked =  true;
			}
			if (document.all.changeInScopeBeforeSCODFlagL2[0].checked == false && document.all.changeInScopeBeforeSCODFlagL2[1].checked == false){
				document.all.changeInScopeBeforeSCODFlagL2[1].checked =  true;
			}
			if (document.all.costOverrunOrg25CostViabilityFlagL2[0].checked == false && document.all.costOverrunOrg25CostViabilityFlagL2[1].checked == false){
				document.all.costOverrunOrg25CostViabilityFlagL2[1].checked =  true;
			}
			if (document.all.projectViabReassesedFlagL2[0].checked == false && document.all.projectViabReassesedFlagL2[1].checked == false){
				document.all.projectViabReassesedFlagL2[1].checked =  true;
			}
			//document.getElementById('projectDelayedFlagL2A').style.checked = true;
			/* document.all.principalInterestSchFlag[0].disabled =  false;
			document.all.principalInterestSchFlag[1].disabled =  false; */
			document.all.infaProjectFlag[0].disabled =  true;
			document.all.infaProjectFlag[1].disabled =  true; 
			
		}else if(levelOfDealy == "3"){
			disableReason();
			//document.getElementById('Image103').style.display = 'none';
			document.getElementById('3').style.display = '';
			document.getElementById('5').style.display = '';
			document.getElementById('6').style.display = '';
			document.getElementById('12').style.display = '';
			document.getElementById('13').style.display = '';
			document.getElementById('14').style.display = '';
			document.getElementById('15').style.display = '';
			document.getElementById('16').style.display = '';
			document.getElementById('18').style.display = '';
			document.getElementById('19').style.display = '';
			document.getElementById('28').style.display = '';
			document.getElementById('30').style.display = '';
			document.getElementById('34').style.display = '';
			document.getElementById('40').style.display = '';
			document.getElementById('37').style.display = ''; 
			
			document.getElementById('39').style.display = '';
			document.getElementById('31').style.display = '';
			document.getElementById('33').style.display = '';
			document.getElementById('27').style.display = '';
			document.getElementById('30').style.display = '';
			document.getElementById('33').style.display = ''; 
			document.getElementById('6').style.display = '';
			document.getElementById('32').style.display = '';
			document.getElementById('20').style.display = '';
			document.getElementById('39').style.display = '';
			//document.getElementById('2').style.display = '';
			document.getElementById('22').style.display = '';
			document.getElementById('24').style.display = '';
			document.getElementById('25').style.display = '';
			
			
			
			
			
			//document.getElementById('1').style.display = 'none';
			//document.getElementById('2').style.display = 'none';
			document.getElementById('20').style.display = 'none';
			document.getElementById('4').style.display = 'none';
			document.getElementById('3').style.display = 'none';
			document.getElementById('7').style.display = 'none';
			document.getElementById('8').style.display = 'none';
			document.getElementById('9').style.display = 'none';
			document.getElementById('10').style.display = 'none';
			document.getElementById('11').style.display = 'none';
			document.getElementById('17').style.display = 'none';
			document.getElementById('19').style.display = 'none';
			document.getElementById('22').style.display = 'none';
			document.getElementById('23').style.display = 'none';
			document.getElementById('25').style.display = 'none'; 
			
			document.getElementById('26').style.display = 'none';
			document.getElementById('28').style.display = 'none';
			document.getElementById('29').style.display = 'none';
			document.getElementById('34').style.display = 'none';
			document.getElementById('35').style.display = 'none';
			document.getElementById('37').style.display = 'none'; 
			document.getElementById('38').style.display = 'none';
			document.getElementById('32').style.display = 'none';
			document.getElementById('31').style.display = 'none';
			document.getElementById('41').style.display = 'none';
			document.getElementById('22').style.display = 'none';
			document.getElementById('0').style.display = 'none';
			document.getElementById('21').style.display = '';
			document.getElementById('72').style.display = 'none';
			document.getElementById('36').style.display = 'none';
			
			
			
			
			/* document.all.principalInterestSchFlag[0].disabled =  false;
			document.all.principalInterestSchFlag[1].disabled =  false; */
			
			
			/* if (document.all.projectDelayedFlagL3[0].checked == false && document.all.projectDelayedFlagL3[1].checked == false){
				document.all.projectDelayedFlagL3[1].checked =  true;
				} */
				if (document.all.principalInterestSchFlag[0].checked == false && document.all.principalInterestSchFlag[1].checked == false){
				document.all.principalInterestSchFlag[1].checked =  true;
				}
				if (document.all.chngInRepayScheduleL3[0].checked == false && document.all.chngInRepayScheduleL3[1].checked == false){
					document.all.chngInRepayScheduleL3[1].checked =  true;
				}
				if (document.all.promotersCapRunFlagL3[0].checked == false && document.all.promotersCapRunFlagL3[1].checked == false){
					document.all.promotersCapRunFlagL3[1].checked =  true;
				}
				
				if (document.all.promotersHoldEquityFlagL3[0].checked == false && document.all.promotersHoldEquityFlagL3[1].checked == false){
					document.all.promotersHoldEquityFlagL3[1].checked =  true;
				}
				if (document.all.hasProjectViabReAssFlagL3[0].checked == false && document.all.hasProjectViabReAssFlagL3[1].checked == false){
					document.all.hasProjectViabReAssFlagL3[1].checked =  true;
				}
				if (document.all.changeInScopeBeforeSCODFlagL3[0].checked == false && document.all.changeInScopeBeforeSCODFlagL3[1].checked == false){
					document.all.changeInScopeBeforeSCODFlagL3[1].checked =  true;
				}
				if (document.all.costOverrunOrg25CostViabilityFlagL3[0].checked == false && document.all.costOverrunOrg25CostViabilityFlagL3[1].checked == false){
					document.all.costOverrunOrg25CostViabilityFlagL3[1].checked =  true;
				}
				if (document.all.projectViabReassesedFlagL3[0].checked == false && document.all.projectViabReassesedFlagL3[1].checked == false){
					document.all.projectViabReassesedFlagL3[1].checked =  true;
				}
			
				document.all.infaProjectFlag[0].disabled =  true;
				document.all.infaProjectFlag[1].disabled =  true; 
			
		}else if(levelOfDealy == ""){
			//document.getElementById('1').style.display = 'none';
			//document.getElementById('2').style.display = 'none';
			document.getElementById('20').style.display = 'none';
			document.getElementById('4').style.display = 'none';
			document.getElementById('3').style.display = 'none';
			document.getElementById('7').style.display = 'none';
			document.getElementById('8').style.display = 'none';
			document.getElementById('9').hidden =true;
			document.getElementById('10').style.display = 'none';
			document.getElementById('11').style.display = 'none';
			document.getElementById('17').style.display = 'none';
			document.getElementById('19').style.display = 'none';
			document.getElementById('22').style.display = 'none';
			document.getElementById('23').style.display = 'none';
			document.getElementById('25').style.display = 'none'; 
		
			document.getElementById('26').style.display = 'none';
			document.getElementById('28').style.display = 'none';
			document.getElementById('29').style.display = 'none';
			document.getElementById('34').style.display = 'none';
			document.getElementById('35').style.display = 'none';
			document.getElementById('37').style.display = 'none'; 
			document.getElementById('38').style.display = 'none';
			document.getElementById('32').style.display = 'none';
			document.getElementById('31').style.display = 'none';
			document.getElementById('41').style.display = 'none';
			document.getElementById('22').style.display = 'none';

			document.getElementById('3').style.display = 'none';
			document.getElementById('5').style.display = 'none';
			document.getElementById('6').style.display = 'none';
			document.getElementById('12').style.display = 'none';
			document.getElementById('13').style.display = 'none';
			document.getElementById('14').style.display = 'none';
			document.getElementById('15').style.display = 'none';
			document.getElementById('16').style.display = 'none';
			document.getElementById('18').style.display = 'none';
			document.getElementById('19').style.display = 'none';
			document.getElementById('28').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('34').style.display = 'none';
			document.getElementById('40').style.display = 'none';
			document.getElementById('37').style.display = 'none'; 
			//document.getElementById('1').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			document.getElementById('31').style.display = 'none';
			document.getElementById('33').style.display = 'none';
			document.getElementById('27').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('33').style.display = 'none'; 
			document.getElementById('6').style.display = 'none';
			document.getElementById('32').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			//document.getElementById('2').style.display = 'none';
			document.getElementById('41').style.display = 'none';
			document.getElementById('22').style.display = 'none';
			document.getElementById('24').style.display = 'none';
			document.getElementById('25').style.display = 'none';
			//document.getElementById('45').style.display = 'none';
			
			document.getElementById('4').style.display = 'none';
			document.getElementById('5').style.display = 'none';
			document.getElementById('7').style.display = 'none';
			document.getElementById('8').style.display = 'none';
			document.getElementById('9').style.display = 'none';
			document.getElementById('10').style.display = 'none';
			document.getElementById('11').style.display = 'none';
			document.getElementById('17').style.display = 'none';
			document.getElementById('18').style.display = 'none';
			document.getElementById('12').style.display = 'none';
			document.getElementById('13').style.display = 'none';
			document.getElementById('14').style.display = 'none';
			document.getElementById('15').style.display = 'none';
			document.getElementById('16').style.display = 'none';
			document.getElementById('17').style.display = 'none'; 
			
			document.getElementById('23').style.display = 'none';
			document.getElementById('24').style.display = 'none';
			document.getElementById('26').style.display = 'none';
			document.getElementById('27').style.display = 'none';
			document.getElementById('29').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('23').style.display = 'none';
			document.getElementById('33').style.display = 'none'; 
			document.getElementById('6').style.display = 'none';
			document.getElementById('32').style.display = 'none';
			document.getElementById('20').style.display = 'none';
			document.getElementById('35').style.display = 'none';
			document.getElementById('38').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			document.getElementById('40').style.display = 'none';
			//document.getElementById('2').style.display = 'none';
			document.getElementById('41').style.display = '';
			document.getElementById('36').style.display = '';
			//document.getElementById('45').style.display = 'none';
			document.getElementById('21').style.display = 'none';
			document.getElementById('0').style.display = '';
			document.getElementById('72').style.display = 'none';
			/* document.all.principalInterestSchFlag[0].disabled =  false;
			document.all.principalInterestSchFlag[1].disabled =  false; */
			/* if(document.getElementById('exstAssetClass').value != null || document.getElementById('exstAssetClass').value != "" ){
				document.getElementById('exstAssetClass').disabled = true;
				document.getElementById('exstAssClassDate').disabled = true;
				document.getElementById('Image756').style.display = 'none';
				
				
				} */
				
				
			document.all.infaProjectFlag[0].disabled =  false;
			document.all.infaProjectFlag[1].disabled =  false; 	
		}
		
	}
	
	
	
	
	function populateSCODFields(){
		 //var lineno = document.getElementById('lineNo').value;
		 var scodLineNo = '<%=scodLineNoList%>';
		 var lineno_array = scodLineNo.split(',');
		 var system =  document.forms[0].facilitySystem.value;
		 var lineno = document.forms[0].lineNo.value;		 
		 //var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
		 document.forms[0].isCreate.value != 'Y'
		 var flag = false;
		 for(var i = 0; i < lineno_array.length; i++) {
		    
		    if(lineno_array[i] == lineno){
		    	flag = true;
		    }
		 }
		if(flag  && lineno != "" && system != "ET"){
			document.forms[0].isCreate.value = 'Y';
			document.getElementById('51').style.display = '';
			document.getElementById('52').style.display = '';
			document.getElementById('53').style.display = '';
			if(document.forms[0].isCreate.value == 'Y'){
			document.getElementById('41').style.display = '';
			}
			if(document.getElementById("exstAssetClass").value == ''){
			document.getElementById("exstAssetClass").selectedIndex = "2";
			}
		}else{
			document.getElementById('51').style.display = 'none';
			document.getElementById('52').style.display = 'none';
			document.getElementById('53').style.display = 'none';
			document.getElementById('41').style.display = 'none';
		} 
		
		
	}
	
	//var b = ; 
	
	
	
	function projectLoanYes(){
		document.all.projectLoan[0].checked = true;
		//alert(document.forms[0].isCreate.value);
		document.all.projectLoan[1].disabled = true;
	}
	
	function projectLoanNo(){
		document.all.projectLoan[1].disabled = false;
	}
	
	// End: Uma:Phase 3 CR :Limit Calculation Dashboard 
						function IsAlphaNumeric(event) {
						var character = String.fromCharCode(event.keyCode);
						return isValid(character);
					}

					function isValid(str) {
						return !/[~`!@#$%\^&*()+=\-\[\]\\';,/{}|\\":<>\?]/g
								.test(str);
					}
					
					
					
	function updateDpCalculated(selfObj){
		var tempVal=selfObj.value;
		if("Y"==tempVal){
			document.forms[0].isDP[0].checked = true;
			document.forms[0].isDP[1].checked =false;
			document.forms[0].isDP[0].disabled =false;
			document.forms[0].isDP[1].disabled =false;			
		}
		else if("N"==tempVal){
			document.forms[0].isDP[0].checked = false;
			document.forms[0].isDP[1].checked =false;
			document.forms[0].isDP[0].disabled =true;
			document.forms[0].isDP[1].disabled =true;			
		}
	}
	
	function setRiskTypeHidden(dropdown){
		var RiskType=dropdown.value;
		document.getElementById("riskType").value=RiskType;

		//alert(RiskType);
	}

	
		function updateDpCalculatedNew(selfObj){
		var tempVal=selfObj.value;
		if("Y"==tempVal){
			document.getElementById("DP").disabled = false;
			document.getElementById("DP1").disabled = false;					
		}
		else if("N"==tempVal){
			document.getElementById("DP").disabled = true;	
			document.getElementById("DP1").disabled = true;
		}
	}
			
				
	function lineCount(){
		alert("We cannot Add more than 99 Lines");
	}
	
	
	function viewConvenantScreen(name)
					{
						document.forms[0].action="MILimit.do?event="+name;
					    document.forms[0].submit();
					}
					
function enableCovenantBtn(){
	if(document.getElementById("facilitySystem").value == 'UBS-LIMITS'){
		document.getElementById('btnedit_viewCovenant').disabled = false;
	}else{
		document.getElementById('btnedit_viewCovenant').disabled = true;
	}
}
				</script>

				
</head>

<body >
<br>
<%
String actionStr1 = "com.integrosys.cms.ui.manualinput.limit.LmtDetailAction";
String migratedFlag = "N";
	 migratedFlag = (String)session.getAttribute(actionStr1+".migratedFlag");
if(migratedFlag==null)
	 {
		 migratedFlag = "N"; 
	 }
%>
&nbsp;&nbsp;<html:errors property="facilitySystemID"/> 
<p class="required"><font color="#FF0000">*</font> Mandatory for Submission&nbsp;&nbsp;&nbsp;&nbsp;</p>
<table align="right" width="100%"  class="tblFormSection">
<tr >
<td width="25%" >
<%if(migratedFlag.equals("Y")){ %>
      (Migrated Record)
      <%}%>
</td>
<td >&nbsp;</td>
</tr>
</table>


<html:form action="MILimit.do">
  <html:hidden name="LmtDetailForm" property="facCoBorrowerLiabIds" styleId="facCoBorrowerIds" value="<%=facCoBorrowerLiabIds%>"/>

    <input type="hidden" name="event" value="<%=request.getAttribute("event") %>"/>
    <input type="hidden" name="fromEvent" value="<%=updateEvent %>"/>
    <input type="hidden" name="indexID" value=""/>
    <input type="hidden" name="lineDetailId" value=""/>
    <input type="hidden" name="itemType" value=""/>

   <html:hidden property="limitProfileID"/>
	<%-- <html:text property="availAndOptionApplicable" styleId="availAndOptionApplicable" value="<%=availAndOptionApplicable%>"/> --%>
    
  <input type="hidden" name="limitProfileID" value="<%=request.getAttribute("limitProfileID") %>"/>

 	<html:hidden property="customerID" styleId="customerID"/>
 	<% String limitIdFromRequest =(String) request.getAttribute("limitId");
 	String limitId = null;
 	if(limitIdFromRequest!=null){
 		limitId = limitIdFromRequest;
 	}else{
 		limitId = limitIdFromObj; 
 	}
 	%>
 	<input type="hidden" name="limitId" value="<%=limitId %>"/>
 	<input type="hidden" name="isCreate"  value="<%=request.getAttribute("isCreate") %>"/>
    <%System.out.println("isCreate =========>"+request.getAttribute("isCreate")); %>
    <%System.out.println("limitId =========>"+limitId); %>
    <bean:define id="itrxValue" name="com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.lmtTrxObj" type="com.integrosys.cms.app.limit.trx.ILimitTrxValue" scope="session"/>
    <bean:define id="formObj" name="LmtDetailForm" scope="request" type="com.integrosys.cms.ui.manualinput.limit.LmtDetailForm"/>
    <input type="hidden" name="facCat" id="facCat" value="<%=formObj.getFacilityCat()%>" />
    <input type="hidden" name="facName" id="facName" value="<%=formObj.getFacilityName()%>" />
      <input type="hidden" name="facilityCode" id="facilityCode" value="<%=formObj.getFacilityCode()%>" /> 
    <input type="hidden" name="actSancAmount" id="actSancAmount" value="<%=formObj.getRequiredSecCov()%>" />
<%
 boolean disableFacType = true; %>
    <logic:notEmpty name="LmtDetailForm" property="showSublist" scope="request">
        <% disableFacType = false; %>
    </logic:notEmpty>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection">
<thead>
    <tr>
        <td width="81%"><h3><bean:message key="title.facility.details"/></h3></td>
        <td width="19%" align="right" valign="bottom">&nbsp; </td>
    </tr>
    <tr>
        <td colspan="2"><hr/></td>
    </tr>
</thead>
<tbody>
<%System.out.println("++++++++++++++++++++++++++"+request.getAttribute("fundedAmount")); %>
  
    <input type="hidden" name="fundedAmount" value="<%=(String)request.getAttribute("fundedAmount") %>"/>
	<input type="hidden" name="nonFundedAmount" value="<%=(String)request.getAttribute("nonFundedAmount")  %>" />
    <input type="hidden" name="memoExposer"  value="<%=(String)request.getAttribute("memoExposer")  %>" />
	<input type="hidden" name="sanctionedLimit"	value="<%=(String)request.getAttribute("sanctionedLimit") %>" />

<tr>
<td colspan="2">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblInfo">
<tbody>
<tr class="odd">
    <td class="fieldname" width="20%"><bean:message key="label.facility.id"/>&nbsp;</td>
    <td width="30%">
        <bean:write name="LmtDetailForm" property="limitRef"/>&nbsp;
        <html:hidden property="limitRef"/>
    </td>
   <td class="fieldname" width="20%"><bean:message key="label.facility.category"/><font color="#FF0000">*</font> </td>
                  <td width="30%">
                  <%
                  if(updateEvent.equals("prepare_update"))
                  {
                  %>

 					   <% System.out.println("formObj.getFacilityCat().........................."+formObj.getFacilityCat());
		                 %>
		                  <%if(null != formObj.getLineNo()){ %>
		                  		<html:select disabled="true" property="facilityCat" styleId="facilityCat" value="<%=formObj.getFacilityCat().trim()%>" onchange="javascript:refreshFacName(this)">
		                  	<%--	<html:options collection="facDetailList" property="value" labelProperty="label"/> 
		                    </html:select></td> --%>
		                        <integro:common-code
										categoryCode="<%=CategoryCodeConstant.CommonCode_FACILITY_CATEGORY%>" descWithCode="false" />   
						</html:select>
						<%}else{ %>
						<html:select disabled="false" property="facilityCat" styleId="facilityCat" value="<%=formObj.getFacilityCat().trim()%>" onchange="javascript:refreshFacName(this)">
		                  	<%--	<html:options collection="facDetailList" property="value" labelProperty="label"/> 
		                    </html:select></td> --%>
		                        <integro:common-code
										categoryCode="<%=CategoryCodeConstant.CommonCode_FACILITY_CATEGORY%>" descWithCode="false" />   
						</html:select>
						<%} %>
						<html:errors property="facilityCat" />
						<html:hidden property="facilityCat" styleId="facilityCat"/>  
		                  <%} 					

					else{ %>
						<% if(null!=itrxValue.getLimit() && null!=itrxValue.getLimit().getFacilityCat()){%>
							 <html:select disabled="true" property="facilityCat" styleId="facilityCat" value="<%=formObj.getFacilityCat()%>"  onchange="javascript:refreshFacName(this)">
	                  			<integro:common-code categoryCode="<%=CategoryCodeConstant.CommonCode_FACILITY_CATEGORY%>"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="facilityCat"/>
							 <html:hidden property="facilityCat" styleId="facilityCat"/>  
						<%} else{%>
                 			<html:select property="facilityCat" styleId="facilityCat" value="<%=formObj.getFacilityCat()%>"  onchange="javascript:refreshFacName(this)">
	                  			<integro:common-code categoryCode="<%=CategoryCodeConstant.CommonCode_FACILITY_CATEGORY%>"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="facilityCat"/>
							 <html:hidden property="facilityCat" styleId="facilityCat"/>  
							 
						<%}
					}%>
					 
					</td>
	</tr>
			<tr class="even" size="50">
		  	   		  	   <td class="fieldname"><bean:message key="label.facility.name"/><font color="#FF0000">*</font> </td>
                  <td>
                  <%
                  if(updateEvent.equals("prepare_update"))
                  { 
                	  System.out.println("<<<<<<formObj.getFacilityName()>>>>>2416>>>>"+formObj.getFacilityName());
                  %>

               <%--  commented to make as dropdown while editing
               <bean:write name="LmtDetailForm" property="facilityName"/>&nbsp;
        			<html:hidden property="facilityName"/>      --%> 
        			 <% if(formObj.getFacilityName()==null || formObj.getFacilityName().trim().equals("")){
        				 System.out.println("<<<<<<formObj.getFacilityName()>>>>>2423>>>>"+formObj.getFacilityName());
        			 %>
        			 	<html:select property="facilityName" styleId="facilityName" onchange="javascript:refreshFacDetail(this);">				                  
							<option value="">Please Select </option>                     
							<html:options collection ="facNameList" labelProperty ="label" property ="value"/>								                   
						</html:select> 
        			 <%}else if(null == formObj.getLineNo()){
        				 System.out.println("<<<<<<formObj.getFacilityName()>>>>>2430>>>>"+formObj.getFacilityName());
        				 %>
        			 	<html:select property="facilityName" disabled="false" styleId="facilityName" onchange="javascript:refreshFacDetail(this);">				                  
							<option value="">Please Select </option>                     
							<html:options collection ="facNameList" labelProperty ="label" property ="value"/>								                   
						</html:select> 
        			 <%}else{
        				 System.out.println("<<<<<<formObj.getFacilityName()>>>>>2437>>>>"+formObj.getFacilityName());
        				 %>
        			 	<html:select property="facilityName" disabled="true" styleId="facilityName" onchange="javascript:refreshFacDetail(this);">				                  
							<option value="">Please Select </option>                     
							<html:options collection ="facNameList" labelProperty ="label" property ="value"/>								                   
						</html:select> 
        			 <%} %>
					<%}
					else{ 
						System.out.println("<<<<<<formObj.getFacilityName()>>>>>2440>>>>"+formObj.getFacilityName());
					%>
					<% if(null!=itrxValue.getLimit() && null!=itrxValue.getLimit().getFacilityName()){
					//DefaultLogger.debug(this,"itrxValue.getLimit().getFacilityName():"+itrxValue.getLimit().getFacilityName());%>
        			 	<html:select disabled="true" property="facilityName" styleId="facilityName" onchange="javascript:refreshFacDetail(this);">				                  
							<option value="">Please Select </option>                     
							<html:options collection ="facNameList" labelProperty ="label" property ="value"/>								                   
						</html:select> 
        			 <%
        			 System.out.println("<<<<<<formObj.getFacilityName()>>>>>2449>>>>"+formObj.getFacilityName()); 
					}else{ 
						System.out.println("<<<<<<formObj.getFacilityName()>>>>>2451>>>>"+formObj.getFacilityName());%>
        			 	<html:select property="facilityName"  styleId="facilityName" onchange="javascript:refreshFacDetail(this);" value="<%=formObj.getFacilityName() %>">				                  
							<option value="">Please Select </option>                     
							<html:options collection ="facNameList" labelProperty ="label" property ="value"/>								                   
						</html:select> 
        			 <%} }%>
					<html:errors property="facilityName"/>
					 <html:hidden property="facilityName" styleId="facilityName"/>  
              <html:hidden property="facilityCode" styleId="facilityCode" />
                  </td>
                  <td class="fieldname"> Facility Type</td>
                   <td><html:text property="facilityType" styleId="facilityType" readonly="true" /></td>
                </tr>
                <tr class="odd">
                  <td class="fieldname">System</td>
                 <td>
                 <html:text property="facilitySystem" styleId="facilitySystem" readonly="true"  />
                 </td>
             <%
			 System.out.println("updateEvent: "+updateEvent+", formObj.getFacilitySystem(): "+formObj.getFacilitySystem());
             if(updateEvent.equals("prepare_update") || updateEvent.equals("update_return")){ 
             				if("ET".equals(formObj.getFacilitySystem())){ %>
             			                 <html:hidden property="lineNo" styleId="lineNo"/>
             	  <td class="fieldname">DP Required?<font color="#FF0000">*</font></td>
                  <td>
                  	  <% if((updateEvent.equals("prepare_update") && null != formObj.getLineNo()) || (null!=itrxValue.getLimit() && null!=itrxValue.getLimit().getFacilityCat())){ %>
	                  	<html:radio property="isDPRequired" styleId="isDPRequired" value="Y" onclick="javascript:updateDpCalculatedNew(this);"/> &nbsp;Yes
	  				  	<html:radio property="isDPRequired" styleId="isDPRequired" value="N" onclick="javascript:updateDpCalculatedNew(this);"/> &nbsp;No
	  				  	<html:errors property="isDpRequired"/>
	                  <%} else { %>
	                  	<html:radio property="isDPRequired" styleId="isDPRequired" value="Y" onclick="javascript:updateDpCalculated(this);"/> &nbsp;Yes
	  				  	<html:radio property="isDPRequired" styleId="isDPRequired" value="N" onclick="javascript:updateDpCalculated(this);"/> &nbsp;No
	  				  	<html:errors property="isDpRequired"/>
	                  <%} %>
	                  <html:hidden property="isDPRequired"/>
  				  </td>
             				<tr class="even">
           	<td class="fieldname" width="20%">Risk Type<font color="#FF0000">*</font></td>
                  <td width="30%">
                  <html:select property="riskType" styleId="riskType" onchange="javascript:setRiskTypeHidden(this);">
            			<option value="">Please Select </option>   
            			<html:options  collection ="riskTypeList" labelProperty ="label" property ="value" />								                   
					</html:select> <html:errors property="riskType"/>
					<html:hidden property="riskType" styleId="riskType" />
              </td>
          </tr>
            <%}else{ %>
        	<td class="fieldname" width="20%" id="syndicateLoanHeading"><bean:message key="label.facility.syndicateLoan"/></td>
   			<td width="30%" id="syndicateLoanField">
        		<html:radio property="syndicateLoan" styleId="syndicateLoan" value="Y"/>&nbsp;Yes&nbsp;
        		<html:radio property="syndicateLoan" styleId="syndicateLoan" value="N" />&nbsp;No&nbsp;
        	</td>        		
          </tr>
                <tr class="even">
           	<td class="fieldname" width="20%">Risk Type<font color="#FF0000">*</font></td>
                  <td width="30%">
                  <html:select property="riskType" styleId="riskType" onchange="javascript:setRiskTypeHidden(this);">
            			<option value="">Please Select </option>   
            			<html:options  collection ="riskTypeList" labelProperty ="label" property ="value" />								                   
					</html:select> <html:errors property="riskType"/>
					<html:hidden property="riskType" styleId="riskType" />
              </td>
          </tr>
          
                <tr class="even" id="lineNoTr">
                  <td class="fieldname"><span id="lineNoHeading">Line No.</span></td>
                 <td><span id="lineNoField"><html:text property="lineNo" styleId="lineNo" readonly="true" /></span></td>
                  <td class="fieldname">DP Required?<font color="#FF0000">*</font></td>
                  <td>
                  	  <% if((updateEvent.equals("prepare_update") && null != formObj.getLineNo()) || (null!=itrxValue.getLimit() && null!=itrxValue.getLimit().getFacilityCat())){ System.out.println("1111111111");%>
	                  	<html:radio property="isDPRequired" styleId="isDPRequired" value="Y" onclick="javascript:updateDpCalculatedNew(this);"/> &nbsp;Yes
	  				  	<html:radio property="isDPRequired" styleId="isDPRequired" value="N" onclick="javascript:updateDpCalculatedNew(this);"/> &nbsp;No
	  				  	<html:errors property="isDpRequired"/>
	                  <%} else { System.out.println("22222222");%>
	                  	<html:radio property="isDPRequired" styleId="isDPRequired" value="Y" onclick="javascript:updateDpCalculated(this);"/> &nbsp;Yes
	  				  	<html:radio property="isDPRequired" styleId="isDPRequired" value="N" onclick="javascript:updateDpCalculated(this);"/> &nbsp;No
	  				  	<html:errors property="isDpRequired"/>
	                  <%} %>
	                  <html:hidden property="isDPRequired"/>
  				  </td>
                </tr>   
             <%}
             }else{ %>
        	<td class="fieldname" width="20%" id="syndicateLoanHeading"><bean:message key="label.facility.syndicateLoan"/></td>
   			<td width="30%" id="syndicateLoanField">
        		<html:radio property="syndicateLoan" styleId="syndicateLoan" value="Y"/>&nbsp;Yes&nbsp;
        		<html:radio property="syndicateLoan" styleId="syndicateLoan" value="N" />&nbsp;No&nbsp;
        	</td>        		
          </tr>
                <tr class="even">
				<td class="fieldname" width="20%">Risk Type<font color="#FF0000">*</font></td>
                  <td width="30%">
                  <html:select property="riskType" styleId="riskType"  onchange="javascript:setRiskTypeHidden(this);">
						<option value="">Please Select </option>
						<html:options  collection ="riskTypeList" labelProperty ="label" property ="value" />								                   
					</html:select> <html:errors property="riskType"/>
					
					<html:hidden property="riskType" styleId="riskType" />
              </td>
          	<td></td><td></td>
         	  </tr>
         	  
                <tr class="even" id="lineNoTr">
                  <td class="fieldname" id="lineNoHeadingTd"><span id="lineNoHeading">Line No.</span></td>
                 <td id="lineNoFieldTd"><span id="lineNoField"><html:text property="lineNo" styleId="lineNo" readonly="true" /></span></td>
                  <td class="fieldname">DP Required?<font color="#FF0000">*</font></td>
                  <td>
	                   <% if((updateEvent.equals("prepare_update") && null != formObj.getLineNo()) || (null!=itrxValue.getLimit() && null!=itrxValue.getLimit().getFacilityCat())){System.out.println("333333333333"); %>
	                  	<html:radio property="isDPRequired" styleId="isDPRequired" value="Y" /> &nbsp;Yes
	  				  	<html:radio property="isDPRequired" styleId="isDPRequired" value="N" /> &nbsp;No
	                  	<html:errors property="isDpRequired"/>
	                  <%} else { System.out.println("444444444444");%>
	                   <html:radio property="isDPRequired" styleId="isDPRequired" value="Y" onclick="javascript:updateDpCalculated(this);"/> &nbsp;Yes
	  				  	<html:radio property="isDPRequired" styleId="isDPRequired" value="N" onclick="javascript:updateDpCalculated(this);"/> &nbsp;No
	  				  	<html:errors property="isDpRequired"/>
	                  <%} %>
                  	<html:hidden property="isDPRequired"/>
  				  </td>
                </tr>      
<%} %>
                <tr class="odd">
                  <td class="fieldname">Purpose</td>        
                    <%if(formObj.getPurpose()==null || "".equals(formObj.getPurpose())) {%>
                   <td> 
                  <html:text property="purpose" styleId="purpose"/>
                  <html:text property="otherPurpose" styleId="otherPurpose" readonly="true"/>
                   </td>
                  <%}else if(formObj.getPurpose().equals("Others")) { %>
                   <td>
                  <html:text property="purpose" styleId="purpose" />
                     <html:text property="otherPurpose" styleId="otherPurpose"/>
                </td>
                 <%}else { %>
                   <td>
                  <html:text property="purpose" styleId="purpose" />
                     <html:text property="otherPurpose" styleId="otherPurpose" readonly="true"/>
                </td>
                  <%} %>  
                 <%if(formObj.getPurpose()==null || "".equals(formObj.getPurpose())) {  System.out.println("**** 111111111111111");%>
                  <td class="fieldname">Should DP be calculated from Bank Shares?</td>
                  <td ><html:radio property="isDP" styleId="isDP" value="Y" disabled="true"/> Yes
  				  	  <html:radio property="isDP" styleId="isDP" value="N" disabled="true"/> No
  				  </td>
  				  <%}else if(updateEvent.equals("prepare_update")) { System.out.println("**** 222222222222");System.out.println("****  formObj.getIsDP() : "+formObj.getIsDP());%>
  					   <td class="fieldname" >Should DP be calculated from Bank Shares?</td>
                  <td >
                   <%if(formObj.getIsDP() == null || formObj.getIsDP().trim().equals("")) {%>
                  	  <input type="radio" id="DP" name="isDP" value="Y" disabled="disabled">Yes
                  	  <input type="radio" id="DP1" name="isDP" value="N" disabled="disabled">No
                  	 <%}else if(formObj.getIsDP().equalsIgnoreCase("N")) {%>
                  	  <input type="radio" id="DP" name="isDP" value="Y" disabled="disabled">Yes
                  	  <input type="radio" id="DP1" name="isDP" value="N" checked="checked" disabled="disabled">No
                  	 <%}else if(formObj.getIsDP().equalsIgnoreCase("Y")) {%>
                  	 <input type="radio" id="DP" name="isDP" value="Y" checked="checked" disabled="disabled">Yes
                  	  <input type="radio" id="DP1" name="isDP" value="N" disabled="disabled">No
                  	 <%} %>
  				  	  <input type="hidden" id="isDP" name="isDP" /> 
  				  </td>
  					 <%}else if(formObj.getPurpose().toUpperCase().equals("WORKING CAPITAL") || formObj.getPurpose().toUpperCase().equals("WORKING_CAPITAL")){ System.out.println("**** 3333333333333");%>
                  <td class="fieldname" >Should DP be calculated from Bank Shares?</td>
                  <td ><html:radio property="isDP" styleId="isDP" value="Y" /> Yes
  				  	  <html:radio property="isDP" styleId="isDP" value="N"/> No
  				  </td>
  				  <%}else{System.out.println("**** 44444444444"); %>  
  				     <td class="fieldname">Should DP be calculated from Bank Shares?</td>
                  <td ><html:radio property="isDP" styleId="isDP" value="Y" disabled="true"/> Yes
  				  	  <html:radio property="isDP" styleId="isDP" value="N" disabled="true"/> No
  				  </td>
  				  <%} %>				  
                </tr>
                <tr class="even">
                  <td class="fieldname">Relationship Manager</td>
                  <td>
                  <%
                  if(updateEvent.equals("prepare_update"))
                  {
                  %>
                   <integro:empty-if-null value="<%= relationShipMgrName %>"/>
        			<html:hidden property="relationShipManager" styleId="relationShipManager" value="<%=formObj.getRelationShipManager() %>" />             
				 <%
				 }
				 else
				 {
				  %>
                    <html:select property="relationShipManager" styleId="relationShipManager" value="<%=formObj.getRelationShipManager() %>">
                    <html:option value="">Please Select</html:option>
								<%
									if (relationShipMngrList == null
													|| relationShipMngrList.size() == 0) {
									}
											Iterator iter = relationShipMngrList.iterator();
											while (iter.hasNext()) {
												LabelValueBean labValBean = (LabelValueBean) iter.next();
												String currentLabel = labValBean.getLabel();
												String currentValue = labValBean.getValue();
								%>
								<html:option value="<%=currentValue%>">
									<%=currentLabel%>
								</html:option>

								<%
									}
								%>

							</html:select> 
				<%} %>				  
                  </td>
                  <td class="fieldname">Released</td>
                <td>
             <% 
             if(isUserCpcMaker){
            	 if(updateEvent.equals("prepare_update"))
              	{%>
              		<html:hidden property="isReleased" styleId="isReleased"/>             
 					<% if(formObj.getIsReleased().equals("Y")){%>
 						<input type="checkbox" id="partyC" checked="checked" onclick="javascript:checkbox()" disabled="disabled"></input>
 					<%} else if(formObj.getIsReleased().equals("N")){%>
 						<input type="checkbox" id="partyC" onclick="javascript:checkbox()" disabled="disabled"></input>
 			 		<%}	
 			 	}else{
 			  		if(formObj.getIsReleased()==null || formObj.getIsReleased().equals("")){%>
 						<input type="checkbox" id="partyC" onclick="javascript:checkbox()" disabled="disabled"></input>
 						<html:hidden property="isReleased" styleId="isReleased"/>
 					<%}else if(formObj.getIsReleased().equals("Y")){%>
 						<input type="checkbox" id="partyC" checked="checked" onclick="javascript:checkbox()" disabled="disabled"></input>
 						<html:hidden property="isReleased" styleId="isReleased"/>
 					<%} else if(formObj.getIsReleased().equals("N")){%>
 						<input type="checkbox" id="partyC" onclick="javascript:checkbox()" disabled="disabled"></input>
 						<html:hidden property="isReleased" styleId="isReleased"/>
 			 		<%}
 			 	}
             }else{
             	if(updateEvent.equals("prepare_update"))
             	{%>
             		<html:hidden property="isReleased" styleId="isReleased"/>             
					<% if(formObj.getIsReleased().equals("Y")){%>
						<input type="checkbox" id="partyC" checked="checked" onclick="javascript:checkbox()" disabled="disabled"></input>
					<%} else if(formObj.getIsReleased().equals("N")){%>
						<input type="checkbox" id="partyC" onclick="javascript:checkbox()" ></input>
			 		<%}	
			 	}else{
			  		if(formObj.getIsReleased()==null || formObj.getIsReleased().equals("")){%>
						<input type="checkbox" id="partyC" onclick="javascript:checkbox()"></input>
						<html:hidden property="isReleased" styleId="isReleased"/>
					<%}else if(formObj.getIsReleased().equals("Y")){%>
						<input type="checkbox" id="partyC" checked="checked" onclick="javascript:checkbox()"></input>
						<html:hidden property="isReleased" styleId="isReleased"/>
					<%} else if(formObj.getIsReleased().equals("N")){%>
						<input type="checkbox" id="partyC" onclick="javascript:checkbox()"></input>
						<html:hidden property="isReleased" styleId="isReleased"/>
			 		<%}
			 	}
         }%>
                  
                  
                  </td>
                </tr>
                <tr class="even">
                  <td class="fieldname">Banking Arrangement <font color="#FF0000">*</font></td>
                  <td>
                  	<html:select property="bankingArrangement" style="width:250px">
						<integro:common-code categoryCode="<%=CategoryCodeConstant.BANKING_ARRANGEMENT%>" descWithCode="false" />
					</html:select>
					<html:errors property="bankingArrangement"/>
                  </td>
                  <td class="fieldname">Clause as per Policy <font color="#FF0000">*</font></td>
                <td>
                  	<html:select property="clauseAsPerPolicy" style="width:250px">
						<integro:common-code categoryCode="<%=CategoryCodeConstant.CLAUSE_AS_PER_POLICY%>" descWithCode="false"/>
					</html:select>
					<html:errors property="clauseAsPerPolicy"/>
                </td>
                </tr>                
                <tr class="odd">
		  <td class="fieldname">Grade <font color="#FF0000">*</font> </td>
                  <td>
                                    <%
                  if(updateEvent.equals("prepare_update"))
                  {
                  %>
                  <bean:write name="LmtDetailForm" property="grade"/>&nbsp;
        			<html:hidden property="grade"/>
                  <%}
                  else{%>
                  <html:select property="grade" >
                    <html:option value="">Select</html:option>
                    <html:option value="1">1</html:option>
                    <html:option value="2">2</html:option>
                    <html:option value="3">3</html:option>
                    <html:option value="4">4</html:option>
                    <html:option value="5">5</html:option>
                    <html:option value="6">6</html:option>
                    <html:option value="7">7</html:option>
                    <html:option value="8">8</html:option>
                    <html:option value="9">9</html:option>
                    <html:option value="10">10</html:option>
                  </html:select>
                  <%} %>
                  <html:errors property="facilityGrade"/></td>
                  <td class="fieldname"><p>Secured</p></td>
                  <td>
                  <% if(formObj.getIsSecured()==null || formObj.getIsSecured().equals("")){%>
								
								<input type="checkbox" id="isSecuredCheckbox" onclick="javascript:checkboxSecured()"></input>
								<html:hidden property="isSecured" styleId="isSecured"/>
								<% }else if(formObj.getIsSecured().equals("Y")){%>
								<input type="checkbox" id="isSecuredCheckbox" checked="checked" onclick="javascript:checkboxSecured()"></input>
								<html:hidden property="isSecured" styleId="isSecured"/>
								<%} else if(formObj.getIsSecured().equals("N")){%>
								<input type="checkbox" id="isSecuredCheckbox" onclick="javascript:checkboxSecured()"></input>
								<html:hidden property="isSecured" styleId="isSecured"/>
								<%} %>
			
        			   <html:errors property="isSecured"/>
                       &nbsp;&nbsp;           
                  </td> 
                </tr>
                <tr class="even">
		  <td class="fieldname">Currency</td>
                   <td>
                  <% if(formObj.getCurrencyCode()==null || formObj.getCurrencyCode().trim().equals("")){%>
                  		<html:select  property="currencyCode" styleId="currencyCode" value="INR" onchange="convertToINR();">
                  			<html:options collection="currencyList" property="value" labelProperty="label"/>
                    	</html:select>
                  <%}else{ System.out.println(formObj.getCurrencyCode());%>
                  		<%if(null!=itrxValue.getLimit() && null!=itrxValue.getLimit().getCurrencyCode()){ %>
                  			<html:select disabled="true" property="currencyCode" styleId="currencyCode" value="<%=formObj.getCurrencyCode().trim()%>" onchange="convertToINR();">
                  				<html:options collection="currencyList" property="value" labelProperty="label"/>
                    		</html:select>
                  		<%}else{ %>
                  			<html:select property="currencyCode" styleId="currencyCode" value="<%=formObj.getCurrencyCode().trim()%>" onchange="convertToINR();">
                  				<html:options collection="currencyList" property="value" labelProperty="label"/>
                    		</html:select>
                  		<%} %>
                  <%} %>
                  </td>
                  <td class="fieldname">Adhoc</td>
                  <td>
                  <%
                  if(updateEvent.equals("prepare_update_xxyyzz"))// if(updateEvent.equals("prepare_update")) commented on 17 jul 2012 due to enable check box on adhoc select on edit option
                  {
                  %>
        			<html:hidden property="isAdhoc" styleId="isAdhoc" value="<%=formObj.getIsAdhoc()%>"/> 
        			<%if(formObj.getIsAdhoc().equals("on")) { %>
                  <input type="checkbox" id="checkAdhoc" name="checkAdhoc" checked="checked" disabled="disabled"/>
                  <%}else if(formObj.getIsAdhoc().equals("N")){ %>
                  <input type="checkbox" id="checkAdhoc" name="checkAdhoc"  disabled="disabled" />
                  <%}
                  }
                  else{  %>
                  <%if(formObj.getIsAdhoc()== null || formObj.getIsAdhoc().equals("N") ||  formObj.getIsAdhoc().equals("")) {
                   %>
                   
                    <input type="checkbox" id="partyC" onclick="javascript:enbleadhoc();"></input>
									<html:hidden property="isAdhoc" styleId="isAdhoc"/>
                   
                   <!--
                   <html:checkbox property="isAdhoc" onclick="javascript : enbleadhoc(this);" value="false"/> 
                 -->
                   <%
                  }else{
                	  %>
                	   <input type="checkbox" id="partyC" onclick="javascript:enbleadhoc();"  checked="checked" ></input>
								<html:hidden property="isAdhoc" styleId="isAdhoc"/>	
                	  
                	  <!--<html:checkbox property="isAdhoc" onclick="javascript : enbleadhoc(this);" value="true"/>
                      -->
                      <%
                  }
                  
                  %>                  
                  
                  <input type="hidden" name="checkAdhoc"/>
                  <%} %>
                  </td> 
                </tr>
                  <%
                  if(updateEvent.equals("prepare_update_xxyyzz"))  { // if(updateEvent.equals("prepare_update")) commented on 17 jul 2012 due to enable check box on adhoc select on edit option
                  %>
                  <html:hidden property="isAdhocToSum" styleId="isAdhocToSum"/>
                  <tr class="odd" id="adhoc" style="background:transparent;height:auto;border:0 none;display:none;">
                  <td class="fieldname">Whether  adhoc limit needs to be added in Total Sanctioned amount </td>
                  <td> <%System.out.println("formObj.getIsAdhocToSum()"+formObj.getIsAdhocToSum()); %>
                  <%
                  if(formObj.getIsAdhoc()!=null && formObj.getIsAdhoc().equalsIgnoreCase("on")){
                  if(formObj.getIsAdhocToSum().equals("on")) { %>
                  <input type="checkbox" id="adhocToSum" name="adhocToSum" disabled="disabled" checked="checked" />
                  <%}
                  else if(formObj.getIsAdhocToSum().equals("N")){ %>
                  <input type="checkbox" id="adhocToSum" name="adhocToSum" disabled="disabled"/>
                  <%}}else{%>
                  <html:hidden property="isAdhocToSum" value=""/>
                  <input type="checkbox" id="adhocToSum" name="adhocToSum" disabled="disabled"/>
                  <%} %>
                  </td>
                  <td class="fieldname">Adhoc Limit</td>
                             <td> 
                  <%if(formObj.getIsAdhoc()!=null && formObj.getIsAdhoc().equals("N")){ %>
                  	<html:text property="adhocLmtAmount" styleId="adhocLmtAmount" maxlength="41" readonly="true"/>
                  <%}else{ %>
				    <html:text property="adhocLmtAmount" maxlength="41" styleId="adhocLmtAmount" onblur="javascript:formatAmountAsCommaSeparated(this)"/>
				  <%} %>
                  </td>
                  </tr>
                  <%}else{
                   %>
                   <tr class="odd" id="adhoc" style="background:transparent;height:auto;border:0 none;display:none;">
                  <td class="fieldname">Whether  adhoc limit needs to be added in Total Sanctioned amount </td>
                  <td> <html:checkbox property="isAdhocToSum" styleId="isAdhocToSum" /><html:errors property="isAdhocToSum"/></td>
                  <td class="fieldname">Adhoc Limit</td>
				  <td><html:text property="adhocLmtAmount" maxlength="41" onkeyup="onKeyUpEvent(this);" styleId="adhocLmtAmount" onblur="onBlurEvent(this); convertToINR(); javascript:formatAmountAsCommaSeparated(this)"/><html:errors property="adhocLmtAmount"/></td>
                  </tr>
                   <%} %>
                  
                
<tr class="even">
    <td class="fieldname" width="20%">Sub Limit</td>
    <%if(!"ET".equals(formObj.getFacilitySystem())){%>
    <td width="30%" id="subLimitId">
        <html:radio property="limitType" styleId="limitType" value="Yes" onclick="javascript : enbleGnt(this);"   />&nbsp;Yes&nbsp;
        <html:radio property="limitType" styleId="limitType" value="No" onclick="javascript : enbleGnt(this);"  />&nbsp;No&nbsp;
        &nbsp;<html:errors property="limitType"/>
    </td>
    <%}else{ %>
    <td width="30%" id="subLimitId">
        <html:radio property="limitType" styleId="limitType" value="Yes" onclick="javascript : enbleGnt(this);" disabled="true" />&nbsp;Yes&nbsp;
        <html:radio property="limitType" styleId="limitType" value="No" onclick="javascript : enbleGnt(this);" disabled="true"/>&nbsp;No&nbsp;
        &nbsp;<html:errors property="limitType"/>
    </td>
    <%} %>
    <td class="fieldname" width="20%">Guarantee&nbsp;</td>
     <%if(!"ET".equals(formObj.getFacilitySystem())){%>
     <td width="30%" >        
       <html:radio property="guarantee" styleId="guarantee" value="Yes" onclick="javascript : enbleGuarantee(this);"  />&nbsp;Yes&nbsp;
       <html:radio property="guarantee" styleId="guarantee" value="No" onclick="javascript : enbleGuarantee(this);"  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="guarantee"/>
    </td>
    <%}else{ %>
    <td width="30%" >        
       <html:radio property="guarantee" styleId="guarantee" value="Yes" onclick="javascript : enbleGuarantee(this);" disabled="true" />&nbsp;Yes&nbsp;
       <html:radio property="guarantee" styleId="guarantee" value="No" onclick="javascript : enbleGuarantee(this);" disabled="true" />&nbsp;No&nbsp;
         &nbsp;<html:errors property="guarantee"/>
    </td>
    <%} %>
</tr>
     <tr class="even" id="guaranteeNo" style="background:transparent;height:auto;border:0 none;display:none;">
                  <td class="fieldname" width="20%">Facility Name <font color="#FF0000">*</font> </td>
                  <td width="30%"> <html:select property="mainFacilityId" styleId="mainFacilityId" value="<%=formObj.getMainFacilityId() %>" >
						<option value="">Please Select </option>                     
						<html:options  collection ="subFacNameList" labelProperty ="label" property ="value" />								                   
					</html:select>
              &nbsp;<html:errors property="subFacilityName"/>     </td>
                  <td class="fieldname" width="20%">&nbsp;</td>
                  <td width="30%">&nbsp; </td>
      </tr>
     <tr class="even" id="guaranteeYes" style="background:transparent;height:auto;border:0 none;display:none;">
                  <td class="fieldname" width="20%">Party Name <font color="#FF0000">*</font> </td>
                  <td width="30%"><html:select property="subPartyName" styleId="subPartyName" value="<%=formObj.getSubPartyName() %>" 
                  																onchange="javascript : refreshLiabilityID(this);"  >	
              <option value="">Please Select </option>                     
						<html:options  collection ="subPartyNameList" labelProperty ="label" property ="value" />								                   
					</html:select> <html:errors property="subPartyName"/>    </td>
              <td class="fieldname" width="20%">Liability ID<font color="#FF0000">*</font></td>
                  <td width="30%">
                  <html:select property="liabilityID" styleId="liabilityID" value="<%=formObj.getLiabilityID() %>" >
              <option value="">Please Select </option>                     
						<html:options  collection ="liabilityIDList" labelProperty ="label" property ="value" />								                   
					</html:select> <html:errors property="liabilityID"/> 
              </td>
     </tr>
     
<tr class="even">
     <tr class="even">
                        <td class="fieldname" width="20%">Sanctioned Amount<font color="#FF0000">*</font> </td>
                  <td width="30%"><html:text property="requiredSecCov" maxlength="41" styleId="requiredSecCov" 
                  onkeyup="onKeyUpEvent(this);" onblur="onBlurEvent(this); convertToINR(); javascript:formatAmountAsCommaSeparated(this);" />
                  &nbsp; &nbsp;             
                  <html:errors property="requiredSecCov" /></td>
                  <td class="fieldname" width="20%">Releasable Amount</td>
                   <td width="30%"><html:text  property="releasableAmount" onkeyup="onKeyUpEvent(this);" maxlength="41" styleId="releasableAmount" onblur="onBlurEvent(this); checkAmount(); javascript:formatAmountAsCommaSeparated(this)"/>
  &nbsp;<html:errors property="releasableAmount"/>
                    &nbsp; </td></tr>
		<tr class="odd">
		  <td class="fieldname">Sanctioned Amount (INR)</td>
		  <td><input type="text" id="inrValue" name="inrValue" maxlength="41" readonly="readonly" value="<%=UIUtil.formatWithCommaAndDecimal((String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.inrValue")) %>"/> &nbsp;</td>
		  <td class="fieldname">Released</td>
          <td width="30%"><html:text  property="totalReleasedAmount" styleId="totalReleasedAmount" readonly="true"/> &nbsp;<html:errors property="totalReleasedAmount" /><html:errors property="TotalReleasedError"/></td> 	
		</tr>	
		
	
		   <tr class="even">
		<%    if(null == formObj.getAdhocFacility() || "".equals(formObj.getAdhocFacility()) ) { %>
				  <td class="fieldname"><bean:message key="label.facility.adhocFacility"/> <font color="#FF0000">*</font> </td>
				  <td width="30%" >        
		          <input type="radio" name="adhocFacility" id="adhocFacility" value="Y"  onclick="javascript : adhocAlert(this);"  />&nbsp;Yes&nbsp;
		          <input type="radio" name="adhocFacility" id="adhocFacility" value="N"   onclick="javascript : adhocAlert(this);" checked="checked"  />&nbsp;No&nbsp;
		          &nbsp;<html:errors property="adhocFacilityError"/>
		         <input type="hidden" name="adhocFacilityNew" id="adhocFacilityNew" value="true"   />
		         <input type="hidden" name="adhocFacilitytest" id="adhocFacilitytest" value="<%=formObj.getAdhocFacility() %>"   />
		         
		          </td>
		    <%}  else{ 	%>
		     <td class="fieldname"><bean:message key="label.facility.adhocFacility"/><font color="#FF0000">*</font> </td>
				  <td width="30%" >        
				    <input type="hidden" name="adhocFacilitytest" id="adhocFacilitytest" value="<%=formObj.getAdhocFacility() %>"   />
				   
				     <%  if( "true".equalsIgnoreCase(request.getParameter("adhocFacilityNew"))) {  %>
             			<input type="hidden" name="adhocFacilityNew" id="adhocFacilityNew" value="true"   />
							<%}else{ %>
					      <input type="hidden" name="adhocFacilityNew" id="adhocFacilityNew" value="false"   />
						<%} %>
		        
		            <%  if( "N".equals(formObj.getAdhocFacility())) {  %>
 
              <input type="radio" name="adhocFacility" id="adhocFacility" value="Y"  onclick="javascript : adhocAlert(this);"  />&nbsp;Yes&nbsp;                  
			  <input type="radio" name="adhocFacility" id="adhocFacility" value="N"  onclick="javascript : adhocAlert(this);"  checked="checked"/>&nbsp;No&nbsp; 
						
							<%}else{ %>
				 <input type="radio" name="adhocFacility" id="adhocFacility" value="Y" onclick="javascript : adhocAlert(this);"  checked="checked" />&nbsp;Yes&nbsp;                  
		          <input type="radio" name="adhocFacility" id="adhocFacility" value="N" onclick="javascript : adhocAlert(this);"    />&nbsp;No&nbsp;
						
									 
							<%} %>
		         
		          &nbsp;<html:errors property="adhocFacilityError"/>
		     <%} %>
		          <td class="fieldname"><bean:message key="label.facility.adhocLastAvailDt"/></td>
		<%if
		
		(!"".equals(formObj.getAdhocLastAvailDate()) && null != formObj.getAdhocLastAvailDate() && !"null".equalsIgnoreCase(formObj.getAdhocLastAvailDate())){  %>
                 <td><input type="text" name="adhocLastAvailDate" id="adhocLastAvailDate"  style="width:90px"  disabled="disabled"  value="<%=formObj.getAdhocLastAvailDate()  %>" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="ImageadhocLastAvailDate" border="0" id="Image758"  disabled="disabled"
									             onclick="showCalendar('adhocLastAvailDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="adhocLastAvailDateError"/> </td>
									            
							<%}else{ %>
		<td><input type="text" name="adhocLastAvailDate" id="adhocLastAvailDate" style="width:90px" disabled="disabled" />
                      <img src="img/calendara.gif" alt="calender" name="ImageadhocLastAvailDate" border="0" id="Image758"  disabled="disabled"
									             onclick="showCalendar('adhocLastAvailDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="adhocLastAvailDateError"/> </td>
									            
									            <%} %>
		  </tr>			
		   <tr class="odd">
		           <td class="fieldname"><bean:message key="label.facility.multiDrawdownAllow"/></td>
				   <td width="30%" >        
			
			   <%  if( "N".equals(formObj.getMultiDrawdownAllow()) ) {  %>
                 <input type="radio" name="multiDrawdownAllow" id="multiDrawdownAllow" value="Y"   disabled="disabled"/>&nbsp;Yes&nbsp;                  
			     <input type="radio" name="multiDrawdownAllow" id="multiDrawdownAllow" value="N" checked="checked"   disabled="disabled" />&nbsp;No&nbsp; 
						
							<%}else if( "Y".equals(formObj.getMultiDrawdownAllow()) ){ %>
				   <input type="radio" name="multiDrawdownAllow" id="multiDrawdownAllow" value="Y"  checked="checked" disabled="disabled" />&nbsp;Yes&nbsp;                  
		           <input type="radio" name="multiDrawdownAllow" id="multiDrawdownAllow" value="N"   disabled="disabled"/>&nbsp;No&nbsp;
						
							<%} else{%>
					 <input type="radio" name="multiDrawdownAllow" id="multiDrawdownAllow" value="Y"   disabled="disabled" />&nbsp;Yes&nbsp;                  
		             <input type="radio" name="multiDrawdownAllow" id="multiDrawdownAllow" value="N"   disabled="disabled"/>&nbsp;No&nbsp;
								<%} %>
							
			         &nbsp;<html:errors property="multiDrawdownAllowError"/>
			      </td>
			      
		          <td class="fieldname"><bean:message key="label.facility.adhocTenor"/></td>
		          		<%if (!"".equals(formObj.getAdhocTenor()) && null!= formObj.getAdhocTenor()){ %>
                  	 <td width="30%"><input type="text"  name="adhocTenor" id="adhocTenor"  value="<%=formObj.getAdhocTenor() %>" disabled="disabled"/> &nbsp;<html:errors property="adhocTenorError" /></td> 	
                  
							<%}else{ %>
					   <td width="30%"><input type="text"  name="adhocTenor" id="adhocTenor" disabled="disabled"/> &nbsp;<html:errors property="adhocTenorError" /></td> 	
						
							<%} %>
		   </tr>	
	    	<tr class="even"> 
				   <td class="fieldname"><bean:message key="label.facility.adhocFacilityExpDt"/></td>

	<%if (!"".equals(formObj.getAdhocFacilityExpDate()) && null != formObj.getAdhocFacilityExpDate() && !"null".equalsIgnoreCase(formObj.getAdhocFacilityExpDate())){ %>
                 <td><input type="text" name="adhocFacilityExpDate" id="adhocFacilityExpDate"  style="width:90px"  disabled="disabled"  value="<%=formObj.getAdhocFacilityExpDate().trim()%>" size="15" maxlength="10" />
									              <img src="img/calendara.gif" alt="calender" name="ImageadhocFacilityExpDate" border="0" id="Image758" disabled="disabled"
									             onclick="showCalendar('adhocFacilityExpDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="adhocFacilityExpDateError"/> </td>
									          
							<%}else{ %>
		<td><input type="text" name="adhocFacilityExpDate" id="adhocFacilityExpDate" style="width:90px" disabled="disabled" />
									              <img src="img/calendara.gif" alt="calender" name="ImageadhocFacilityExpDate" border="0" id="Image758" disabled="disabled"
									             onclick="showCalendar('adhocFacilityExpDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="adhocFacilityExpDateError"/> </td>
									             
									            <%} %>
	
				   <td class="fieldname"><bean:message key="label.facility.genPurposeLoan"/><font color="#FF0000">*</font> </td>
				   <td width="30%" >        

		       	<%  if(null == formObj.getGeneralPurposeLoan()   || "N".equals(formObj.getGeneralPurposeLoan()) || "".equals(formObj.getGeneralPurposeLoan())) {  %>
 
              <input type="radio" name="generalPurposeLoan" id="generalPurposeLoan" value="Y"  />&nbsp;Yes&nbsp;                  
			     <input type="radio" name="generalPurposeLoan" id="generalPurposeLoan" value="N" checked="checked"   />&nbsp;No&nbsp; 
							<%}else{ %>
				 <input type="radio" name="generalPurposeLoan" id="generalPurposeLoan" value="Y"  checked="checked" />&nbsp;Yes&nbsp;                  
		           <input type="radio" name="generalPurposeLoan" id="generalPurposeLoan" value="N"  />&nbsp;No&nbsp;
						
							<%} %>
		            &nbsp;<html:errors property="generalPurposeLoanError"/>
		            </td>
    	  </tr>	
	                <%  
	                if( "Y".equals(formObj.getAdhocFacility())) {    %>
	                   <script language="javascript">
	                   document.forms[0].adhocLastAvailDate.disabled =false;
				       	document.forms[0].adhocTenor.disabled =false;
				   		document.forms[0].multiDrawdownAllow[0].disabled =false;
				       	document.forms[0].multiDrawdownAllow[1].disabled =false;
				       	document.forms[0].adhocFacilityExpDate.disabled =false;
				    	document.forms[0].ImageadhocFacilityExpDate.disabled =false;
				    	document.forms[0].ImageadhocLastAvailDate.disabled =false;

						 </script>
						 <%} %>
</tr>
<%if(!("ET".equals(formObj.getFacilitySystem()))) {%>
<tr class="even" id ="51">
    <td class="fieldname" width="20%">Project Finance<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="projectFinance" styleId="projectFinance" value="Y" onclick="projectLoanYes();"  />&nbsp;Yes&nbsp;
        <html:radio property="projectFinance" styleId="projectFinance" value="N" onclick="projectLoanNo()" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectFinance"/>
    </td>
    <td class="fieldname" width="20%">Project Loan <font color="#FF0000">*</font>&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectLoan" styleId="projectLoan" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <%if(ICMSConstant.YES.equals(formObj.getProjectFinance())){ %>
       		<html:radio property="projectLoan" styleId="projectLoan" value="N" onclick="" disabled="true" />&nbsp;No&nbsp;
       <%}else{ %>
       		<html:radio property="projectLoan" styleId="projectLoan" value="N" onclick="" />&nbsp;No&nbsp;
       <%} %>
         &nbsp;<html:errors property="projectLoan"/>
    </td>
</tr>


<tr class="even" id="52">
    <td class="fieldname" width="20%">Infra / Non-Infra project flag <font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="infaProjectFlag" styleId="infaProjectFlag" value="Y" onclick=""  />&nbsp;Infra&nbsp;
        <html:radio property="infaProjectFlag" styleId="infaProjectFlag" value="N" onclick="" />&nbsp;Non-Infra&nbsp;
        &nbsp;<html:errors property="infaProjectFlag"/>
    </td>
<td width="20%" class="fieldname">SCOD (Scheduled Commercial Operations Date)<font color="#FF0000">*</font> </td>	
                 <td><html:text property="scodDate" styleId ="scodDate" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','scodDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image723" 
									             onclick="showCalendar('scodDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>

					 &nbsp;<html:errors property="scodDate"/>				             
             </td>
</tr>





    <tr class="even" id="53">      
          <td class="fieldname">Remarks on SCOD <font color="#FF0000">*</font></td>
          <td width="30%"><html:text  property="remarksSCOD" styleId="remarksSCOD" maxlength="200" readonly="false"/> &nbsp;<html:errors property="remarksSCOD" /></td> 	
		<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	</tr>
	<%
	String lineNo = "";
	if(null != formObj.getLineNo()) {
		lineNo=formObj.getLineNo();
	}else {
		lineNo="";
		System.out.println("lineNo...."+lineNo);
		System.out.println("formObj.getIsCreate().................................................................."+formObj.getIsCreate());
	}
	System.out.println("formObj.getIsCreate().................................................................."+formObj.getIsCreate());
	 /* if(formObj.getIsCreate() == null){
		formObj.setIsCreate("Y");
	}  */
	//String scodLineNoList=PropertyManager.getValue("scod.linenocode.name");
	
	boolean scodB = false;
	if(scodLineNoList != null && !scodLineNoList.equals("")) {
	String[] scodlinelist = scodLineNoList.split(",");
	for(int i=0; i< scodlinelist.length; i++ ) {
		if(formObj.getLineNo()!=null && formObj.getLineNo().equals(scodlinelist[i])) {
			scodB = true;
		}
	}
	}
	
	if(scodLineNoList != null){
	if(!"Y".equals(formObj.getIsCreate()) && scodB){ %>
	<tr class="even" id = '0'>
<td class="fieldname" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepaySchedule" styleId="chngInRepaySchedule" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepaySchedule" styleId="chngInRepaySchedule" value="N"  onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepaySchedule"/>
    </td>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 
  </tr>
  <%}} %>
		<% 
		if(scodLineNoList != null ){
		if(!"Y".equals(formObj.getIsCreate()) && scodB){ %>
	<tr class="even" id="82">

<td class="fieldname" width="20%">Whether Limit released as you are updating SCOD?<font color="#FF0000">*</font>&nbsp;</td>
    <td width="30%" >        
       <html:radio property="whlmreupSCOD" styleId="whlmreupSCOD" value="Y" onclick="disableSCOD(this);"  />&nbsp;Yes&nbsp;
       <html:radio property="whlmreupSCOD" styleId="whlmreupSCOD" value="N" onclick="disableSCOD(this);"  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="whlmreupSCOD"/>
    </td> 
    <td class="fieldname" width="20%">Whether Project is Delayed<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="projectDelayedFlag" styleId="projectDelayedFlag" value="Y" onclick="disableSCODOnDelay(this);"  />&nbsp;Yes&nbsp;
        <html:radio property="projectDelayedFlag" styleId="projectDelayedFlag" value="N" onclick="disableSCODOnDelay(this);" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectDelayedFlag"/>
    </td>    
          </tr>	
	<%}} %>
	
	 <tr class="even" id="41">
	  <td class="fieldname">Existing Asset classification <font color="#FF0000">*</font></td>
	 <td>
	<html:select property="exstAssetClass" styleId="exstAssetClass"   onchange="" >
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClass"/></td>
		 <td width="20%" class="fieldname">Existing Asset classification Date<font color="#FF0000">*</font> </td>	
		  <%if (!"".equals(formObj.getExstAssClassDate()) && formObj.getExstAssClassDate() != null){ %>
                 <td><html:text property="exstAssClassDate" styleId="exstAssClassDate" style="width:90px" readonly="true"  value="<%=formObj.getExstAssClassDate()%>"  onblur="itg_checkform('frmMain','exstAssClassDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image756"
									             onclick="showCalendar('exstAssClassDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="exstAssClassDate"/></td> <%}else{ %>
				   <td><html:text property="exstAssClassDate" styleId="exstAssClassDate" style="width:90px" readonly="true"   onblur="itg_checkform('frmMain','exstAssClassDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image756"
									             onclick="showCalendar('exstAssClassDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="exstAssClassDate"/></td>
									             <%} %>
									             </tr>
			<%System.out.println("Jay........"+formObj.getEvent()); %>
			<%System.out.println("Jay........"+formObj.getIsCreate()); %>
			<% 
			if(scodLineNoList != null ){
			if(!"Y".equals(formObj.getIsCreate()) && scodB){ %>
			
			
          	             
				 <tr class="even" id = "36">
	  <td class="fieldname">Revised Asset Classification<font color="#FF0000">*</font></td>
	 <td>
	<html:select property="revisedAssetClass" styleId="revisedAssetClass" value="<%=formObj.getRevisedAssetClass()%>"  onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClass"/></td>
		 <td width="20%" class="fieldname">Revised Asset Classification Date<font color="#FF0000">*</font> </td>	
		 <%System.out.println("getRevsdAssClassDate...."+formObj.getRevsdAssClassDate()); %>
		  <%if (!"".equals(formObj.getRevsdAssClassDate()) && formObj.getRevsdAssClassDate() != null){ %>
                 <td><html:text property="revsdAssClassDate" style="width:90px" readonly="true" value="<%=formObj.getRevsdAssClassDate() %>" onblur="itg_checkform('frmMain','revsdAssClassDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsdAssClassDate"/></td>
									             <%}else{ %>
				  <td><html:text property="revsdAssClassDate" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','revsdAssClassDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsdAssClassDate"/></td>
									             <%} %>
									             </tr>	 		             
									             
									           
	<tr class="even" id = "80">
	
		 <td width="20%" class="fieldname">ACOD (Actual Commercial Operations Date)<font color="#FF0000">*</font> </td>	
		 
		  <%if (!"".equals(formObj.getActualCommOpsDate()) && formObj.getActualCommOpsDate() != null){ %>
                 <td><html:text property="actualCommOpsDate" styleId="actualCommOpsDate"  style="width:90px" readonly="true"   onchange="changeLevelOfDelay(this);" value="<%=formObj.getActualCommOpsDate() %>" onblur="itg_checkform('frmMain','actualCommOpsDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image758"
									             onclick="showCalendar('actualCommOpsDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="actualCommOpsDate"/> </td><%}else{ %>
		<td><html:text property="actualCommOpsDate" styleId="actualCommOpsDate" style="width:90px" readonly="true" onchange="changeLevelOfDelay(this);" onblur="itg_checkform('frmMain','actualCommOpsDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image758"
									             onclick="showCalendar('actualCommOpsDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="actualCommOpsDate"/> </td>
									            <%} %>
	<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
									             </tr>
									             
	
<tr class="even" id = "81">
    <td class="fieldname">Level of delay in SCOD</td>

	 <td>
	<html:select property="lelvelDelaySCOD" styleId="lelvelDelaySCOD" value="<%=formObj.getLelvelDelaySCOD()%>"  onchange="lelvelDelaySCODFun(this);">
	                  			<integro:common-code categoryCode="DELAY_LEVEL_ID"
	                  					 descWithCode="false"  />   
							 </html:select><html:errors property="lelvelDelaySCOD"/></td>
						
     <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 
</tr>
 <tr class="even" id = '72'>
<td class="fieldname" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepayScheduleL1" styleId="chngInRepayScheduleL1" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepayScheduleL1" styleId="chngInRepayScheduleL1" value="N"  onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepayScheduleL1"/>
    </td>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 
  </tr>   
<%-- <tr class="even" id = '1'>
    
    <td class="fieldname" width="20%" id="reasonLevelOneDelayLable">Reason for Deferment of SCOD in the event of level 1 delay<font color="#FF0000">*</font>&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelOneDelay" styleId="reasonLevelOneDelay" maxlength="200" readonly="false"/> &nbsp;<html:errors property="reasonLevelOneDelay" /></td> 	
<td class="fieldname" width="20%"></td>
    <td width="30%">
        &nbsp;
    </td>
</tr> --%>
<%-- <tr class="even" id = '2'>
    <td class="fieldname" width="20%">Whether Project is Delayed<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="projectDelayedFlagL2" styleId="projectDelayedFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="projectDelayedFlagL2" styleId="projectDelayedFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectDelayedFlagL2"/>
    </td>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 	
</tr> --%>

<%-- <tr class="even" id = '45'>
    <td class="fieldname" width="20%">Whether Project is Delayed<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="projectDelayedFlagL3" styleId="projectDelayedFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="projectDelayedFlagL3" styleId="projectDelayedFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectDelayedFlagL3"/>
    </td>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 	
</tr> --%>

<tr class="even" id = '3'>
    <%-- <td class="fieldname" width="20%">whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepaySchedule" styleId="chngInRepaySchedule" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepaySchedule" styleId="chngInRepaySchedule" value="N"  onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepaySchedule"/>
    </td> --%>
     <td width="20%" class="fieldname">Extended SCOD (ESCOD) date in the event of level 1 delay<font color="#FF0000">*</font> </td>
       <%if (!"".equals(formObj.getEscodLevelOneDelayDate()) && formObj.getEscodLevelOneDelayDate() != null){ %>	
                 <td><html:text property="escodLevelOneDelayDate" style="width:90px" readonly="true" value="<%=formObj.getEscodLevelOneDelayDate()%>" onblur="itg_checkform('frmMain','escodLevelOneDelayDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('escodLevelOneDelayDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="escodLevelOneDelayDate"/></td><%}else{ %>
				  <td><html:text property="escodLevelOneDelayDate" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','escodLevelOneDelayDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('escodLevelOneDelayDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="escodLevelOneDelayDate"/></td>
									             <%} %>
									              <td class="fieldname" width="20%" id="reasonLevelOneDelayLable">Reason for Deferment of SCOD in the event of level 1 delay<font color="#FF0000">*</font>&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelOneDelay" styleId="reasonLevelOneDelay" maxlength="200" readonly="false"/> &nbsp;<html:errors property="reasonLevelOneDelay" /></td> 	

</tr>


<tr class="even" id = '4'>
   
     <td width="20%" class="fieldname">Extended SCOD (ESCOD) date in the event of level 2 delay<font color="#FF0000">*</font> </td>	
      <%if (!"".equals(formObj.getEscodLevelSecondDelayDate()) && formObj.getEscodLevelSecondDelayDate() != null){ %>	
                 <td><html:text property="escodLevelSecondDelayDate" style="width:90px" readonly="true" value="<%=formObj.getEscodLevelSecondDelayDate() %>" onblur="itg_checkform('frmMain','escodLevelSecondDelayDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('escodLevelSecondDelayDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/> 
									           <html:errors property="escodLevelSecondDelayDate"/>  </td><%}else{ %>
				   <td><html:text property="escodLevelSecondDelayDate" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','escodLevelSecondDelayDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('escodLevelSecondDelayDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									            <html:errors property="escodLevelSecondDelayDate"/> </td> 
									             <%} %>
	 <td class="fieldname" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepayScheduleL2" styleId="chngInRepayScheduleL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepayScheduleL2" styleId="chngInRepayScheduleL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepayScheduleL2"/>
    </td>
</tr>


<tr class="even" id = '5'>
   <td class="fieldname" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepayScheduleL3" styleId="chngInRepayScheduleL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepayScheduleL3" styleId="chngInRepayScheduleL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepayScheduleL3"/>
    </td>
     <td width="20%" class="fieldname">&nbsp;</td>	
                 <td></td>
	 
</tr>

<tr class="even" id = '6'>
   
    <%if (!"".equals(formObj.getEscodLevelThreeDelayDate()) && formObj.getEscodLevelThreeDelayDate() != null){ %>
     <td width="20%" class="fieldname">Extended SCOD (ESCOD) date in the event of level 3 delay<font color="#FF0000">*</font> </td>	
                 <td><html:text property="escodLevelThreeDelayDate" style="width:90px" readonly="true" value="<%=formObj.getEscodLevelThreeDelayDate() %>" onblur="itg_checkform('frmMain','escodLevelThreeDelayDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('escodLevelThreeDelayDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="escodLevelThreeDelayDate"/> </td><%}else{ %>
	    <td width="20%" class="fieldname">Extended SCOD (ESCOD) date in the event of level 3 delay<font color="#FF0000">*</font> </td>	
                 <td><html:text property="escodLevelThreeDelayDate" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','escodLevelThreeDelayDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('escodLevelThreeDelayDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/> 
									             <html:errors property="escodLevelThreeDelayDate"/></td>
									             <%} %>
	<td class="fieldname" width="20%">Reason for Deferment of SCOD in the event of level 3 delay<font color="#FF0000">*</font>&nbsp;&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelThreeDelay" styleId="reasonLevelThreeDelay" readonly="flase"/> &nbsp;<html:errors property="reasonLevelThreeDelay" /></td> 	
	
</tr>


<tr class="even" id = '20'>

       <td class="fieldname" width="20%">Reason for Deferment of SCOD in the event of level 2 delay<font color="#FF0000">*</font>&nbsp;&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelTwoDelay" styleId="reasonLevelTwoDelay" readonly="false"/> &nbsp;<html:errors property="reasonLevelTwoDelay" /></td>
		 <td width="20%" class="fieldname">&nbsp;</td>	
                 <td>&nbsp;</td>
</tr>

<tr class="even" id = '7'>
   
     <td width="20%" class="fieldname">Reason for revision in ESCOD due to level 2 delay<font color="#FF0000">*</font> </td>	
                 <td>A. For Infra Projects&nbsp;<html:errors property="reasonForRevisionInfraDelayLvl2" /></td>
	<td class="fieldname">&nbsp;</td>
		<td width="30%">B. For Non-Infra Projects&nbsp;<html:errors property="reasonForRevisionNonInfraDelayLvl2" /></td>
</tr>

<tr class="even" id = '8'>
   
     <td width="20%" class="fieldname">&nbsp;</td>	
      <%if("Y".equals(formObj.getLegalOrArbitrationLevel2Flag()) && null != formObj.getLegalOrArbitrationLevel2Flag()){ %>
     
                 <td> <input type="checkbox" property="legalOrArbitrationLevel2FlagC" id="legalOrArbitrationLevel2FlagC" checked="checked"></input>
						<html:hidden property="legalOrArbitrationLevel2Flag" styleId="legalOrArbitrationLevel2Flag"/>Legal / arbitration proceedings in the project </td>
						<%}else{ %>
		      <td> <input type="checkbox" property="legalOrArbitrationLevel2FlagC" id="legalOrArbitrationLevel2FlagC"></input>
						<html:hidden property="legalOrArbitrationLevel2Flag" styleId="legalOrArbitrationLevel2Flag"/>Legal / arbitration proceedings in the project </td>
		<%} %>
     	<td class="fieldname"></td>
     	<%System.out.println("formObj.getChngOfOwnPrjFlagNonInfraLevel2()..."+formObj.getChngOfOwnPrjFlagNonInfraLevel2());%>
     	<%if("Y".equals(formObj.getChngOfOwnPrjFlagNonInfraLevel2()) && null != formObj.getChngOfOwnPrjFlagNonInfraLevel2()){ %>
		<td width="30%"> <input type="checkbox" id="chngOfOwnPrjFlagNonInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel2" styleId="chngOfOwnPrjFlagNonInfraLevel2"/>Change of ownership of project</td>
						<%}else{ %>
			<td width="30%"> <input type="checkbox" id="chngOfOwnPrjFlagNonInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel2" styleId="chngOfOwnPrjFlagNonInfraLevel2"/>Change of ownership of project</td>
			<%} %>
</tr>

<tr class="even" id = '9'>
   
     <td width="20%" class="fieldname"></td>
     <%if("Y".equals(formObj.getReasonBeyondPromoterLevel2Flag()) && null != formObj.getReasonBeyondPromoterLevel2Flag()){ %>	
                 <td><input type="checkbox" id="reasonBeyondPromoterLevel2FlagC" onclick="" checked="checked"></input>
						<html:hidden property="reasonBeyondPromoterLevel2Flag" styleId="reasonBeyondPromoterLevel2Flag"/> Reasons beyond control of promoter </td>
		<%}else{ %>
                 <td><input type="checkbox" id="reasonBeyondPromoterLevel2FlagC" onclick=""></input>
						<html:hidden property="reasonBeyondPromoterLevel2Flag" styleId="reasonBeyondPromoterLevel2Flag"/> Reasons beyond control of promoter </td>
		<%} %>
	<td class="fieldname"></td>
						<%if("Y".equals(formObj.getChngOfProjScopeNonInfraLevel2()) && null != formObj.getChngOfProjScopeNonInfraLevel2()){ %>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeNonInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel2" styleId="chngOfProjScopeNonInfraLevel2"/>Change of scope of project </td>
						<%}else{ %>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeNonInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel2" styleId="chngOfProjScopeNonInfraLevel2"/>Change of scope of project </td>
						<%} %>
</tr>


<tr class="even" id = '10'>
   
     <td width="20%" class="fieldname"></td>
         <%if("Y".equals(formObj.getChngOfOwnPrjFlagInfraLevel2()) && null != formObj.getChngOfOwnPrjFlagInfraLevel2()){ %>	
                 <td> <input type="checkbox" id="chngOfOwnPrjFlagInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel2" styleId="chngOfOwnPrjFlagInfraLevel2"/> Change of ownership of project </td>
						<%} else{ %>
                 <td> <input type="checkbox" id="chngOfOwnPrjFlagInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel2" styleId="chngOfOwnPrjFlagInfraLevel2"/> Change of ownership of project </td>
						<%} %>
						
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>


<tr class="even" id = '11'>
   
    <td class="fieldname"></td>
             <%if("Y".equals(formObj.getChngOfProjScopeInfraLevel2()) && null != formObj.getChngOfProjScopeInfraLevel2()){ %>	
		<td width="30%"><input type="checkbox" id="chngOfProjScopeInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeInfraLevel2" styleId="chngOfProjScopeInfraLevel2"/> Change of scope of project </td>
						<%} else{%>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfProjScopeInfraLevel2" styleId="chngOfProjScopeInfraLevel2"/> Change of scope of project </td>
						<%} %>
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>





<tr class="even" id = '12'>
   
     <td width="20%" class="fieldname">Reason for revision in ESCOD due to level 3 delay<font color="#FF0000">*</font> </td>	
                 <td>A. For Infra Projects&nbsp;<html:errors property="reasonForRevisionInfraDelayLvl3" /></td>
	<td class="fieldname">&nbsp;</td>
		<td width="30%">B. For Non-Infra Projects&nbsp;<html:errors property="reasonForRevisionNonInfraDelayLvl3" /></td>
</tr>

<tr class="even" id = '13'>
   
     <td width="20%" class="fieldname"> </td>	
                 <%if("Y".equals(formObj.getLegalOrArbitrationLevel3Flag()) && null != formObj.getLegalOrArbitrationLevel3Flag()){ %>	
                 <td><input type="checkbox" id="legalOrArbitrationLevel3FlagC" onclick="" checked="checked"></input>
						<html:hidden property="legalOrArbitrationLevel3Flag" styleId="legalOrArbitrationLevel3Flag"/> Legal / arbitration proceedings in the project </td>
				<%}else{%>
                 <td><input type="checkbox" id="legalOrArbitrationLevel3FlagC" onclick=""></input>
						<html:hidden property="legalOrArbitrationLevel3Flag" styleId="legalOrArbitrationLevel3Flag"/> Legal / arbitration proceedings in the project </td>
				<%} %>
	<td class="fieldname"></td>
	   <%if("Y".equals(formObj.getChngOfOwnPrjFlagNonInfraLevel3()) && null != formObj.getChngOfOwnPrjFlagNonInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" id="chngOfOwnPrjFlagNonInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel3" styleId="chngOfOwnPrjFlagNonInfraLevel3"/> Change of ownership of project </td>
		<%}else{ %>
		<td width="30%"><input type="checkbox" id="chngOfOwnPrjFlagNonInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel3" styleId="chngOfOwnPrjFlagNonInfraLevel3"/> Change of ownership of project </td>
		<%} %>
</tr>

<tr class="even" id = '14'>
   	   <%if("Y".equals(formObj.getReasonBeyondPromoterLevel3Flag()) && null != formObj.getReasonBeyondPromoterLevel3Flag()){ %>
     <td width="20%" class="fieldname"> </td>	
                 <td><input type="checkbox" id="reasonBeyondPromoterLevel3FlagC" onclick="" checked="checked"></input>
						<html:hidden property="reasonBeyondPromoterLevel3Flag" styleId="reasonBeyondPromoterLevel3Flag"/> Reasons beyond control of promoter </td>
						<%}else{%>
     <td width="20%" class="fieldname"> </td>	
                 <td><input type="checkbox" id="reasonBeyondPromoterLevel3FlagC" onclick=""></input>
						<html:hidden property="reasonBeyondPromoterLevel3Flag" styleId="reasonBeyondPromoterLevel3Flag"/> Reasons beyond control of promoter </td>
						<%} %>
	<td class="fieldname"></td>
   	   <%if("Y".equals(formObj.getChngOfProjScopeNonInfraLevel3()) && null != formObj.getChngOfProjScopeNonInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeNonInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel3" styleId="chngOfProjScopeNonInfraLevel3"/> Change of scope of project </td>
						<%}else{ %>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeNonInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel3" styleId="chngOfProjScopeNonInfraLevel3"/> Change of scope of project </td>
						<%} %>
</tr>


<tr class="even" id = '15'>
   
     <td width="20%" class="fieldname"> </td>	
      <%if("Y".equals(formObj.getChngOfOwnPrjFlagInfraLevel3()) && null != formObj.getChngOfOwnPrjFlagInfraLevel3()){ %>
                 <td><input type="checkbox" id="chngOfOwnPrjFlagInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel3" styleId="chngOfOwnPrjFlagInfraLevel3"/> Change of ownership of project </td>
						<%} else{ %>
                 <td><input type="checkbox" id="chngOfOwnPrjFlagInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel3" styleId="chngOfOwnPrjFlagInfraLevel3"/> Change of ownership of project </td>
						<%} %>
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>


<tr class="even" id = '16'>
   
    <td class="fieldname"></td>
          <%if("Y".equals(formObj.getChngOfProjScopeInfraLevel3()) && null != formObj.getChngOfProjScopeInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeInfraLevel3" styleId="chngOfProjScopeInfraLevel3"/> Change of scope of project </td>
						<%} else{ %>
		<td width="30%"><input type="checkbox" id="chngOfProjScopeInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfProjScopeInfraLevel3" styleId="chngOfProjScopeInfraLevel3"/> Change of scope of project </td>
						<%} %>
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>




<tr class="even" id = '17'>
    <td class="fieldname" width="20%">Details of legal / arbitration proceedings&nbsp;</td>
          <td width="30%"><html:text  property="leaglOrArbiProceed" styleId="leaglOrArbiProceed" readonly="false"/> &nbsp;<html:errors property="leaglOrArbiProceed" /></td>
          
          <td class="fieldname" width="20%">Details of "reasons beyond control of promoter"&nbsp;</td>
          <td width="30%"><html:text  property="detailsRsnByndPro" styleId="detailsRsnByndPro" readonly="false"/> &nbsp;<html:errors property="detailsRsnByndPro" /></td>
</tr>


<tr class="even" id = '18'>
    <td class="fieldname" width="20%">Details of legal / arbitration proceedings&nbsp;</td>
          <td width="30%"><html:text  property="leaglOrArbiProceedLevel3" styleId="leaglOrArbiProceedLevel3" readonly="false"/> &nbsp;<html:errors property="leaglOrArbiProceedLevel3" /></td>
          
          <td class="fieldname" width="20%">Details of "reasons beyond control of promoter"&nbsp;</td>
          <td width="30%"><html:text  property="detailsRsnByndProLevel3" styleId="detailsRsnByndProLevel3" readonly="false"/> &nbsp;<html:errors property="detailsRsnByndProLevel3" /></td>
</tr>

<tr class="even" id = '19'>
<td class="fieldname" width="20%">Whether request for deferment received prior to expiry of SCOD<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="recvPriorOfSCOD" styleId="recvPriorOfSCOD" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="recvPriorOfSCOD" styleId="recvPriorOfSCOD" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="recvPriorOfSCOD"/>
    </td>
    	<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
		</tr>
    





<tr class="even" id = '21'>
    <td class="fieldname" width="20%">Change of Ownership</td>
    <td width="30%">
        &nbsp;
    </td>
    <td class="fieldname" width="20%">Change of scope</td>
    <td width="30%">
        &nbsp;
    </td>
</tr>


<tr class="even" id = '22'>
    <td class="fieldname" width="20%">a) Do New Promoters have capability to run the project</td>
    <td width="30%">
        <html:radio property="promotersCapRunFlag" styleId="promotersCapRunFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersCapRunFlag" styleId="promotersCapRunFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersCapRunFlag"/>
    </td>
    <td class="fieldname" width="20%">a) Change in scope has taken place before SCOD&nbsp;</td>
    <td width="30%" >        
       <html:radio property="changeInScopeBeforeSCODFlag" styleId="changeInScopeBeforeSCODFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="changeInScopeBeforeSCODFlag" styleId="changeInScopeBeforeSCODFlag" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="changeInScopeBeforeSCODFlag"/>
    </td>
</tr>

<tr class="even" id = '23'>
    <td class="fieldname" width="20%">a) Do New Promoters have capability to run the project</td>
    <td width="30%">
        <html:radio property="promotersCapRunFlagL2" styleId="promotersCapRunFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersCapRunFlagL2" styleId="promotersCapRunFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersCapRunFlagL2"/>
    </td>
    <td class="fieldname" width="20%">a) Change in scope has taken place before SCOD&nbsp;</td>
    <td width="30%" >        
       <html:radio property="changeInScopeBeforeSCODFlagL2" styleId="changeInScopeBeforeSCODFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="changeInScopeBeforeSCODFlagL2" styleId="changeInScopeBeforeSCODFlagL2" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="changeInScopeBeforeSCODFlagL2"/>
    </td>
</tr>

<tr class="even" id = '24'>
    <td class="fieldname" width="20%">a) Do New Promoters have capability to run the project</td>
    <td width="30%">
        <html:radio property="promotersCapRunFlagL3" styleId="promotersCapRunFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersCapRunFlagL3" styleId="promotersCapRunFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersCapRunFlagL3"/>
    </td>
    <td class="fieldname" width="20%">a) Change in scope has taken place before SCOD&nbsp;</td>
    <td width="30%" >        
       <html:radio property="changeInScopeBeforeSCODFlagL3" styleId="changeInScopeBeforeSCODFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="changeInScopeBeforeSCODFlagL3" styleId="changeInScopeBeforeSCODFlagL3" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="changeInScopeBeforeSCODFlagL3"/>
    </td>
</tr>

<tr class="even" id = '25'>
    <td class="fieldname" width="20%">b) Do New promoters hold 51% equity in the project</td>
    <td width="30%">
        <html:radio property="promotersHoldEquityFlag" styleId="promotersHoldEquityFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersHoldEquityFlag" styleId="promotersHoldEquityFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersHoldEquityFlag"/>
    </td>
    <td class="fieldname" width="20%">b) Cost Overrun > 25% of original project cost&nbsp;</td>
    <td width="30%" >        
       <html:radio property="costOverrunOrg25CostViabilityFlag" styleId="costOverrunOrg25CostViabilityFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="costOverrunOrg25CostViabilityFlag" styleId="costOverrunOrg25CostViabilityFlag" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="costOverrunOrg25CostViabilityFlag"/>
    </td>
</tr>

<tr class="even" id = '26'>
    <td class="fieldname" width="20%">b) Do New promoters hold 51% equity in the project</td>
    <td width="30%">
        <html:radio property="promotersHoldEquityFlagL2" styleId="promotersHoldEquityFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersHoldEquityFlagL2" styleId="promotersHoldEquityFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersHoldEquityFlagL2"/>
    </td>
    <td class="fieldname" width="20%">b) Cost Overrun > 25% of original project cost&nbsp;</td>
    <td width="30%" >        
       <html:radio property="costOverrunOrg25CostViabilityFlagL2" styleId="costOverrunOrg25CostViabilityFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="costOverrunOrg25CostViabilityFlagL2" styleId="costOverrunOrg25CostViabilityFlagL2" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="costOverrunOrg25CostViabilityFlagL2"/>
    </td>
</tr>

<tr class="even" id = '27'>
    <td class="fieldname" width="20%">b) Do New promoters hold 51% equity in the project</td>
    <td width="30%">
        <html:radio property="promotersHoldEquityFlagL3" styleId="promotersHoldEquityFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersHoldEquityFlagL3" styleId="promotersHoldEquityFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersHoldEquityFlagL3"/>
    </td>
    <td class="fieldname" width="20%">b) Cost Overrun > 25% of original project cost&nbsp;</td>
    <td width="30%" >        
       <html:radio property="costOverrunOrg25CostViabilityFlagL3" styleId="costOverrunOrg25CostViabilityFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="costOverrunOrg25CostViabilityFlagL3" styleId="costOverrunOrg25CostViabilityFlagL3" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="costOverrunOrg25CostViabilityFlagL3"/>
    </td>
</tr>


<tr class="even" id = '28'>
    <td class="fieldname" width="20%">c) Has project viability been re-assessed</td>
    <td width="30%">
        <html:radio property="hasProjectViabReAssFlag" styleId="hasProjectViabReAssFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="hasProjectViabReAssFlag" styleId="hasProjectViabReAssFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="hasProjectViabReAssFlag"/>
    </td>
    <td class="fieldname" width="20%">c) Project Viability reassessed&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectViabReassesedFlag" styleId="projectViabReassesedFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="projectViabReassesedFlag" styleId="projectViabReassesedFlag" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectViabReassesedFlag"/>
    </td>
</tr>

<tr class="even" id = '29'>
    <td class="fieldname" width="20%">c) Has project viability been re-assessed</td>
    <td width="30%">
        <html:radio property="hasProjectViabReAssFlagL2" styleId="hasProjectViabReAssFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="hasProjectViabReAssFlagL2" styleId="hasProjectViabReAssFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="hasProjectViabReAssFlagL2"/>
    </td>
    <td class="fieldname" width="20%">c) Project Viability reassessed&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectViabReassesedFlagL2" styleId="projectViabReassesedFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="projectViabReassesedFlagL2" styleId="projectViabReassesedFlagL2" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectViabReassesedFlagL2"/>
    </td>
</tr>

<tr class="even" id = '30'>
    <td class="fieldname" width="20%">c) Has project viability been re-assessed</td>
    <td width="30%">
        <html:radio property="hasProjectViabReAssFlagL3" styleId="hasProjectViabReAssFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="hasProjectViabReAssFlagL3" styleId="hasProjectViabReAssFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="hasProjectViabReAssFlagL3"/>
    </td>
    <td class="fieldname" width="20%">c) Project Viability reassessed&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectViabReassesedFlagL3" styleId="projectViabReassesedFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="projectViabReassesedFlagL3" styleId="projectViabReassesedFlagL3" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectViabReassesedFlagL3"/>
    </td>
</tr>



 <tr class="even" id = "34">
	  <td class="fieldname">Existing Asset classification </td>
	 <td>
	<html:select property="exstAssetClassL1" styleId="exstAssetClassL1" value="<%=formObj.getExstAssetClassL1()%>" disabled="true"  onchange="">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClassL1"/></td>
		 <td width="20%" class="fieldname">Existing Asset classification Date<font color="#FF0000">*</font> </td>	
		     <%if (!"".equals(formObj.getExstAssClassDateL1()) && formObj.getExstAssClassDateL1() != null){ %>
                 <td><html:text property="exstAssClassDateL1" style="width:90px" readonly="true" disabled="true" value="<%=formObj.getExstAssClassDate() %>" onblur="itg_checkform('frmMain','exstAssClassDateL1','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image101"
									             onclick="showCalendar('exstAssClassDateL1', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()" hidden = "true"/>
									             </td><%}else{ %>
				 <td><html:text property="exstAssClassDateL1" style="width:90px" readonly="true" disabled="true" value="<%=formObj.getExstAssClassDate() %>" onblur="itg_checkform('frmMain','exstAssClassDateL1','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image101" 
									             onclick="showCalendar('exstAssClassDateL1', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()" hidden="true"/>
									             </td>
									             <%} %>
									             </tr>
								 	             
				<tr class="even" id = "35">
	  <td class="fieldname">Existing Asset classification</td>
	 <td>
	<html:select property="exstAssetClassL2" styleId="exstAssetClassL2" value="<%=formObj.getExstAssetClassL2()%>" disabled="true"  onchange="">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClassL2"/></td>
		 <td width="20%" class="fieldname">Existing Asset classification Date<font color="#FF0000">*</font> </td>
		   <%if (!"".equals(formObj.getExstAssClassDateL2()) && formObj.getExstAssClassDateL2() != null){ %>	
                 <td><html:text property="exstAssClassDateL2" style="width:90px" readonly="true" disabled="true" value="<%=formObj.getExstAssClassDate() %>" onblur="itg_checkform('frmMain','exstAssClassDateL2','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image102"
									             onclick="showCalendar('exstAssClassDateL2', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()" hidden="true"/>
									             </td><%}else{ %>
				 <td><html:text property="exstAssClassDateL2" style="width:90px" readonly="true" value="<%=formObj.getExstAssClassDate() %>" disabled="true" onblur="itg_checkform('frmMain','exstAssClassDateL2','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image102"
									             onclick="showCalendar('exstAssClassDateL2', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()" hidden="true"/>
									             </td>
									             <%} %>
									             </tr>
									             
									             
				<tr class="even" id = "40">
	  <td class="fieldname">Existing Asset classification</td>
	 <td>
	<html:select property="exstAssetClassL3" styleId="exstAssetClassL3" value="<%=formObj.getExstAssetClassL3()%>" disabled="true"  onchange="">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClassL3"/></td>
		 <td width="20%" class="fieldname">Existing Asset classification Date<font color="#FF0000">*</font> </td>	
		    <%if (!"".equals(formObj.getExstAssClassDateL3()) && formObj.getExstAssClassDateL3() != null){ %>	
                 <td><html:text property="exstAssClassDateL3" style="width:90px" readonly="true" disabled="true" value="<%=formObj.getExstAssClassDate() %>" onblur="itg_checkform('frmMain','exstAssClassDateL3','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image103"
									             onclick="showCalendar('exstAssClassDateL3', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()" hidden="true"/>
									             </td><%}else{ %>
				 <td><html:text property="exstAssClassDateL3" style="width:90px" readonly="true"  disabled="true" value="<%=formObj.getExstAssClassDate() %>" onblur="itg_checkform('frmMain','exstAssClassDateL3','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image103"
									             onclick="showCalendar('exstAssClassDateL3', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()" hidden="true"/>
									             </td>
									             <%} %>
									             </tr>
									             
									            

									             
		 <tr class="even" id = "37">
	  <td class="fieldname">Revised Asset Classification<font color="#FF0000">*</font></td>
	 <td>
	<html:select property="revisedAssetClassL1" styleId="revisedAssetClassL1" value="<%=formObj.getRevisedAssetClassL1()%>"  onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClassL1"/></td>
		 <td width="20%" class="fieldname">Revised Asset Classification Date<font color="#FF0000">*</font> </td>
		   <%if (!"".equals(formObj.getRevsdAssClassDateL1()) && formObj.getRevsdAssClassDateL1() != null){ %>		
                 <td><html:text property="revsdAssClassDateL1" style="width:90px" readonly="true" value="<%=formObj.getRevsdAssClassDateL1() %>" onblur="itg_checkform('frmMain','revsdAssClassDateL1','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDateL1', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revisedAssetClassL1"/></td><%}else{ %>
				 <td><html:text property="revsdAssClassDateL1" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','revsdAssClassDateL1','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDateL1', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsdAssClassDateL1"/></td>
									             <%} %>
									             </tr>
									             
	<tr class="even" id = "38">
	  <td class="fieldname">Revised Asset Classification<font color="#FF0000">*</font></td>
	 <td>
	<html:select property="revisedAssetClass_L2" styleId="revisedAssetClass_L2" value="<%=formObj.getRevisedAssetClass_L2()%>"  onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClass_L2"/></td>
		 <td width="20%" class="fieldname">Revised Asset Classification Date<font color="#FF0000">*</font> </td>	
		   <%if (!"".equals(formObj.getRevsdAssClassDate_L2()) && formObj.getRevsdAssClassDate_L2() != null){ %>		
                 <td><html:text property="revsdAssClassDate_L2" style="width:90px" readonly="true" value="<%=formObj.getRevsdAssClassDate_L2() %>" onblur="itg_checkform('frmMain','revsdAssClassDate_L2','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDate_L2', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/><html:errors property="revsdAssClassDate_L2"/>
									             </td><%}else{ %>
				     <td><html:text property="revsdAssClassDate_L2" style="width:90px" readonly="true" onblur="itg_checkform('frmMain','revsdAssClassDate_L2','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDate_L2', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/><html:errors property="revsdAssClassDate_L2"/>
									             </td>
									             <%} %>
									             </tr>
									             
	
	<tr class="even" id = "39">
	  <td class="fieldname">Revised Asset Classification<font color="#FF0000">*</font></td>
	 <td>
	<html:select property="revisedAssetClass_L3" styleId="revisedAssetClass_L3" value="<%=formObj.getRevisedAssetClass_L3()%>"  onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClass_L3"/></td>
		 <td width="20%" class="fieldname">Revised Asset Classification Date<font color="#FF0000">*</font> </td>	
		    <%if (!"".equals(formObj.getRevsdAssClassDate_L3()) && formObj.getRevsdAssClassDate_L3() != null){ %>		
                 <td><html:text property="revsdAssClassDate_L3" style="width:90px" readonly="true" value="<%=formObj.getRevsdAssClassDate_L3() %>" onblur="itg_checkform('frmMain','revsdAssClassDate_L3','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDate_L3', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/><html:errors property="revsdAssClassDate_L3"/>
									             </td><%}else{ %>
				 <td><html:text property="revsdAssClassDate_L3" style="width:90px" readonly="true"  onblur="itg_checkform('frmMain','revsdAssClassDate_L3','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsdAssClassDate_L3', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/><html:errors property="revsdAssClassDate_L3"/>
									             </td>
									             <%} %>
									             </tr>
									             
	<tr class="even" id = '31'>

      <td width="20%" class="fieldname">Revised ESCOD stipulated in the event of first level delay in SCOD</td>
      <%if (!"".equals(formObj.getRevsedESCODStpDate()) && formObj.getRevsedESCODStpDate() != null){ %>		
                 <td><html:text property="revsedESCODStpDate" disabled="true" styleId="revsedESCODStpDate" style="width:90px" readonly="false" value="<%=formObj.getRevsedESCODStpDate() %>" onblur="itg_checkform('frmMain','revsedESCODStpDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" hidden="true" name="Image729" border="0" id="Image201"
									             onclick="showCalendar('revsedESCODStpDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image729','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									              <html:errors property="revsedESCODStpDate"/></td><%}else{ %>
					  <td><html:text property="revsedESCODStpDate" disabled="true" styleId="revsedESCODStpDate" style="width:90px" readonly="false"  onblur="itg_checkform('frmMain','revsedESCODStpDate','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" hidden="true" alt="calender" name="Image729" border="0" id="Image201"
									             onclick="showCalendar('revsedESCODStpDate', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image729','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsedESCODStpDate"/></td>
									             <%} %> 
     <td class="fieldname" width="20%">Whether Principal/ Interest Servicing is as per schedule<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="principalInterestSchFlag"/>
    </td>
</tr>

<tr class="even" id = '32'>

     <td width="20%" class="fieldname">Revised ESCOD stipulated in the event of second level delay in SCOD<font color="#FF0000">*</font> </td>	
          <%if (!"".equals(formObj.getRevsedESCODStpDateL2()) && formObj.getRevsedESCODStpDateL2() != null){ %>		
                 <td><html:text property="revsedESCODStpDateL2" styleId="revsedESCODStpDateL2" style="width:90px" readonly="false" value="<%=formObj.getRevsedESCODStpDateL2() %>"  onblur="itg_checkform('frmMain','revsedESCODStpDateL2','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image730" border="0" id="Image730"
									             onclick="showCalendar('revsedESCODStpDateL2', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image729','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsedESCODStpDateL2"/></td><%}else{ %>
				  <td><html:text property="revsedESCODStpDateL2" styleId="revsedESCODStpDateL2" style="width:90px" readonly="false"   onblur="itg_checkform('frmMain','revsedESCODStpDateL2','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image730" border="0" id="Image730"
									             onclick="showCalendar('revsedESCODStpDateL2', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image730','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsedESCODStpDateL2"/></td>
									             <%} %>
      <td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
</tr>

<tr class="even" id = '33'>

     <td width="20%" class="fieldname">Revised ESCOD stipulated in the event of third level delay in SCOD<font color="#FF0000">*</font> </td>	
           <%if (!"".equals(formObj.getRevsedESCODStpDateL3()) && formObj.getRevsedESCODStpDateL3() != null){ %>		
                 <td><html:text property="revsedESCODStpDateL3" styleId="revsedESCODStpDateL3" style="width:90px" readonly="false" value="<%=formObj.getRevsedESCODStpDateL3() %>" onblur="itg_checkform('frmMain','revsedESCODStpDateL3','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsedESCODStpDateL3', 'dd/mm/y')"
									             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsedESCODStpDateL3"/></td><%}else{ %>
					 <td><html:text property="revsedESCODStpDateL3" styleId="revsedESCODStpDateL3" style="width:90px" readonly="false"  onblur="itg_checkform('frmMain','revsedESCODStpDateL3','Date','5');return document.MM_returnValue" size="15" maxlength="10" />
                     <img src="img/calendara.gif" alt="calender" name="Image723" border="0" id="Image725"
									             onclick="showCalendar('revsedESCODStpDateL3', 'dd/mm/y')"
						 			             onmouseover="MM_swapImage('Image723','','img/calendarb.gif',1)"
									             onmouseout="MM_swapImgRestore()"/>
									             <html:errors property="revsedESCODStpDateL3"/></td>				             
									             <%} %>
      <td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
</tr>



<%}} }%>

		<tr class="even">
                  <td class="fieldname">Tenor&nbsp;</td>
                 <td>
                 	 <html:select property="tenorUnit" value="<%=formObj.getTenorUnit()%>">
                                    <integro:common-code categoryCode="<%=CategoryCodeConstant.FACILITY_TENOR%>" descWithCode="false"/>
                     </html:select>&nbsp;
                     
                     <html:text property="tenor" maxlength="3"/>&nbsp;
                	 <html:errors property="tenor"/>&nbsp;&nbsp;
                 </td>
                 
                  <td class="fieldname">Margin %&nbsp;</td>
                  <td><html:text property="margin" maxlength="5"/>&nbsp;
                  <html:errors property="margin"/>
                  </td>
		</tr>    

<tr class="odd">
                  <td class="fieldname">Tenor Description&nbsp;</td>
                 <td><html:text property="tenorDesc"/>
                  <html:errors property="tenorDesc"/>
                 </td>
                 <%-- <% if(availAndOptionApplicable != null && availAndOptionApplicable.equals("on")) {%> --%>
                  <td class="fieldname" id="putCallOptionHeading">Put / Call Option&nbsp;</td>
                  <td id="putCallOptionField">
                  	<html:radio property="putCallOption" styleId="putCallOption" value="PUT"/>&nbsp;Put&nbsp;
        			<html:radio property="putCallOption" styleId="putCallOption" value="CALL" />&nbsp;Call&nbsp;
                  </td>
                  <%-- <%} %> --%>
</tr>   

<%-- <% if(availAndOptionApplicable != null && availAndOptionApplicable.equals("on")){ %> --%>
<tr class="even" id="loanOptionAvailabilityId">
                  <td class="fieldname">Loan Availability Date&nbsp;</td>
                 <td>
					<html:text property="loanAvailabilityDate" readonly="true" />
	 				<img src="img/calendara.gif"  name="Image724" border="0" id="Image724" onclick="return showCalendar('loanAvailabilityDate', 'dd/mm/y');" onmouseover="MM_swapImage('Image724','','img/calendarb.gif',1)" onmouseout="MM_swapImgRestore()" />
	 				<html:errors property="loanAvailabilityDate"/>
	 			</td>	
                  <td class="fieldname">Option Date&nbsp;</td>
                  <td>
                	<html:text property="optionDate" readonly="true" />
	 				<img src="img/calendara.gif"  name="Image724" border="0" id="Image724" onclick="return showCalendar('optionDate', 'dd/mm/y');" onmouseover="MM_swapImage('Image724','','img/calendarb.gif',1)" onmouseout="MM_swapImgRestore()" />
                  	&nbsp;
                  	<html:errors property="optionDate"/>
                  </td>
</tr>  
          <%-- <%} %> --%>

						
</tbody>
</table>
</td>
</tr>
</tbody>
</table>

 <%
if("Y".equals(formObj.getFacCoBorrowerInd()) ){ %>

	<jsp:include page="edit_fac_co_borrower_details.jsp"/>
	<html:hidden name="LmtDetailForm" property="facCoBorrowerInd"/>
<%}else if(!"Y".equals(formObj.getFacCoBorrowerInd()) && ("prepare_create".equals(event) || "create".equals(event) || "update_return".equals(event ) ) ){ %>
    <jsp:include page="edit_fac_co_borrower_details.jsp"/>
	<html:hidden name="LmtDetailForm" property="facCoBorrowerInd"/>
<%} %>

<logic:notEmpty name="LmtDetailForm" property="showSublist" scope="request">
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
 <thead>
        <tr>
            <td><h3>CAM Covenant:</h3></td>
        </tr>
    </thead>
    <tbody>
    <tr>
            <td>
                <input class="btnNormal" type="button" name="btnedit_viewCovenant" id="btnedit_viewCovenant" value="Edit/View" disabled = "disabled" onclick="javascript : viewConvenantScreen('create_covenant_detail_ubs')">				
            </td>
        </tr>
    </tbody>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
    <thead>
        <tr>
            <td colspan="2"><h3>Line Details</h3></td>
        </tr>
        <tr>
        <td align="left">
        	<html:errors property="lineDetailsError" />
        </td>
       	         <td align="right" valign="baseline" id="button">
         <%if(isUserCpcMaker){%>
             <% if(formObj.getIsReleased()==null || formObj.getIsReleased().equals("")){%>
				 <input class="btnNormal" type="button" name="btnAddXRef" id="btnAddXRef" value="Add Line Details" disabled="disabled" onclick="javascript:createXRef('<%=fcunsSystem%>','<%=ubslimitSystem%>')"/>&nbsp;				
			<% }else if(formObj.getIsReleased().equals("Y")){%>
				<input class="btnNormal" type="button" id="btnAddXRef" name="btnAddXRef" value="Add Line Details" disabled="disabled" onclick="javascript:createXRef('<%=fcunsSystem%>','<%=ubslimitSystem%>')"/>&nbsp;
			<%} else if(formObj.getIsReleased().equals("N")){%>
				<input class="btnNormal" type="button" id="btnAddXRef" name="btnAddXRef" value="Add Line Details" disabled="disabled" onclick="javascript:createXRef('<%=fcunsSystem%>','<%=ubslimitSystem%>')"/>&nbsp;
			<%} %>
            <!-- <input class="btnNormal" type="button" name="btnDelXRef" value="Remove" onclick="javascript:deleteXRef()"/> -->
         <%}else{ %>
         	 <% if(formObj.getIsReleased()==null || formObj.getIsReleased().equals("")){%>
				 <input class="btnNormal" type="button" name="btnAddXRef" id="btnAddXRef" value="Add Line Details" disabled="disabled" onclick="javascript:createXRef('<%=fcunsSystem%>','<%=ubslimitSystem%>')"/>&nbsp;				
			<% }else if(formObj.getIsReleased().equals("Y")){
					List lstLine=formObj.getAcntRefSummaryList();
					int lineCount = lstLine.size();
					System.out.println("<<<<<<<<<<<<<Count of Line>>>>>>>>>>>>>"+lineCount);
					if(lineCount > 98){
			%>
				<input class="btnNormal" type="button" id="btnAddXRef" name="btnAddXRef" value="Add Line Details" onclick="javascript:lineCount()"/>&nbsp;
				<%}else{%>
					<input class="btnNormal" type="button" id="btnAddXRef" name="btnAddXRef" value="Add Line Details" onclick="javascript:createXRef('<%=fcunsSystem%>','<%=ubslimitSystem%>')"/>&nbsp;
				<%}
				} else if(formObj.getIsReleased().equals("N")){%>
				<input class="btnNormal" type="button" id="btnAddXRef" name="btnAddXRef" value="Add Line Details" disabled="disabled" onclick="javascript:createXRef('<%=fcunsSystem%>','<%=ubslimitSystem%>')"/>&nbsp;
			<%} %>
            <!-- <input class="btnNormal" type="button" name="btnDelXRef" value="Remove" onclick="javascript:deleteXRef()"/> -->
         <%} %>   
            
        </td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td colspan="2">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tblInput">
                    <thead>
                        <tr>
                            <td width="2%">Serial No.</td>
                            <td width="18%">Interest Rate</td>
                            <td width="15%">Released Amount</td>
                            <td width="15%">Released Date</td>
                            <td width="16%">Utilized Amount</td>
							<td width="16%">Undrawn Limit</td>	
							<td width="8%">Status </td>	
                            <td width="9%">Action</td> 
                           <!-- <td width="9%">Delete</td> -->
                        </tr>
                    </thead>
                    <tbody>
                    <%BigDecimal totalReleasedAmount = new BigDecimal("0"); %>
                        <logic:present name="LmtDetailForm" property="acntRefSummaryList" scope="request">
                            <bean:define id="acntrefSize" value="<%= String.valueOf(formObj.getAcntRefSummaryList().size()) %>"/>
                            <logic:notEqual name="acntrefSize" value="0">
                            
                                <logic:iterate id="acntrefitm" indexId="acntrefind" name="LmtDetailForm" property="acntRefSummaryList" scope="request"
                                               type="com.integrosys.cms.app.limit.bus.ILimitSysXRef">
                                    <%
                                    String headerClass = "index";
                                    ICustomerSysXRef acntRef = acntrefitm.getCustomerSysXRef();
                                    if (acntrefitm instanceof CompareResult) {
                                        acntRef = ((ILimitSysXRef) ((CompareResult) acntrefitm).getObj()).getCustomerSysXRef();
                                        headerClass = ((CompareResult) acntrefitm).getKey();
                                    } else {
                                        acntRef = ((ILimitSysXRef) acntrefitm).getCustomerSysXRef();
                                    } 
                                    
                                    BigDecimal undrawnAmount = new BigDecimal("0");
                                    System.out.println("total Released amt "+totalReleasedAmount);
                                    System.out.println("From the ilimit "+totalReleasedAmount );
                                    if(acntRef.getReleasedAmount()==null){
                                    	acntRef.setReleasedAmount(totalReleasedAmount.toString());
                                    }
                                	undrawnAmount = new BigDecimal((acntRef.getReleasedAmount().replaceAll(",", ""))).subtract(new BigDecimal(((acntRef.getUtilizedAmount().replaceAll(",", "")).trim())));
                                    totalReleasedAmount = totalReleasedAmount.add(new BigDecimal((acntRef.getReleasedAmount().replaceAll(",", ""))));
                                    System.out.println("acntRef.getSerialNo():"+acntRef.getSerialNo()+":"+ acntRef.getAction()+":"+acntRef.getCloseFlag()+":"+acntRef.getStatus()+" System:"+ acntRef.getFacilitySystem()+" acntRef.getLiabBranch():"+acntRef.getLiabBranch());
                                    System.out.println("acntRef.getFacilitySystem():"+acntRef.getFacilitySystem());
                                    String serialNo="";
                                    
                                    if(null!=acntRef.getSerialNo()){
                                     serialNo=acntRef.getSerialNo();
                                    }else{
                                    	serialNo = acntRef.getHiddenSerialNo();
                                    	acntRef.setSerialNo(acntRef.getHiddenSerialNo());
                                    }
                                    
                                    String facilitySystemId=acntRef.getFacilitySystemID();
                                    String index=facilitySystemId+serialNo;
                                    %>
                                	<%if(!"HIDE".equalsIgnoreCase(acntRef.getStatus())){%>
                                    <tr class="<%=(acntrefind.intValue() + 1)%2==0?"even":"odd"%>">
                                        <td class="index">
                                        <%if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()) && ((!"N".equals(acntRef.getSendToFile()) && ICMSConstant.FCUBS_STATUS_PENDING_SUCCESS.equals(acntRef.getStatus()))
                                        		|| (singaporeSystem.equals(acntRef.getFacilitySystem())))){ %>
                                        &nbsp;<integro:empty-if-null value="<%=acntRef.getSerialNo()%>"/>
                                        <%}else if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()) && !"N".equals(acntRef.getSendToFile()) && !"BAHRAIN".equalsIgnoreCase(acntRef.getFacilitySystem())){ %>
                                        &nbsp;-
                                        <%}else if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()) && "BAHRAIN".equalsIgnoreCase(acntRef.getFacilitySystem())){ %>
                                          &nbsp;<integro:empty-if-null value="<%=acntRef.getSerialNo()%>"/>
                                        <%}else{ %>
                                          &nbsp;<integro:empty-if-null value="<%=acntRef.getSerialNo()%>"/>
                                            <%} %>
                                        </td>
                                         <% 
                                         if(acntRef.getInterestRateType() != null) {
	                                        if(acntRef.getInterestRateType().equals("fixed")) {%>
	                                        <td>
	                                            &nbsp;<integro:empty-if-null value="<%= acntRef.getIntRateFix() %>"/>
	                                        </td>
	                                        <%}else { %>
	                                        <td>
	                                        <% if(acntRef.getIntRateFloatingMarginFlag() != null && acntRef.getIntRateFloatingMarginFlag().equals("-")){%>
	                                            &nbsp;<integro:empty-if-null value="<%= String.valueOf(Double.parseDouble(acntRef.getIntRateFloatingRange()) - Double.parseDouble(acntRef.getIntRateFloatingMargin())) %>"/>
	                                            <%}else { %>
	                                            &nbsp;<integro:empty-if-null value="<%= String.valueOf(Double.parseDouble(acntRef.getIntRateFloatingMargin()) + Double.parseDouble(acntRef.getIntRateFloatingRange()))%>"/>
	                                            <%} %>
	                                        </td>
	                                        <%}
	                                        }%>
	                                        <%if(acntRef.getInterestRateType() == null) {  %>
	                                        <td>
	                                            &nbsp;
	                                        </td>
	                                        <%}%>
                                        <td>
                                            &nbsp;<integro:empty-if-null value="<%=UIUtil.formatWithCommaAndDecimal(acntRef.getReleasedAmount())%>"/>
                                        </td>
                                        <td>
                                            &nbsp;<integro:empty-if-null value="<%=acntRef.getReleaseDate()%>"/>
                                        </td>
                                        <td>
                                            &nbsp;<integro:empty-if-null value="<%=UIUtil.formatWithCommaAndDecimal(acntRef.getUtilizedAmount())%>"/>
                                        </td>
                                        <td>
                                            &nbsp;<integro:empty-if-null value="<%=UIUtil.formatWithCommaAndDecimal(undrawnAmount.toString())%>"/>
                                        </td>
										<td>&nbsp;<integro:empty-if-null value="<%=acntRef.getStatus()%>"/></td>
                                       <td style="text-align:center"> 
                                               <!--if(isUserCpcMaker){ %>
                                       		<select name="select2"
												onchange="javascript:updateXRef(this.value,'<%= index %>','<%=String.valueOf(acntRef.getXRefID())%>','<%=fcunsSystem%>','<%=ubslimitSystem%>')">
												<option value="">Please Select</option>
												<option value="view">View</option>
											</select>
                                      }else{ -->
                                      <%if(null!=acntRef.getFacilitySystem() && (acntRef.getFacilitySystem().equals(fcunsSystem) || acntRef.getFacilitySystem().equals(ubslimitSystem) || acntRef.getFacilitySystem().equals("ET")
                                    		  || singaporeSystem.equals(acntRef.getFacilitySystem()))){
                                        if("".equals(serialNo)){%>
                                        <select name="select2"
												onchange="javascript:updateXRef(this.value,'<%= index %>','<%=String.valueOf(acntRef.getXRefID())%>','<%=fcunsSystem%>','<%=ubslimitSystem%>')">
												<option value="">Please Select</option>
												<option value="view">View</option>
												<%if(!isUserCpcMaker){%>
												<%if(ICMSConstant.FCUBS_STATUS_PENDING.equals(acntRef.getStatus()) || ICMSConstant.FCUBS_STATUS_PENDING_SUCCESS.equals(acntRef.getStatus()) || ICMSConstant.FCUBS_STATUS_PENDING_REJECTED.equals(acntRef.getStatus()) ){ %>
												<option value="updateStatus">Update Status</option>
												<%} %>
												
												<%if(ICMSConstant.FCUBS_STATUS_REJECTED.equals(acntRef.getStatus())){
												if(ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(acntRef.getAction()) || ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction())){ %>
												<option value="edit">Edit</option>
												<%} %>
												<%if(ICMSConstant.FCUBSLIMIT_ACTION_REOPEN.equals(acntRef.getAction()) && !acntRef.getFacilitySystem().equals("ET")){ %>
													<option value="reopen">Reopen</option>
												<%} %>
												<%if(ICMSConstant.FCUBSLIMIT_ACTION_CLOSE.equals(acntRef.getAction()) && !acntRef.getFacilitySystem().equals("ET")){ %>
													<option value="close">Close</option>
												<%} }else if(ICMSConstant.FCUBS_STATUS_SUCCESS.equals(acntRef.getStatus())){
													if(!"Y".equals(acntRef.getCloseFlag())){ %>
													<option value="edit">Edit</option>
													<%} %>
													<%if("Y".equals(acntRef.getCloseFlag()) && !acntRef.getFacilitySystem().equals("ET")){ %>
														<option value="reopen">Reopen</option>
													<%} %>
													<%if(!"Y".equals(acntRef.getCloseFlag()) && !acntRef.getFacilitySystem().equals("ET")){ %>
														<option value="close">Close</option>
													<%}} 	 else if("PENDING_UPDATE".equals(acntRef.getStatus())){
														if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction())){ %>
														<option value="edit">Edit</option>
														<%} if(ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(acntRef.getAction())){ %>
														<option value="edit">Edit</option>
														<%}if(ICMSConstant.FCUBSLIMIT_ACTION_REOPEN.equals(acntRef.getAction()) && !acntRef.getFacilitySystem().equals("ET")){ %>
															<option value="reopen">Reopen</option>
														<%}if(ICMSConstant.FCUBSLIMIT_ACTION_CLOSE.equals(acntRef.getAction()) && !acntRef.getFacilitySystem().equals("ET")){ %>
															<option value="close">Close</option>
														<%}}else if(null == acntRef.getStatus()){ %>
												<option value="edit">Edit</option>
												<%if(!acntRef.getFacilitySystem().equals("ET")){ %>
												<option value="close">Close</option>
												<%}}}%>
											</select>
											
											<%}else {
											System.out.println("acntRef.getStatus() ==========="+acntRef.getStatus());
											System.out.println("acntRef.getAction() ==========="+acntRef.getAction());
											System.out.println("ICMSConstant.FCUBS_STATUS_REJECTED.equals(acntRef.getStatus()) ======"+ICMSConstant.FCUBS_STATUS_REJECTED.equals(acntRef.getStatus()));
											System.out.println("ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(acntRef.getAction()) ====="+ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(acntRef.getAction()));
											System.out.println("ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()) ======"+ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()));%>
											<select name="select2"
												onchange="javascript:updateXRef(this.value,'<%= index %>','<%=String.valueOf(acntRef.getXRefID())%>','<%=fcunsSystem%>','<%=ubslimitSystem%>')">
												<option value="">Please Select</option>
												<option value="view">View</option>
												<%if(!isUserCpcMaker){%>
												<%if((ICMSConstant.FCUBS_STATUS_PENDING.equals(acntRef.getStatus()) 
														|| ICMSConstant.FCUBS_STATUS_PENDING_SUCCESS.equals(acntRef.getStatus()) 
														|| ICMSConstant.FCUBS_STATUS_PENDING_REJECTED.equals(acntRef.getStatus())) && !singaporeSystem.equals(acntRef.getFacilitySystem()) ){%>
													<option value="updateStatus">Update Status</option>
												<%} %>
												
												<%if(ICMSConstant.FCUBS_STATUS_REJECTED.equals(acntRef.getStatus())){
													System.out.println("Inside rejected status===========");
													
													if(ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(acntRef.getAction()) 
															|| ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction())){ 
														System.out.println("Inside modify action===========");%>
														<option value="edit">Edit</option>
													<%}
													
													if((null == acntRef.getAction() || "null".equals(acntRef.getAction())) 
															/* && acntRef.getFacilitySystem().equals("ET") */
														){ 
														System.out.println("Inside modify where action is null===========");
														acntRef.setAction("MODIFY");%>
														<option value="edit">Edit</option>
													<%}
													
													if(ICMSConstant.FCUBSLIMIT_ACTION_REOPEN.equals(acntRef.getAction()) ){ %>
														<option value="reopen">Reopen</option>
													<%}
													
													if(ICMSConstant.FCUBSLIMIT_ACTION_CLOSE.equals(acntRef.getAction()) && !acntRef.getFacilitySystem().equals("ET")){ %>
														<option value="close">Close</option>
													<%}
													
													if(ICMSConstant.FCUBS_STATUS_REJECTED.equals(acntRef.getStatus()) 
															&& ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction())
															&& !acntRef.getFacilitySystem().equals("ET")
															&& acntRef.getSendToCore().equals("N")
															&& Integer.parseInt(acntRef.getSerialNo())>99){%>
															<option value="close">Close</option>
												   <%}
												}
												
												else if(ICMSConstant.FCUBS_STATUS_SUCCESS.equals(acntRef.getStatus())){
													if(!"Y".equals(acntRef.getCloseFlag())){ %>
														<option value="edit">Edit</option>
													<%}if("Y".equals(acntRef.getCloseFlag()) && Integer.parseInt(acntRef.getSerialNo())<=99){ %>
														<option value="reopen">Reopen</option>
													<%}if(!"Y".equals(acntRef.getCloseFlag()) && !acntRef.getFacilitySystem().equals("ET") && !singaporeSystem.equals(acntRef.getFacilitySystem())){ %>
														<option value="close">Close</option>
													<%}
												}	 
												
												else if("PENDING_UPDATE".equals(acntRef.getStatus())){
													if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction())){ %>
														<option value="edit">Edit</option>
													<%} if(ICMSConstant.FCUBSLIMIT_ACTION_MODIFY.equals(acntRef.getAction())){ %>
														<option value="edit">Edit</option>
													<%}if(ICMSConstant.FCUBSLIMIT_ACTION_REOPEN.equals(acntRef.getAction())){ %>
														<option value="reopen">Reopen</option>
													<%}if(ICMSConstant.FCUBSLIMIT_ACTION_CLOSE.equals(acntRef.getAction()) && !acntRef.getFacilitySystem().equals("ET")){ %>
														<option value="close">Close</option>
													<%}
												}
												
												else if(null == acntRef.getStatus()){ %>
													<option value="edit">Edit</option>
													<%if(!acntRef.getFacilitySystem().equals("ET")) {%>
														<option value="close">Close</option>
													<%}
												}}%>
											</select>
											<%}
                                        
                                      		}else{ %>
											<select name="select2"
												onchange="javascript:updateXRef(this.value,'<%= index %>','<%=String.valueOf(acntRef.getXRefID())%>','<%=fcunsSystem%>','<%=ubslimitSystem%>')">
												<option value="">Please Select</option>
												<option value="view">View</option>
												<%if(!isUserCpcMaker){%>
												<option value="edit">Edit</option>
												<%} %>
											</select>
										<%} %>
                                       </td> 
                                    </tr>
                                  <%} %>
                                </logic:iterate>
                                <script language="javascript">
                                //	document.forms[0].totalReleasedAmount.value ='<%= totalReleasedAmount %>';
                                
                                //Phase 3 CR:comma separated
                                document.forms[0].totalReleasedAmount.value ='<%= UIUtil.formatWithCommaAndDecimal(totalReleasedAmount.toString()) %>';
								</script>
                            </logic:notEqual>
                            <logic:equal name="acntrefSize" value="0">
                                <tr class="odd">
                                    <td colspan="9">There is no line for facility.</td>
                                </tr>
                            </logic:equal>
                        </logic:present>
                        <logic:notPresent name="LmtDetailForm" property="acntRefSummaryList" scope="request">
                            <tr class="odd">
                                <td colspan="9">There is no line for facility.</td>
                            </tr>
                        </logic:notPresent>
                    </tbody>
                </table>
                <script language="javascript">
                <% System.out.println("formObj.getSyndicateLoan() :--------"+formObj.getSyndicateLoan()); %>
                 <% if(formObj.getLimitType() == null || formObj.getLimitType().equals("")
                		 || formObj.getLimitType().equals("No")){%>		
					document.forms[0].limitType[1].checked =true;
					document.forms[0].guarantee[1].checked =true;
					document.forms[0].guarantee[0].disabled =true;
					document.forms[0].guarantee[1].disabled =true;
				<%} 
                 System.out.println("formObj.getIsAdhoc() :");                 
                 if(formObj.getIsAdhoc()!= null){
                	 System.out.println("formObj.getIsAdhoc() :--------"+formObj.getIsAdhoc()); 
                 %>		
                 
                 	document.getElementById('adhoc').style.display = ''
				<%}
				if(formObj.getLimitType() != null && formObj.getLimitType().equals("Yes")){
					if(formObj.getGuarantee() != null && formObj.getGuarantee().equals("Yes")) {
				%>		
				document.getElementById('guaranteeYes').style.display = ''
		        document.getElementById('guaranteeNo').style.display = 'none'
			<%}	if(formObj.getGuarantee() != null && formObj.getGuarantee().equals("No")) { %>
				document.getElementById('guaranteeYes').style.display = 'none'
		        document.getElementById('guaranteeNo').style.display = ''
			<%	} 
			} if(formObj.getSyndicateLoan() == null || formObj.getSyndicateLoan().equals("No") || formObj.getSyndicateLoan().equals("")) { %>
			 <% System.out.println("formObj.getSyndicateLoan()111 :--------"+formObj.getSyndicateLoan()); %>
					document.forms[0].syndicateLoan[1].checked = true;
					 <%}
				 if(null != formObj.getSyndicateLoan() && formObj.getSyndicateLoan().equals("Yes")) { %>
					document.forms[0].syndicateLoan[0].checked = true;
					<%} %>
					
					  <%
					    if(null == formObj.getAdhocFacility()  || "N".equals(formObj.getAdhocFacility()) || "".equals(formObj.getAdhocFacility())) {  %>
								document.forms[0].adhocFacility[1].checked = true;
						 <%}
						 if(null != formObj.getAdhocFacility() && "Y".equals(formObj.getAdhocFacility())) { 
					
						 %>
						 
						    document.forms[0].adhocLastAvailDate.disabled =false;
					       	document.forms[0].adhocTenor.disabled =false;
					   		document.forms[0].multiDrawdownAllow[0].disabled =false;
					       	document.forms[0].multiDrawdownAllow[1].disabled =false;
					       	document.forms[0].adhocFacilityExpDate.disabled =false;
					    	document.forms[0].ImageadhocFacilityExpDate.disabled =false;
					    	document.forms[0].ImageadhocLastAvailDate.disabled =false;

						      	
						    	document.forms[0].partyC[1].checked = false;
						        document.forms[0].adhocLmtAmount.value = '';
						        document.forms[0].adhocLmtAmount.disabled ="disabled";
						    	document.forms[0].partyC[1].disabled = "disabled";
						    	
						 <%} 
					
						
						 if(null == formObj.getGeneralPurposeLoan()   || "N".equals(formObj.getGeneralPurposeLoan()) || "".equals(formObj.getGeneralPurposeLoan())) {  %>
							document.forms[0].generalPurposeLoan[1].checked = true;
					     <%}  if(null != formObj.getGeneralPurposeLoan() && "Y".equals(formObj.getGeneralPurposeLoan())) { %>
							document.forms[0].generalPurposeLoan[0].checked = true;
					     <%}  
					     
					     if("N".equals(formObj.getMultiDrawdownAllow())) {%>
							document.forms[0].multiDrawdownAllow[1].checked = true;
					     <%}  if(null != formObj.getMultiDrawdownAllow() && "Y".equals(formObj.getMultiDrawdownAllow())) {%>
							document.forms[0].multiDrawdownAllow[0].checked = true;
					     <%} 
						  %>
	 				
					 
				</script>
            </td>
        </tr>
    </tbody>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
    <thead>
        <tr>
            <td colspan="2"><h3>Limit Security Mapping</h3></td>
        </tr>
        <tr>
        <td align="left">
        	<html:errors property="securityMappingDetailsError" />
        	<html:errors property="securityLinkError" />
        </td>
            <td align="right" valign="baseline">
              <% if(formObj.getIsSecured()==null || formObj.getIsSecured().equals("")){%>
						<input class="btnNormal" type="button" id="btnAddLmtSec" name="btnAddLmtSec" value="Add New Security" disabled="disabled" onclick="javascript:createLmtSec()"/>&nbsp;		
				 			
								<% }else if(formObj.getIsSecured().equals("Y")){%>
                                   <input class="btnNormal" type="button" id="btnAddLmtSec" name="btnAddLmtSec" value="Add New Security" onclick="javascript:createLmtSec()"/>&nbsp;							
								<%} else if(formObj.getIsSecured().equals("N")){%>
								<input class="btnNormal" type="button" id="btnAddLmtSec" name="btnAddLmtSec" value="Add New Security" disabled="disabled" onclick="javascript:createLmtSec()"/>&nbsp;
							
								<%} %>
                <!--<input class="btnNormal" type="button" name="btnDelLmtSec" value="Remove" onclick="javascript:deleteLmtSec()"/>
            --></td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td colspan="2">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tblInput">
                    <thead>
                        <tr>
                            <td width="2%">S/N</td>
                            <td width="22%">Source Security ID</td>
                            <td width="16%">Collateral Code-Name</td>
                            <td width="16%">Security Type</td>
                            <td width="16%">Security Sub-Type</td>
                            <td width="16%">Security Coverage %</td>
                            <td width="10%">Action</td>
                        </tr>
                    </thead>
                    <tbody>
                        <logic:present name="LmtDetailForm" property="lmtSecSummaryList" scope="request">
                            <bean:define id="lmtsecSize" value="<%= String.valueOf(formObj.getLmtSecSummaryList().size()) %>"/>
                            <logic:notEqual name="lmtsecSize" value="0">
                                <logic:iterate id="lmtsecitm" indexId="lmtsecind" name="LmtDetailForm" property="lmtSecSummaryList" scope="request"
                                               type="com.integrosys.cms.ui.manualinput.limit.LmtSecSummaryItem">
                                    <tr class="<bean:write name="lmtsecitm" property="rowClass" />">
                                        <td class="<bean:write name="lmtsecitm" property="headerClass" />">
                                            <%= lmtsecind.intValue() + 1 %>											
                                        </td>
                                        <td>
                                            &nbsp;<bean:write name="lmtsecitm" property="sciSecurityId"/>
                                        </td>
                                        <td>
                                            &nbsp;
                                            <% if(collateralMap!=null){if(lmtsecitm.getCollateralId()!=null){%>
                                           <integro:empty-if-null value="<%=collateralMap.get(lmtsecitm.getCollateralId()) %>"/>
                                            <%}} %>
                                        </td>
                                        <td>
                                            &nbsp;<bean:write name="lmtsecitm" property="securityType"/>
                                        </td>
                                        <td>
                                            &nbsp;<bean:write name="lmtsecitm" property="securitySubType"/>
                                            <%
                                            String str = lmtsecitm.getSecurityType() + "," +lmtsecitm.getSecuritySubType()+ "," +lmtsecitm.getSciSecurityId();
                                            %>
                                            
                                            <html:hidden property="securityTypeSubType" value="<%=str %>"/>
                                        </td>
                                        <td>
                                        	<%
                                        	if(lmtsecitm.getLmtSecurityCoverage() == null || lmtsecitm.getLmtSecurityCoverage().equals("")){
                                        		lmtsecitm.setLmtSecurityCoverage("0");
                                        	}
                                            %>
                                            &nbsp;<html:text  property="securityCoverage" value="<%=lmtsecitm.getLmtSecurityCoverage() %>"/>
                                        </td>
                                        <td>
                                            <select name="secOption" onchange="javascript:deleteLmtSec('<%= lmtsecind.toString() %>', this.value,'<%= lmtsecitm.getSciSecurityId() %>' ,'<%= lmtsecitm.getSecuritySubType() %>' ,this)" id="secOption[<%= lmtsecind.toString()%>]" >
                                            <option value="">Please Select</option>
                                            <option value="Delete">Delete</option>
                                            <option value="View">View</option>
                                            </select>
                                            &nbsp;
                                       
                                        </td>
                                    </tr>
                                </logic:iterate>
                            </logic:notEqual>
                            <tr><td colspan="7"><html:errors property="securityCoverage"/></td></tr>
                            <logic:equal name="lmtsecSize" value="0">
                                <tr class="odd">
                                    <td colspan="7">There is no limit security mapping.</td>
                                </tr>
                            </logic:equal>
                        </logic:present>
                        <logic:notPresent name="LmtDetailForm" property="lmtSecSummaryList" scope="request">
                            <tr class="odd">
                                <td colspan="7">There is no limit security mapping.</td>
                            </tr>
                        </logic:notPresent>
                    </tbody>
                </table>
				<html:errors property="secNotReq"/>
				  <html:hidden property="deletedLmtSec" value=""/>    
             <html:hidden property="securityIdDel" value=""/>
             <html:hidden property="isFromCamonlineReq" />
             
            </td>
        </tr>
    </tbody>
</table>
<%if(!"Y".equals(isCreate)){ %>
<!--Start: Uma:Phase 3 CR :Limit Calculation Dashboard -->
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
<thead>
<tr>
<td colspan="2"><h3>Limit Calculation:</h3>&nbsp;</td>
 </tr>
 <tr>
  <td > 
            <input class="btnNormal" type="button" name="limitCalculation" value="Limit Calculation" onclick="javascript:limitCalculationDashboard()" id="limitCalculation"/>&nbsp;
</td>
 </tr>
</thead>
</table>
<!--End: Uma:Phase 3 CR :Limit Calculation Dashboard -->
<%} %>
</logic:notEmpty>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
    <tr><td>&nbsp;</td></tr>
    <logic:equal name="itrxValue" property="status" value="<%= ICMSConstant.STATE_REJECTED %>">
        <tr>
            <td colspan="2">
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblInfo">
                    <tbody>
                        <tr>
                            <td class="fieldname">Remarks</td>
                            <td class="odd">
                                <html:textarea property="remarks" rows="3" cols="120"/>&nbsp;
                                <html:errors property="remarks"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="fieldname">Last Action By</td>
                            <td class="even"><%=itrxValue.getUserInfo()%>&nbsp;</td>
                        </tr>
                        <tr class="odd">
                            <td class="fieldname">Last Remarks Made</td>
                            <td><integro:wrapper value="<%=itrxValue.getRemarks()%>"/>&nbsp;</td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
    </logic:equal>
     <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr> 
      <tr>
       <td> <jsp:include page="view_audit_details.jsp"></jsp:include></td>
      </tr> 
</table>
<table width="150" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
        <td><a href="javascript:submitLimit(<%=isLmtSecChange%>,<%=adhocVal%>);"><img src="img/submit1.gif" name="Image41" border="0" id="Image3"/></a></td>
        <td><a href="javascript:saveLimit()"><img src="img/save1.gif" name="Image41" border="0" id="Image4"/></a></td>
        <td><a href="javascript:cancelSubmit()"><img src="img/cancel1.gif" name="Image51" width="70" height="20" border="0" id="Image5"/></a></td>
    </tr>
    <tr>
        <td colspan="3">&nbsp;</td>
    </tr>
</table>
<% System.out.println("formObj.getGrade()..................."+formObj.getGrade());%>
<input type="hidden" id="grade" name="grade" value="<%=formObj.getGrade()%>"/>
<input type="hidden" id="availAndOptionApplicable" name="availAndOptionApplicable"/>
<html:hidden property="riskType" styleId="riskType" />
<jsp:include page="scod_detail_hidden.jsp"></jsp:include>
</html:form>
</body>
</html>