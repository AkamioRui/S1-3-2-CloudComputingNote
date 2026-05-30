<?php
    ini_set('display_errors',1);

    // get data 
    try {
        $pdo = new PDO('mysql:host=database;dbname=mydb',"root");
    } catch (PDOException $e) {
        print($e->getMessage());
    }
        // id         
        // image_name 
        // image      
        // location   
        // time       
    $stmt = $pdo->prepare('select * from data where id=?;');
    $stmt->execute([$_GET['id']]);
    $data = $stmt->fetch();

    // inline replacement
    $html = file_get_contents('html/image.html');
    $html = str_replace(
        [
            '@@@image_name@@@',
            '@@@location@@@',
            '@@@time@@@',
            '@@@id@@@',
        ],
        [
            $data['image_name'],
            $data['location'],
            $data['time'],
            $data['id'],
        ],
        $html
    );

    // block replacement
    $regex = '/<!-- @@@image -->.*?<!-- \/@@@image -->/s';
    $body = "<img src=\"data:image;base64,".base64_encode($data['image'])."\"/>";
    $html = preg_replace($regex,$body,$html);
    
    print($html)
?>