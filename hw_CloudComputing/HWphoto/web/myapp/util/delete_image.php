<?php
// $_GET["id"]

$pdo = new PDO("mysql:host=database;dbname=mydb","root");
$pdo
->prepare('delete from data where id = ? ;')
->execute([$_POST["id"]]) 

?>