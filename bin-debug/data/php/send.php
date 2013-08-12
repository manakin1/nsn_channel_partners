<?php

$senderName = $_GET["senderName"];
$replyAddress = $_GET["replyAddress"];
$subject = $_GET["subject"];
$messageBody = $_GET["messageBody"];
$recipient = $_GET["recipient"];
$header = "From: ". $senderName . " <" . $senderName . ">\r\n";

if (mail($recipient, $subject, $messageBody, $header))
{
  echo "success";
}

else
{
  echo "error";
}
?>