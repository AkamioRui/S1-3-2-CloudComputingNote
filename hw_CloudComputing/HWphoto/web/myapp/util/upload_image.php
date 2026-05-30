<?php
// input
// $_POST['image_name'] 
// $_FILES['image']
// $_POST['location'],
// $_POST['time']

//output
// 


ini_set('display_errors',1);
try{
    $image_name= $_POST['image_name']?:$_FILES['image']['name'];
    $image     = file_get_contents($_FILES['image']['tmp_name']);
    $location  = $_POST['location']?:"unknown location";
    $time      = $_POST['time']?:Date('Y-m-d H:i:s');
} catch(Throwable $e){
    error_log("======= image code = ".$_FILES['image']['error']." =======");
    throw $e;
}
error_log("======= data =======");
error_log($image_name);
error_log($_FILES['image']['tmp_name']);
error_log($location);
error_log($time);
error_log("======= data =======");


$pdo = new PDO('mysql:host=database;dbname=mydb',"root");
// id, int
// image, longblob
// location, varchar(20)
// time, date
$stmt = $pdo->prepare('
    insert into data(image_name,image,location,time)
    values (:image_name,:image,:location,:time)
');
$result = $stmt->execute([
    'image_name'=>$image_name,
    'image'     =>$image,
    'location'  =>$location,
    'time'      =>$time
]);



?>