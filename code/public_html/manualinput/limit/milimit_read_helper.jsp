<%@ page import="java.util.*,
				 java.util.Collection,
				    com.integrosys.base.techinfra.util.DateUtil,
		 com.integrosys.cms.ui.manualinput.limit.EventConstant,
                 com.integrosys.cms.ui.manualinput.limit.MILimitUIHelper,
                 com.integrosys.base.techinfra.diff.CompareResult,
                 com.integrosys.cms.app.limit.bus.ILimit,
                 com.integrosys.cms.app.customer.bus.ICustomerSysXRef,
		 com.integrosys.base.businfra.currency.CurrencyManager,
                 com.integrosys.cms.app.limit.trx.ILimitTrxValue,
                 com.integrosys.cms.app.limit.trx.OBLimitTrxValue,
                 com.integrosys.cms.ui.manualinput.limit.LmtDetailForm,
                 java.math.BigDecimal,
                 com.integrosys.cms.app.limit.bus.ILimitSysXRef" %>
<%@ page import="com.integrosys.component.bizstructure.app.bus.ITeam"%>
<%@ page import="com.integrosys.cms.app.common.constant.ICMSConstant"%>
<%@ page import="com.integrosys.base.uiinfra.common.ICommonEventConstant"%>
<%@ page import="com.integrosys.cms.ui.common.constant.IGlobalConstant"%>
<%@page import="com.integrosys.cms.ui.collateral.CategoryCodeConstant"%>
<%@ page import="com.integrosys.base.techinfra.diff.CompareOBUtil"%>
<%@ taglib uri="/WEB-INF/IntegroTag.tld" prefix="integro" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%
    ITeam userTeam = (ITeam) session.getAttribute(ICommonEventConstant.GLOBAL_SCOPE + "." + IGlobalConstant.USER_TEAM);
	HashMap collateralMap=(HashMap) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.collateralMap");
	ILimitTrxValue lmtTrxObj=(ILimitTrxValue) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.lmtTrxObj");
	ILimit actualLimit = lmtTrxObj.getLimit();	
	ILimit stageLimit = lmtTrxObj.getStagingLimit();
	
      
    
    Locale locale = (Locale) session.getAttribute(ICommonEventConstant.GLOBAL_SCOPE + "." + com.integrosys.base.uiinfra.common.Constants.GLOBAL_LOCALE_KEY);	
    long oneTeamMshipID = userTeam.getTeamMemberships()[0].getTeamTypeMembership().getMembershipID();
    long teamTypeID = userTeam.getTeamType().getTeamTypeID();
    boolean isMr = false;
    
    if (oneTeamMshipID == ICMSConstant.TEAM_TYPE_MR_MAKER ||
            oneTeamMshipID == ICMSConstant.TEAM_TYPE_MR_CHECKER) {
        isMr = true;
    }

    MILimitUIHelper helper = new MILimitUIHelper();
    
    String relationShipMgrName = (String) request.getAttribute("relationShipMgrName");
    Collection subPartyNameList = (Collection) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.subPartyNameList");
	request.setAttribute("subPartyNameList", subPartyNameList);
	LmtDetailForm lmtDetailForm = (LmtDetailForm) request.getAttribute("LmtDetailForm");
	
	  List riskTypeList = (List)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.riskTypeList");
	  pageContext.setAttribute("riskTypeList" ,riskTypeList);	  
	  System.out.println("riskTypeList => "+riskTypeList);

	 String fcunsSystem=PropertyManager.getValue("fcubs.systemName");
	 String ubslimitSystem=PropertyManager.getValue("ubs.systemName");
	 String scodLineNoList=PropertyManager.getValue("scod.linenocode.name");
	 String totalReleasedAmount = (String)request.getAttribute("totalReleasedAmount");
	 String event = request.getParameter("event");
	 boolean isFacilityCamCovenantReq = EventConstant.EVENT_PROCESS.equals(event) || EventConstant.EVENT_APPROVE.equals(event);
	 String singapore=PropertyManager.getValue("singapore.systemName");
	 
	 String availAndOptionApplicable;
			 
	 availAndOptionApplicable = (String)request.getAttribute("availAndOptionApplicable");
	 if(availAndOptionApplicable == null)
		 availAndOptionApplicable="";
	 System.out.println(availAndOptionApplicable +"availAndOptionApplicable"); 
	 pageContext.setAttribute("availAndOptionApplicable" ,availAndOptionApplicable);
	  
%>


<%@page import="java.util.HashMap"%>
<%@page import="com.integrosys.cms.ui.common.UIUtil"%>
<%@page import="com.integrosys.cms.app.common.util.CommonUtil"%>
<%@page import="com.integrosys.base.techinfra.propertyfile.PropertyManager"%><script language="javascript">


