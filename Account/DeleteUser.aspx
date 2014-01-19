<%@ Page Title="Delete User" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="DeleteUser.aspx.vb" Inherits="_90DayChallenge.DeleteUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3>Delete User</h3>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please select a User" ControlToValidate="ddlUserList">
        </asp:RequiredFieldValidator>

        <asp:ObjectDataSource ID="odsAllUsers" runat="server" SelectMethod="GetAllUsers" TypeName="System.Web.Security.Membership"></asp:ObjectDataSource>
        <asp:DropDownList ID="ddlUserList" runat="server" DataSourceID="odsAllUsers">
        </asp:DropDownList>

        <asp:Button ID="btnDelete" runat="server" Text="Delete Selected User" />
</asp:Content>
