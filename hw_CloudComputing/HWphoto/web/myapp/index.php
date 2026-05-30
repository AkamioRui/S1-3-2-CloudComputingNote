<?php 
    ini_set('display_errors',1);
    $pdo = new PDO('mysql:host=database;dbname=mydb','root');
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE,PDO::FETCH_ASSOC);
    // | id         | int           |
    // | image_name | varchar(1024) |
    // | image      | longblob      |
    // | location   | varchar(1024) |
    // | time       | date          |
    $data = $pdo->query("select id,image from data;")->fetchAll();
    
    
    $html = file_get_contents('html/index.html');

    $regex = '/<!-- @@@image -->.*?<!-- \/@@@image -->/s';
    $body = array_map(function($d){
        return "<img src=\"data:image;base64,".base64_encode($d['image'])."\" onclick=\"goTo(".$d['id'].")\" />\n";
    },$data);
    
    
    $body = implode("\n",$body);
    $html = preg_replace($regex,$body,$html);
    echo $html;



    // $data = $pdo->query('select * from data;')->fetchAll();
    // foreach( $data as $d){
    //     print "<div>
    //         <p>id:{$d['id']}</p>
    //         <p>image_name:{$d['image_name']}</p>
    //         <p>location:{$d['location']}</p>
    //         <p>time:{$d['time']}</p>
    //         <img src='data:image;base64,".base64_encode($d['image'])."'>
    //     </div>\n";
    // }

?>