function populateRiskTypeFields(isLoanOptionAvailable){
//	alert(isLoanOptionAvailable);
	if(isLoanOptionAvailable == 'on'){
		alert("In if")
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

function updateXRef(editOrView , ind,fcunsSystem,ubslimitSystem){
	var system=document.forms[0].facilitySystem.value;

    if(editOrView == "view"){
        if(document.forms[0].event.value == 'process'){
    		document.forms[0].fromEvent.value = 'process';
        }else if(document.forms[0].event.value == 'custread'){
    		document.forms[0].fromEvent.value = 'custread';
        }else if('<%=request.getParameter("event") %>' == 'prepare_close'){
    		document.forms[0].fromEvent.value = 'close_read';
    	} else if('<%=request.getParameter("event") %>' == 'prepare_delete'){
    		document.forms[0].fromEvent.value = 'prepare_delete';
    	} else {
        	document.forms[0].fromEvent.value = 'read';
        }

        if(system == fcunsSystem || system == ubslimitSystem){
        document.forms[0].indexID.value = ind;
        document.forms[0].limitId.value = <%= request.getAttribute("limitId") %>;
        document.forms[0].event.value = 'view_sub_acnt_ubs';
        document.forms[0].submit();
        }else if(system == "ET"){
        document.forms[0].indexID.value = ind;
        document.forms[0].limitId.value = <%= request.getAttribute("limitId") %>;
        document.forms[0].event.value = 'view_sub_acnt_ts';
        document.forms[0].submit();
        }else{
        document.forms[0].indexID.value = ind;
        document.forms[0].limitId.value = <%= request.getAttribute("limitId") %>;
        document.forms[0].event.value = 'view_sub_acnt';
        document.forms[0].submit();
        }
    }
}

function editLmtDetails() {

    document.forms[0].event.value = 'prepare_cust_update';
    document.forms[0].submit();
 }

function editLimit() {
    var lmtId = <%=request.getParameter("limitId")%>;
    	document.location.href = 'MILimit.do?event=prepare_update&limitId=' + lmtId;
	}

function deleteLmtSec(indexId, action, securityId, securitySubtype)  {
    if(action =='View'){
    	document.forms[0].action = "MILimit.do?securityId="+securityId +"&securitySubtype=" +securitySubtype;
    	if(document.forms[0].event.value == 'process'){
    		document.forms[0].fromEvent.value = 'process';
        } else if(document.forms[0].event.value == 'custread'){
    		document.forms[0].fromEvent.value = 'custread';
        } else if('<%=request.getParameter("event") %>' == 'prepare_close'){
    		document.forms[0].fromEvent.value = 'prepare_close';
    	} else if('<%=request.getParameter("event") %>' == 'prepare_delete'){
    		document.forms[0].fromEvent.value = 'prepare_delete';
    	}else {
        	document.forms[0].fromEvent.value = 'view_sec';
        }
        document.forms[0].event.value = 'view_security';
        document.forms[0].submit();
    }
}


function viewConvenantScreen(name)
{
	document.forms[0].action="MILimit.do?event="+name;
    document.forms[0].submit();
}

function enableCovenantBtn(){
	var system=document.forms[0].facilitySystem.value;
	if(system == 'UBS-LIMITS'){
		document.getElementById('btnedit_viewCovenant').disabled = false;
	}else{
		document.getElementById('btnedit_viewCovenant').disabled = true;
	}
}
	


function disableSCOD(whlmreupSCOD){
	var whlmreupSCOD = whlmreupSCOD.value;
	
	if(whlmreupSCOD == 'Y'){
	document.getElementById('scodDate').disabled = true;
	//document.getElementById('Image723').disabled = true;
	document.getElementById('remarksSCOD').disabled = true;
	}
	
	if(whlmreupSCOD == 'N'){
		document.getElementById('scodDate').disabled = false;
		//document.getElementById('Image723').disabled = false;
		document.getElementById('remarksSCOD').disabled = false;
	}
	

}


window.onload = function(){
	enableCovenantBtn();
	var scodLineNo = '<%=scodLineNoList%>';
	var lineno = document.forms[0].lineNo.value;
  	if(scodLineNo.indexOf(lineno) != -1 && lineno != ""){
	var event = document.forms[0].event.value;
	if( event == 'read' || event == 'null' || event == 'process' ||'<%=request.getParameter("event") %>' == 'prepare_delete' ||'<%=request.getParameter("event") %>' == 'prepare_close'){
		var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
if(event == 'process' && (levelOfDealy == "" || levelOfDealy == null) ){
	document.all.projectFinance[0].disabled =  true;
	document.all.projectFinance[1].disabled =  true;
	document.all.projectLoan[0].disabled =  true;
	document.all.projectLoan[1].disabled =  true;
	document.all.infaProjectFlag[0].disabled =  true;
	document.all.infaProjectFlag[1].disabled =  true;
	document.all.principalInterestSchFlag[0].disabled =  true;
	document.all.principalInterestSchFlag[1].disabled =  true;
	document.getElementById('exstAssetClass').disabled = true;
	document.getElementById('50').style.display = '';
	document.all.whlmreupSCOD[0].disabled =  true;
	document.all.whlmreupSCOD[1].disabled =  true;
	
	
}
	//var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
	if(levelOfDealy != ""){
	var whlmreupSCOD = document.getElementById('whlmreupSCOD').value;
	}else{
		whlmreupSCOD ="";
	}
	if(whlmreupSCOD == 'Y'){
		document.getElementById('scodDate').disabled = true;
		//document.getElementById('Image723').disabled = true;
		document.getElementById('remarksSCOD').disabled = true;
		
		}
		
		if(whlmreupSCOD == 'N'){
			document.getElementById('scodDate').disabled = false;
		//	document.getElementById('Image723').disabled = false;
			document.getElementById('remarksSCOD').disabled = false;
		}

		if(levelOfDealy == "1"){
			//document.getElementById('reasonLevelOneDelay').style.display = 'none';
			document.getElementById('revsedESCODStpDate').disabled = true;
			//document.getElementById('Image729').disabled = true;
			document.getElementById('21').style.display = '';
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
			//document.getElementById('45').style.display = 'none';

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
			
			
			
			
			document.all.projectDelayedFlag[0].disabled = true;
			document.all.projectDelayedFlag[1].disabled = true;
			document.all.principalInterestSchFlag[0].disabled = true;
			document.all.principalInterestSchFlag[1].disabled = true;
			document.all.recvPriorOfSCOD[0].disabled = true;
			document.all.recvPriorOfSCOD[1].disabled = true;
			document.all.chngInRepaySchedule[0].disabled = true;
			document.all.chngInRepaySchedule[1].disabled = true;
			document.all.promotersCapRunFlag[0].disabled = true;
			document.all.promotersCapRunFlag[1].disabled = true;
			document.all.promotersHoldEquityFlag[0].disabled =  true;
			document.all.promotersHoldEquityFlag[1].disabled =  true;
			document.all.hasProjectViabReAssFlag[0].disabled =  true;
			document.all.hasProjectViabReAssFlag[1].disabled =  true;
			document.all.changeInScopeBeforeSCODFlag[0].disabled =  true;
			document.all.changeInScopeBeforeSCODFlag[1].disabled =  true;
			document.all.costOverrunOrg25CostViabilityFlag[0].disabled =  true;
			document.all.costOverrunOrg25CostViabilityFlag[1].disabled =  true;
			document.all.projectViabReassesedFlag[0].disabled =  true;
			document.all.projectViabReassesedFlag[1].disabled =  true;
			document.all.projectFinance[0].disabled =  true;
			document.all.projectFinance[1].disabled =  true;
			document.all.projectLoan[0].disabled =  true;
			document.all.projectLoan[1].disabled =  true;
			document.all.infaProjectFlag[0].disabled =  true;
			document.all.infaProjectFlag[1].disabled =  true;
			document.all.whlmreupSCOD[0].disabled =  true;
			document.all.whlmreupSCOD[1].disabled =  true;
			
		}
		
		
		if(levelOfDealy == "2"){
			//document.getElementById('reasonLevelOneDelay').style.display = 'none';
			document.getElementById('revsedESCODStpDateL2').disabled = true;
			//document.getElementById('Image730').disabled = true;
			
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
			document.getElementById('1').style.display = 'none';
			document.getElementById('39').style.display = 'none';
			document.getElementById('31').style.display = 'none';
			document.getElementById('33').style.display = '';
			document.getElementById('27').style.display = 'none';
			document.getElementById('30').style.display = 'none';
			document.getElementById('33').style.display = 'none'; 
			document.getElementById('6').style.display = 'none';
			document.getElementById('32').style.display = '';
			document.getElementById('39').style.display = 'none';
			//document.getElementById('2').style.display = 'none';
			document.getElementById('41').style.display = 'none';
			document.getElementById('22').style.display = 'none';
			document.getElementById('24').style.display = 'none';
			document.getElementById('25').style.display = 'none';
			//document.getElementById('45').style.display = 'none';
			document.getElementById('36').style.display = 'none';
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
			
			
			
			//document.all.projectDelayedFlagL2[0].disabled = true;
			//document.all.projectDelayedFlagL2[1].disabled = true;
			document.all.principalInterestSchFlag[0].disabled = true;
			document.all.principalInterestSchFlag[1].disabled = true;
			document.all.recvPriorOfSCOD[0].disabled = true;
			document.all.recvPriorOfSCOD[1].disabled = true;
			document.all.chngInRepayScheduleL2[0].disabled = true;
			document.all.chngInRepayScheduleL2[1].disabled = true;
			document.all.promotersCapRunFlagL2[0].disabled = true;
			document.all.promotersCapRunFlagL2[1].disabled = true;
			document.all.promotersHoldEquityFlagL2[0].disabled =  true;
			document.all.promotersHoldEquityFlagL2[1].disabled =  true;
			document.all.hasProjectViabReAssFlagL2[0].disabled =  true;
			document.all.hasProjectViabReAssFlagL2[1].disabled =  true;
			document.all.changeInScopeBeforeSCODFlagL2[0].disabled =  true;
			document.all.changeInScopeBeforeSCODFlagL2[1].disabled =  true;
			document.all.costOverrunOrg25CostViabilityFlagL2[0].disabled =  true;
			document.all.costOverrunOrg25CostViabilityFlagL2[1].disabled =  true;
			document.all.projectViabReassesedFlagL2[0].disabled =  true;
			document.all.projectViabReassesedFlagL2[1].disabled =  true;
			document.all.projectFinance[0].disabled =  true;
			document.all.projectFinance[1].disabled =  true;
			document.all.projectLoan[0].disabled =  true;
			document.all.projectLoan[1].disabled =  true;
			document.all.infaProjectFlag[0].disabled =  true;
			document.all.infaProjectFlag[1].disabled =  true;
			document.all.whlmreupSCOD[0].disabled =  true;
			document.all.whlmreupSCOD[1].disabled =  true;
		}
		
		
		if(levelOfDealy == "3"){
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
			document.getElementById('41').style.display = '';
			document.getElementById('22').style.display = '';
			document.getElementById('24').style.display = '';
			document.getElementById('25').style.display = '';
			
			
			
			
			
			document.getElementById('1').style.display = 'none';
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
			document.getElementById('36').style.display = 'none';
			
			
			
			
			
			
			
			
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
				
				//document.all.projectDelayedFlagL3[0].disabled = true;
				//document.all.projectDelayedFlagL3[1].disabled = true;
				document.all.principalInterestSchFlag[0].disabled = true;
				document.all.principalInterestSchFlag[1].disabled = true;
				document.all.chngInRepayScheduleL3[0].disabled = true;
				document.all.chngInRepayScheduleL3[1].disabled = true;
				document.all.promotersCapRunFlagL3[0].disabled = true;
				document.all.promotersCapRunFlagL3[1].disabled =true;
				document.all.promotersHoldEquityFlagL3[0].disabled =  true;
				document.all.promotersHoldEquityFlagL3[1].disabled =  true;
				document.all.hasProjectViabReAssFlagL3[0].disabled =  true;
				document.all.hasProjectViabReAssFlagL3[1].disabled =  true;
				document.all.changeInScopeBeforeSCODFlagL3[0].disabled =  true;
				document.all.changeInScopeBeforeSCODFlagL3[1].disabled =  true;
				document.all.costOverrunOrg25CostViabilityFlagL3[0].disabled =  true;
				document.all.costOverrunOrg25CostViabilityFlagL3[1].disabled =  true;
				document.all.projectViabReassesedFlagL3[0].disabled =  true;
				document.all.projectViabReassesedFlagL3[1].disabled =  true;
				document.all.projectFinance[0].disabled =  true;
				document.all.projectFinance[1].disabled =  true;
				document.all.projectLoan[0].disabled =  true;
				document.all.projectLoan[1].disabled =  true;
				document.all.infaProjectFlag[0].disabled =  true;
				document.all.infaProjectFlag[1].disabled =  true;
				document.all.whlmreupSCOD[0].disabled =  true;
				document.all.whlmreupSCOD[1].disabled =  true;
			
			
		}
		
		
		if(levelOfDealy == ""){
			document.all.projectFinance[0].disabled =  true;
			document.all.projectFinance[1].disabled =  true;
			document.all.projectLoan[0].disabled =  true;
			document.all.projectLoan[1].disabled =  true;
			document.all.infaProjectFlag[0].disabled =  true;
			document.all.infaProjectFlag[1].disabled =  true;
			document.all.principalInterestSchFlag[0].disabled =  true;
			document.all.principalInterestSchFlag[1].disabled =  true;
			document.all.whlmreupSCOD[0].disabled =  true;
			document.all.whlmreupSCOD[1].disabled =  true;
			document.getElementById('lelvelDelaySCOD').disabled = true;
			document.getElementById('exstAssetClass').disabled = true;
		}
		
		
	}
	}
  	var availAndOptionApplicable = '<%=availAndOptionApplicable%>';
	document.getElementById('availAndOptionApplicable').value = '<%=availAndOptionApplicable%>';
	populateRiskTypeFields(availAndOptionApplicable);

}

function lelvelDelaySCODFun(levelOfDealy){
	var levelOfDealy = document.getElementById('lelvelDelaySCOD').value;
//	disableRadioButtons(levelOfDealy);
	if(levelOfDealy == "1"){
		//document.getElementById('reasonLevelOneDelay').style.display = 'none';
		
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
		document.getElementById('40').style.display = '';
		//document.getElementById('2').style.display = '';
		document.getElementById('41').style.display = '';
		document.getElementById('22').style.display = '';
		document.getElementById('24').style.display = '';
		document.getElementById('25').style.display = '';
		document.getElementById('21').style.display = '';
		
		document.getElementById('1').style.display = '';
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
		document.getElementById('41').style.display = '';
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
		
		
		document.all.projectDelayedFlag[0].disabled = true;
		document.all.projectDelayedFlag[1].disabled = true;
		document.all.principalInterestSchFlag[0].disabled = true;
		document.all.principalInterestSchFlag[1].disabled = true;
		document.all.recvPriorOfSCOD[0].disabled = true;
		document.all.recvPriorOfSCOD[1].disabled = true;
		document.all.chngInRepaySchedule[0].disabled = true;
		document.all.chngInRepaySchedule[1].disabled = true;
		document.all.promotersCapRunFlag[0].disabled = true;
		document.all.promotersCapRunFlag[1].disabled = true;
		document.all.promotersHoldEquityFlag[0].disabled =  true;
		document.all.promotersHoldEquityFlag[1].disabled =  true;
		document.all.hasProjectViabReAssFlag[0].disabled =  true;
		document.all.hasProjectViabReAssFlag[1].disabled =  true;
		document.all.changeInScopeBeforeSCODFlag[0].disabled =  true;
		document.all.changeInScopeBeforeSCODFlag[1].disabled =  true;
		document.all.costOverrunOrg25CostViabilityFlag[0].disabled =  true;
		document.all.costOverrunOrg25CostViabilityFlag[1].disabled =  true;
		document.all.projectViabReassesedFlag[0].disabled =  true;
		document.all.projectViabReassesedFlag[1].disabled =  true;
		document.all.projectFinance[0].disabled =  true;
		document.all.projectFinance[1].disabled =  true;
		document.all.projectLoan[0].disabled =  true;
		document.all.projectLoan[1].disabled =  true;
		document.all.infaProjectFlag[0].disabled =  true;
		document.all.infaProjectFlag[1].disabled =  true;
		document.all.whlmreupSCOD[0].disabled =  true;
		document.all.whlmreupSCOD[1].disabled =  true;
		//document.getElementById('projectDelayedFlag').disabled = true;
		
		//document.getElementById('projectDelayedFlagL2A').style.checked = true;
		
	}else if(levelOfDealy == "2"){
		//document.getElementById('reasonLevelOneDelay').style.display = 'none';
		document.getElementById('revsedESCODStpDateL2').disabled = true;
		//document.getElementById('Image730').disabled = true;
		
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
		document.getElementById('36').style.display = 'none';
		
		
		
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
		document.getElementById('1').style.display = 'none';
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
		
		
		//document.all.projectDelayedFlagL2[0].disabled = true;
		//document.all.projectDelayedFlagL2[1].disabled = true;
		document.all.principalInterestSchFlag[0].disabled = true;
		document.all.principalInterestSchFlag[1].disabled = true;
		document.all.recvPriorOfSCOD[0].disabled = true;
		document.all.recvPriorOfSCOD[1].disabled = true;
		document.all.chngInRepayScheduleL2[0].disabled = true;
		document.all.chngInRepayScheduleL2[1].disabled = true;
		document.all.promotersCapRunFlagL2[0].disabled = true;
		document.all.promotersCapRunFlagL2[1].disabled = true;
		document.all.promotersHoldEquityFlagL2[0].disabled =  true;
		document.all.promotersHoldEquityFlagL2[1].disabled =  true;
		document.all.hasProjectViabReAssFlagL2[0].disabled =  true;
		document.all.hasProjectViabReAssFlagL2[1].disabled =  true;
		document.all.changeInScopeBeforeSCODFlagL2[0].disabled =  true;
		document.all.changeInScopeBeforeSCODFlagL2[1].disabled =  true;
		document.all.costOverrunOrg25CostViabilityFlagL2[0].disabled =  true;
		document.all.costOverrunOrg25CostViabilityFlagL2[1].disabled =  true;
		document.all.projectViabReassesedFlagL2[0].disabled =  true;
		document.all.projectViabReassesedFlagL2[1].disabled =  true;
		document.all.projectFinance[0].disabled =  true;
		document.all.projectFinance[1].disabled =  true;
		document.all.projectLoan[0].disabled =  true;
		document.all.projectLoan[1].disabled =  true;
		document.all.infaProjectFlag[0].disabled =  true;
		document.all.infaProjectFlag[1].disabled =  true;
		document.all.whlmreupSCOD[0].disabled =  true;
		document.all.whlmreupSCOD[1].disabled =  true;
		
		//document.getElementById('projectDelayedFlagL2A').style.checked = true;
		
	}else if(levelOfDealy == "3"){
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
		document.getElementById('41').style.display = '';
		document.getElementById('22').style.display = '';
		document.getElementById('24').style.display = '';
		document.getElementById('25').style.display = '';
		
		
		
		
		
		document.getElementById('1').style.display = 'none';
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
		document.getElementById('36').style.display = 'none';
		
		
		
		
		
		
		
		
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
			
			
			//document.all.projectDelayedFlagL3[0].disabled = true;
			//document.all.projectDelayedFlagL3[1].disabled = true;
			document.all.principalInterestSchFlag[0].disabled = true;
			document.all.principalInterestSchFlag[1].disabled = true;
			document.all.chngInRepayScheduleL3[0].disabled = true;
			document.all.chngInRepayScheduleL3[1].disabled = true;
			document.all.promotersCapRunFlagL3[0].disabled = true;
			document.all.promotersCapRunFlagL3[1].disabled =true;
			document.all.promotersHoldEquityFlagL3[0].disabled =  true;
			document.all.promotersHoldEquityFlagL3[1].disabled =  true;
			document.all.hasProjectViabReAssFlagL3[0].disabled =  true;
			document.all.hasProjectViabReAssFlagL3[1].disabled =  true;
			document.all.changeInScopeBeforeSCODFlagL3[0].disabled =  true;
			document.all.changeInScopeBeforeSCODFlagL3[1].disabled =  true;
			document.all.costOverrunOrg25CostViabilityFlagL3[0].disabled =  true;
			document.all.costOverrunOrg25CostViabilityFlagL3[1].disabled =  true;
			document.all.projectViabReassesedFlagL3[0].disabled =  true;
			document.all.projectViabReassesedFlagL3[1].disabled =  true;
			document.all.projectFinance[0].disabled =  true;
			document.all.projectFinance[1].disabled =  true;
			document.all.projectLoan[0].disabled =  true;
			document.all.projectLoan[1].disabled =  true;
			document.all.infaProjectFlag[0].disabled =  true;
			document.all.infaProjectFlag[1].disabled =  true;
			document.all.whlmreupSCOD[0].disabled =  true;
			document.all.whlmreupSCOD[1].disabled =  true;
			
			
			
	}else if(levelOfDealy == ""){
		document.getElementById('1').style.display = 'none';
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
		document.getElementById('1').style.display = 'none';
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
		
		document.all.projectFinance[0].disabled =  true;
		document.all.projectFinance[1].disabled =  true;
		document.all.projectLoan[0].disabled =  true;
		document.all.projectLoan[1].disabled =  true;
		document.all.infaProjectFlag[0].disabled =  true;
		document.all.infaProjectFlag[1].disabled =  true;
		document.all.whlmreupSCOD[0].disabled =  true;
		document.all.whlmreupSCOD[1].disabled =  true;
		document.all.principalInterestSchFlag[0].disabled =  true;
		document.all.principalInterestSchFlag[1].disabled =  true;
		document.getElementById('exstAssetClass').disabled = true;
		
		
	}
}

function populateSCODFields(){
	var lineno = document.forms[0].lineNo.value;
	 var scodLineNo = '<%=scodLineNoList%>';
	 var lineno_array = scodLineNo.split(',');
	 var flag = false;
	 for(var i = 0; i < lineno_array.length; i++) {
	    
	    if(lineno_array[i] == lineno){
	    	flag = true;
	    }
	 }
	if(flag && lineno != ""){
		document.getElementById('51').style.display = '';
		document.getElementById('52').style.display = '';
		document.getElementById('53').style.display = '';
		document.getElementById('41').style.display = '';
	}else{
		document.getElementById('51').style.display = 'none';
		document.getElementById('52').style.display = 'none';
		document.getElementById('53').style.display = 'none';
		document.getElementById('41').style.display = 'none';
	} 
	
	
}


 function disableExtraFields(){
	 
	if(document.all.whlmreupSCOD[0].checked == false && document.all.whlmreupSCOD[1].checked == false){
		document.getElementById('100').style.display = 'none';
		document.getElementById('36').style.display = 'none';
		document.getElementById('101').style.display = 'none';
		document.getElementById('50').style.display = 'none';
		
		
	}
	
} 

var b = setInterval(populateSCODFields,100);
var c = setInterval(disableExtraFields,100);



</script>
<tbody>
    <!-- <input type="hidden" name="fromEvent" /> -->
    <input type="hidden" name="fromEvent" value="<%=request.getAttribute("fromEvent") %>"/>
    <input type="hidden" name="indexID" value=""/>
    <input type="hidden" name="itemType" value=""/>
    <input type="hidden" name="trxID" value="<%=request.getParameter("trxID") %>"/>
    <html:hidden property="isCreate"/>
<bean:define id="formObj" name="LmtDetailForm" scope="request" type="com.integrosys.cms.ui.manualinput.limit.LmtDetailForm"/>

<html:hidden property="limitProfileID" value="<%=formObj.getLimitProfileID() %>"/>
	<html:hidden property="customerID" value="<%=formObj.getCustomerID() %>"/>
	<html:hidden property="limitId" value="<%=formObj.getLimitId() %>"/>
	<html:hidden property="limitRef" value="<%=formObj.getLimitRef() %>"/>
	 <input type="hidden" name="fundedAmount" value="<%=(String)request.getAttribute("fundedAmount") %>"/>
	<input type="hidden" name="nonFundedAmount" value="<%=(String)request.getAttribute("nonFundedAmount")  %>" />
    <input type="hidden" name="memoExposer"  value="<%=(String)request.getAttribute("memoExposer")  %>" />
	<input type="hidden" name="sanctionedLimit"	value="<%=(String)request.getAttribute("sanctionedLimit") %>" />
<tr>
<td colspan="2">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblInfo">
<tbody>
    <tr class="odd">
        <td class="fieldName" width="20%"><bean:message key="label.facility.id"/>&nbsp;</td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="limitRef"/>&nbsp;
            <html:hidden property="limitRef"/>
        </td>
        
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"facilityCat")?"fieldname":"fieldnamediff"%>" width="20%"><bean:message key="label.facility.category"/><span class="mandatoryPerfection">*</span></td>
        <td width="30%">
             <html:select property="facilityCat" value="<%=formObj.getFacilityCat()%>" disabled="true">
                  <integro:common-code
									categoryCode="<%=CategoryCodeConstant.FACILITY_CATEGORY%>" descWithCode="false" />   
					</html:select>
            <html:hidden property="facilityCat"/>
        </td>      
    </tr>
    <tr class="even">
    	<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"facilityName")?"fieldname":"fieldnamediff"%>" width="20%"><bean:message key="label.facility.name"/>&nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="facilityName"/>&nbsp;
            <html:hidden property="facilityName"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"facilityType")?"fieldname":"fieldnamediff"%>" width="20%"><bean:message key="label.facility.type"/>&nbsp;</td>
        <td width="30%">
            <integro:common-code-single categoryCode="<%=CategoryCodeConstant.FACILITY_TYPE%>" entryCode="<%=formObj.getFacilityType() %>" display="true" descWithCode="false" />&nbsp;
            <html:hidden property="facilityType"/>
        </td> 
    </tr>
    <tr class="odd">
       <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"facilitySystem")?"fieldname":"fieldnamediff"%>" width="20%">System&nbsp;</td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="facilitySystem"/>&nbsp;
            <html:hidden property="facilitySystem"/>
              <html:hidden property="facilitySystemID"/>
        </td> 

        <%if(formObj.getFacilitySystem()!=null){ %>
        <%if(!formObj.getFacilitySystem().equals("ET")){ %>      

        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"syndicateLoan")?"fieldname":"fieldnamediff"%>" width="20%"><bean:message key="label.facility.syndicateLoan"/>&nbsp;</td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="syndicateLoan"/>&nbsp;
            <html:hidden property="syndicateLoan"/>
        </td> 
          <%}} %>
       
    </tr>
     <tr class="odd">
        <td class="fieldname" width="20%">Risk Type<font color="#FF0000">*</font></td>
        <td width="30%">         
        <% if(formObj.getRiskType()!=null){   %>
            <html:select property="riskType" style="width:450" value="<%=formObj.getRiskType().trim()%>" disabled="true">
               		<html:options collection="riskTypeList" labelProperty="label" property="value" />
             </html:select>
         <%} %>   
        <html:hidden property="riskType"/>
        </td> 
     <td width="30%"></td><td width="30%"></td>              
    </tr>
    <tr class="even">

         <%if(formObj.getFacilitySystem()!=null){ %>
    	 <%if(!formObj.getFacilitySystem().equals("ET")){ %>

    	 	<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"lineNo")?"fieldname":"fieldnamediff"%>" width="20%">Line no. &nbsp;</td>
	        <td width="30%">
	            <bean:write name="LmtDetailForm" property="lineNo"/>&nbsp;
	            <html:hidden property="lineNo"/>
	        </td> 
    	 <%}else{ %>
    	 	<td></td>
    	 	<td></td>
    	 <%}}%>
        
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"isDPRequired")?"fieldname":"fieldnamediff"%>" width="20%">DP Required ?&nbsp;</td>
        <td width="30%">
            <%=ICMSConstant.YES.equals(formObj.getIsDPRequired())?"Yes":"No"%>
            <html:hidden property="isDPRequired"/>
        </td> 
    </tr>
    
    <tr class="odd">        
       <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"purpose")?"fieldname":"fieldnamediff"%>" width="20%">Purpose&nbsp;</td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="purpose"/>&nbsp;
            <html:hidden property="purpose"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"isDP")?"fieldname":"fieldnamediff"%>" width="20%">Should DP be calculated from Bank shares?&nbsp;</td>
        <td width="30%">
            <%=ICMSConstant.YES.equals(formObj.getIsDP())?"Yes": (ICMSConstant.NO.equals(formObj.getIsDP())?"No":"-")%> &nbsp;
            <html:hidden property="isDP"/>
        </td> 
    </tr>
    <tr class="even">
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"relationShipManager")?"fieldname":"fieldnamediff"%>" width="20%">RelationShip Manager&nbsp;</td>
        <td width="30%">
            <integro:empty-if-null value="<%= relationShipMgrName %>"/>
            <html:hidden property="relationShipManager"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"isReleased")?"fieldname":"fieldnamediff"%>" width="20%">Released&nbsp;</td>
        <td width="30%">
        <%if(formObj.getIsReleased() != null && formObj.getIsReleased().equals("Y")){ %>
        	Yes
        <%}else { %>
        	No
        <%} %>
            <html:hidden property="isReleased"/>
        </td> 
    </tr>
    <tr class="even">
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"bankingArrangement")?"fieldname":"fieldnamediff"%>" width="20%">Banking Arrangement&nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">
            <integro:common-code-single categoryCode="<%=com.integrosys.cms.ui.limit.CategoryCodeConstant.BANKING_ARRANGEMENT %>" 
									entryCode="<%=formObj.getBankingArrangement()%>"  display="true" descWithCode="false" /> &nbsp;
            <html:hidden property="bankingArrangement"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"clauseAsPerPolicy")?"fieldname":"fieldnamediff"%>" width="20%">Clause as per Policy&nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">
			<integro:common-code-single categoryCode="<%=com.integrosys.cms.ui.limit.CategoryCodeConstant.CLAUSE_AS_PER_POLICY %>" 
									entryCode="<%=formObj.getClauseAsPerPolicy()%>"  display="true" descWithCode="false" /> &nbsp;
            <html:hidden property="clauseAsPerPolicy"/>
        </td> 
    </tr>
   
	 <tr class="even">
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"grade")?"fieldname":"fieldnamediff"%>" width="20%">Grade&nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="grade"/>&nbsp;
            <html:hidden property="grade"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"isSecured")?"fieldname":"fieldnamediff"%>" width="20%">Secured&nbsp;</td>
        <td width="30%">
        <%if(formObj.getIsSecured() != null && formObj.getIsSecured().equals("Y")){ %>
        	Yes
        <%}else { %>
        	No
        <%} %>
            <html:hidden property="isSecured"/>
        </td> 
    </tr>
     <tr class="odd">
	    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"currencyCode")?"fieldname":"fieldnamediff"%>" width="20%">Currency&nbsp;</td>
        <td width="30%">
            
            <html:select property="currencyCode" value="<%=formObj.getCurrencyCode().trim()%>"  disabled="true">
               		<html:options collection="currencyList" property="value" labelProperty="label"/>
             </html:select>
            <html:hidden property="currencyCode"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"isAdhoc")?"fieldname":"fieldnamediff"%>" width="20%">Adhoc&nbsp;</td>
        <td width="30%">
            <%if(formObj.getIsAdhoc() != null && formObj.getIsAdhoc().equals("on")){ %>
        	Yes
        <%}else{ %>
        	No
         <%} %>
            <html:hidden property="isAdhoc"/>
        </td> 
	</tr>
	<tr class="even">
	    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"isAdhocToSum")?"fieldname":"fieldnamediff"%>" width="20%">Whether adhoc limit needs to be added in Total Sanctioned amount &nbsp;</td>
        <td width="30%">
        <%if(formObj.getIsAdhocToSum() != null && formObj.getIsAdhocToSum().equals("on")){ %>
        	Yes
        <%}else{ %>
        	No
         <%} %>
            <!--<bean:write name="LmtDetailForm" property="isAdhocToSum"/>&nbsp;
            --><html:hidden property="isAdhocToSum"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"adhocLmtAmount")?"fieldname":"fieldnamediff"%>" width="20%">Adhoc Limit&nbsp;</td>
        <td width="30%">
        <integro:empty-if-null value="<%=formObj.getAdhocLmtAmount() %>"/>
            <!--<bean:write name="LmtDetailForm" property="adhocLmtAmount"/>&nbsp;
            --><html:hidden property="adhocLmtAmount"/>
        </td> 
	</tr>
