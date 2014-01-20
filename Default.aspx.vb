Imports System.Data.Sql
Imports System.Data.SqlClient

Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        lblNextWeighIn.Text = "The next weigh in is on " & Format(nextDOW(ConfigurationManager.AppSettings("WeighInDay")), "MM/dd/yyyy") & "."

        Dim FirstName As String = HttpContext.Current.Profile.GetPropertyValue("FirstName")
        Dim LastName As String = HttpContext.Current.Profile.GetPropertyValue("LastName")

        Dim strFriendlyName As String = FirstName & " " & LastName.Substring(0, 1).ToUpper & "."
        lblFriendlyName.Text = strFriendlyname

        Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("90day").ConnectionString)
        con.Open()

        If nextDOW(ConfigurationManager.AppSettings("WeighInDay")) = Now Then

            lblWeekOf.Text = Format(nextDOW(ConfigurationManager.AppSettings("WeighInDay")), "MM/dd/yyyy")

            Dim cmd As SqlCommand = New SqlCommand("CheckExisting", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim parm As SqlParameter = New SqlParameter("MyCount", SqlDbType.Int)
            parm.Direction = ParameterDirection.Output
            cmd.Parameters.Add(parm)
            cmd.Parameters.Add(New SqlParameter("@UserName", strFriendlyName))
            cmd.Parameters.Add(New SqlParameter("@WeekOf", lblWeekOf.Text))
            cmd.ExecuteNonQuery()

            Dim id As Integer = Convert.ToInt32(parm.Value)

            If id = 0 Then
                pnlEnterData.Visible = True
            Else
                pnlNoWeigh.Visible = True
                lblWeighAlready.Visible = True
                lblWeighAlready.Text = "You have already weighed in for this period.  The next weigh in is " & Format(Now.AddDays(7), "MM/dd/yyyy" & ".")
                lblNextWeighIn.Visible = False
                pnlEnterData.Visible = False
            End If
        Else
            pnlNoWeigh.Visible = True
        End If

        If Today >= ConfigurationManager.AppSettings("StartDate") And Today <= DateAdd(DateInterval.Day, 3, CDate(ConfigurationManager.AppSettings("StartDate"))) Then

            Dim cmd As SqlCommand = New SqlCommand("CheckExistingMeasurement", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim parm As SqlParameter = New SqlParameter("MyCount", SqlDbType.Int)
            parm.Direction = ParameterDirection.Output
            cmd.Parameters.Add(parm)
            cmd.Parameters.Add(New SqlParameter("@UserName", strFriendlyName))
            cmd.ExecuteNonQuery()

            Dim id As Integer = Convert.ToInt32(parm.Value)

            If id = 0 Then
                pnlMeasurements.Visible = True
            Else
                pnlMeasurements.Visible = False
                lblMeasureAlready.Visible = True
                lblMeasureAlready.Text = "You have already logged measurements in for this period."
            End If

        End If
        con.Close()

        sqlLeaderBoard.DataBind()

    End Sub

    Public Function nextDOW(whDayOfWeek As DayOfWeek, _
                        Optional theDate As DateTime = Nothing) As DateTime
        'returns the next day of the week
        If theDate = Nothing Then theDate = DateTime.Now

        If whDayOfWeek = theDate.DayOfWeek Then Return theDate
        Dim d As DateTime = theDate.AddDays(whDayOfWeek - theDate.DayOfWeek)
        Return If(d <= theDate, d.AddDays(7), d)
    End Function

    Protected Sub sqlLeaderBoard_Inserting(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceCommandEventArgs) Handles sqlLeaderBoard.Inserting
        Debug.Print("Fired, insert")
        'Debug.Print(e.Command.Parameters("@Username").Value)
        'Debug.Print(e.Command.Parameters("@WeekOf").Value)
        'Debug.Print(e.Command.Parameters("@Weight").Value)

        'e.Command.Parameters("@Image").Value = ConfigurationManager.AppSettings("ImageDirectory") & "\" & _
        '    Format(Now, "yyyy-MM-dd") & "_" & _
        ' e.Command.Parameters("@Username").Value.ToString.Replace(".", "").Replace(" ", "")

    End Sub

    Protected Sub btnSubmitWeight_Click(sender As Object, e As EventArgs) Handles btnSubmitWeight.Click
        If uploadImage.HasFile = True Then
            uploadImage.SaveAs(ConfigurationManager.AppSettings("ImageDirectory") & "\" & _
            Format(Now, "yyyy-MM-dd") & "_" & lblFriendlyName.Text.Replace(".", "").Replace(" ", "") & ".jpg")
        End If
        txtWeight.Text = ""
        sqlLeaderBoard.Insert()
        Response.Redirect("default.aspx")
    End Sub

    Protected Sub btnMeasurements_Click(sender As Object, e As EventArgs) Handles btnMeasurements.Click
        sqlMeasurements.Insert()

    End Sub

    Protected Sub sqlMeasurements_Inserting(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceCommandEventArgs) Handles sqlMeasurements.Inserting
        Dim FirstName As String = HttpContext.Current.Profile.GetPropertyValue("FirstName")
        Dim LastName As String = HttpContext.Current.Profile.GetPropertyValue("LastName")

        Dim strFriendlyName = FirstName & " " & LastName.Substring(0, 1).ToUpper & "."

        e.Command.Parameters("@Username").Value = strFriendlyName
        txtArm.Text = ""
        txtCalf.Text = ""
        txtChest.Text = ""
        txtHips.Text = ""
        txtThigh.Text = ""
        txtWaist.Text = ""

    End Sub

    Protected Sub sqlMeasurements_Inserted(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles sqlMeasurements.Inserted
        Response.Redirect("/")
    End Sub

    Protected Sub sqlLeaderBoard_Inserted(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles sqlLeaderBoard.Inserted
        Response.Redirect("/")
    End Sub
End Class