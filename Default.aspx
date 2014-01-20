<%@ Page Title="Weight Loss Challenge" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false"
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
            <asp:TextBox ID="txtWeight" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="vldWeight" runat="server" ControlToValidate="txtWeight" 
                    CssClass="failureNotification" ErrorMessage="A weight is required." ToolTip="A weight is required." 
                    ValidationGroup="LogWeightGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="vldWeightType" runat="server" ControlToValidate="txtWeight" 
                    CssClass="failureNotification" ErrorMessage="A correct weight is required." 
                    ToolTip="A correct weight is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogWeightGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p>
            <asp:Label ID="lblFileUpload" runat="server" AssociatedControlID="uploadImage">Today's Picture:</asp:Label>
            <asp:FileUpload ID="uploadImage" runat="server" />
            <asp:RequiredFieldValidator ID="vldFileUpload" runat="server" ControlToValidate="uploadImage" 
                CssClass="failureNotification" ErrorMessage="An image is required." ToolTip="An image is required." 
                ValidationGroup="LogWeightGrp">*</asp:RequiredFieldValidator>
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
            No one has posted a weight yet!  But this is where the leader board is going to be!
        </EmptyDataTemplate>
    </asp:GridView><br /><br />
    <asp:Panel ID="pnlMeasurements" runat="server" Visible="false">
        <asp:SqlDataSource ID="sqlMeasurements" runat="server" ConnectionString="<%$ ConnectionStrings:90day %>"
         InsertCommand="InsertMeasurements" InsertCommandType="StoredProcedure" 
            ProviderName="System.Data.SqlClient">
         <InsertParameters>
            <asp:ControlParameter Name="Username" ControlID="lblFriendlyName" Direction="Input" />
            <asp:ControlParameter Name="Waist" ControlID="txtWaist" Direction="Input" />
            <asp:ControlParameter Name="Thighs" ControlID="txtThigh" Direction="Input" />
            <asp:ControlParameter Name="Hips" ControlID="txtHips" Direction="Input" />
            <asp:ControlParameter Name="Chest" ControlID="txtChest" Type="Double" />
            <asp:ControlParameter Name="Arm" ControlID="txtArm" Direction="Input" />
            <asp:ControlParameter Name="Calves" ControlID="txtCalf" Type="Double" />
         </InsertParameters>
         </asp:SqlDataSource>
        Measurements are due today!  Please enter in your information below.
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="failureNotification" 
            ValidationGroup="LogMeasurementGrp"/>
        <p>
            <asp:Label ID="Label3" runat="server" AssociatedControlID="txtWaist">Waist:</asp:Label>
            <asp:TextBox ID="txtWaist" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtWaist" 
                    CssClass="failureNotification" ErrorMessage="A waist measurement is required." ToolTip="A waist measurement is required." 
                    ValidationGroup="LogMeasurementGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtWaist" 
                    CssClass="failureNotification" ErrorMessage="A valid waist measurement is required." 
                    ToolTip="A valid waist measurement is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogMeasurementGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p>
            <asp:Label ID="Label2" runat="server" AssociatedControlID="txtthigh">Thigh:</asp:Label>
            <asp:TextBox ID="txtThigh" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtThigh" 
                    CssClass="failureNotification" ErrorMessage="A thigh measurement is required." ToolTip="A thigh measurement is required." 
                    ValidationGroup="LogMeasurementGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtThigh" 
                    CssClass="failureNotification" ErrorMessage="A valid thigh measurement is required." 
                    ToolTip="A valid thigh measurement is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogMeasurementGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p>
            <asp:Label ID="Label4" runat="server" AssociatedControlID="txthips">Hips:</asp:Label>
            <asp:TextBox ID="txtHips" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtHips" 
                    CssClass="failureNotification" ErrorMessage="A hips measurement is required." ToolTip="A hips measurement is required." 
                    ValidationGroup="LogMeasurementGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtHips" 
                    CssClass="failureNotification" ErrorMessage="A valid hips measurement is required." 
                    ToolTip="A valid hips measurement is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogMeasurementGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p>
            <asp:Label ID="Label5" runat="server" AssociatedControlID="txtchest">Chest:</asp:Label>
            <asp:TextBox ID="txtChest" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtChest" 
                    CssClass="failureNotification" ErrorMessage="A chest measurement is required." ToolTip="A chest measurement is required." 
                    ValidationGroup="LogMeasurementGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtChest" 
                    CssClass="failureNotification" ErrorMessage="A valid chest measurement is required." 
                    ToolTip="A valid chest measurement is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogMeasurementGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p>
            <asp:Label ID="Label6" runat="server" AssociatedControlID="txtArm">Arm:</asp:Label>
            <asp:TextBox ID="txtArm" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtArm" 
                    CssClass="failureNotification" ErrorMessage="An arm measurement is required." ToolTip="Am arm measurement is required." 
                    ValidationGroup="LogMeasurementGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtarm" 
                    CssClass="failureNotification" ErrorMessage="A valid arm measurement is required." 
                    ToolTip="A valid arm measurement is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogMeasurementGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p>
            <asp:Label ID="Label7" runat="server" AssociatedControlID="txtCalf">Calf:</asp:Label>
            <asp:TextBox ID="txtCalf" runat="server" CssClass="textShortEntry"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtCalf" 
                    CssClass="failureNotification" ErrorMessage="A calf measurement is required." ToolTip="A calf measurement is required." 
                    ValidationGroup="LogMeasurementGrp">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ControlToValidate="txtCalf" 
                    CssClass="failureNotification" ErrorMessage="A valid calf measurement is required." 
                    ToolTip="A valid calf measurement is required." ValidationExpression="^\d{1,3}(?:\.\d{1,2})?$"
                    ValidationGroup="LogMeasurementGrp">*</asp:RegularExpressionValidator>
         <br />
        </p>
        <p class="submitButton" style="text-align:left">
            <asp:Button ID="btnMeasurements" runat="server" Text="Log Measurements" 
                ValidationGroup="LogMeasurementGrp"/>
        </p>
    </asp:Panel>
        <p class="submitButton" style="text-align:left">
            <asp:Label ID="lblMeasureAlready" runat="server" Visible="false" />
        </p>
</asp:Content>
