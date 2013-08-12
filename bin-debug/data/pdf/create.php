<?php

$method = $_GET['method'];
$name = $_GET['name'];

if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {
	
	// get bytearray
	$pdf = $GLOBALS["HTTP_RAW_POST_DATA"];
	
	// add headers for download dialog-box
	header('Content-Type: application/pdf');
	header('Content-Length: '.strlen($pdf));
	header('Content-disposition:'.$method.'; filename="'.$name.'"');
	
	echo $pdf;
	
	$data = $GLOBALS["HTTP_RAW_POST_DATA"];
	$file = fopen($name, "wb");
    fwrite($file, $data);
    $attachment =  chunk_split(base64_encode($data));
    fclose($file);
  
    $senderName = "NSN Channel Partner Program";
    $replyAddress = "";
    $subject = "Marketing plan";
    $messageBody = "Your marketing plan." ;
    $recipient = $_GET["email1"];
    $recipient2 = $_GET["email2"];
    $recipient3 = $_GET["email3"];

    $separator = md5(time());
    
    $header = "From: ". $senderName . " <" . $senderName . ">\r\n";
  
    $header .= "MIME-Version: 1.0\r\n";
    $header .= "Content-Type: multipart/mixed; boundary=\"".$separator."\"\r\n";
    $header .= "Content-Transfer-Encoding: 7bit\r\n";
    $header .= "This is a MIME encoded message.\r\n";
   
    $header .= "--".$separator."\r\n";
    $header .= "Content-Type: text/html; charset=\"iso-8859-1\"\r\n";
    $header .= "Content-Transfer-Encoding: 8bit\r\n\r\n";
    $header .= $messageBody."\r\n\r\n";
  
    $header .= "--".$separator."\r\n";
    $header .= "Content-Type: application/octet-stream; name=\"".$name."\"\r\n";
    $header .= "Content-Transfer-Encoding: base64\r\n";
    $header .= "Content-Disposition: attachment\r\n\r\n";
    $header .= $attachment."\r\n\r\n";
    $header .= "--".$separator."--";

    mail($recipient, $subject, "", $header);
    mail($recipient2, $subject, "", $header);
    mail($recipient3, $subject, "", $header);
 	
}  else echo 'An error occured.';

?>