Public Class Register
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RegisterUser.ContinueDestinationPageUrl = Request.QueryString("ReturnUrl")
    End Sub

    Protected Sub RegisterUser_CreatedUser(ByVal sender As Object, ByVal e As EventArgs) Handles RegisterUser.CreatedUser
        FormsAuthentication.SetAuthCookie(RegisterUser.UserName, False)

        Dim continueUrl As String = RegisterUser.ContinueDestinationPageUrl
        If String.IsNullOrEmpty(continueUrl) Then
            continueUrl = "~/"
        End If

        Dim profile As ProfileBase = ProfileBase.Create(RegisterUser.UserName)
        Dim FirstName As TextBox = RegisterUserWizardStep.ContentTemplateContainer.FindControl("FirstName")
        Dim LastName As TextBox = RegisterUserWizardStep.ContentTemplateContainer.FindControl("LastName")

        Debug.Print(FirstName.Text)
        Debug.Print(LastName.Text)

        profile.SetPropertyValue("FirstName", FirstName.Text)
        profile.SetPropertyValue("LastName", LastName.Text)

        profile.Save()

        Response.Redirect(continueUrl)
    End Sub
End Class