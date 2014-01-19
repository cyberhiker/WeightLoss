<%@ Page Title="Home Page" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false"
    CodeBehind="Default.aspx.vb" Inherits="_90DayChallenge._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>
        Welcome!</h2>
    <asp:Panel ID="pnlEnterData" runat="server" Visible="false">
        Weigh in is today (<asp:Label ID="lblWeekOf" runat="server"></asp:Label>)!  Please enter in your information below and upload your photo below.
        <p>
            You will appear as: <asp:Label ID="lblFriendlyName" runat="server" />
        </p>
        <asp:ValidationSummary ID="LogWeightSummary" runat="server" CssClass="failureNotification" 
            ValidationGroup="LogWeightGrp"/>
        <p>
            <asp:Label ID="lblWeight" runat="server" AssociatedControlID="txtWeight">Today's Weight:</asp:Label>
            <asp:TextBox ID="txtWeight" runat="server" CssClass="textEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vldWeight" runat="server" ControlToValidate="txtWeight" 
                    CssClass="failureNotification" ErrorMessage="A weight is required." ToolTip="A weight is required." 
                    ValidationGroup="LogWeightGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="vldWeightType" runat="server" ControlToValidate="txtWeight" 
                    CssClass="failureNotification" ErrorMessage="A correct weight is required." 
                    ToolTip="A correct weight is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogWeightGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p class="submitButton" style="text-align:left">
            <asp:Button ID="btnSubmitWeight" runat="server" Text="Log Weight" 
                ValidationGroup="LogWeightGrp"/>
        </p>
    </asp:Panel>
    <asp:Panel ID="pnlNoWeigh" runat="server" Visible="false"><br />
        <asp:Label ID="lblWeighAlready" runat="server" Visible="false" /><br />
        <asp:Label ID="lblNextWeighIn" runat="server" Visible="true" />
        
    </asp:Panel>

    <h2>
        <asp:SqlDataSource ID="sqlLeaderBoard" runat="server" ConnectionString="<%$ ConnectionStrings:90day %>" 
            SelectCommand="GenerateLeaderBoard" SelectCommandType="StoredProcedure"
            InsertCommand="InsertWeighIn" InsertCommandType="StoredProcedure">
            <InsertParameters>
                <asp:ControlParameter Name="Username" ControlID="lblFriendlyName" Direction="Input" />
                <asp:ControlParameter Name="WeekOf" ControlID="lblWeekOf" Direction="Input" />
                <asp:ControlParameter Name="Weight" ControlID="txtWeight" Direction="Input" />

            </InsertParameters>
        </asp:SqlDataSource>
        Here are the current standings:
    </h2>
    <br />
    <asp:GridView ID="grdLeaderBoard" runat="server" DataSourceID="sqlLeaderBoard" 
        Width="535px" >
        <EmptyDataTemplate>
            No one has posted a weight yet!
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>
