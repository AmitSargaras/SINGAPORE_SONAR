<%@ page import="com.integrosys.cms.app.common.constant.ICMSConstant,
				 java.util.List,
			     com.integrosys.base.uiinfra.tag.PageIndex,
				 com.integrosys.cms.ui.manualinput.limit.EventConstant,
				 com.integrosys.cms.app.collateral.bus.OBCollateral,
                 com.integrosys.cms.ui.manualinput.limit.LmtSecMappingForm" %>

<%@ taglib uri="/WEB-INF/IntegroTag.tld" prefix="integro" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@page import="com.integrosys.cms.ui.collateral.CategoryCodeConstant"%><html> <!-- InstanceBegin template="/Templates/ContentPage.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Untitled Document</title>
<!-- InstanceEndEditable -->

<!-- InstanceBeginEditable name="CssStyle" -->

<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
  <script type="text/javascript" src="js/emulation.js"></script>
  <script language="JavaScript" src="js/itgPrjConfigSetup.js"></script>
  <script language="JavaScript" src="js/itgCheckForm.js"></script>
  <script type="text/javascript" src="js/calendar.js"></script>
  <script type="text/javascript" src="js/calDriver.js"></script>
  <script type="text/javascript" src="js/imageNavigation.js"></script>
</head>
<body onload="MM_preloadImages('img/save2.gif','img/cancel2.gif')">
<% 
   String startInd = (String)request.getParameter("startIndex");
   String totalCount = (String)request.getAttribute("totalSecCount");
   int length = 10;
   int startIndex = (startInd == null || "".equals(startInd))?0:Integer.parseInt(startInd);
   int totalSecCount = (totalCount == null || "".equals(totalCount))?0:Integer.parseInt(totalCount);
   
   List countryList=(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.countryList");
   pageContext.setAttribute("countryList",countryList);
   
   List currencyList=(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.currencyList");
   pageContext.setAttribute("currencyList",currencyList);
   
   List orgList =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.orgList");
   pageContext.setAttribute("orgList",orgList);
   
   List collCodeDescMap =(List) session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.collCodeDescMap");
   pageContext.setAttribute("collCodeDescMap",collCodeDescMap);
   
   String context = request.getContextPath() + "/";

	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
   
%>
<script language="javascript">
	function searchSecurity()
	{
		document.forms[0].totalSecCount.value = "";
		document.forms[0].submit();
	}

	function goPageIndex(stInd)
	{
		document.forms[0].startIndex.value = stInd;
		document.forms[0].submit();
	}

	function saveSecurityLink()	{
		document.forms[0].event.value = 'create';
		document.forms[0].submit();
	}

	function cancelSubmit()
	{
		if(document.forms[0].fromEvent.value == 'prepare_close'){
			   document.forms[0].trxID.value == '<%=request.getParameter("trxID")%>';
			   document.forms[0].action="MILimit.do?event=prepare_close"+ "&trxID="+document.forms[0].trxID.value;
			    document.forms[0].submit();
		}else if(document.forms[0].fromEvent.value == 'custread'){
			 document.forms[0].limitId.value = '<%= request.getAttribute("lmtId")%>';
			 document.forms[0].action="MILimitList.do?event=show_lmt_cust_detail";
			 document.forms[0].submit();
		}else if(document.forms[0].fromEvent.value == 'prepare_cust_update'){
			   document.forms[0].limitId.value = '<%= request.getAttribute("lmtId")%>';
			   document.forms[0].action="MILimit.do?event=prepare_cust_update";
			   document.forms[0].submit();
		}else if(document.forms[0].fromEvent.value == 'view_sec'){
			 document.forms[0].limitId.value = '<%= request.getAttribute("lmtId")%>';
			 document.forms[0].action="MILimitList.do?event=show_lmt_detail";
			 document.forms[0].submit();
		}else if(document.forms[0].fromEvent.value == 'process'){
			   document.forms[0].trxID.value == '<%=request.getParameter("trxID")%>';
			   document.forms[0].action="MILimit.do?event=process"+ "&trxID="+document.forms[0].trxID.value;
			    document.forms[0].submit();
		 }else if(document.forms[0].fromEvent.value == 'update'){
			   document.forms[0].trxID.value == '<%=request.getParameter("trxID")%>';
			   document.forms[0].action="MILimit.do?event=track"+ "&trxID="+ document.forms[0].trxID.value ;
			    document.forms[0].submit();
		 }else if(document.forms[0].fromEvent.value == 'track'){
			   document.forms[0].trxID.value == '<%=request.getParameter("trxID")%>';
			   document.forms[0].action="MILimit.do?event=track"+ "&trxID="+ document.forms[0].trxID.value ;
			    document.forms[0].submit();
		 } else if(document.forms[0].fromEvent.value == 'prepare_delete'){
			 document.forms[0].limitId.value = '<%= request.getAttribute("lmtId")%>';
			   document.forms[0].action="MILimitList.do?event=del_limit";
			    document.forms[0].submit();
		}else {
				document.forms[0].event.value = 'cancel';
				document.forms[0].submit();
			}
	}
	
	function createNewSecurity()
    {
		document.forms[0].event.value = '<%=EventConstant.EVENT_CREATE_NEW_SEC%>';
		document.forms[0].submit();		
    }
</script>
<html:form action="MILmtSecDetail.do">
 <input type="hidden" name="event" value="search_secdetail"/>
 <input type="hidden" name="startIndex" value="0"/>
 <input type="hidden" name="totalSecCount" value="<%= totalCount==null?"":totalCount %>" /> 
 <html:hidden property="fromEvent"/>
 <html:hidden property="limitProfileID"/>
 <html:hidden property="customerID"/>
 <html:hidden property="indexID"/>
  <input type="hidden" name="trxID" value="<%=request.getParameter("trxID") %>"/>
 <input type="hidden" name="limitId" value="<%=request.getParameter("lmtId") %>"/>
   <input type="hidden"  name="inrValue" readonly="readonly" value="<%=(String)session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.inrValue") %>"/>
    <input type="hidden" name="fundedAmount" value="<%=(String)request.getAttribute("fundedAmount") %>"/>
	<input type="hidden" name="nonFundedAmount" value="<%=(String)request.getAttribute("nonFundedAmount")  %>" />
    <input type="hidden" name="memoExposer"  value="<%=(String)request.getAttribute("memoExposer")  %>" />
	<input type="hidden" name="sanctionedLimit"	value="<%=(String)request.getAttribute("sanctionedLimit") %>" />
 <html:hidden property="isCreate"/> 
 <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="tblFormSection">
      <thead>
    <%  OBCollateral col = ((OBCollateral)(session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.collateral"))); 
    	if (col == null) {
    		col = ((OBCollateral)(session.getAttribute("com.integrosys.cms.ui.manualinput.limit.LmtDetailAction.collObj"))); 
    	}
    %>
    
        <tr> 
          <td width="81%" ><h3>Security Details</h3></td>
          <td width="19%" align="right" valign="bottom" >&nbsp; </td>
        </tr>
        <tr> 
          <td colspan="2"> <hr/> </td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td colspan="2">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tblInfo">
              <tbody>
                <tr class="odd">
                  <td class="fieldname" width="20%">Source Security ID&nbsp;</td>
                  <td width="30%">
                    <%= col.getCollateralID() %>
		  </td>
		  <td class="fieldname" width="20%">Security Booking Country&nbsp;<font color="#FF0000">*</font></td>
                  <td width="30%">
                  <html:select property="secBookingCountry"  value="<%= col.getCollateralLocation() %>" disabled="true">
		      		<option value="">Please Select </option>	
                      <html:options collection="countryList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;
                  </td>
                </tr>
                <tr class="even">
                  <td class="fieldname" width="20%">Security Branch Name&nbsp;</td>
                  <td width="30%">
                   <html:select property="secBookingOrg" value="<%= col.getSecurityOrganization() %>" disabled="true">
		      <option value="">Please Select </option>	
                      <html:options collection="orgList" property="value" labelProperty="label"/>
                    </html:select>&nbsp;
		  </td>
		  <td class="fieldname" width="20%">Security Currency&nbsp;<font color="#FF0000">*</font></td>
                  <td width="30%">
                  <html:select property="secCurrency" value="<%= col.getCurrencyCode().trim()%>" disabled="true">
		      <option value="">Please Select </option>	
                      <html:options collection="currencyList" property="value" labelProperty="label" />
                    </html:select>&nbsp;
                   
                  </td>
                </tr>	
		<tr class="odd">
				<td class="fieldname" width="20%">Security Type&nbsp;<font color="#FF0000">*</font></td>
                  <td width="30%">
                     <%= col.getCollateralSubType().getTypeName()%>
                  </td>
                  <td class="fieldname" width="20%">Security Sub-Type&nbsp;<font color="#FF0000">*</font></td>
                  <td width="30%">
                    <%= col.getCollateralSubType().getSubTypeName()%>
		  </td>
         </tr>	  
         <tr class="odd">
            <td class="fieldname">Collateral Code-Name<font color="#FF0000">*</font></td>
            <td width="30%">
             <html:select property="collateralCode" value="<%= col.getCollateralCode() %>" disabled="true">
		      <option value="">Please Select </option>	
                      <html:options collection="collCodeDescMap" property="label" labelProperty="value" />
                    </html:select>&nbsp;
             
             </td>
           
            <td class="fieldname">Security Priority <font color="#FF0000">*</font></td>
            <td><%if(col.getSecPriority() != null && col.getSecPriority().equals("Y")) {%>
            		Primary 
            <%}else{ %>
            		Secondary 
            <%} %>
            </td>
          </tr>
          <tr class="odd">
              <td class="fieldname">Monitoring Process of Collaterals<font color="#FF0000">*</font></td>
             <%if(col.getMonitorProcess()!=null && !col.getMonitorProcess().equals("")){
            	 String process=col.getMonitorProcess();
            	 if(process.equals("Y"))
            		 process="Yes";
            	 if(process.equals("N"))
            		 process="No";       	 
            	 %>
            <td><%= process %></td>
            <%}else{ %>
             <td>-</td>
            <%} %>
            <td class="fieldname">Monitoring Frequency  of Collaterals<font color="#FF0000">*</font></td>
             <%if(col.getMonitorFrequency()!=null && !col.getMonitorFrequency().equals("")){ %>
            <td><integro:common-code-single entryCode="<%=col.getMonitorFrequency()%>"  display="true"
                                    		categoryCode="<%=CategoryCodeConstant.FREQUENCY%>" descWithCode="false" /></td>
            <%}else{ %>
             <td>-</td>
            <%} %>
          </tr>
        <%if(col.getSCIReferenceNote() == null){
        	col.setSCIReferenceNote("");
        }	%>
        
         
		<tr class="even">
		  <td class="fieldname" width="20%">Security Reference Note&nbsp;</td>
                   <td colspan="3">
                    <input type="text" name="secReferenceNote" value="<%= col.getSCIReferenceNote()%>" rows="4" style="width:80%" readonly="true" />
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table>
 
 
  
 <table width="150" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
   <td>&nbsp;</td>
   <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="96">&nbsp;</td>
    <td width="54">&nbsp;</td>
  </tr>
  <tr>
    <td>
      
	<logic:notPresent name="displayList" scope="request">
	  &nbsp;
      </logic:notPresent>
    </td>
    <td><a href="javascript:cancelSubmit()"><img src="img/return1.gif" name="Image51" width="70" height="20" border="0" id="Image5" /></a></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
 </table>  
</html:form> 
</body>