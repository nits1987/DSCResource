#$IncludeScriptLocation = "$(split-path $SCRIPT:MyInvocation.MyCommand.Path -parent)\scripts"
#. $IncludeScriptLocation\hostsfile.ps1

#region Helpers
enum Ensure
{
    Absent
    Present
}
#endregion
#region RemoveEmptyAppPools
[DscResource()]
class CreateNewEventLogResource
{
    [DscProperty(Key)]
    [string]$LogName
    [DscProperty(Mandatory)]
    [string[]]$Source
    [DscProperty(Mandatory)]
    [Ensure]$Ensure
	
    [void] Set()
    {
        if($this.Ensure -eq [Ensure]::Present)
        {
            if(!$(Get-EventLog -List).Log.Contains($this.LogName))
           { New-EventLog -LogName $this.LogName -Source $this.Source}
        }
    }
    [bool] Test()
    {
       if($this.Ensure -eq [Ensure]::Present)
       {
            if($(Get-EventLog -List).Log.Contains($this.LogName))
            {
                return $true
            }
            else
            {
                return $false
            }
       }
       else {
        if($(Get-EventLog -List).Log.Contains($this.LogName))
        {
            return $false
        }
        else
        {
            return $true
        }
       }
    }
    [CreateNewEventLogResource] Get()
    {
        if($this.Ensure -eq [Ensure]::Present)
        {
            $this.LogName = Get-EventLog -LogName $this.LogName
            
        }   
        return $this
    }
}
#endregion