</tbody>

<tbody>
<tr class="odd">
	    <td class="fieldName" width="20%">Sub Limit &nbsp;</td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="limitType"/>&nbsp;
            <html:hidden property="limitType"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"guarantee")?"fieldname":"fieldnamediff"%>" width="20%">Guarantee &nbsp;</td>
        <td width="30%">
        <integro:empty-if-null value="<%=formObj.getGuarantee()%>"/>
            <!--<bean:write name="LmtDetailForm" property="guarantee"/>&nbsp;
            --><html:hidden property="guarantee"/>
        </td> 
	</tr>
	
	
	<tr class="even">
	    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"subPartyName")?"fieldname":"fieldnamediff"%>" width="20%">Party Name &nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">
        <logic:notEmpty name="LmtDetailForm" property="guarantee" scope="request">
        <html:select property="subPartyName" value="<%=formObj.getSubPartyName() %>" disabled="true" >	
              <option value="">Please Select </option>                     
						<html:options  collection ="subPartyNameList" labelProperty ="label" property ="value" />								                   
		</html:select> 
        <html:hidden property="subPartyName" value="<%=formObj.getSubPartyName() %>" />
        </logic:notEmpty>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"subFacilityName")?"fieldname":"fieldnamediff"%>" width="20%">Facility Name&nbsp;</td>
        <td width="30%">
        <logic:notEmpty name="LmtDetailForm" property="guarantee" scope="request">
        <integro:empty-if-null value="<%=formObj.getSubFacilityName()%>"/><!--
            <bean:write name="LmtDetailForm" property="subFacilityName"/>&nbsp;
            --><html:hidden property="subFacilityName"/>
            </logic:notEmpty>
        </td> 
	</tr>
	
