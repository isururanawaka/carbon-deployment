<!--
 ~ Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 ~
 ~ WSO2 Inc. licenses this file to you under the Apache License,
 ~ Version 2.0 (the "License"); you may not use this file except
 ~ in compliance with the License.
 ~ You may obtain a copy of the License at
 ~
 ~    http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing,
 ~ software distributed under the License is distributed on an
 ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 ~ KIND, either express or implied.  See the License for the
 ~ specific language governing permissions and limitations
 ~ under the License.
 -->
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.webapp.list.ui.WebappAdminClient" %>
<%@ page import="java.util.ResourceBundle" %>
<%
    String[] webappkeySet = request.getParameterValues("webappKey");
    String pageNumber = request.getParameter("pageNumber");
    String deleteAllWebapps = request.getParameter("deleteAllWebapps");
    String webappState = request.getParameter("webappState");
    if (webappState == null) {
        webappState = "started";
    }
    int pageNumberInt = 0;
    if (pageNumber != null) {
        pageNumberInt = Integer.parseInt(pageNumber);
    }
%>

<%
    String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

    ResourceBundle bundle = ResourceBundle
            .getBundle(WebappAdminClient.BUNDLE, request.getLocale());

    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);
    WebappAdminClient client;
    try {
        client = new WebappAdminClient(cookie, backendServerURL, configContext, request.getLocale());
    } catch (Exception e) {
        CarbonUIMessage uiMsg = new CarbonUIMessage(CarbonUIMessage.ERROR, e.getMessage(), e);
        session.setAttribute(CarbonUIMessage.ID, uiMsg);
%>
<jsp:include page="../admin/error.jsp"/>
<%
        return;
    }

    try {
        if (deleteAllWebapps != null) {
            if (webappState.equalsIgnoreCase("all")) {
                client.deleteAllStartedWebapps();
                client.deleteAllStoppedWebapps();
                CarbonUIMessage.sendCarbonUIMessage(bundle.getString("successfully.deleted.all.webapps"),
                                                    CarbonUIMessage.INFO, request);
            } else if (webappState.equalsIgnoreCase("started")) {
                client.deleteAllStartedWebapps();
                CarbonUIMessage.sendCarbonUIMessage(bundle.getString("successfully.deleted.all.started.webapps"),
                                                    CarbonUIMessage.INFO, request);
            } else if (webappState.equalsIgnoreCase("stopped")) {
                client.deleteAllStoppedWebapps();
                CarbonUIMessage.sendCarbonUIMessage(bundle.getString("successfully.deleted.all.stopped.webapps"),
                                                    CarbonUIMessage.INFO, request);
            } else {
                throw new ServletException("Unknown webappstate " + webappState);
            }
        } else {
            if (webappState.equalsIgnoreCase("all")) {
                client.deleteAllWebapps(webappkeySet);
                CarbonUIMessage.sendCarbonUIMessage(bundle.getString("successfully.deleted.webapps"),
                                                    CarbonUIMessage.INFO, request);
            } else if (webappState.equalsIgnoreCase("started")) {
                client.deleteStartedWebapps(webappkeySet);
                CarbonUIMessage.sendCarbonUIMessage(bundle.getString("successfully.deleted.webapps"),
                                                    CarbonUIMessage.INFO, request);
            } else if (webappState.equalsIgnoreCase("stopped")) {
                client.deleteStoppedWebapps(webappkeySet);
                CarbonUIMessage.sendCarbonUIMessage(bundle.getString("successfully.deleted.webapps"),
                                                    CarbonUIMessage.INFO, request);
            } else {
                throw new ServletException("Unknown webappstate " + webappState);
            }
        }
%>
<script>
    location.href = 'index.jsp?pageNumber=<%=pageNumberInt%>'
</script>

<%
} catch (Exception e) {
    CarbonUIMessage.sendCarbonUIMessage(e.getMessage(), CarbonUIMessage.ERROR, request);
%>
<script type="text/javascript">
    location.href = "index.jsp?pageNumber=<%=pageNumberInt%>";
</script>
<%
        return;
    }
%>