<?php

// class ErrReport
// {
    // public static function test($num,$err,$file,$line)
    // {
        // return true;
    // }
	
	 // function CallbackFunction() {  
       // return true;
   // }  
// }
// set_error_handler(array('ErrReport', 'Log'));

function myErrorHandler($errno,$errstr,$errfile,$errline){
	 
	 echo "<b>Custom error:</b> [$errno] $errstr<br>";
     echo " Error on line $errline in $errfile<br>";
	
}

set_error_handler("myErrorHandler");

 




function distance($var) 
{
    if ($var) {
		#trigger_error(error_message,error_type);
		//��������
        trigger_error("Incorrect parameters, arrays expected", E_USER_ERROR);
        return NULL;
    }
}

 

// ����һ���û�����
$t1 = distance(true) . "\n";
echo $t1;

?>