</tbody>

<tbody>
<tr class="odd">
	  
	    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"liabilityID")?"fieldname":"fieldnamediff"%>" width="20%">Laibility ID &nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">
         <logic:notEmpty name="LmtDetailForm" property="guarantee" scope="request">
        <integro:empty-if-null value="<%=formObj.getLiabilityID() %>"/><!--
            <bean:write name="LmtDetailForm" property="liabilityID"/>&nbsp;
            --><html:hidden property="liabilityID"/>
        </logic:notEmpty>
        </td> 
        <td class="fieldName" width="20%"> &nbsp;</td>
        <td width="30%">
            <html:hidden property="totalReleasedAmount"/>
        </td> 
	</tr>
	<tr class="even">
	    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"requiredSecurityCoverage")?"fieldname":"fieldnamediff"%>" width="20%">Sanctioned Amount  &nbsp;<span class="mandatoryPerfection">*</span></td>
        <td width="30%">            
            <integro:amount param="amount" decimal="2" amount="<%=UIUtil.convertToAmount(locale,CommonUtil.getBaseCurrency(),lmtDetailForm.getRequiredSecCov())%>" />
            &nbsp;&nbsp;&nbsp;<html:errors property="requiredSecCov"/>
            <html:hidden property="requiredSecCov"/>
        </td>          
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"releasableAmount")?"fieldname":"fieldnamediff"%>" width="20%">Releasable Amount &nbsp;</td>
        <td width="30%">            
            <integro:amount param="amount" decimal="2" amount="<%=UIUtil.convertToAmount(locale,CommonUtil.getBaseCurrency(),lmtDetailForm.getReleasableAmount())%>" />
            <html:hidden property="releasableAmount"/><html:errors property="releasableAmountChecker"/>
        </td> 
	</tr>
</tbody>

<tbody>
<tr class="odd">
	    <td class="fieldName" width="20%">Sanctioned Amount(INR)  &nbsp;</td>
        <td  width="30%" >
        <%	
        	String amt = (String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.inrValue");
        %>
            <b><integro:amount param="amount" decimal="2" amount="<%=UIUtil.convertToAmount(locale,CommonUtil.getBaseCurrency(),amt) %>"/> &nbsp;</b>            
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"totalReleasedAmount")?"fieldname":"fieldnamediff"%>" width="20%"> Released</td>
        <td width="30%">
  <% if(lmtDetailForm.getTotalReleasedAmount()==null){
        	if(actualLimit != null){
		System.out.println("actualLimit.getTotalReleasedAmount()===>"+actualLimit.getTotalReleasedAmount());
        	lmtDetailForm.setTotalReleasedAmount(actualLimit.getTotalReleasedAmount());
			}
        }	
        %>
        
                  <integro:amount param="amount" decimal="2" amount="<%=UIUtil.convertToAmount(locale,CommonUtil.getBaseCurrency(),lmtDetailForm.getTotalReleasedAmount())%>" />
            <html:hidden property="totalReleasedAmount"/></td> 	
		</tr>	
	</tr>
</tbody>

	  <tr class="even">
       
        <td class="fieldname" width="20%"><bean:message key="label.facility.adhocFacility"/>&nbsp;</td>
        <td width="30%">
        <%if(formObj.getAdhocFacility() != null && formObj.getAdhocFacility().equals("Y")){ %>
        	Yes
        <%}else { %>
        	No
        <%} %>
            <html:hidden property="adhocFacility"/>
        </td> 
        
         <td class="fieldname" width="20%"><bean:message key="label.facility.adhocLastAvailDt"/>&nbsp;</td>
        <td width="30%">
            <integro:empty-if-null value="<%=formObj.getAdhocLastAvailDate()  %>"/>
            
            <html:hidden property="adhocLastAvailDate"/>
        </td> 
    </tr>
  </tbody>

<tbody>
     <tr class="odd">
       
        <td class="fieldname" width="20%"><bean:message key="label.facility.multiDrawdownAllow"/>&nbsp;</td>
        <td width="30%">
        <%
        	if(formObj.getMultiDrawdownAllow() != null && formObj.getMultiDrawdownAllow().equals("Y")){
        %>
        	Yes
        <%}else { %>
        	No
        <%} %>
            <html:hidden property="multiDrawdownAllow"/>
        </td> 
        
         <td class="fieldname" width="20%"><bean:message key="label.facility.adhocTenor"/>&nbsp;</td>
        <td width="30%">
            <integro:empty-if-null value="<%= formObj.getAdhocTenor() %>"/>
            <html:hidden property="adhocTenor"/>
        </td> 
    </tr>
    
    
     <tr class="even">
       
         <td class="fieldname" width="20%"><bean:message key="label.facility.adhocFacilityExpDt"/>&nbsp;</td>
        <td width="30%">
            <integro:empty-if-null value="<%=formObj.getAdhocFacilityExpDate() %>"/>
            <html:hidden property="adhocFacilityExpDate"/>
        </td> 
        
        <td class="fieldname" width="20%"><bean:message key="label.facility.genPurposeLoan"/>&nbsp;</td>
        <td width="30%">
        <%if(formObj.getGeneralPurposeLoan() != null && formObj.getGeneralPurposeLoan().equals("Y")){ %>
        	Yes
        <%}else { %>
        	No
        <%} %>
            <html:hidden property="generalPurposeLoan"/>
        </td> 
       
    </tr>
   
</tbody>




<%if(formObj.getProjectFinance() != null && formObj.getProjectLoan() != null){%>


<tr  width="20%" id="51">
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectFinance")?"fieldname":"fieldnamediff"%>" width="20%">Project Finance<font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="projectFinance" styleId="projectFinance" value="Y" onclick="" disabled="true"/>&nbsp;Yes&nbsp;
        <html:radio property="projectFinance" styleId="projectFinance" value="N" onclick="" disabled="true"/>&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectFinance"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectLoan")?"fieldname":"fieldnamediff"%>" width="20%">Project Loan <font color="#FF0000">*</font>&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectLoan" styleId="projectLoan" value="Y" onclick="" disabled="true" />&nbsp;Yes&nbsp;
       <html:radio property="projectLoan" styleId="projectLoan" value="N" onclick="" disabled="true" />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectLoan"/>
    </td>
</tr>


<tr class="even" id="52">
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"infaProjectFlag")?"fieldname":"fieldnamediff"%>" width="20%">Infra / Non-Infra project flag <font color="#FF0000">*</font></td>
    <td width="30%">
        <html:radio property="infaProjectFlag" styleId="infaProjectFlag" value="Y" onclick="" disabled="true" />&nbsp;Infra&nbsp;
        <html:radio property="infaProjectFlag" styleId="infaProjectFlag" value="N" onclick="" disabled="true" />&nbsp;Non-Infra&nbsp;
        &nbsp;<html:errors property="infaProjectFlag"/>
    </td>
<td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"scodDate")?"fieldname":"fieldnamediff"%>">SCOD (Scheduled Commercial Operations Date)<font color="#FF0000">*</font> </td>	
                 <td><html:text property="scodDate" styleId ="scodDate" style="width:90px" readonly="true" disabled="true" />

					 &nbsp;<html:errors property="scodDate"/>				             
             </td>
</tr>





    <tr class="even" id="53">      
          <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"remarksSCOD")?"fieldname":"fieldnamediff"%>">Remarks on SCOD <font color="#FF0000">*</font></td>
          <td width="30%"><html:text  property="remarksSCOD" styleId="remarksSCOD" disabled="true" readonly="false"/> &nbsp;<html:errors property="remarksSCOD" /></td> 	
		<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	</tr>
	
	 <tr class="even" id="41">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssetClass")?"fieldname":"fieldnamediff"%>">Existing Asset classification <font color="#FF0000">*</font></td>
	 <td>
	<html:select property="exstAssetClass" styleId="exstAssetClass" value="<%=formObj.getExstAssetClass()%>"  onchange="" disabled="true">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false"/>   
							 </html:select><html:errors property="exstAssetClass"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssClassDate")?"fieldname":"fieldnamediff"%>">Existing Asset classification Date </td>	
		  <%if (!"".equals(formObj.getExstAssClassDate()) && formObj.getExstAssClassDate() != null){ %>
                 <td><html:text property="exstAssClassDate" style="width:90px" readonly="true" value="<%=formObj.getExstAssClassDate()%>" disabled="true"/>
									             </td> <%}else{ %>
				   <td><html:text property="exstAssClassDate" style="width:90px" readonly="true"  disabled="true" />
									             </td>
									             <%} %>
									             </tr>
			<%System.out.println("Jay........"+formObj.getEvent()); %>
			<%System.out.println("Jay........"+formObj.getIsCreate()); %>
			<%System.out.println("Jay........"+formObj.getLelvelDelaySCOD()); %>   	
			<% 
			if(scodLineNoList != null){
			if(scodLineNoList.contains(formObj.getLineNo())){ %>
			<tr class="even" id ="100">
			<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"whlmreupSCOD")?"fieldname":"fieldnamediff"%>" width="20%">Whether Limit released as you are updating SCOD?&nbsp;</td>
    <td width="30%" >        
       <html:radio property="whlmreupSCOD" styleId="whlmreupSCOD" value="Y" onclick="disableSCOD(this);"  disabled="true"/>&nbsp;Yes&nbsp;
       <html:radio property="whlmreupSCOD" styleId="whlmreupSCOD" value="N" onclick="disableSCOD(this);"  disabled="true"/>&nbsp;No&nbsp;
         &nbsp;<html:errors property="whlmreupSCOD"/>
    </td>
<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectDelayedFlag")?"fieldname":"fieldnamediff"%>" width="20%">Whether Project is Delayed</td>
    <td width="30%">
        <html:radio property="projectDelayedFlag" styleId="projectDelayedFlag" value="Y" onclick="" disabled="true" />&nbsp;Yes&nbsp;
        <html:radio property="projectDelayedFlag" styleId="projectDelayedFlag" value="N" onclick="" disabled="true"/>&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectDelayedFlag"/>
    </td>
     
          </tr>	
          	             
				 <tr class="even" id = "36">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revisedAssetClass")?"fieldname":"fieldnamediff"%>">Revised Asset Classification</td>
	 <td>
	<html:select property="revisedAssetClass" styleId="revisedAssetClass" value="<%=formObj.getRevisedAssetClass()%>" disabled="true" onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClass"/></td>
	<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsdAssClassDate")?"fieldname":"fieldnamediff"%>">Revised Asset Classification Date</td>
		  <%if (!"".equals(formObj.getRevsdAssClassDate()) && formObj.getRevsdAssClassDate() != null){ %>
                 <td><html:text property="revsdAssClassDate" style="width:90px" readonly="true" disabled="true"/></td>
									             <%}else{ %>
				  <td><html:text property="revsdAssClassDate" style="width:90px" readonly="true" disabled="true" /></td>
									             <%} %>
									             </tr>	 		             
									             
									           
	<tr class="even" id = "101">
	
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"actualCommOpsDate")?"fieldname":"fieldnamediff"%>">ACOD (Actual Commercial Operations Date)<font color="#FF0000">*</font> </td>	
		 
		 <%System.out.println("asdfsadfasdfsafas"+formObj.getActualCommOpsDate()); %>
		  <%if (!"".equals(formObj.getActualCommOpsDate()) && formObj.getActualCommOpsDate() != null){ %>
                 <td><html:text property="actualCommOpsDate" style="width:90px" readonly="true" disabled="true"/> </td><%}else{ %>
		<td><html:text property="actualCommOpsDate" style="width:90px" readonly="true" disabled="true"/> </td>
									            <%} %>
	<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
									             </tr>
									             
