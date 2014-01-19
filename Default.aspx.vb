﻿Imports System.Data.Sql
Imports System.Data.SqlClient

Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        lblNextWeighIn.Text = "The next weigh in is on " & Format(nextDOW(ConfigurationManager.AppSettings("WeighInDay")), "MM/dd/yyyy") & "."

        If nextDOW(ConfigurationManager.AppSettings("WeighInDay")) = Now Then

            Dim FirstName As String = HttpContext.Current.Profile.GetPropertyValue("FirstName")
            Dim LastName As String = HttpContext.Current.Profile.GetPropertyValue("LastName")

            lblFriendlyName.Text = FirstName & " " & LastName.Substring(0, 1).ToUpper & "."

            lblWeekOf.Text = Format(nextDOW(ConfigurationManager.AppSettings("WeighInDay")), "MM/dd/yyyy")

            Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("90day").ConnectionString)
            con.Open()

            Dim cmd As SqlCommand = New SqlCommand("CheckExisting", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim parm As SqlParameter = New SqlParameter("MyCount", SqlDbType.Int)
            parm.Direction = ParameterDirection.Output
            cmd.Parameters.Add(parm)
            cmd.Parameters.Add(New SqlParameter("@UserName", lblFriendlyName.Text))
            cmd.Parameters.Add(New SqlParameter("@WeekOf", lblWeekOf.Text))
            cmd.ExecuteNonQuery()
            con.Close()

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
        Debug.Print(e.Command.Parameters("@Username").Value)
        Debug.Print(e.Command.Parameters("@WeekOf").Value)
        Debug.Print(e.Command.Parameters("@Weight").Value)
        'txtWeight.Text = ""

    End Sub

    Protected Sub btnSubmitWeight_Click(sender As Object, e As EventArgs) Handles btnSubmitWeight.Click
        sqlLeaderBoard.Insert()

    End Sub
End Class