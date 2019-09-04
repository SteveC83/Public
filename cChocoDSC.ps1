Configuration cChocoDSC
{
    Param
    (
        
        [String]$SystemTimeZone="UTC"
      
    )  
    Import-DscResource -ModuleName cChoco
    Import-DscResource -ModuleName ComputerManagementDSC

    Node localhost {

                    TimeZone SysTimeZone
                    {
                    IsSingleInstance = 'Yes'
                    TimeZone = $SystemTimeZone
                    }

                    cChocoinstaller Install 
                    {
                    InstallDir = "C:\Choco"
                    }           
    }
}