<%}} %>	
			<% if(formObj.getLelvelDelaySCOD() != null && ("1".equals(formObj.getLelvelDelaySCOD()) || "2".equals(formObj.getLelvelDelaySCOD()) || "3".equals(formObj.getLelvelDelaySCOD()))){ %>

<tr class="even"  >
    <td  class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"lelvelDelaySCOD")?"fieldname":"fieldnamediff"%>">Level of delay in SCOD</td>
	 <td>
	<html:select property="lelvelDelaySCOD" styleId="lelvelDelaySCOD" value="<%=formObj.getLelvelDelaySCOD()%>" disabled="true" onchange="lelvelDelaySCODFun(this);">
	                  			<integro:common-code categoryCode="DELAY_LEVEL_ID"
	                  					 descWithCode="false"  />   
							 </html:select><html:errors property="lelvelDelaySCOD"/></td>
						<%--  <td class="fieldname" width="20%">Whether Principal/ Interest Servicing is as per schedule</td>
    <td width="30%">
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="Y" onclick="" disabled="true" />&nbsp;Yes&nbsp;
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="N" onclick="" disabled="true"/>&nbsp;No&nbsp;
        &nbsp;<html:errors property="principalInterestSchFlag"/>
    </td> --%>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 
</tr>
<%}else{%>
<%System.out.println("jay....."); %>
	<tr class="even" id="50">
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"lelvelDelaySCOD")?"fieldname":"fieldnamediff"%>">Level of delay in SCOD</td>
	 <td>
	<html:select property="lelvelDelaySCOD" styleId="lelvelDelaySCOD" value="<%=formObj.getLelvelDelaySCOD()%>" disabled="true" onchange="lelvelDelaySCODFun(this);">
	                  			<integro:common-code categoryCode="DELAY_LEVEL_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="lelvelDelaySCOD"/></td>
						 <%-- <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"principalInterestSchFlag")?"fieldname":"fieldnamediff"%>" width="20%">Whether Principal/ Interest Servicing is as per schedule</td>
    <td width="30%">
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="Y" onclick="" disabled="true" />&nbsp;Yes&nbsp;
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="N" onclick="" disabled="true"/>&nbsp;No&nbsp;
        &nbsp;<html:errors property="principalInterestSchFlag"/>
    </td> --%>
   <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 
</tr>
<%}%>
<% if(!"".equals(formObj.getLelvelDelaySCOD()) && formObj.getLelvelDelaySCOD() != null){ %>

<tr class="even" id = '1'>
    
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"reasonLevelOneDelay")?"fieldname":"fieldnamediff"%>" width="20%" id="reasonLevelOneDelayLable">Reason for Deferment of SCOD in the event of level 1 delay&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelOneDelay" styleId="reasonLevelOneDelay" disabled="true" readonly="false"/> &nbsp;<html:errors property="reasonLevelOneDelay" /></td> 	
  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"principalInterestSchFlag")?"fieldname":"fieldnamediff"%>" width="20%">Whether Principal/ Interest Servicing is as per schedule</td>
    <td width="30%">
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="Y" onclick="" disabled="true" />&nbsp;Yes&nbsp;
        <html:radio property="principalInterestSchFlag" styleId="principalInterestSchFlag" value="N" onclick="" disabled="true"/>&nbsp;No&nbsp;
        &nbsp;<html:errors property="principalInterestSchFlag"/>
    </td>
</tr>
<%-- <tr class="even" id = '2'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectDelayedFlagL2")?"fieldname":"fieldnamediff"%>" width="20%">Whether Project is Delayed</td>
    <td width="30%">
        <html:radio property="projectDelayedFlagL2" styleId="projectDelayedFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="projectDelayedFlagL2" styleId="projectDelayedFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectDelayedFlagL2"/>
    </td>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 	
</tr>

<tr class="even" id = '45'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectDelayedFlagL3")?"fieldname":"fieldnamediff"%>" width="20%">Whether Project is Delayed</td>
    <td width="30%">
        <html:radio property="projectDelayedFlagL3" styleId="projectDelayedFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="projectDelayedFlagL3" styleId="projectDelayedFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="projectDelayedFlagL3"/>
    </td>
    <td class="fieldname" width="20%">&nbsp;</td>
          <td width="30%"></td> 	
</tr> --%>

<tr class="even" id = '3'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"chngInRepaySchedule")?"fieldname":"fieldnamediff"%>" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepaySchedule" styleId="chngInRepaySchedule" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepaySchedule" styleId="chngInRepaySchedule" value="N"  onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepaySchedule"/>
    </td>
     <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"escodLevelOneDelayDate")?"fieldname":"fieldnamediff"%>">Extended SCOD (ESCOD) date in the event of level 1 delay<font color="#FF0000">*</font> </td>
       <%if (!"".equals(formObj.getEscodLevelOneDelayDate()) && formObj.getEscodLevelOneDelayDate() != null){ %>	
                 <td><html:text property="escodLevelOneDelayDate" style="width:90px" readonly="true" disabled="true"/>
									             </td><%}else{ %>
				  <td><html:text property="escodLevelOneDelayDate" style="width:90px" readonly="true" disabled="true"/></td>
									             <%} %>
</tr>


<tr class="even" id = '4'>
   
     <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"escodLevelSecondDelayDate")?"fieldname":"fieldnamediff"%>">Extended SCOD (ESCOD) date in the event of level 2 delay<font color="#FF0000">*</font> </td>	
      <%if (!"".equals(formObj.getEscodLevelSecondDelayDate()) && formObj.getEscodLevelSecondDelayDate() != null){ %>	
                 <td><html:text property="escodLevelSecondDelayDate" style="width:90px" readonly="true" disabled="true" />
									             </td><%}else{ %>
				   <td><html:text property="escodLevelSecondDelayDate" style="width:90px" readonly="true" disabled="true"/>
									             </td>
									             <%} %>
	 <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"chngInRepayScheduleL2")?"fieldname":"fieldnamediff"%>" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepayScheduleL2" styleId="chngInRepayScheduleL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepayScheduleL2" styleId="chngInRepayScheduleL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepayScheduleL2"/>
    </td>
</tr>


<tr class="even" id = '5'>
   <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"chngInRepayScheduleL3")?"fieldname":"fieldnamediff"%>" width="20%">Whether change in repayment schedule</td>
    <td width="30%">
        <html:radio property="chngInRepayScheduleL3" styleId="chngInRepayScheduleL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="chngInRepayScheduleL3" styleId="chngInRepayScheduleL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="chngInRepayScheduleL3"/>
    </td>
     <td width="20%" class="fieldname">&nbsp;</td>	
                 <td></td>
	 
</tr>

<tr class="even" id = '6'>
   
<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"reasonLevelThreeDelay")?"fieldname":"fieldnamediff"%>" width="20%">Reason for Deferment of SCOD in the event of level 3 delay&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelThreeDelay" styleId="reasonLevelThreeDelay" disabled="true" readonly="flase"/> &nbsp;<html:errors property="reasonLevelThreeDelay" /></td> 	
    <%if (!"".equals(formObj.getEscodLevelThreeDelayDate()) && formObj.getEscodLevelThreeDelayDate() != null){ %>
     <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"escodLevelThreeDelayDate")?"fieldname":"fieldnamediff"%>">Extended SCOD (ESCOD) date in the event of level 3 delay<font color="#FF0000">*</font> </td>	
                 <td><html:text property="escodLevelThreeDelayDate" style="width:90px" readonly="true" disabled="true"/>
									             </td><%}else{ %>
	    <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"escodLevelThreeDelayDate")?"fieldname":"fieldnamediff"%>">Extended SCOD (ESCOD) date in the event of level 3 delay<font color="#FF0000">*</font> </td>	
                 <td><html:text property="escodLevelThreeDelayDate" style="width:90px" readonly="true" disabled="true"/>
									             </td>
									             <%} %>
</tr>

<tr class="even" id = '7'>
   
     <td width="20%" class="fieldname">Reason for revision in ESCOD due to level 2 delay<font color="#FF0000">*</font> </td>	
                 <td>A. For Infra Projects</td>
	<td class="fieldname">&nbsp;</td>
		<td width="30%">B. For Non-Infra Projects</td>
</tr>

<tr class="even" id = '8'>
   
     <td width="20%" class="fieldname">&nbsp;</td>	
      <%if("Y".equals(formObj.getLegalOrArbitrationLevel2Flag()) && null != formObj.getLegalOrArbitrationLevel2Flag()){ %>
     
                 <td> <input type="checkbox" disabled="disabled" property="legalOrArbitrationLevel2FlagC" id="legalOrArbitrationLevel2FlagC" checked="checked"></input>
						<html:hidden property="legalOrArbitrationLevel2Flag" styleId="legalOrArbitrationLevel2Flag"/>Legal / arbitration proceedings in the project </td>
						<%} %>
		<%if("N".equals(formObj.getLegalOrArbitrationLevel2Flag()) || null == formObj.getLegalOrArbitrationLevel2Flag()){ %>
		      <td> <input type="checkbox" disabled="disabled" property="legalOrArbitrationLevel2FlagC" id="legalOrArbitrationLevel2FlagC"></input>
						<html:hidden property="legalOrArbitrationLevel2Flag" styleId="legalOrArbitrationLevel2Flag"/>Legal / arbitration proceedings in the project </td>
		<%} %>
     	<td class="fieldname"></td>
     	<%if("Y".equals(formObj.getChngOfOwnPrjFlagNonInfraLevel2()) && null != formObj.getChngOfOwnPrjFlagNonInfraLevel2()){ %>
		<td width="30%"> <input type="checkbox"  disabled="disabled" id="chngOfOwnPrjFlagNonInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel2" styleId="chngOfOwnPrjFlagNonInfraLevel2"/>Change of ownership of project</td>
						<%} %>
			<%if("N".equals(formObj.getChngOfOwnPrjFlagNonInfraLevel2()) || null == formObj.getChngOfOwnPrjFlagNonInfraLevel2()){ %>
			<td width="30%"> <input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagNonInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel2" styleId="chngOfOwnPrjFlagNonInfraLevel2"/>Change of ownership of project</td>
			<%} %>
</tr>

<tr class="even" id = '9'>
   
     <td width="20%" class="fieldname"></td>
     <%if("Y".equals(formObj.getReasonBeyondPromoterLevel2Flag()) && null != formObj.getReasonBeyondPromoterLevel2Flag()){ %>	
                 <td><input type="checkbox" disabled="disabled" id="reasonBeyondPromoterLevel2FlagC" onclick="" checked="checked"></input>
						<html:hidden property="reasonBeyondPromoterLevel2Flag" styleId="reasonBeyondPromoterLevel2Flag"/> Reasons beyond control of promoter </td>
		<%} %>
	<%if("N".equals(formObj.getReasonBeyondPromoterLevel2Flag()) || null == formObj.getReasonBeyondPromoterLevel2Flag()){ %>	
                 <td><input type="checkbox" disabled="disabled" id="reasonBeyondPromoterLevel2FlagC" onclick=""></input>
						<html:hidden property="reasonBeyondPromoterLevel2Flag" styleId="reasonBeyondPromoterLevel2Flag"/> Reasons beyond control of promoter </td>
		<%} %>
	<td class="fieldname"></td>
	<%if("N".equals(formObj.getChngOfProjScopeNonInfraLevel2()) || null == formObj.getChngOfProjScopeNonInfraLevel2()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeNonInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel2" styleId="chngOfProjScopeNonInfraLevel2"/>Change of scope of project </td>
						<%} %>
	<%if("Y".equals(formObj.getChngOfProjScopeNonInfraLevel2()) && null != formObj.getChngOfProjScopeNonInfraLevel2()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeNonInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel2" styleId="chngOfProjScopeNonInfraLevel2"/>Change of scope of project </td>
						<%} %>
</tr>


<tr class="even" id = '10'>
   
     <td width="20%" class="fieldname"></td>
         <%if("Y".equals(formObj.getChngOfOwnPrjFlagInfraLevel2()) && null != formObj.getChngOfOwnPrjFlagInfraLevel2()){ %>	
                 <td> <input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel2" styleId="chngOfOwnPrjFlagInfraLevel2"/> Change of ownership of project </td>
						<%} %>
						
	<%if("N".equals(formObj.getChngOfOwnPrjFlagInfraLevel2()) || null == formObj.getChngOfOwnPrjFlagInfraLevel2()){ %>
                 <td> <input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel2" styleId="chngOfOwnPrjFlagInfraLevel2"/> Change of ownership of project </td>
						<%} %>
						
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>


<tr class="even" id = '11'>
   
    <td class="fieldname"></td>
             <%if("Y".equals(formObj.getChngOfProjScopeInfraLevel2()) && null != formObj.getChngOfProjScopeInfraLevel2()){ %>	
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeInfraLevel2C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeInfraLevel2" styleId="chngOfProjScopeInfraLevel2"/> Change of scope of project </td>
						<%} %>
	<%if("N".equals(formObj.getChngOfProjScopeInfraLevel2()) || null == formObj.getChngOfProjScopeInfraLevel2()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeInfraLevel2C" onclick=""></input>
						<html:hidden property="chngOfProjScopeInfraLevel2" styleId="chngOfProjScopeInfraLevel2"/> Change of scope of project </td>
						<%} %>
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>





<tr class="even" id = '12'>
   
     <td width="20%" class="fieldname">Reason for revision in ESCOD due to level 3 delay<font color="#FF0000">*</font> </td>	
                 <td>A. For Infra Projects</td>
	<td class="fieldname">&nbsp;</td>
		<td width="30%">B. For Non-Infra Projects</td>
</tr>

<tr class="even" id = '13'>
   
     <td width="20%" class="fieldname"> </td>	
                 <%if("Y".equals(formObj.getLegalOrArbitrationLevel3Flag()) && null != formObj.getLegalOrArbitrationLevel3Flag()){ %>	
                 <td><input type="checkbox" disabled="disabled" id="legalOrArbitrationLevel3FlagC" onclick="" checked="checked"></input>
						<html:hidden property="legalOrArbitrationLevel3Flag" styleId="legalOrArbitrationLevel3Flag"/> Legal / arbitration proceedings in the project </td>
				<%} %>
	<%if("N".equals(formObj.getLegalOrArbitrationLevel3Flag()) || null == formObj.getLegalOrArbitrationLevel3Flag()){ %>
                 <td><input type="checkbox" disabled="disabled" id="legalOrArbitrationLevel3FlagC" onclick=""></input>
						<html:hidden property="legalOrArbitrationLevel3Flag" styleId="legalOrArbitrationLevel3Flag"/> Legal / arbitration proceedings in the project </td>
				<%} %>
	<td class="fieldname"></td>
	   <%if("Y".equals(formObj.getChngOfOwnPrjFlagNonInfraLevel3()) && null != formObj.getChngOfOwnPrjFlagNonInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagNonInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel3" styleId="chngOfOwnPrjFlagNonInfraLevel3"/> Change of ownership of project </td>
		<%} %>
	<%if("N".equals(formObj.getChngOfOwnPrjFlagNonInfraLevel3()) || null == formObj.getChngOfOwnPrjFlagNonInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagNonInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagNonInfraLevel3" styleId="chngOfOwnPrjFlagNonInfraLevel3"/> Change of ownership of project </td>
		<%} %>
</tr>

<tr class="even" id = '14'>
   	   <%if("Y".equals(formObj.getReasonBeyondPromoterLevel3Flag()) && null != formObj.getReasonBeyondPromoterLevel3Flag()){ %>
     <td width="20%" class="fieldname"> </td>	
                 <td><input type="checkbox" disabled="disabled" id="reasonBeyondPromoterLevel3FlagC" onclick="" checked="checked"></input>
						<html:hidden property="reasonBeyondPromoterLevel3Flag" styleId="reasonBeyondPromoterLevel3Flag"/> Reasons beyond control of promoter </td>
						<%} %>
	<%if("N".equals(formObj.getReasonBeyondPromoterLevel3Flag()) || null == formObj.getReasonBeyondPromoterLevel3Flag()){ %>
     <td width="20%" class="fieldname"> </td>	
                 <td><input type="checkbox" disabled="disabled" id="reasonBeyondPromoterLevel3FlagC" onclick=""></input>
						<html:hidden property="reasonBeyondPromoterLevel3Flag" styleId="reasonBeyondPromoterLevel3Flag"/> Reasons beyond control of promoter </td>
						<%} %>
	<td class="fieldname"></td>
   	   <%if("Y".equals(formObj.getChngOfProjScopeNonInfraLevel3()) && null != formObj.getChngOfProjScopeNonInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeNonInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel3" styleId="chngOfProjScopeNonInfraLevel3"/> Change of scope of project </td>
						<%} %>
	<%if("N".equals(formObj.getChngOfProjScopeNonInfraLevel3()) || null == formObj.getChngOfProjScopeNonInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeNonInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfProjScopeNonInfraLevel3" styleId="chngOfProjScopeNonInfraLevel3"/> Change of scope of project </td>
						<%} %>
</tr>


<tr class="even" id = '15'>
   
     <td width="20%" class="fieldname"> </td>	
      <%if("Y".equals(formObj.getChngOfOwnPrjFlagInfraLevel3()) && null != formObj.getChngOfOwnPrjFlagInfraLevel3()){ %>
                 <td><input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel3" styleId="chngOfOwnPrjFlagInfraLevel3"/> Change of ownership of project </td>
						<%} %>
	<%if("N".equals(formObj.getChngOfOwnPrjFlagInfraLevel3()) || null == formObj.getChngOfOwnPrjFlagInfraLevel3()){ %>
                 <td><input type="checkbox" disabled="disabled" id="chngOfOwnPrjFlagInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfOwnPrjFlagInfraLevel3" styleId="chngOfOwnPrjFlagInfraLevel3"/> Change of ownership of project </td>
						<%} %>
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>


<tr class="even" id = '16'>
   
    <td class="fieldname"></td>
          <%if("Y".equals(formObj.getChngOfProjScopeInfraLevel3()) && null != formObj.getChngOfProjScopeInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeInfraLevel3C" onclick="" checked="checked"></input>
						<html:hidden property="chngOfProjScopeInfraLevel3" styleId="chngOfProjScopeInfraLevel3"/> Change of scope of project </td>
						<%} %>
		   <%if("N".equals(formObj.getChngOfProjScopeInfraLevel3()) || null == formObj.getChngOfProjScopeInfraLevel3()){ %>
		<td width="30%"><input type="checkbox" disabled="disabled" id="chngOfProjScopeInfraLevel3C" onclick=""></input>
						<html:hidden property="chngOfProjScopeInfraLevel3" styleId="chngOfProjScopeInfraLevel3"/> Change of scope of project </td>
						<%} %>
						<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
	
</tr>




<tr class="even" id = '17'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"leaglOrArbiProceed")?"fieldname":"fieldnamediff"%>" width="20%">Details of legal / arbitration proceedings&nbsp;</td>
          <td width="30%"><html:text  property="leaglOrArbiProceed" styleId="leaglOrArbiProceed" disabled="true" readonly="false"/> &nbsp;<html:errors property="leaglOrArbiProceed" /></td>
          
          <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"detailsRsnByndPro")?"fieldname":"fieldnamediff"%>" width="20%">Details of "reasons beyond control of promoter"&nbsp;</td>
          <td width="30%"><html:text  property="detailsRsnByndPro" styleId="detailsRsnByndPro" disabled="true" readonly="false"/> &nbsp;<html:errors property="detailsRsnByndPro" /></td>
</tr>


<tr class="even" id = '18'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"leaglOrArbiProceedLevel3")?"fieldname":"fieldnamediff"%>" width="20%">Details of legal / arbitration proceedings&nbsp;</td>
          <td width="30%"><html:text  property="leaglOrArbiProceedLevel3" styleId="leaglOrArbiProceedLevel3" disabled="true" readonly="false"/> &nbsp;<html:errors property="leaglOrArbiProceedLevel3" /></td>
          
          <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"detailsRsnByndProLevel3")?"fieldname":"fieldnamediff"%>" width="20%">Details of "reasons beyond control of promoter"&nbsp;</td>
          <td width="30%"><html:text  property="detailsRsnByndProLevel3" styleId="detailsRsnByndProLevel3" disabled="true" readonly="false"/> &nbsp;<html:errors property="detailsRsnByndProLevel3" /></td>
</tr>

<tr class="even" id = '19'>
<td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"recvPriorOfSCOD")?"fieldname":"fieldnamediff"%>" width="20%">Whether request for deferment received prior to expiry of SCOD</td>
    <td width="30%">
        <html:radio property="recvPriorOfSCOD" styleId="recvPriorOfSCOD" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="recvPriorOfSCOD" styleId="recvPriorOfSCOD" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="recvPriorOfSCOD"/>
    </td>
    	<td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
		</tr>
    


<tr class="even" id = '20'>

     <td width="20%" class="fieldname">&nbsp;</td>	
                 <td>&nbsp;</td>
       <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"reasonLevelTwoDelay")?"fieldname":"fieldnamediff"%>" width="20%">Reason for Deferment of SCOD in the event of level 2 delay&nbsp;</td>
          <td width="30%"><html:text  property="reasonLevelTwoDelay" styleId="reasonLevelTwoDelay" disabled="true" readonly="false"/> &nbsp;<html:errors property="reasonLevelTwoDelay" /></td>
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
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"promotersCapRunFlag")?"fieldname":"fieldnamediff"%>" width="20%">Do New Promoters have capability to run the project</td>
    <td width="30%">
        <html:radio property="promotersCapRunFlag" styleId="promotersCapRunFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersCapRunFlag" styleId="promotersCapRunFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersCapRunFlag"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"changeInScopeBeforeSCODFlag")?"fieldname":"fieldnamediff"%>" width="20%">Change in scope has taken place before SCOD&nbsp;</td>
    <td width="30%" >        
       <html:radio property="changeInScopeBeforeSCODFlag" styleId="changeInScopeBeforeSCODFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="changeInScopeBeforeSCODFlag" styleId="changeInScopeBeforeSCODFlag" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="changeInScopeBeforeSCODFlag"/>
    </td>
</tr>

<tr class="even" id = '23'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"promotersCapRunFlagL2")?"fieldname":"fieldnamediff"%>" width="20%">Do New Promoters have capability to run the project</td>
    <td width="30%">
        <html:radio property="promotersCapRunFlagL2" styleId="promotersCapRunFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersCapRunFlagL2" styleId="promotersCapRunFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersCapRunFlagL2"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"changeInScopeBeforeSCODFlagL2")?"fieldname":"fieldnamediff"%>" width="20%">Change in scope has taken place before SCOD&nbsp;</td>
    <td width="30%" >        
       <html:radio property="changeInScopeBeforeSCODFlagL2" styleId="changeInScopeBeforeSCODFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="changeInScopeBeforeSCODFlagL2" styleId="changeInScopeBeforeSCODFlagL2" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="changeInScopeBeforeSCODFlagL2"/>
    </td>
</tr>

<tr class="even" id = '24'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"promotersCapRunFlagL3")?"fieldname":"fieldnamediff"%>" width="20%">Do New Promoters have capability to run the project</td>
    <td width="30%">
        <html:radio property="promotersCapRunFlagL3" styleId="promotersCapRunFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersCapRunFlagL3" styleId="promotersCapRunFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersCapRunFlagL3"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"changeInScopeBeforeSCODFlagL3")?"fieldname":"fieldnamediff"%>" width="20%">Change in scope has taken place before SCOD&nbsp;</td>
    <td width="30%" >        
       <html:radio property="changeInScopeBeforeSCODFlagL3" styleId="changeInScopeBeforeSCODFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="changeInScopeBeforeSCODFlagL3" styleId="changeInScopeBeforeSCODFlagL3" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="changeInScopeBeforeSCODFlagL3"/>
    </td>
</tr>

<tr class="even" id = '25'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"promotersHoldEquityFlag")?"fieldname":"fieldnamediff"%>" width="20%">Do New promoters hold 51% equity in the project</td>
    <td width="30%">
        <html:radio property="promotersHoldEquityFlag" styleId="promotersHoldEquityFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersHoldEquityFlag" styleId="promotersHoldEquityFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersHoldEquityFlag"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"costOverrunOrg25CostViabilityFlag")?"fieldname":"fieldnamediff"%>" width="20%">Cost Overrun > 25% of original project cost&nbsp;</td>
    <td width="30%" >        
       <html:radio property="costOverrunOrg25CostViabilityFlag" styleId="costOverrunOrg25CostViabilityFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="costOverrunOrg25CostViabilityFlag" styleId="costOverrunOrg25CostViabilityFlag" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="costOverrunOrg25CostViabilityFlag"/>
    </td>
</tr>

<tr class="even" id = '26'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"promotersHoldEquityFlagL2")?"fieldname":"fieldnamediff"%>" width="20%">Do New promoters hold 51% equity in the project</td>
    <td width="30%">
        <html:radio property="promotersHoldEquityFlagL2" styleId="promotersHoldEquityFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersHoldEquityFlagL2" styleId="promotersHoldEquityFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersHoldEquityFlagL2"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"costOverrunOrg25CostViabilityFlagL2")?"fieldname":"fieldnamediff"%>" width="20%">Cost Overrun > 25% of original project cost&nbsp;</td>
    <td width="30%" >        
       <html:radio property="costOverrunOrg25CostViabilityFlagL2" styleId="costOverrunOrg25CostViabilityFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="costOverrunOrg25CostViabilityFlagL2" styleId="costOverrunOrg25CostViabilityFlagL2" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="costOverrunOrg25CostViabilityFlagL2"/>
    </td>
</tr>

<tr class="even" id = '27'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"promotersHoldEquityFlagL3")?"fieldname":"fieldnamediff"%>"  width="20%">Do New promoters hold 51% equity in the project</td>
    <td width="30%">
        <html:radio property="promotersHoldEquityFlagL3" styleId="promotersHoldEquityFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="promotersHoldEquityFlagL3" styleId="promotersHoldEquityFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="promotersHoldEquityFlagL3"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"costOverrunOrg25CostViabilityFlagL3")?"fieldname":"fieldnamediff"%>" width="20%">Cost Overrun > 25% of original project cost&nbsp;</td>
    <td width="30%" >        
       <html:radio property="costOverrunOrg25CostViabilityFlagL3" styleId="costOverrunOrg25CostViabilityFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="costOverrunOrg25CostViabilityFlagL3" styleId="costOverrunOrg25CostViabilityFlagL3" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="costOverrunOrg25CostViabilityFlagL3"/>
    </td>
</tr>


<tr class="even" id = '28'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"hasProjectViabReAssFlag")?"fieldname":"fieldnamediff"%>" width="20%">Has project viability been re-assessed</td>
    <td width="30%">
        <html:radio property="hasProjectViabReAssFlag" styleId="hasProjectViabReAssFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="hasProjectViabReAssFlag" styleId="hasProjectViabReAssFlag" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="hasProjectViabReAssFlag"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectViabReassesedFlag")?"fieldname":"fieldnamediff"%>" width="20%"> Project Viability reassessed&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectViabReassesedFlag" styleId="projectViabReassesedFlag" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="projectViabReassesedFlag" styleId="projectViabReassesedFlag" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectViabReassesedFlag"/>
    </td>
</tr>

<tr class="even" id = '29'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"hasProjectViabReAssFlagL2")?"fieldname":"fieldnamediff"%>" width="20%">Has project viability been re-assessed</td>
    <td width="30%">
        <html:radio property="hasProjectViabReAssFlagL2" styleId="hasProjectViabReAssFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="hasProjectViabReAssFlagL2" styleId="hasProjectViabReAssFlagL2" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="hasProjectViabReAssFlagL2"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectViabReassesedFlagL2")?"fieldname":"fieldnamediff"%>" width="20%"> Project Viability reassessed&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectViabReassesedFlagL2" styleId="projectViabReassesedFlagL2" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="projectViabReassesedFlagL2" styleId="projectViabReassesedFlagL2" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectViabReassesedFlagL2"/>
    </td>
</tr>

<tr class="even" id = '30'>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"hasProjectViabReAssFlagL3")?"fieldname":"fieldnamediff"%>" width="20%">Has project viability been re-assessed</td>
    <td width="30%">
        <html:radio property="hasProjectViabReAssFlagL3" styleId="hasProjectViabReAssFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
        <html:radio property="hasProjectViabReAssFlagL3" styleId="hasProjectViabReAssFlagL3" value="N" onclick="" />&nbsp;No&nbsp;
        &nbsp;<html:errors property="hasProjectViabReAssFlagL3"/>
    </td>
    <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"projectViabReassesedFlagL3")?"fieldname":"fieldnamediff"%>" width="20%"> Project Viability reassessed&nbsp;</td>
    <td width="30%" >        
       <html:radio property="projectViabReassesedFlagL3" styleId="projectViabReassesedFlagL3" value="Y" onclick=""  />&nbsp;Yes&nbsp;
       <html:radio property="projectViabReassesedFlagL3" styleId="projectViabReassesedFlagL3" value="N" onclick=""  />&nbsp;No&nbsp;
         &nbsp;<html:errors property="projectViabReassesedFlagL3"/>
    </td>
</tr>



 <tr class="even" id = "34">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssetClassL1")?"fieldname":"fieldnamediff"%>">Existing Asset classification</td>
	 <td>
	<html:select property="exstAssetClassL1" styleId="exstAssetClassL1" value="<%=formObj.getExstAssetClassL1()%>" disabled="true"  onchange="">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClassL1"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssClassDateL1")?"fieldname":"fieldnamediff"%>">Existing Asset classification Date<font color="#FF0000">*</font> </td>	
		     <%if (!"".equals(formObj.getExstAssClassDateL1()) && formObj.getExstAssClassDateL1() != null){ %>
                 <td><html:text property="exstAssClassDateL1" style="width:90px" disabled="true" readonly="true" />
									             </td><%}else{ %>
				 <td><html:text property="exstAssClassDateL1" style="width:90px" readonly="true" disabled="true" />
									             </td>
									             <%} %>
									             </tr>
								 	             
				<tr class="even" id = "35">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssetClassL2")?"fieldname":"fieldnamediff"%>">Existing Asset classification</td>
	 <td>
	<html:select property="exstAssetClassL2" styleId="exstAssetClassL2" value="<%=formObj.getExstAssetClassL2()%>" disabled="true" onchange="">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClassL2"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssClassDateL2")?"fieldname":"fieldnamediff"%>">Existing Asset classification Date<font color="#FF0000">*</font> </td>
		   <%if (!"".equals(formObj.getExstAssClassDateL2()) && formObj.getExstAssClassDateL2() != null){ %>	
                 <td><html:text property="exstAssClassDateL2" style="width:90px" readonly="true" disabled="true"/>
									             </td><%}else{ %>
				 <td><html:text property="exstAssClassDateL2" style="width:90px" readonly="true" disabled="true" />
									             </td>
									             <%} %>
									             </tr>
									             
									             
				<tr class="even" id = "40">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssetClassL3")?"fieldname":"fieldnamediff"%>">Existing Asset classification</td>
	 <td>
	<html:select property="exstAssetClassL3" styleId="exstAssetClassL3" value="<%=formObj.getExstAssetClassL3()%>" disabled="true" onchange="">
	                  			<integro:common-code categoryCode="EXE_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="exstAssetClassL3"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"exstAssClassDateL3")?"fieldname":"fieldnamediff"%>">Existing Asset classification Date<font color="#FF0000">*</font> </td>	
		    <%if (!"".equals(formObj.getExstAssClassDateL3()) && formObj.getExstAssClassDateL3() != null){ %>	
                 <td><html:text property="exstAssClassDateL3" style="width:90px" readonly="true" disabled="true" />
									             </td><%}else{ %>
				 <td><html:text property="exstAssClassDateL3" style="width:90px" readonly="true" disabled="true"/>
									             </td>
									             <%} %>
									             </tr>
									             
									            

									             
		 <tr class="even" id = "37">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revisedAssetClassL1")?"fieldname":"fieldnamediff"%>">Revised Asset Classification</td>
	 <td>
	<html:select property="revisedAssetClassL1" styleId="revisedAssetClassL1" value="<%=formObj.getRevisedAssetClassL1()%>" disabled="true"  onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClassL1"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsdAssClassDateL1")?"fieldname":"fieldnamediff"%>">Revised Asset Classification Date<font color="#FF0000">*</font> </td>
		   <%if (!"".equals(formObj.getRevsdAssClassDateL1()) && formObj.getRevsdAssClassDateL1() != null){ %>		
                 <td><html:text property="revsdAssClassDateL1" style="width:90px" disabled="true" readonly="true"/>
									             </td><%}else{ %>
				 <td><html:text property="revsdAssClassDateL1" style="width:90px" readonly="true" disabled="true" />
									             </td>
									             <%} %>
									             </tr>
									             
	<tr class="even" id = "38">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revisedAssetClass_L2")?"fieldname":"fieldnamediff"%>">Revised Asset Classification</td>
	 <td>
	<html:select property="revisedAssetClass_L2" styleId="revisedAssetClass_L2" value="<%=formObj.getRevisedAssetClass_L2()%>" disabled="true"  onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClass_L2"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsdAssClassDate_L2")?"fieldname":"fieldnamediff"%>">Revised Asset Classification Date<font color="#FF0000">*</font> </td>	
		   <%if (!"".equals(formObj.getRevsdAssClassDate_L2()) && formObj.getRevsdAssClassDate_L2() != null){ %>		
                 <td><html:text property="revsdAssClassDate_L2" style="width:90px" readonly="true" disabled="true" />
									             </td><%}else{ %>
				     <td><html:text property="revsdAssClassDate_L2" style="width:90px" readonly="true" disabled="true"/>
									             </td>
									             <%} %>
									             </tr>
									             
	
	<tr class="even" id = "39">
	  <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revisedAssetClass_L3")?"fieldname":"fieldnamediff"%>">Revised Asset Classification</td>
	 <td>
	<html:select property="revisedAssetClass_L3" styleId="revisedAssetClass_L3" value="<%=formObj.getRevisedAssetClass_L3()%>" disabled="true" onchange="">
	                  			<integro:common-code categoryCode="REV_ASSET_CLASS_ID"
	                  					 descWithCode="false" />   
							 </html:select><html:errors property="revisedAssetClass_L3"/></td>
		 <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsdAssClassDate_L3")?"fieldname":"fieldnamediff"%>">Revised Asset Classification Date<font color="#FF0000">*</font> </td>	
		    <%if (!"".equals(formObj.getRevsdAssClassDate_L3()) && formObj.getRevsdAssClassDate_L3() != null){ %>		
                 <td><html:text property="revsdAssClassDate_L3" style="width:90px" readonly="true" disabled="true"/>
									             </td><%}else{ %>
				 <td><html:text property="revsdAssClassDate_L3" style="width:90px" readonly="true" disabled="true" />
									             </td>
									             <%} %>
									             </tr>
									             
	<tr class="even" id = '31'>

     <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsedESCODStpDate")?"fieldname":"fieldnamediff"%>">Revised ESCOD stipulated in the event of first level delay in SCOD<font color="#FF0000">*</font> </td>
      <%if (!"".equals(formObj.getRevsedESCODStpDate()) && formObj.getRevsedESCODStpDate() != null){ %>		
                 <td><html:text property="revsedESCODStpDate" styleId="revsedESCODStpDate" style="width:90px" disabled="true" />
									             </td><%}else{ %>
					  <td><html:text property="revsedESCODStpDate" styleId="revsedESCODStpDate" style="width:90px" disabled="true" />
									             </td>
									             <%} %>
      <td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
</tr>

<tr class="even" id = '32'>

     <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsedESCODStpDateL2")?"fieldname":"fieldnamediff"%>">Revised ESCOD stipulated in the event of second level delay in SCOD<font color="#FF0000">*</font> </td>	
          <%if (!"".equals(formObj.getRevsedESCODStpDateL2()) && formObj.getRevsedESCODStpDateL2() != null){ %>		
                 <td><html:text property="revsedESCODStpDateL2" styleId="revsedESCODStpDateL2" style="width:90px" disabled="true" />
									             </td><%}else{ %>
				  <td><html:text property="revsedESCODStpDateL2" styleId="revsedESCODStpDateL2" style="width:90px" readonly="false" disabled="true" />
									             </td>
									             <%} %>
      <td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
</tr>

<tr class="even" id = '33'>

     <td width="20%" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"revsedESCODStpDateL3")?"fieldname":"fieldnamediff"%>">Revised ESCOD stipulated in the event of third level delay in SCOD<font color="#FF0000">*</font> </td>	
           <%if (!"".equals(formObj.getRevsedESCODStpDateL3()) && formObj.getRevsedESCODStpDateL3() != null){ %>		
                 <td><html:text property="revsedESCODStpDateL3" styleId="revsedESCODStpDateL3" style="width:90px" disabled="true" />
									             </td><%}else{ %>
					 <td><html:text property="revsedESCODStpDateL3" styleId="revsedESCODStpDateL3" style="width:90px" disabled="true" />
									             </td>				             
									             <%} %>
      <td class="fieldname">&nbsp;</td>
		<td width="30%">&nbsp;</td>
</tr>						



<%} %>


<%} %>



<!-- New CAM Format changes -->
 <tr class="odd">        
       <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"tenor")?"fieldname":"fieldnamediff"%>" width="20%">Tenor&nbsp;</td>
        <td width="30%">
              <html:select property="tenorUnit" value="<%=formObj.getTenorUnit()%>" disabled="true">
                  <integro:common-code
									categoryCode="<%=com.integrosys.cms.ui.limit.CategoryCodeConstant.FACILITY_TENOR%>" descWithCode="false" />   
					</html:select>

				&nbsp;	
				<bean:write name="LmtDetailForm" property="tenor"/>&nbsp;	
            	<html:hidden property="tenorUnit"/>

            <html:hidden property="tenor"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"margin")?"fieldname":"fieldnamediff"%>" width="20%">Margin %&nbsp;</td>
        <td width="30%">
            <bean:write name="LmtDetailForm" property="margin"/>&nbsp;
            <html:hidden property="margin"/>
        </td> 
    </tr>

	<tr class="even">        
       <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"tenorDesc")?"fieldname":"fieldnamediff"%>" width="20%">Tenor Description&nbsp;</td>
        <td width="30%">

				<bean:write name="LmtDetailForm" property="tenorDesc"/>&nbsp;	
            	<html:hidden property="tenorDesc"/>
        </td>
        <%if("on".equals(availAndOptionApplicable)){ %>
        <td id="putCallOptionHeading" class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"putCallOption")?"fieldname":"fieldnamediff"%>" width="20%">Put / Call Option&nbsp;</td>
        <td width="30%" id="putCallOptionField">

            <%if("PUT".equals(formObj.getPutCallOption())){ %>
        	Put
        <%}else if("CALL".equals(formObj.getPutCallOption())){%>
        	Call
        <%} %>
		<%} %>
            <html:hidden property="putCallOption"/>
        </td> 
    </tr>

<%if("on".equals(availAndOptionApplicable)){ %>
    <tr class="odd" id="loanOptionAvailabilityId">        
       <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"loanAvailabilityDate")?"fieldname":"fieldnamediff"%>" width="20%">Loan Availability Date&nbsp;</td>
        <td width="30%">
				<bean:write name="LmtDetailForm" property="loanAvailabilityDate"/>&nbsp;	
            	<html:hidden property="loanAvailabilityDate"/>
        </td> 
        <td class="<%=CompareOBUtil.compOB(stageLimit,actualLimit,"optionDate")?"fieldname":"fieldnamediff"%>" width="20%">Option Date&nbsp;</td>
        <td width="30%">
				<bean:write name="LmtDetailForm" property="optionDate"/>&nbsp;	
            	<html:hidden property="optionDate"/>
        </td> 
    </tr>
<%} %>




</table>
</td>
</tr>
</tbody>

<br>
<br>



<%if(isFacilityCamCovenantReq) {%>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:20px">
      <thead>
    	<tr>
	    	<td>
	    		<p>
	    		<h4>I agree, I have read / reviewed all the covenant details: <html:checkbox property="isCamCovenantVerified" value="Y"/></h4> 
		    	</p>
		    	<html:errors property="loaMasterCamCovenantError"/>
	    	</td>
    	</tr>
	  </thead>
</</table>

<%}%>

<%if("Y".equals(formObj.getFacCoBorrowerInd())){ %>
	<jsp:include page="view_fac_co_borrower_details.jsp" />
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
                <input class="btnNormal" type="button" name="btnedit_viewCovenant" id="btnedit_viewCovenant" disabled = "disabled" value="View" onclick="javascript : viewConvenantScreen('view_covenant_detail_ubs')">				
            </td>
        </tr>
    </tbody>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
    <thead>
        <tr>
            <td><h3>Line Details</h3></td>
        </tr>
        <tr>
            <td><hr/></td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tblInput">
                    <thead>
                        <tr><html:errors property="idlexpirydateerrorchecker"/>
                             <td width="2%">Serial No.</td>
                            <td width="18%">Interest Rate</td>
                            <td width="15%">Released Amount</td>
                            <td width="15%">Released Date</td>
                            <td width="16%">Utilized Amount  </td>
							<td width="16%">Undrawn Limit </td>	
							<td width="8%">Status </td>	
                            <td width="9%">Action</td> 
                        </tr>
                    </thead>
                    <tbody>
                        <logic:present name="LmtDetailForm" property="acntRefSummaryList" scope="request">
                            <bean:define id="acntrefSize" value="<%= String.valueOf(formObj.getAcntRefSummaryList().size()) %>"/>
                            <logic:notEqual name="acntrefSize" value="0">
                                <logic:iterate id="acntrefitm" indexId="acntrefind" name="LmtDetailForm" property="acntRefSummaryList" scope="request"
                                               type="java.lang.Object">
                                    <% String headerClass = "index"; 
                                        ICustomerSysXRef acntRef = null;
                                        Long sId = null;
                                        if (acntrefitm instanceof CompareResult) {
                                            acntRef = ((ILimitSysXRef) ((CompareResult) acntrefitm).getObj()).getCustomerSysXRef();
                                            sId = ((ILimitSysXRef) ((CompareResult) acntrefitm).getObj()).getSID();
                                            headerClass = ((CompareResult) acntrefitm).getKey();
                                        } else {
                                            acntRef = ((ILimitSysXRef) acntrefitm).getCustomerSysXRef();
                                            sId =  ((ILimitSysXRef) acntrefitm).getSID();
                                        } 
                                        BigDecimal undrawnAmount = new BigDecimal("0");

                            //            System.out.println("totalReleasedAmount:"+totalReleasedAmount);
                                		if(acntRef != null){
                                		if(acntRef.getReleasedAmount()==null){
                                			acntRef.setReleasedAmount("0");

                                		}
										}else{
										System.out.println("Exception => acntRef is null.....");
										}
                                        
                                        undrawnAmount = new BigDecimal(acntRef.getReleasedAmount()).subtract(new BigDecimal(acntRef.getUtilizedAmount()));
                                        
                                        System.out.println("acntRef.getSerialNo():"+acntRef.getSerialNo());
                                        System.out.println("acntRef.getAction():"+acntRef.getAction());
                                        String serialNo="";
                                        
                                        if(null!=acntRef.getSerialNo()){
                                         serialNo=acntRef.getSerialNo();
                                        }else{
                                        	serialNo=acntRef.getHiddenSerialNo();
                                        	acntRef.setSerialNo(acntRef.getHiddenSerialNo());
                                        }
                                        
                                        String facilitySystemId=acntRef.getFacilitySystemID();
                                        String index=facilitySystemId+serialNo;
                                        String loaMasterLimitReleaseAmtError = String.valueOf(sId)+"loaMasterLimitReleaseAmtError";
                                        %>
                                    <tr class="<%=(acntrefind.intValue() + 1)%2==0?"even":"odd"%>">
                                        <td class="<%=headerClass%>">

											<%if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()) && !"N".equals(acntRef.getSendToFile()) && ICMSConstant.FCUBS_STATUS_PENDING_SUCCESS.equals(acntRef.getStatus())){ %>
                                        &nbsp;<integro:empty-if-null value="<%=acntRef.getSerialNo()%>"/>
                                        <%} else if(ICMSConstant.FCUBSLIMIT_ACTION_NEW.equals(acntRef.getAction()) && ((!"N".equals(acntRef.getSendToFile()) &&!"HONGKONG".equalsIgnoreCase(acntRef.getFacilitySystem())&& !"GIFTCITY".equalsIgnoreCase(acntRef.getFacilitySystem()) && !singapore.equalsIgnoreCase(acntRef.getFacilitySystem()) ))){ %>
                                        &nbsp;<integro:empty-if-null value="<%=acntRef.getSerialNo()%>"/>
                                        <%}else{ %>
                                          &nbsp;<integro:empty-if-null value="<%=acntRef.getSerialNo()%>"/>

                                            <%} %>
                                        </td>
                                        <% if(acntRef.getInterestRateType() != null) {
                                        if(acntRef.getInterestRateType().equals("fixed")) {%>
                                        <td>
                                            &nbsp;<integro:empty-if-null value="<%= acntRef.getIntRateFix() %>"/>
                                        </td>
                                        <%}else { %>
                                        <td>
                                               <% if(acntRef.getIntRateFloatingMarginFlag().equals("-")){%>
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
                                            &nbsp;<integro:amount param="amount" decimal="2" amount="<%=UIUtil.convertToAmount(locale,CommonUtil.getBaseCurrency(),acntRef.getReleasedAmount())%>"/>
                                            <br>
                                            <html:errors property="<%=loaMasterLimitReleaseAmtError%>"/>
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
                                        	<select name="select2"
												onchange="javascript:updateXRef(this.value,'<%= index %>','<%=fcunsSystem %>','<%=ubslimitSystem %>')">
												<option value="">Please Select</option>
												<option value="view">View</option>
											</select>
                                       </td> 
                                    </tr>
                                </logic:iterate>
                                <!-- <tr class="odd">
                                    	<td colspan="8">
                                    		
                                    	</td>
                                 </tr> -->
                            </logic:notEqual>
                            <logic:equal name="acntrefSize" value="0">
                                <tr class="odd">
                                    <td colspan="7">There is no line for facility.</td>
                                </tr>
                            </logic:equal>
                        </logic:present>
                        <logic:notPresent name="LmtDetailForm" property="acntRefSummaryList" scope="request">
                            <tr class="odd">
                                <td colspan="7">There is no line for facility.</td>
                            </tr>
                        </logic:notPresent>
                    </tbody>
                </table>
                <table width="58%" align="center">
                <tbody>
                <tr>
                    <td>
                		<html:errors property="notAllowedError"/>
                	</td>
                </tr>
                </tbody>
                </table>
            </td>
        </tr>
    </tbody>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection" style="margin-top:10px">
    <thead>
        <tr>
            <td><h3>Limit Security Mapping</h3></td>
        </tr>
        <tr>
            <td><hr/></td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tblInput">
                    <thead>
                        <tr>
                           <td width="2%">S/N</td>
                            <td width="21%">Source Security ID</td>
                            <td width="16%">Collateral Code-Name</td>
                            <td width="16%">Security Type</td>
                            <td width="16%">Security Sub-Type</td>
                            <td width="16%">Security Coverage</td>
                            <td width="14%">Action</td>
                        </tr>
                    </thead>
                    <tbody>
                        <logic:present name="LmtDetailForm" property="lmtSecSummaryList" scope="request">
                            <bean:define id="lmtsecSize" value="<%= String.valueOf(formObj.getLmtSecSummaryList().size()) %>"/>
                            <logic:notEqual name="lmtsecSize" value="0">
                                <logic:iterate id="lmtsecitm" indexId="lmtsecind"
                                               name="LmtDetailForm" property="lmtSecSummaryList" scope="request"
                                               type="com.integrosys.cms.ui.manualinput.limit.LmtSecSummaryItem">
                                    <tr class="<bean:write name="lmtsecitm" property="rowClass" />">
                                        <td class="<bean:write name="lmtsecitm" property="headerClass" />">
                                          <%= lmtsecind.intValue() + 1 %>
                                        </td>
                                        <td>&nbsp;<bean:write name="lmtsecitm" property="sciSecurityId"/></td>
                                        <td>&nbsp;<% if(lmtsecitm!=null)%>
                                        <integro:empty-if-null value="<%=collateralMap.get(lmtsecitm.getCollateralId()) %>"/></td>
                                        <td>&nbsp;<bean:write name="lmtsecitm" property="securityType"/></td>
                                        <td>&nbsp;<bean:write name="lmtsecitm" property="securitySubType"/></td>
                                        <td>&nbsp;<bean:write name="lmtsecitm" property="lmtSecurityCoverage"/></td>
                                        <td>
                                            <select name="secOption" onchange="javascript:deleteLmtSec('<%= lmtsecind.toString() %>', this.value,'<%= lmtsecitm.getSciSecurityId() %>' ,'<%= lmtsecitm.getSecuritySubType() %>' )" >
                                            <option value="">Please Select</option>
                                            <option value="View">View</option>
                                            </select>
                                            &nbsp;
                                            <html:hidden property="deletedLmtSec" value="<%= lmtsecind.toString() %>"/>
                                        </td>
                                    </tr>
                                </logic:iterate>
                            </logic:notEqual>
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
            </td>
        </tr>
    </tbody>
</logic:notEmpty>
<jsp:include page="scod_detail_hidden.jsp"></jsp:include>
